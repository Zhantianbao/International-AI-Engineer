companies = {}
next_company_id = 1


def create_company(name: str, country: str):
    global next_company_id

    company = {
        "company_id": next_company_id,
        "name": name,
        "country": country,
    }

    companies[next_company_id] = company
    next_company_id += 1

    return company


def get_company(company_id: int):
    return companies.get(company_id)


def get_company_by_name(name: str):
    for company in companies.values():
        if company["name"] == name:
            return company

    return None


applications = {
    1: {
        "application_id": 1,
        "position_id": 101,
        "status": "applied",
    }
}


def get_application(application_id: int):
    return applications.get(application_id)


def update_application_status(application_id: int, new_status: str):
    application = applications.get(application_id)

    if application is None:
        return None

    application["status"] = new_status
    return application


def delete_application(application_id: int):
    return applications.pop(application_id, None)