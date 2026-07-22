-- SQL Day02: CRUD, filtering, sorting, and pagination
-- The write operations are commented out because they were already
-- executed interactively and should not be repeated accidentally.

-- ============================================================
-- 1. Read all records
-- ============================================================

SELECT
    company_id,
    name,
    country,
    is_remote_friendly
FROM companies
ORDER BY company_id;


-- ============================================================
-- 2. Comparison operators
-- ============================================================

SELECT
    company_id,
    name
FROM companies
WHERE company_id > 7
ORDER BY company_id;

SELECT
    company_id,
    name
FROM companies
WHERE company_id <= 2
ORDER BY company_id;

SELECT
    company_id,
    name
FROM companies
WHERE company_id <> 5
ORDER BY company_id;

SELECT
    company_id,
    name,
    country,
    is_remote_friendly
FROM companies
WHERE is_remote_friendly = FALSE
ORDER BY company_id;


-- ============================================================
-- 3. AND, OR, and NOT
-- ============================================================

SELECT
    company_id,
    name,
    country,
    is_remote_friendly
FROM companies
WHERE country = 'United States'
  AND is_remote_friendly = TRUE
ORDER BY name;

SELECT
    company_id,
    name,
    country
FROM companies
WHERE country = 'China'
   OR country = 'Germany'
ORDER BY country, name;

SELECT
    company_id,
    name,
    is_remote_friendly
FROM companies
WHERE NOT is_remote_friendly
ORDER BY name;


-- ============================================================
-- 4. IN and BETWEEN
-- ============================================================

SELECT
    company_id,
    name,
    country
FROM companies
WHERE country IN (
    'China',
    'Germany',
    'United Kingdom'
)
ORDER BY country, name;

SELECT
    company_id,
    name
FROM companies
WHERE company_id BETWEEN 5 AND 9
ORDER BY company_id;


-- ============================================================
-- 5. LIKE and ILIKE
-- ============================================================

-- Names beginning with uppercase G.
SELECT
    company_id,
    name
FROM companies
WHERE name LIKE 'G%'
ORDER BY name;

-- Names containing the lowercase text "soft".
SELECT
    company_id,
    name
FROM companies
WHERE name LIKE '%soft%'
ORDER BY name;

-- Case-insensitive search for "AI".
SELECT
    company_id,
    name
FROM companies
WHERE name ILIKE '%AI%'
ORDER BY name;

-- Exactly one character after "SA".
SELECT
    company_id,
    name
FROM companies
WHERE name LIKE 'SA_'
ORDER BY name;


-- ============================================================
-- 6. NULL checks
-- ============================================================

SELECT *
FROM companies
WHERE country IS NULL;

SELECT
    company_id,
    name,
    country
FROM companies
WHERE country IS NOT NULL
ORDER BY company_id;


-- ============================================================
-- 7. Sorting and pagination
-- ============================================================

SELECT
    company_id,
    name
FROM companies
ORDER BY company_id
LIMIT 3;

SELECT
    company_id,
    name
FROM companies
ORDER BY company_id
LIMIT 3
OFFSET 3;


-- ============================================================
-- 8. Create: insert multiple records
-- Already executed.
-- ============================================================

-- INSERT INTO companies (
--     name,
--     country,
--     is_remote_friendly
-- )
-- VALUES
--     ('Google', 'United States', TRUE),
--     ('Microsoft', 'United States', TRUE),
--     ('SAP', 'Germany', FALSE),
--     ('Tencent', 'China', FALSE),
--     ('GitLab', 'United States', TRUE),
--     ('Canonical', 'United Kingdom', TRUE)
-- RETURNING
--     company_id,
--     name,
--     country,
--     is_remote_friendly;


-- ============================================================
-- 9. Update records safely
-- ============================================================

-- Preview the target rows before updating.
SELECT *
FROM companies
WHERE name = 'DeepSeek';

-- Already executed:
-- UPDATE companies
-- SET name = 'DeepSeek'
-- WHERE name = 'Deepseek'
-- RETURNING *;

-- Preview rows matching multiple conditions.
SELECT *
FROM companies
WHERE country = 'China'
ORDER BY company_id;

-- Already executed:
-- UPDATE companies
-- SET is_remote_friendly = TRUE
-- WHERE country = 'China'
--   AND is_remote_friendly = FALSE
-- RETURNING *;


-- ============================================================
-- 10. Delete records safely
-- ============================================================

-- Temporary test row already inserted and deleted:
--
-- INSERT INTO companies (
--     name,
--     country,
--     is_remote_friendly
-- )
-- VALUES (
--     'Temporary Labs',
--     'Test Country',
--     FALSE
-- )
-- RETURNING *;

-- Preview before deletion:
SELECT *
FROM companies
WHERE name = 'Temporary Labs';

-- Already executed:
-- DELETE FROM companies
-- WHERE name = 'Temporary Labs'
-- RETURNING *;


-- ============================================================
-- 11. Final verification
-- ============================================================

SELECT
    company_id,
    name,
    country,
    is_remote_friendly
FROM companies
ORDER BY company_id;

SELECT COUNT(*) AS total_companies
FROM companies;
