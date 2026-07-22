# SQL Day02 — CRUD, Filtering, and Sorting

## 1. Goal

Learn how to retrieve, insert, update, and delete database records safely.

CRUD stands for:

- **Create** — 创建数据
- **Read** — 读取数据
- **Update** — 更新数据
- **Delete** — 删除数据

The corresponding SQL statements are:

```text
Create → INSERT
Read   → SELECT
Update → UPDATE
Delete → DELETE
```

---

## 2. Filtering with WHERE

`WHERE` determines which rows are included in an operation.

```sql
SELECT *
FROM companies
WHERE country = 'China';
```

Common comparison operators:

```text
=   equal to
<>  not equal to
>   greater than
<   less than
>=  greater than or equal to
<=  less than or equal to
```

PostgreSQL also accepts `!=`, but `<>` is the standard SQL form.

---

## 3. Logical operators

### AND

Both conditions must be true:

```sql
WHERE country = 'United States'
  AND is_remote_friendly = TRUE
```

### OR

At least one condition must be true:

```sql
WHERE country = 'China'
   OR country = 'Germany'
```

### NOT

Reverses a boolean condition:

```sql
WHERE NOT is_remote_friendly
```

For a non-null boolean column, this is equivalent to:

```sql
WHERE is_remote_friendly = FALSE
```

---

## 4. IN and BETWEEN

`IN` checks whether a value belongs to a list:

```sql
WHERE country IN (
    'China',
    'Germany',
    'United Kingdom'
)
```

It is similar to combining several equality comparisons with `OR`.

`BETWEEN` checks an inclusive range:

```sql
WHERE company_id BETWEEN 5 AND 9
```

This is equivalent to:

```sql
WHERE company_id >= 5
  AND company_id <= 9
```

Both boundary values are included.

---

## 5. LIKE and ILIKE

`LIKE` performs SQL pattern matching and is normally case-sensitive.

`ILIKE` is PostgreSQL's case-insensitive pattern-matching operator.

The `I` can be understood as:

```text
Insensitive
```

Wildcards:

```text
% → zero or more arbitrary characters
_ → exactly one arbitrary character
```

Examples:

```sql
LIKE 'G%'
```

Begins with uppercase `G`.

```sql
LIKE '%soft%'
```

Contains lowercase `soft`.

```sql
ILIKE '%AI%'
```

Contains `AI` without considering letter case.

```sql
LIKE 'SA_'
```

Begins with `SA` and has exactly one additional character.

`LIKE` patterns are not full regular expressions. PostgreSQL regular expressions use operators such as `~` and `~*`.

---

## 6. NULL checks

`NULL` represents a missing or unknown value.

It must be tested with:

```sql
IS NULL
IS NOT NULL
```

Incorrect:

```sql
WHERE country = NULL
```

Correct:

```sql
WHERE country IS NULL
```

`IS` can also be used in expressions such as:

```sql
IS TRUE
IS FALSE
IS UNKNOWN
IS DISTINCT FROM
IS NOT DISTINCT FROM
```

It cannot normally be used as:

```sql
company_id IS 10
```

A normal number comparison uses:

```sql
company_id = 10
```

---

## 7. Sorting

```sql
ORDER BY company_id;
```

sorts in ascending order by default.

```sql
ORDER BY country, name;
```

sorts by `country` first, and then by `name` when countries are equal.

Without `ORDER BY`, SQL query results have no guaranteed order.

A result may appear to follow insertion order, but updates, deletes, indexes, query plans, and vacuum operations can change the returned order.

---

## 8. LIMIT and OFFSET

```sql
LIMIT 3
```

returns at most three rows.

```sql
LIMIT 3
OFFSET 3
```

skips the first three rows and then returns at most three rows.

Pagination operates on row positions after sorting, not on the numeric values of identifiers.

A stable `ORDER BY` should be used with `LIMIT` and `OFFSET`.

---

## 9. Inserting multiple rows

Multiple records can be inserted using one `INSERT` statement:

```sql
INSERT INTO companies (
    name,
    country,
    is_remote_friendly
)
VALUES
    ('Google', 'United States', TRUE),
    ('Microsoft', 'United States', TRUE),
    ('SAP', 'Germany', FALSE);
```

Each parenthesized value group represents one row.

The result:

```text
INSERT 0 3
```

means that three rows were inserted.

---

## 10. Safe UPDATE workflow

The general syntax is:

```sql
UPDATE table_name
SET column_name = new_value
WHERE condition
RETURNING columns;
```

Required clause order:

```text
UPDATE → SET → WHERE → RETURNING
```

Safe procedure:

1. Write a `SELECT` with the intended `WHERE`.
2. Confirm that it returns exactly the intended rows.
3. Reuse the same condition in `UPDATE`.
4. Use `RETURNING` to inspect the modified rows.
5. Run another `SELECT` to verify the final state.

Example:

```sql
SELECT *
FROM companies
WHERE name = 'Deepseek';
```

```sql
UPDATE companies
SET name = 'DeepSeek'
WHERE name = 'Deepseek'
RETURNING *;
```

An `UPDATE` without `WHERE` targets every row in the table.

---

## 11. Safe DELETE workflow

The general syntax is:

```sql
DELETE FROM table_name
WHERE condition
RETURNING columns;
```

Safe procedure:

1. Preview target rows using `SELECT`.
2. Confirm the condition is sufficiently specific.
3. Execute `DELETE` with the same `WHERE`.
4. Use `RETURNING` to inspect the deleted rows.
5. Query again to confirm that they no longer exist.

An unqualified statement:

```sql
DELETE FROM companies;
```

deletes every row but leaves the table structure intact.

---

## 12. RETURNING

PostgreSQL's `RETURNING` clause can be used with:

```text
INSERT
UPDATE
DELETE
```

Examples:

```sql
INSERT ... RETURNING *;
UPDATE ... RETURNING *;
DELETE ... RETURNING *;
```

It immediately returns the affected rows and reduces the need for an additional query.

The command results indicate affected-row counts:

```text
INSERT 0 6 → inserted 6 rows
UPDATE 1   → updated 1 row
UPDATE 2   → updated 2 rows
DELETE 1   → deleted 1 row
```

---

## 13. Column selection

This query:

```sql
SELECT
    company_id,
    name,
    *
FROM companies;
```

duplicates `company_id` and `name`, because `*` already expands to every column.

Use either:

```sql
SELECT *
FROM companies;
```

or an explicit column list:

```sql
SELECT
    company_id,
    name
FROM companies;
```

Explicit columns are usually clearer in application code.

---

## 14. Errors encountered

### Misspelled SQL keywords

Incorrect:

```sql
SELECE
FORM
INSET
```

Correct:

```sql
SELECT
FROM
INSERT
```

These errors were caught during parsing and did not modify data.

### Missing comma between selected columns

This input:

```sql
SELECT
    company_id
    name
FROM companies;
```

was interpreted as:

```sql
SELECT
    company_id AS name
FROM companies;
```

It returned one column named `name` rather than two columns.

The correct form is:

```sql
SELECT
    company_id,
    name
FROM companies;
```

### Canceled unfinished input

`Ctrl + C` cleared the unfinished `psql` input buffer. The canceled query was not executed.

---

## 15. Final database state

The table contains nine companies.

The company name was updated from:

```text
Deepseek
```

to:

```text
DeepSeek
```

The Chinese companies were updated to remote-friendly.

The temporary deletion-test row was successfully removed.

The deleted identity value `12` will normally not be reused. Identity columns guarantee unique generated values, but not continuous numbering.
