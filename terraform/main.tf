# terraform/main.tf

# 1. Criação da VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Um bloco CIDR privado para sua rede
  enable_dns_hostnames = true          # Permite que instâncias recebam nomes de DNS públicos
  tags = {
    Name    = "Amon-App-VPC"
    Project = "AWSRoadmap"
  }
}
# 2. Criação do Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # Associa o IGW à VPC que acabamos de criar
  tags = {
    Name    = "Amon-App-IGW"
    Project = "AWSRoadmap"
  }
}
# 3. Criação da Subnet Pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"        # Um sub-bloco do CIDR da VPC
  map_public_ip_on_launch = true                 # Atribui um IP público automaticamente às instâncias nesta subnet
  availability_zone       = "${var.aws_region}a" # Ex: us-east-1a. Escolhe a primeira AZ da região.
  tags = {
    Name    = "Amon-App-Public-Subnet"
    Project = "AWSRoadmap"
  }
}
# 4. Criação da Tabela de Rotas Pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "Amon-App-Public-RouteTable"
    Project = "AWSRoadmap"
  }
}

# 5. Adiciona uma rota para a internet ao Route Table
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"                  # Qualquer IP de destino
  gateway_id             = aws_internet_gateway.main.id # Encaminha para o IGW
}

# 6. Associa a Subnet Pública à Tabela de Rotas Pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
# 7. Criação do Security Group para a instância EC2
resource "aws_security_group" "app_sg" {
  name        = "amon_app_sg"
  description = "Security group for Amon's application EC2 instance"
  vpc_id      = aws_vpc.main.id

  # Regra para permitir SSH (porta 22) de qualquer lugar (0.0.0.0/0)
  # Isso é para você poder acessar a instância remotamente.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Acesso de qualquer IP para SSH. Em produção, restrinja ao seu IP!
  }

  # Regra para permitir o acesso HTTP (porta 80) e HTTPS (porta 443) do seu app
  # Se seu app tiver uma interface web, ela rodará nessas portas.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de saída: permite todo o tráfego de saída (seu app precisa acessar as APIs externas!)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 significa todos os protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Amon-App-SecurityGroup"
    Project = "AWSRoadmap"
  }
}
# 8. Criação da Instância EC2 para o seu App
resource "aws_instance" "app_instance" {
  ami           = "ami-053b0d534c0e66e13" # AMI do Ubuntu Server 22.04 LTS (HVM) - us-east-1 (N. Virginia)
                                         # Importante: Verifique a AMI correta para sua região!
                                         # Para sa-east-1 (São Paulo), uma AMI comum seria "ami-0a06640c4ad096464"
  instance_type = "t2.micro"             # Tipo de instância do Free Tier

  subnet_id = aws_subnet.public.id     # Associa à subnet pública que criamos
  vpc_security_group_ids = [aws_security_group.app_sg.id] # Associa ao Security Group do seu app

  # Associa a IAM Role criada à instância EC2
  # Isso permite que a instância use as permissões definidas na Role (acesso ao S3, DynamoDB, etc.)
  iam_instance_profile = aws_iam_instance_profile.app_profile.name

  # Chave SSH para acesso à instância
  # Você precisará ter uma Key Pair já criada na AWS na sua região!
  # Substitua "amon-key-pair" pelo nome da sua Key Pair existente.
  key_name = "amon-project-terraform"

  # User Data Script: Executado na primeira inicialização da instância
  # Ideal para instalar dependências e configurar seu ambiente automaticamente
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y python3 python3-pip git
              pip3 install boto3 requests flask # ou outras libs que seu app usar
              # Git clone do seu repositório (substitua pelo seu URL)
              git clone https://github.com/Amonvix/AWSRoadmap.git /home/ubuntu/AWSRoadmap
              # Navegar para a pasta do seu app (assumindo que o app.py está em src/)
              cd /home/ubuntu/AWSRoadmap/smartform
              # Rodar seu app (exemplo: se for um script simples)
              python3 main.py & # Rodar em background
              EOF

  tags = {
    Name = "Amon-App-Instance"
    Project = "AWSRoadmap"
  }
}

# Referenciar a IAM Role existente
data "aws_iam_role" "app_role_existing" {
  name = "Amon-App-Role" # O nome EXATO da Role que você criou manualmente
}

# Cria um IAM Instance Profile para anexar a Role à EC2
resource "aws_iam_instance_profile" "app_profile" {
  name = "Amon-App-EC2-Profile"
  role = "Amon-App-Role" # Use o nome da Role que você criou
}
