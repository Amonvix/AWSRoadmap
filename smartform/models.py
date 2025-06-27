from pydantic import BaseModel, EmailStr
from typing import Optional

class FormInput(BaseModel):
    nome: str
    email: EmailStr
    cep: str
    pais: str
    nascimento: str

class FormResponse(FormInput):
    id: str
    genero: Optional[str] = None
    endereco: Optional[str] = None
    pais_oficial: Optional[str] = None