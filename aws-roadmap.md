# 🧠 AWS Learning Roadmap

> Um repositório vivo com foco em **aprender AWS na prática**, através de experimentos, projetos pequenos e documentação progressiva por módulo.  
> Conforme os serviços forem sendo explorados, exemplos e mini-projetos serão adicionados.

---

## 🎯 Objetivo

Este repositório tem como meta centralizar o progresso de aprendizado na AWS com foco em:
- Mão na massa com serviços reais
- Baixo custo (usando Free Tier e boas práticas)
- Registro de aprendizado com comparativos (ex: GCP vs AWS)
- Preparação prática para ambientes de produção

---

## 🗺️ Roadmap por Etapas

### 🟩 Etapa 1: Essenciais  
🔥 Aprenda isso primeiro — base de tudo na AWS

- ✅ IAM – Gerenciamento de acesso (usuários, groups, roles, policies)
- ✅ VPC – Rede virtual (subnets, CIDR, gateways, NAT, route tables)
- ✅ EC2 – Instâncias de computação (t2.micro, keypairs, scripts)
- 🔄 S3 – Armazenamento de objetos (buckets, lifecycle, versionamento)
- ✅ CloudWatch – Logs, métricas e alarmes
- 🔄 Route53 – DNS, zonas públicas/privadas, health checks
- 🔄 ElastiCache – Redis/Memcached
- 🔄 SES – Envio de e-mails (verificação, DKIM, reputação)

---

### 🟨 Etapa 2: Intermediários  
🌱 Evolua integrando serviços

- ✅ DynamoDB – NoSQL (chaves, índices, streams, backup/restore)
- ✅ ECS – Orquestração de containers com Fargate
- ✅ RDS – Banco de dados relacional gerenciado

---

### 🟧 Etapa 3: Avançados  
🚀 Escalabilidade, otimização e alta disponibilidade

- 🔄 CloudFront – CDN para conteúdo global
- 🔄 Auto Scaling – Escalabilidade automática de instâncias
- 🔄 Elastic Load Balancer (ELB) – Balanceamento de carga
- 🔄 Launch Templates – Inicialização de instâncias otimizadas
- 🔄 User Data Scripts – Automatização na criação de instâncias
- 🔄 AMIs – Imagens customizadas de EC2

---

### 🟦 Etapa 4: Serverless e Microserviços  
🧬 Arquiteturas modernas e sem servidor

- ✅ Lambda – Funções event-driven
- ✅ ECS Fargate – Containers sem gerenciamento de servidor
- 🔄 EKS – Kubernetes gerenciado
- 🔄 EventBridge – Eventos e agendamento
- 🔄 API Gateway + Lambda@Edge – APIs performáticas
- 🔄 Layers – Compartilhamento de código entre Lambdas

---

## 📁 Estrutura do Repositório

