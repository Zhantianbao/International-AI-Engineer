from pydantic import BaseModel, Field


class CompanyCreate(BaseModel):
    name: str
    country: str
    website_url: str | None = None
    is_remote_friendly: bool = False


class CompanyResponse(BaseModel):
    company_id: int
    name: str
    country: str
    website_url: str | None = None
    is_remote_friendly: bool


class PositionCreate(BaseModel):
    company_id: int
    title: str
    location: str | None = None
    is_remote: bool = False


class PositionResponse(BaseModel):
    position_id: int
    company_id: int
    title: str
    location: str | None = None
    is_remote: bool


class ApplicationCreate(BaseModel):
    position_id: int = Field(gt=0)
    status: str = Field(min_length=1)
    notes: str | None = None


class ApplicationResponse(BaseModel):
    application_id: int
    position_id: int
    status: str
    notes: str | None = None
