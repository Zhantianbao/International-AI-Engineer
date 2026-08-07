# SQL Day05 — Joins, Subqueries, and CTEs

## 1. Goal

Retrieve useful information from multiple related tables in the AI Internship Tracker database.

The main tables used today were:

```text
companies
positions
applications
skills
position_skills
```

---

## 2. Why JOIN is needed

The database is normalized, so related information is stored in separate tables.

For example:

```text
companies
→ company information

positions
→ position information

applications
→ application information
```

`positions` does not repeatedly store the company name and country.

Instead:

```text
positions.company_id
→ references companies.company_id
```

A `JOIN` combines related rows when querying without permanently merging the tables.

---

## 3. Table relationships

Important relationships:

```text
companies 1 ──────< positions

positions 1 ────── 0..1 applications

positions N >──────< N skills
             through
        position_skills
```

JOIN conditions should follow the real relationships between the tables.

Examples:

```sql
p.company_id = c.company_id
```

and:

```sql
a.position_id = p.position_id
```

Columns should not be joined merely because their numeric values happen to be equal.

---

## 4. Table aliases with AS

Example:

```sql
FROM positions AS p
INNER JOIN companies AS c
```

Aliases mean:

```text
p → positions
c → companies
a → applications
s → skills
ps → position_skills
```

Therefore:

```sql
p.title
```

means:

```sql
positions.title
```

Aliases are temporary and exist only during the current query.

`AS` can also rename an output column:

```sql
c.name AS company_name
```

This changes only the result heading, not the real database column.

---

## 5. INNER JOIN

`INNER JOIN` keeps rows for which both sides satisfy the join condition.

Example:

```sql
FROM positions AS p
INNER JOIN companies AS c
    ON p.company_id = c.company_id
```

The condition means:

```text
the company ID stored by the position
=
the primary key of the company
```

If no matching company existed, the position would not appear in the result.

In this project, a foreign key ensures that every position normally has a valid company.

---

## 6. LEFT JOIN

`LEFT JOIN` keeps every row from the left table.

Example:

```sql
FROM positions AS p
LEFT JOIN applications AS a
    ON p.position_id = a.position_id
```

Here:

```text
positions
→ left table

applications
→ right table
```

A position without an application still appears.

Columns from the missing right-side row become:

```text
NULL
```

Example:

```text
Backend Engineer Intern | NULL
```

Therefore:

```text
INNER JOIN
→ keep only matched rows

LEFT JOIN
→ keep every left-table row
→ fill unmatched right-side columns with NULL
```

---

## 7. ON

`ON` specifies how rows from two tables match.

Example:

```sql
ON p.company_id = c.company_id
```

This is based on the real company-position relationship.

An incorrect condition such as:

```sql
ON p.position_id = c.company_id
```

compares unrelated identifiers.

It might appear to work temporarily if generated IDs happen to have the same numbers, but the relationship is logically incorrect.

---

## 8. Using columns that are not in SELECT

`SELECT` controls which columns are displayed.

A column does not need to appear in `SELECT` to be used in:

```text
ON
WHERE
ORDER BY
```

Example:

```sql
SELECT
    p.title
FROM positions AS p
WHERE p.remote_type = 'remote';
```

`remote_type` is used for filtering but is not displayed.

The column must still come from a table available through `FROM` or `JOIN`.

---

## 9. Finding missing related rows

A useful `LEFT JOIN` pattern is:

```sql
SELECT
    p.position_id,
    p.title
FROM positions AS p
LEFT JOIN applications AS a
    ON p.position_id = a.position_id
WHERE a.application_id IS NULL;
```

`application_id` is a primary key, so a real application can never have:

```text
application_id = NULL
```

Therefore a `NULL` value after the `LEFT JOIN` reliably means that no application matched.

---

## 10. Joining three tables

Applications can be connected to companies through positions:

```text
applications
    ↓ position_id
positions
    ↓ company_id
companies
```

Example:

```sql
FROM applications AS a
INNER JOIN positions AS p
    ON a.position_id = p.position_id
INNER JOIN companies AS c
    ON p.company_id = c.company_id
```

The tables do not need a direct foreign key between every pair.

A relationship can be followed through another table.

---

## 11. Many-to-many JOIN

Positions and skills have a many-to-many relationship.

The connection path is:

```text
positions
→ position_skills
→ skills
```

Correct conditions:

```sql
ON p.position_id = ps.position_id
```

then:

```sql
ON ps.skill_id = s.skill_id
```

One position may appear multiple times in the result because each row can represent a different skill.

That is legitimate repetition, not necessarily a duplicate.

---

## 12. Incorrect JOINs and duplicated rows

A JOIN can produce incorrect duplicate rows even when the source tables contain no duplicate records.

Incorrect example:

```sql
INNER JOIN skills AS s
    ON ps.position_id = p.position_id
```

The condition does not reference `s` at all.

