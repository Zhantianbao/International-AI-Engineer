-- SQL Day01: PostgreSQL basics
-- This file records the SQL statements practised interactively.
-- Because the database, table, and rows already exist,
-- rerunning every active statement may produce "already exists"
-- or duplicate-key errors.

-- ============================================================
-- 1. Create the learning database
-- Run this while connected to the default postgres database.
-- It is commented out because sql_learning has already been created.
-- ============================================================

-- CREATE DATABASE sql_learning
-- WITH
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'C.utf8'
--     LC_CTYPE = 'C.utf8'
--     TEMPLATE = template0;

-- psql meta-command used to connect:
-- \c sql_learning


-- ============================================================
-- 2. Create the companies table
-- Already executed interactively.
-- ============================================================

CREATE TABLE companies (
    company_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL,
    is_remote_friendly BOOLEAN NOT NULL DEFAULT FALSE
);


-- ============================================================
-- 3. Insert valid company data
-- ============================================================

INSERT INTO companies (
    name,
    country,
    is_remote_friendly
)
VALUES (
    'OpenAI',
    'United States',
    TRUE
);

-- is_remote_friendly is omitted here,
-- so PostgreSQL uses DEFAULT FALSE.
INSERT INTO companies (
    name,
    country
)
VALUES (
    'Deepseek',
    'China'
);

INSERT INTO companies (
    name,
    country,
    is_remote_friendly
)
VALUES (
    'Anthropic',
    'United States',
    TRUE
)
RETURNING
    company_id,
    name,
    country,
    is_remote_friendly;


-- ============================================================
-- 4. Query the table
-- ============================================================

SELECT
    company_id,
    name,
    country,
    is_remote_friendly
FROM companies
ORDER BY company_id;


-- ============================================================
-- 5. Constraint tests
-- These statements are commented out because they are expected
-- to fail intentionally.
-- ============================================================

-- UNIQUE constraint test:
-- INSERT INTO companies (
--     name,
--     country,
--     is_remote_friendly
-- )
-- VALUES (
--     'OpenAI',
--     'United States',
--     TRUE
-- );

-- NOT NULL constraint test:
-- INSERT INTO companies (
--     name,
--     country,
--     is_remote_friendly
-- )
-- VALUES (
--     'Anthropic',
--     NULL,
--     TRUE
-- );
