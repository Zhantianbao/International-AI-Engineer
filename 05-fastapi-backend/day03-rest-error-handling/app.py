from fastapi import FastAPI, HTTPException, status

import repository
from schemas import (
    CompanyCreate,
    CompanyResponse,
    ApplicationStatusUpdate,
    ApplicationResponse,
)


app = FastAPI()


@app.post(
    "/companies",
    response_model=CompanyResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_company(company: CompanyCreate):

    existing_company = repository.get_company_by_name(company.name)

    if existing_company is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Company already exists",
        )

    return repository.create_company(
        name=company.name,
        country=company.country,
    )


@app.get(
    "/companies/{company_id}",
    response_model=CompanyResponse,
)
def get_company(company_id: int):
    company = repository.get_company(company_id)

    if company is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Company not found",
        )

    return company


@app.patch(
    "/applications/{application_id}/status",
    response_model=ApplicationResponse,
)
def update_application_status(
    application_id: int,
    update: ApplicationStatusUpdate,
):
    application = repository.update_application_status(
        application_id=application_id,
        new_status=update.status,
    )

    if application is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Application not found",
        )

    return application


@app.delete(
    "/applications/{application_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_application(application_id: int):
    deleted_application = repository.delete_application(application_id)

    if deleted_application is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Application not found",
        )

    return None