The new `skills` table therefore is not properly related to the existing rows.

This can cause a Cartesian-product-like expansion.

The correct condition is:

```sql
ON ps.skill_id = s.skill_id
```

Duplicate business combinations can be detected with:

```sql
GROUP BY ...
HAVING COUNT(*) > 1
```

A useful verification is to compare:

```text
total result rows
```

with:

```text
number of distinct business-key combinations
```

For the correct position-skill JOIN:

```text
total rows = 9
unique position-skill pairs = 9
```

---

## 13. GROUP BY with JOIN

JOINs can create multiple rows belonging to the same company.

To answer:

> How many applications does each company have?

the rows must be grouped by company.

Example:

```sql
GROUP BY
    c.company_id,
    c.name
```

Then:

```sql
COUNT(a.application_id)
```

counts applications inside each company group.

Without `GROUP BY`, the aggregate would calculate one result for the complete joined result set.

General idea:

```text
GROUP BY
→ choose the category

COUNT / SUM / AVG / MIN / MAX
→ calculate something for each category
```

---

## 14. COUNT(column) versus COUNT(*)

With `LEFT JOIN`, unmatched right-side rows contain `NULL`.

For application counts:

```sql
COUNT(a.application_id)
```

is preferable because it ignores `NULL`.

Therefore a company with no application receives:

```text
0
```

`COUNT(*)` counts result rows themselves and could incorrectly count an unmatched LEFT JOIN row as one.

---

## 15. Subqueries

A subquery is a query nested inside another SQL statement.

Example:

```sql
SELECT
    p.position_id,
    p.title
FROM positions AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM applications AS a
    WHERE a.position_id = p.position_id
);
```

The outer query reads positions.

The subquery checks whether an application exists for the current position.

---

## 16. SELECT 1 with EXISTS

In:

```sql
EXISTS (
    SELECT 1
    FROM applications
    WHERE ...
)
```

the number `1` is only a constant placeholder.

`EXISTS` does not care what the subquery returns.

It only checks:

```text
Did the subquery return at least one row?
```

Therefore:

```text
EXISTS
→ at least one matching row exists

NOT EXISTS
→ no matching row exists
```

---

## 17. Correlated subquery

This subquery:

```sql
SELECT 1
FROM applications AS a
WHERE a.position_id = p.position_id
```

uses:

```sql
p.position_id
```

from the outer query.

This is called a:

```text
correlated subquery
```

Conceptually:

```text
for each position:
    check whether applications contains
    a row for this position
```

The PostgreSQL optimizer may execute it differently internally, but this model explains its meaning.

---

## 18. Common subquery patterns

Single value:

```sql
WHERE value = (
    SELECT ...
)
```

Multiple possible values:

```sql
WHERE value IN (
    SELECT ...
)
```

Check whether rows exist:

```sql
WHERE EXISTS (
    SELECT 1 ...
)
```

Check whether rows do not exist:

```sql
WHERE NOT EXISTS (
    SELECT 1 ...
)
```

---

## 19. CTE

`CTE` means:

```text
Common Table Expression
```

Basic syntax:

```sql
WITH result_name AS (
    SELECT ...
)
SELECT ...
FROM result_name;
```

A CTE creates a named query result that can be referenced by the rest of the SQL statement.

It is not a permanent table.

Example:

```sql
WITH company_application_counts AS (
    ...
)
SELECT *
FROM company_application_counts;
```

The CTE makes a complex query easier to divide into logical stages.

---

## 20. Finding companies with the most applications

First, the CTE calculates:

```text
OpenAI     → 1
DeepSeek   → 0
Canonical  → 1
```

Then a scalar subquery calculates:

```sql
SELECT MAX(application_count)
FROM company_application_counts
```

which returns:

```text
1
```

The outer query keeps:

```sql
WHERE application_count = 1
```

Therefore both:

```text
OpenAI
Canonical
```

are returned because they are tied for the highest application count.

This is more appropriate than:

```sql
ORDER BY application_count DESC
LIMIT 1
```

when multiple companies can share first place.

---

## 21. Query-processing mental model

A simplified logical order is:

```text
FROM
→ JOIN / ON
→ WHERE
→ GROUP BY
→ aggregate calculations
→ HAVING
→ SELECT
→ ORDER BY
→ LIMIT
```

This explains why columns can be used for filtering even when they do not appear in the final `SELECT`.

---

## 22. Day05 understanding

Today I practised:

```text
INNER JOIN
LEFT JOIN
table aliases
join conditions
three-table joins
many-to-many joins
missing-related-row queries
GROUP BY with JOIN
COUNT with NULL
incorrect JOIN duplication
subqueries
EXISTS
NOT EXISTS
correlated subqueries
CTEs
scalar subqueries
```

The most important idea is:

> JOIN conditions must represent real table relationships.

A result containing repeated values is not automatically wrong. The correct question is whether each result row represents a distinct and valid business relationship.
