BEGIN;

TRUNCATE TABLE
    position_skills,
    applications,
    skills,
    positions,
    companies
RESTART IDENTITY
CASCADE;

INSERT INTO companies (
    name,
    country,
    website_url,
    is_remote_friendly
)
VALUES
    (
        'OpenAI',
        'United States',
        'https://openai.com',
        TRUE
    ),
    (
        'DeepSeek',
        'China',
        'https://www.deepseek.com',
        TRUE
    ),
    (
        'Canonical',
        'United Kingdom',
        'https://canonical.com',
        TRUE
    );

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
SELECT
    companies.company_id,
    seed_positions.title,
    seed_positions.location,
    seed_positions.remote_type,
    seed_positions.employment_type,
    seed_positions.job_url,
    seed_positions.description,
    seed_positions.posted_at
FROM (
    VALUES
        (
            'OpenAI',
            'AI Engineer Intern',
            'San Francisco',
            'hybrid',
            'internship',
            'https://example.com/jobs/openai-ai-intern',
            'Build and evaluate AI applications.',
            DATE '2026-07-20'
        ),
        (
            'DeepSeek',
            'Backend Engineer Intern',
            'Beijing',
            'onsite',
            'internship',
            'https://example.com/jobs/deepseek-backend-intern',
            'Develop backend services for AI products.',
            DATE '2026-07-21'
        ),
        (
            'Canonical',
            'Python Developer Intern',
            'Remote',
            'remote',
            'internship',
            'https://example.com/jobs/canonical-python-intern',
            'Develop Python services in a distributed team.',
            DATE '2026-07-22'
        )
) AS seed_positions (
    company_name,
    title,
    location,
    remote_type,
    employment_type,
    job_url,
    description,
    posted_at
)
JOIN companies
    ON companies.name = seed_positions.company_name;

INSERT INTO skills (
    name,
    category
)
VALUES
    ('Python', 'programming_language'),
    ('PostgreSQL', 'database'),
    ('FastAPI', 'framework'),
    ('Git', 'tool'),
    ('Docker', 'devops'),
    ('Machine Learning', 'ai_ml');

INSERT INTO position_skills (
    position_id,
    skill_id,
    is_required
)
SELECT
    positions.position_id,
    skills.skill_id,
    seed_position_skills.is_required
FROM (
    VALUES
        (
            'https://example.com/jobs/openai-ai-intern',
            'Python',
            TRUE
        ),
        (
            'https://example.com/jobs/openai-ai-intern',
            'Machine Learning',
            TRUE
        ),
        (
            'https://example.com/jobs/openai-ai-intern',
            'PostgreSQL',
            FALSE
        ),
        (
            'https://example.com/jobs/deepseek-backend-intern',
            'Python',
            TRUE
        ),
        (
            'https://example.com/jobs/deepseek-backend-intern',
            'FastAPI',
            TRUE
        ),
        (
            'https://example.com/jobs/deepseek-backend-intern',
            'PostgreSQL',
            TRUE
        ),
        (
            'https://example.com/jobs/canonical-python-intern',
            'Python',
            TRUE
        ),
        (
            'https://example.com/jobs/canonical-python-intern',
            'Git',
            TRUE
        ),
        (
            'https://example.com/jobs/canonical-python-intern',
            'Docker',
            FALSE
        )
) AS seed_position_skills (
    job_url,
    skill_name,
    is_required
)
JOIN positions
    ON positions.job_url = seed_position_skills.job_url
JOIN skills
    ON skills.name = seed_position_skills.skill_name;

INSERT INTO applications (
    position_id,
    status,
    applied_at,
    notes
)
SELECT
    position_id,
    'applied',
    DATE '2026-07-24',
    'Application submitted through the company website.'
FROM positions
WHERE job_url = 'https://example.com/jobs/openai-ai-intern';

INSERT INTO applications (
    position_id,
    status,
    notes
)
SELECT
    position_id,
    'planned',
    'Review the job requirements before applying.'
FROM positions
WHERE job_url = 'https://example.com/jobs/canonical-python-intern';

COMMIT;
