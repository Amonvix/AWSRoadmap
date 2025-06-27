import requests
from app.models import FormInput, FormResponse

def enrich_form_data(data: FormInput) -> FormResponse:
    result = FormResponse(**data.dict(), id="")

    try:
        r1 = requests.get(f"https://api.genderize.io?name={data.nome}")
        result.genero = r1.json().get("gender")
    except:
        result.genero = None

    try:
        r2 = requests.get(f"https://viacep.com.br/ws/{data.cep}/json")
        result.endereco = r2.json().get("logradouro")
    except:
        result.endereco = None

    try:
        r3 = requests.get(f"https://restcountries.com/v3.1/name/{data.pais}")
        result.pais_oficial = r3.json()[0]["name"]["common"]
    except:
        result.pais_oficial = None

    return result