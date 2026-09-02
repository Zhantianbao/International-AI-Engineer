from fastapi import FastAPI

from schemas import (
    ApplicationCreate,
    ApplicationResponse,
    CompanyCreate,
    CompanyResponse,
    PositionCreate,
    PositionResponse,
)


app = FastAPI()


@app.post("/companies", response_model=CompanyResponse)
def create_company(company: CompanyCreate):
    return {
        "company_id": 1,
        "name": company.name,
        "country": company.country,
        "website_url": company.website_url,
        "is_remote_friendly": company.is_remote_friendly,
    }


@app.post("/positions", response_model=PositionResponse)
def create_position(position: PositionCreate):
    return {
        "position_id": 1,
        "company_id": position.company_id,
        "title": position.title,
        "location": position.location,
        "is_remote": position.is_remote,
    }


@app.post("/applications", response_model=ApplicationResponse)
def create_application(application: ApplicationCreate):
    return {
        "application_id": 1,
        "position_id": application.position_id,
        "status": application.status,
        "notes": application.notes,
    }
