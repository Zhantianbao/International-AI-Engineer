from db import get_connection


def add_company(name, country, website_url=None, is_remote_friendly=False):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO companies (
                    name,
                    country,
                    website_url,
                    is_remote_friendly
                )
                VALUES (%s, %s, %s, %s)
                RETURNING company_id, name;
                """,
                (
                    name,
                    country,
                    website_url,
                    is_remote_friendly,
                ),
            )

            return cur.fetchone()


def add_position(
    company_id,
    title,
    location=None,
    remote_type="onsite",
    employment_type="internship",
    job_url=None,
    description=None,
    posted_at=None,
):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO positions (
                    company_id,
                    title,
                    location,
                    remote_type,
                    employment_type,
                    job_url,
                    description,
                    posted_at
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING position_id, title;
                """,
                (
                    company_id,
                    title,
                    location,
                    remote_type,
                    employment_type,
                    job_url,
                    description,
                    posted_at,
                ),
            )

            return cur.fetchone()


def add_application(
    position_id,
    status="planned",
    applied_at=None,
    notes=None,
):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO applications (
                    position_id,
                    status,
                    applied_at,
                    notes
                )
                VALUES (%s, %s, %s, %s)
                RETURNING application_id, position_id, status;
                """,
                (
                    position_id,
                    status,
                    applied_at,
                    notes,
                ),
            )

            return cur.fetchone()


def update_application_status(application_id, status):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                UPDATE applications
                SET
                    status = %s,
                    applied_at = CASE
                        WHEN %s = 'planned' THEN NULL
                        ELSE COALESCE(applied_at, CURRENT_DATE)
                    END,
                    updated_at = CURRENT_TIMESTAMP
                WHERE application_id = %s
                RETURNING
                    application_id,
                    status,
                    applied_at,
                    updated_at;
                """,
                (
                    status,
                    status,
                    application_id,
                ),
            )

            return cur.fetchone()


def list_applications():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT
                    a.application_id,
                    c.name AS company_name,
                    p.title AS position_title,
                    a.status,
                    a.applied_at
                FROM applications AS a
                INNER JOIN positions AS p
                    ON a.position_id = p.position_id
                INNER JOIN companies AS c
                    ON p.company_id = c.company_id
                ORDER BY a.application_id;
                """
            )

            return cur.fetchall()


def list_applications_by_status(status):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT
                    a.application_id,
                    c.name AS company_name,
                    p.title AS position_title,
                    a.status,
                    a.applied_at
                FROM applications AS a
                INNER JOIN positions AS p
                    ON a.position_id = p.position_id
                INNER JOIN companies AS c
                    ON p.company_id = c.company_id
                WHERE a.status = %s
                ORDER BY a.application_id;
                """,
                (status,),
            )

            return cur.fetchall()


def get_summary_statistics():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT
                    (SELECT COUNT(*) FROM companies) AS company_count,
                    (SELECT COUNT(*) FROM positions) AS position_count,
                    COUNT(*) AS application_count,
                    COUNT(*) FILTER (WHERE status = 'planned') AS planned_count,
                    COUNT(*) FILTER (WHERE status = 'applied') AS applied_count,
                    COUNT(*) FILTER (WHERE status = 'interview') AS interview_count,
                    COUNT(*) FILTER (WHERE status = 'offer') AS offer_count,
                    COUNT(*) FILTER (WHERE status = 'rejected') AS rejected_count,
                    COUNT(*) FILTER (WHERE status = 'withdrawn') AS withdrawn_count
                FROM applications;
                """
            )

            return cur.fetchone()
