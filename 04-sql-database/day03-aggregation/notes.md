# SQL Day03 — Aggregate Functions and Grouped Reports

## 1. Goal

Use SQL aggregate functions and grouped queries to produce meaningful database statistics.

---

## 2. Aggregate functions

Aggregate functions summarize multiple input rows into one result.

```text
COUNT → count records
SUM   → calculate a total
AVG   → calculate an average
MAX   → find the maximum value
MIN   → find the minimum value
```

Example:

```sql
SELECT
    COUNT(*) AS company_count,
    MIN(company_id) AS minimum_company_id,
    MAX(company_id) AS maximum_company_id,
    SUM(company_id) AS company_id_sum,
    AVG(company_id) AS average_company_id
FROM companies;
```

The `companies` table contains nine records, but the query returns one summary row.

---

## 3. COUNT

### Count all rows

```sql
SELECT COUNT(*)
FROM companies;
```

`COUNT(*)` counts every selected row.

### Count non-null column values

```sql
SELECT COUNT(country)
FROM companies;
```

`COUNT(column_name)` counts only rows where the selected column is not `NULL`.

### Count distinct values

```sql
SELECT COUNT(DISTINCT country)
FROM companies;
```

This first removes duplicate country values and then counts the remaining distinct values.

Current result:

```text
total companies: 9
distinct countries: 4
```

---

## 4. DISTINCT

`DISTINCT` removes duplicate result combinations.

One column:

```sql
SELECT DISTINCT
    country
FROM companies;
```

Multiple columns:

```sql
SELECT DISTINCT
    country,
    is_remote_friendly
FROM companies;
```

With multiple selected columns, PostgreSQL compares the complete combination:

```text
(country, is_remote_friendly)
```

It does not deduplicate each column independently.

---

## 5. Column aliases

`AS` gives a result column a temporary name:

```sql
SELECT
    COUNT(*) AS total_companies
FROM companies;
```

Without the alias, the output column might be named:

```text
count
```

With the alias, it becomes:

```text
total_companies
```

The alias changes only the query result heading. It does not rename the real database column.

---

## 6. Nested function calls

Functions can be nested:

```sql
AVG(LENGTH(name))
```

Execution happens from the inside out:

```text
LENGTH(name)
→ calculate the length of each company name

AVG(...)
→ calculate the average of those lengths
```

Example:

```sql
SELECT
    SUM(LENGTH(name)) AS total_name_characters,
    AVG(LENGTH(name)) AS average_name_length,
    MIN(LENGTH(name)) AS shortest_name_length,
    MAX(LENGTH(name)) AS longest_name_length
FROM companies;
```

---

## 7. ROUND

`ROUND` rounds a numeric value:

```sql
ROUND(AVG(LENGTH(name)), 2)
```

Arguments:

```text
first argument  → numeric value to round
second argument → number of decimal places
```

Example output:

```text
7.50
7.20
```

---

## 8. GROUP BY

`GROUP BY` places rows with the same grouping value into one group.

```sql
SELECT
    country,
    COUNT(*) AS company_count
FROM companies
GROUP BY country;
```

Conceptually:

```text
all company rows
→ separate rows by country
→ count the rows in each country group
→ return one result row per country
```

Current grouped result:

```text
China           → 2
Germany         → 1
United Kingdom  → 1
United States   → 5
```

---

## 9. Grouping by multiple columns

```sql
SELECT
    country,
    is_remote_friendly,
    COUNT(*) AS company_count
FROM companies
GROUP BY
    country,
    is_remote_friendly;
```

The grouping key is the complete combination:

```text
(country, is_remote_friendly)
```

For example:

```text
(China, true)
(Germany, false)
(United States, true)
```

This behaves similarly to `DISTINCT` over multiple columns.

---

## 10. SELECT rules with GROUP BY

After using `GROUP BY`, each selected expression must generally be either:

1. included in `GROUP BY`; or
2. processed by an aggregate function.

Valid:

```sql
SELECT
    country,
    COUNT(*)
FROM companies
GROUP BY country;
```

Invalid:

```sql
SELECT
    country,
    company_id,
    COUNT(*)
FROM companies
GROUP BY country;
```

A country group can contain several different `company_id` values, so PostgreSQL cannot choose one identifier to display.

