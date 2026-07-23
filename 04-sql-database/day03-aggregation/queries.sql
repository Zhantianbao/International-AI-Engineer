-- SQL Day03: Aggregate functions and grouped reports
-- All statements in this file are read-only SELECT queries,
-- so the file can be executed repeatedly without modifying data.

-- ============================================================
-- Report 1: Count all company records
-- ============================================================

SELECT
    COUNT(*) AS total_companies
FROM companies;


-- ============================================================
-- Report 2: List distinct countries
-- ============================================================

SELECT DISTINCT
    country
FROM companies
ORDER BY country;


-- ============================================================
-- Report 3: Count all companies and distinct countries
-- ============================================================

SELECT
    COUNT(*) AS total_companies,
    COUNT(DISTINCT country) AS distinct_country_count
FROM companies;


-- ============================================================
-- Report 4: Summarize company identifiers
-- This is mainly used to practise aggregate syntax.
-- ============================================================

SELECT
    COUNT(*) AS company_count,
    MIN(company_id) AS minimum_company_id,
    MAX(company_id) AS maximum_company_id,
    SUM(company_id) AS company_id_sum,
    ROUND(AVG(company_id), 2) AS average_company_id
FROM companies;


-- ============================================================
-- Report 5: Summarize company-name lengths
-- ============================================================

SELECT
    COUNT(*) AS company_count,
    SUM(LENGTH(name)) AS total_name_characters,
    ROUND(AVG(LENGTH(name)), 2) AS average_name_length,
    MIN(LENGTH(name)) AS shortest_name_length,
    MAX(LENGTH(name)) AS longest_name_length
FROM companies;


-- ============================================================
-- Report 6: Count companies by country
-- ============================================================

SELECT
    country,
    COUNT(*) AS company_count
FROM companies
GROUP BY country
ORDER BY country;


-- ============================================================
-- Report 7: Count companies by remote-friendly status
-- ============================================================

SELECT
    is_remote_friendly,
    COUNT(*) AS company_count
FROM companies
GROUP BY is_remote_friendly
ORDER BY is_remote_friendly;


-- ============================================================
-- Report 8: Count companies by country and remote status
-- ============================================================

SELECT
    country,
    is_remote_friendly,
    COUNT(*) AS company_count
FROM companies
GROUP BY
    country,
    is_remote_friendly
ORDER BY
    country,
    is_remote_friendly;


-- ============================================================
-- Report 9: Show countries containing at least two companies
-- ============================================================

SELECT
    country,
    COUNT(*) AS company_count
FROM companies
GROUP BY country
HAVING COUNT(*) >= 2
ORDER BY company_count DESC;


-- ============================================================
-- Report 10: Count remote-friendly companies by country
-- WHERE filters rows before grouping.
-- HAVING filters groups after aggregation.
-- ============================================================

SELECT
    country,
    COUNT(*) AS remote_company_count
FROM companies
WHERE is_remote_friendly = TRUE
GROUP BY country
HAVING COUNT(*) >= 2
ORDER BY remote_company_count DESC;


-- ============================================================
-- Report 11: Produce multiple summary values for each country
-- ============================================================

SELECT
    country,
    COUNT(*) AS company_count,
    SUM(LENGTH(name)) AS total_name_characters,
    ROUND(AVG(LENGTH(name)), 2) AS average_name_length,
    MIN(LENGTH(name)) AS shortest_name_length,
    MAX(LENGTH(name)) AS longest_name_length
FROM companies
GROUP BY country
ORDER BY country;


-- ============================================================
-- Report 12: Filter countries by average company-name length
-- ============================================================

SELECT
    country,
    ROUND(AVG(LENGTH(name)), 2) AS average_name_length
FROM companies
GROUP BY country
HAVING AVG(LENGTH(name)) >= 7
ORDER BY average_name_length DESC;


-- ============================================================
-- Report 13: Count companies and distinct countries
-- within each remote-friendly status group
-- ============================================================

SELECT
    is_remote_friendly,
    COUNT(*) AS company_count,
    COUNT(DISTINCT country) AS distinct_country_count
FROM companies
GROUP BY is_remote_friendly
ORDER BY is_remote_friendly;
