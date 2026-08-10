from datetime import date

import psycopg

from repository import (
    add_application,
    add_company,
    add_position,
    get_summary_statistics,
    list_applications,
    list_applications_by_status,
    update_application_status,
)


def optional_text(prompt):
    value = input(prompt).strip()

    if value == "":
        return None

    return value


def print_application(application):
    application_id, company, position, status, applied_at = application

    print(
        f"#{application_id} | "
        f"{company} | "
        f"{position} | "
        f"{status} | "
        f"{applied_at or '-'}"
    )


def create_company():
    name = input("Company name: ").strip()
    country = input("Country: ").strip()
    website_url = optional_text("Website URL (optional): ")

    remote_answer = input(
        "Remote friendly? [y/N]: "
    ).strip().lower()

    is_remote_friendly = remote_answer in {"y", "yes"}

    company = add_company(
        name=name,
        country=country,
        website_url=website_url,
        is_remote_friendly=is_remote_friendly,
    )

    print("Company created:")
    print(company)


def create_position():
    company_id = int(
        input("Company ID: ").strip()
    )

    title = input("Position title: ").strip()
    location = optional_text("Location (optional): ")

    remote_type = (
        input(
            "Remote type [onsite/hybrid/remote] "
            "(default: onsite): "
        )
        .strip()
        .lower()
        or "onsite"
    )

    employment_type = (
        input(
            "Employment type "
            "(default: internship): "
        )
        .strip()
        .lower()
        or "internship"
    )

    job_url = optional_text("Job URL (optional): ")
    description = optional_text(
        "Description (optional): "
    )

    position = add_position(
        company_id=company_id,
        title=title,
        location=location,
        remote_type=remote_type,
        employment_type=employment_type,
        job_url=job_url,
        description=description,
        posted_at=None,
    )

    print("Position created:")
    print(position)


def create_application():
    position_id = int(
        input("Position ID: ").strip()
    )

    status = (
        input(
            "Status "
            "[planned/applied/interview/offer/"
            "rejected/withdrawn] "
            "(default: planned): "
        )
        .strip()
        .lower()
        or "planned"
    )

    applied_at = None

    if status != "planned":
        applied_at_text = input(
            "Applied date [YYYY-MM-DD]: "
        ).strip()

        applied_at = date.fromisoformat(
            applied_at_text
        )

    notes = optional_text("Notes (optional): ")

    application = add_application(
        position_id=position_id,
        status=status,
        applied_at=applied_at,
        notes=notes,
    )

    print("Application created:")
    print(application)


def change_application_status():
    application_id = int(
        input("Application ID: ").strip()
    )

    status = input("New status: ").strip().lower()

    application = update_application_status(
        application_id=application_id,
        status=status,
    )

    if application is None:
        print(
            f"Application #{application_id} "
            "was not found."
        )
        return

    print("Application updated:")
    print(application)


def show_all_applications():
    applications = list_applications()

    if not applications:
        print("No applications found.")
        return

    for application in applications:
        print_application(application)


def show_applications_by_status():
    status = input("Status: ").strip().lower()

    applications = list_applications_by_status(
        status
    )

    if not applications:
        print(
            f"No applications found "
            f"with status '{status}'."
        )
        return

    for application in applications:
        print_application(application)


def show_summary():
    statistics = get_summary_statistics()

    (
        company_count,
        position_count,
        application_count,
        planned_count,
        applied_count,
        interview_count,
        offer_count,
        rejected_count,
        withdrawn_count,
    ) = statistics

    print("\nSummary")
    print("-------")
    print(f"Companies:    {company_count}")
    print(f"Positions:    {position_count}")
    print(f"Applications: {application_count}")
    print()
    print(f"Planned:      {planned_count}")
    print(f"Applied:      {applied_count}")
    print(f"Interview:    {interview_count}")
    print(f"Offer:        {offer_count}")
    print(f"Rejected:     {rejected_count}")
    print(f"Withdrawn:    {withdrawn_count}")


def print_menu():
    print(
        """
AI Internship Tracker

1. Add company
2. Add position
3. Add application
4. Update application status
5. List all applications
6. Filter applications by status
7. Show summary statistics
0. Exit
"""
    )


def main():
    while True:
        print_menu()

        choice = input(
            "Choose an option: "
        ).strip()

        try:
            if choice == "1":
                create_company()

            elif choice == "2":
                create_position()

            elif choice == "3":
                create_application()

            elif choice == "4":
                change_application_status()

            elif choice == "5":
                show_all_applications()

            elif choice == "6":
                show_applications_by_status()

            elif choice == "7":
                show_summary()

            elif choice == "0":
                print("Goodbye.")
                break

            else:
                print("Invalid option.")

        except ValueError as exc:
            print(f"Invalid input: {exc}")

        except psycopg.Error as exc:
            print("Database error:")
            print(exc)


if __name__ == "__main__":
    main()
