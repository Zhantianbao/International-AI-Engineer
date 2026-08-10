-- SQL Day05 — Joins and Advanced Queries
-- Database: ai_internship_tracker


-- =========================================================
-- 1. List positions with company information
-- INNER JOIN keeps only successfully matched rows.
-- =========================================================

SELECT
    p.position_id,
    p.title,
    c.name AS company_name,
    c.country,
    p.remote_type
FROM positions AS p
INNER JOIN companies AS c
    ON p.company_id = c.company_id
ORDER BY p.position_id;


-- =========================================================
-- 2. List every position with its application status
-- LEFT JOIN keeps all positions even when no application exists.
-- =========================================================

SELECT
    p.position_id,
    p.title,
    c.name AS company_name,
    a.status
FROM positions AS p
INNER JOIN companies AS c
    ON p.company_id = c.company_id
LEFT JOIN applications AS a
    ON p.position_id = a.position_id
ORDER BY p.position_id;


-- =========================================================
-- 3. List applications with position and company information
-- Three-table JOIN.
-- =========================================================

SELECT
    a.application_id,
    a.status,
    a.applied_at,
    p.position_id,
    p.title,
    c.company_id,
    c.name AS company_name,
    c.country
FROM applications AS a
INNER JOIN positions AS p
    ON a.position_id = p.position_id
INNER JOIN companies AS c
    ON p.company_id = c.company_id
ORDER BY a.application_id;


-- =========================================================
-- 4. List skills associated with each position
-- positions -> position_skills -> skills
-- =========================================================

SELECT
    p.position_id,
    p.title,
    s.skill_id,
    s.name AS skill_name,
    s.category,
    ps.is_required
FROM positions AS p
INNER JOIN position_skills AS ps
    ON p.position_id = ps.position_id
INNER JOIN skills AS s
    ON ps.skill_id = s.skill_id
ORDER BY
    p.position_id,
    ps.is_required DESC,
    s.name;


-- =========================================================
-- 5. Find positions without applications using LEFT JOIN
-- =========================================================

SELECT
    p.position_id,
    p.title
FROM positions AS p
LEFT JOIN applications AS a
    ON p.position_id = a.position_id
WHERE a.application_id IS NULL
ORDER BY p.position_id;


-- =========================================================
-- 6. Count applications for every company
-- COUNT(column) ignores NULL values.
-- =========================================================

SELECT
    c.company_id,
    c.name AS company_name,
    COUNT(a.application_id) AS application_count
FROM companies AS c
LEFT JOIN positions AS p
    ON c.company_id = p.company_id
LEFT JOIN applications AS a
    ON p.position_id = a.position_id
GROUP BY
    c.company_id,
    c.name
ORDER BY
    application_count DESC,
    c.company_id;


-- =========================================================
-- 7. Find positions without applications using a subquery
-- This is a correlated NOT EXISTS subquery.
-- =========================================================

SELECT
    p.position_id,
    p.title
FROM positions AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM applications AS a
    WHERE a.position_id = p.position_id
)
ORDER BY p.position_id;


-- =========================================================
-- 8. Diagnostic example: an incorrect JOIN
--
-- The second ON condition does not connect skills AS s.
-- It causes every matching position-skill relation to combine
-- with every skill and produces duplicated/incorrect rows.
-- LIMIT keeps the diagnostic output manageable.
-- =========================================================

SELECT
    p.position_id,
    p.title,
    ps.skill_id AS relation_skill_id,
    s.skill_id AS displayed_skill_id,
    s.name AS skill_name
FROM positions AS p
INNER JOIN position_skills AS ps
    ON p.position_id = ps.position_id
INNER JOIN skills AS s
    ON ps.position_id = p.position_id
ORDER BY
    p.position_id,
    s.skill_id
LIMIT 20;


-- =========================================================
-- 9. Detect duplicated business combinations produced
-- by the incorrect JOIN above.
-- =========================================================

SELECT
    p.position_id,
    s.skill_id,
    s.name AS skill_name,
    COUNT(*) AS duplicate_count
FROM positions AS p
INNER JOIN position_skills AS ps
    ON p.position_id = ps.position_id
INNER JOIN skills AS s
    ON ps.position_id = p.position_id
GROUP BY
    p.position_id,
    s.skill_id,
    s.name
HAVING COUNT(*) > 1
ORDER BY
    p.position_id,
    s.skill_id;


-- =========================================================
-- 10. Correct JOIN condition
-- position_skills.skill_id must match skills.skill_id.
-- =========================================================

SELECT
    p.position_id,
    p.title,
    s.skill_id,
    s.name AS skill_name,
    ps.is_required
FROM positions AS p
INNER JOIN position_skills AS ps
    ON p.position_id = ps.position_id
INNER JOIN skills AS s
    ON ps.skill_id = s.skill_id
ORDER BY
    p.position_id,
    s.skill_id;


-- Verify that the corrected JOIN has no duplicate
-- position-skill combinations.

SELECT
    COUNT(*) AS total_rows,
    COUNT(
        DISTINCT (
            p.position_id,
            s.skill_id
        )
    ) AS unique_position_skill_pairs
FROM positions AS p
INNER JOIN position_skills AS ps
    ON p.position_id = ps.position_id
INNER JOIN skills AS s
    ON ps.skill_id = s.skill_id;


-- =========================================================
-- 11. CTE: calculate application count for each company
-- =========================================================

WITH company_application_counts AS (
    SELECT
        c.company_id,
        c.name AS company_name,
        COUNT(a.application_id) AS application_count
    FROM companies AS c
    LEFT JOIN positions AS p
        ON c.company_id = p.company_id
    LEFT JOIN applications AS a
        ON p.position_id = a.position_id
    GROUP BY
        c.company_id,
        c.name
)
SELECT
    *
FROM company_application_counts
ORDER BY
    application_count DESC,
    company_id;


-- =========================================================
-- 12. Find the company or companies with the most applications
-- using a CTE and a scalar subquery.
-- =========================================================

WITH company_application_counts AS (
    SELECT
        c.company_id,
        c.name AS company_name,
        COUNT(a.application_id) AS application_count
    FROM companies AS c
    LEFT JOIN positions AS p
        ON c.company_id = p.company_id
    LEFT JOIN applications AS a
        ON p.position_id = a.position_id
    GROUP BY
        c.company_id,
        c.name
)
SELECT
    company_id,
    company_name,
    application_count
FROM company_application_counts
WHERE application_count = (
    SELECT MAX(application_count)
    FROM company_application_counts
)
ORDER BY company_id;
