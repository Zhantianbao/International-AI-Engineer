from pydantic import BaseModel


class CompanyCreate(BaseModel):
    name: str
    country: str


class CompanyResponse(BaseModel):
    company_id: int
    name: str
    country: str


class ApplicationStatusUpdate(BaseModel):
    status: str


class ApplicationResponse(BaseModel):
    application_id: int
    position_id: int
    status: str