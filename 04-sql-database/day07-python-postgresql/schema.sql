BEGIN;

DROP TABLE IF EXISTS position_skills;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS companies;

CREATE TABLE companies (
    company_id INTEGER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL,
    website_url TEXT,
    is_remote_friendly BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_companies
        PRIMARY KEY (company_id),

    CONSTRAINT uq_companies_name
        UNIQUE (name),

    CONSTRAINT ck_companies_name_not_blank
        CHECK (BTRIM(name) <> ''),

    CONSTRAINT ck_companies_country_not_blank
        CHECK (BTRIM(country) <> ''),

    CONSTRAINT ck_companies_website_url
        CHECK (
            website_url IS NULL
            OR website_url ~ '^https?://'
        )
);

CREATE TABLE positions (
    position_id INTEGER GENERATED ALWAYS AS IDENTITY,
    company_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    location VARCHAR(150),
    remote_type VARCHAR(20) NOT NULL DEFAULT 'onsite',
    employment_type VARCHAR(30) NOT NULL DEFAULT 'internship',
    job_url TEXT,
    description TEXT,
    posted_at DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_positions
        PRIMARY KEY (position_id),

    CONSTRAINT fk_positions_company
        FOREIGN KEY (company_id)
        REFERENCES companies(company_id)
        ON DELETE RESTRICT,

    CONSTRAINT uq_positions_job_url
        UNIQUE (job_url),

    CONSTRAINT ck_positions_title_not_blank
        CHECK (BTRIM(title) <> ''),

    CONSTRAINT ck_positions_remote_type
        CHECK (
            remote_type IN (
                'onsite',
                'hybrid',
                'remote'
            )
        ),

    CONSTRAINT ck_positions_employment_type
        CHECK (
            employment_type IN (
                'internship',
                'part_time',
                'full_time',
                'contract'
            )
        ),

    CONSTRAINT ck_positions_job_url
        CHECK (
            job_url IS NULL
            OR job_url ~ '^https?://'
        )
);

CREATE TABLE applications (
    application_id INTEGER GENERATED ALWAYS AS IDENTITY,
    position_id INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'planned',
    applied_at DATE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_applications
        PRIMARY KEY (application_id),

    CONSTRAINT uq_applications_position
        UNIQUE (position_id),

    CONSTRAINT fk_applications_position
        FOREIGN KEY (position_id)
        REFERENCES positions(position_id)
        ON DELETE CASCADE,

    CONSTRAINT ck_applications_status
        CHECK (
            status IN (
                'planned',
                'applied',
                'interview',
                'offer',
                'rejected',
                'withdrawn'
            )
        ),

    CONSTRAINT ck_applications_applied_at
        CHECK (
            status = 'planned'
            OR applied_at IS NOT NULL
        ),

    CONSTRAINT ck_applications_updated_at
        CHECK (
            updated_at >= created_at
        )
);

CREATE TABLE skills (
    skill_id INTEGER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(30) NOT NULL DEFAULT 'other',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_skills
        PRIMARY KEY (skill_id),

    CONSTRAINT uq_skills_name
        UNIQUE (name),

    CONSTRAINT ck_skills_name_not_blank
        CHECK (BTRIM(name) <> ''),

    CONSTRAINT ck_skills_category
        CHECK (
            category IN (
                'programming_language',
                'framework',
                'database',
                'ai_ml',
                'cloud',
                'devops',
                'tool',
                'other'
            )
        )
);

CREATE TABLE position_skills (
    position_id INTEGER NOT NULL,
    skill_id INTEGER NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_position_skills
        PRIMARY KEY (
            position_id,
            skill_id
        ),

    CONSTRAINT fk_position_skills_position
        FOREIGN KEY (position_id)
        REFERENCES positions(position_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_position_skills_skill
        FOREIGN KEY (skill_id)
        REFERENCES skills(skill_id)
        ON DELETE CASCADE
);

COMMIT;
