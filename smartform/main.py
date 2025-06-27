from fastapi import FastAPI, HTTPException
from app.models import FormInput, FormResponse
from app.external import enrich_form_data
from app.storage import save_form_data
import uuid
from fastapi import Path

app = FastAPI()

@app.post("/form", response_model=FormResponse)
def submit_form(data: FormInput):
    enriched = enrich_form_data(data)
    enriched.id = str(uuid.uuid4())
    save_form_data(enriched)
    return enriched

@app.get("/form/{form_id}", response_model=FormResponse)
def get_form(form_id: str = Path(..., description="UUID do formulário")):
    item = fetch_form_data(form_id)
    if not item:
        raise HTTPException(status_code=404, detail="Formulário não encontrado")
    return item