Possible solutions include:

```sql
MIN(company_id)
MAX(company_id)
ARRAY_AGG(company_id)
```

Adding a primary key to `GROUP BY` is usually not useful for reporting because every row forms its own group and `COUNT(*)` becomes `1`.

---

## 11. HAVING

`HAVING` filters groups after grouping and aggregation.

```sql
SELECT
    country,
    COUNT(*) AS company_count
FROM companies
GROUP BY country
HAVING COUNT(*) >= 2;
```

This retains only country groups containing at least two companies.

Current result:

```text
United States → 5
China         → 2
```

---

## 12. WHERE and HAVING

### WHERE

`WHERE` filters individual rows before grouping.

```sql
WHERE is_remote_friendly = TRUE
```

### HAVING

`HAVING` filters completed groups after aggregation.

```sql
HAVING COUNT(*) >= 2
```

Combined example:

```sql
SELECT
    country,
    COUNT(*) AS remote_company_count
FROM companies
WHERE is_remote_friendly = TRUE
GROUP BY country
HAVING COUNT(*) >= 2
ORDER BY remote_company_count DESC;
```

Conceptual execution order:

```text
FROM
→ WHERE
→ GROUP BY
→ aggregate functions
→ HAVING
→ SELECT
→ ORDER BY
```

`WHERE COUNT(*) >= 2` is not valid because the aggregate value does not exist at the `WHERE` stage.

Without an explicit `GROUP BY`, an aggregate query can treat all selected rows as one implicit group:

```sql
SELECT COUNT(*)
FROM companies
HAVING COUNT(*) >= 5;
```

---

## 13. ORDER BY with reports

```sql
ORDER BY company_count DESC;
```

`DESC` stands for:

```text
Descending
```

It sorts from larger values to smaller values.

```sql
ORDER BY company_count ASC;
```

`ASC` stands for:

```text
Ascending
```

It sorts from smaller values to larger values and is the default.

Aliases can be used in `ORDER BY`:

```sql
COUNT(*) AS company_count
...
ORDER BY company_count DESC;
```

---

## 14. Grouped reports

A grouped report summarizes records by category.

Example:

```sql
SELECT
    country,
    COUNT(*) AS company_count
FROM companies
GROUP BY country;
```

In this report:

```text
category → country
record   → one row in the companies table
```

A report query answers a meaningful analytical question, such as:

- How many companies are in each country?
- Which countries contain at least two companies?
- How many remote-friendly companies exist in each country?
- What is the average company-name length by country?
- How many distinct countries occur in each remote-status group?

Day03 includes thirteen report queries, exceeding the required minimum of eight.

---

## 15. Reports completed

The queries include:

1. Total number of companies.
2. List of distinct countries.
3. Total companies and distinct-country count.
4. Minimum, maximum, sum, and average company identifiers.
5. Company-name length summary.
6. Company count by country.
7. Company count by remote status.
8. Company count by country and remote status.
9. Countries containing at least two companies.
10. Remote-friendly company count by country.
11. Multiple name-length statistics by country.
12. Countries whose average name length is at least seven.
13. Company and distinct-country counts by remote status.

---

## 16. Errors encountered

### Running Git outside the repository

```text
fatal: not a git repository
```

The command was initially executed from:

```text
/home/skybaby
```

instead of the repository directory.

### Executing a filename as a command

```bash
queries.sql
```

caused:

```text
command not found
```

A filename is not automatically a Shell command. `touch queries.sql` was used to create the file.

### SQL spelling errors

Incorrect:

```sql
DRDER BY
FORM companies
GROUP BY county
FROM companiess
```

Correct:

```sql
ORDER BY
FROM companies
GROUP BY country
FROM companies
```

### Copying the psql prompt

Text such as:

```text
sql_learning=#
```

is a client prompt, not part of the SQL statement.

When pasted into SQL input, PostgreSQL reports a syntax error.

`Ctrl + C` can clear the unfinished input buffer.

---

## 17. Final understanding

Aggregate functions reduce multiple records to summary values.

`GROUP BY` creates categories of rows.

`HAVING` filters grouped results.

The key distinction is:

```text
WHERE  → filters records before grouping
HAVING → filters groups after aggregation
```
