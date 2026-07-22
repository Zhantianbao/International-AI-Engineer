# SQL Day01 — PostgreSQL Basics

## 1. Learning goals

- Understand the relationship between SQL, PostgreSQL, databases, schemas, and tables.
- Verify the PostgreSQL server process and connection.
- Create a UTF-8 learning database.
- Create the first relational table.
- Insert and query data.
- Understand primary keys, unique constraints, not-null constraints, default values, identity columns, and B-tree indexes.

---

## 2. SQL and PostgreSQL

### SQL

SQL stands for:

- **Structured** — 结构化的
- **Query** — 查询
- **Language** — 语言

SQL is a language used to define, query, insert, update, and delete relational data.

### PostgreSQL

PostgreSQL is a relational database management system.

RDBMS stands for:

- **Relational** — 关系型的
- **Database** — 数据库
- **Management** — 管理
- **System** — 系统

PostgreSQL receives SQL statements, checks permissions and constraints, executes operations, and safely manages database files.

The basic hierarchy is:

```text
PostgreSQL server instance
└── database
    └── schema
        └── table
            ├── columns
            └── rows
```

The default schema used in this exercise is:

```text
public
```

The complete table name is therefore:

```text
public.companies
```

---

## 3. Client and server

`psql` is the PostgreSQL command-line client.

The connection structure is:

```text
psql client
    ↓
Unix socket or TCP connection
    ↓
PostgreSQL server
    ↓
database files
```

The client must not directly edit PostgreSQL data files. All database operations are handled by the PostgreSQL server so that transactions, concurrency, permissions, and data integrity remain valid.

The connection used in this exercise was:

```text
database: sql_learning
role: postgres
socket directory: /var/run/postgresql
configured port: 5432
```

Because no `-h` option was supplied to `psql`, the connection used a Unix domain socket rather than a TCP network connection.

---

## 4. SQL statements and psql meta-commands

### SQL statements

SQL statements are sent to the PostgreSQL server and normally end with a semicolon:

```sql
SELECT *
FROM companies;
```

### psql meta-commands

Commands beginning with `\` are interpreted by the `psql` client itself.

They usually do not require a semicolon.

```text
\l
```

Lists databases.

```text
\c sql_learning
```

Connects to the `sql_learning` database.

```text
\dt
```

Lists visible tables.

- `d` can be understood as `describe`
- `t` means `table`

```text
\d companies
```

Shows the structure of the `companies` table.

```text
\conninfo
```

Shows the current connection information.

```text
\q
```

Quits `psql`.

---

## 5. psql prompts

```text
sql_learning=#
```

Means:

- connected to the `sql_learning` database;
- ready to accept a new command;
- current database role is a superuser.

```text
sql_learning-#
```

Means the current SQL statement is not finished, usually because the semicolon has not been entered.

```text
sql_learning(#
```

Means an opening parenthesis has not yet been closed.

To cancel unfinished input:

```text
Ctrl + C
```

To clear the current SQL buffer:

```text
\r
```

---

## 6. Database creation

The learning database was created with:

```sql
CREATE DATABASE sql_learning
WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C.utf8'
    LC_CTYPE = 'C.utf8'
    TEMPLATE = template0;
```

### OWNER

```sql
OWNER = postgres
```

Specifies which PostgreSQL role owns and manages the database.

This is a PostgreSQL permission concept, not a Linux file owner.

### ENCODING

```sql
ENCODING = 'UTF8'
```

Specifies how text characters are stored as bytes.

UTF-8 supports Chinese, English, many other languages, and international characters.

The original default databases used `LATIN1`, which does not support the full range of international characters required by modern applications.

### LC_COLLATE

```sql
LC_COLLATE = 'C.utf8'
```

Controls text comparison and sorting rules.

It affects operations such as:

```sql
ORDER BY name;
```

### LC_CTYPE

```sql
LC_CTYPE = 'C.utf8'
```

Controls character classification and case-conversion behavior, such as identifying letters and converting between uppercase and lowercase.

### TEMPLATE

```sql
TEMPLATE = template0
```

PostgreSQL creates a new database by copying a template database.

`template0` is the clean original template and can be used when the new database requires a different encoding or locale from `template1`.

---

## 7. Table definition

The first table was created with:

```sql
CREATE TABLE companies (
    company_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL,
    is_remote_friendly BOOLEAN NOT NULL DEFAULT FALSE
);
```

A column definition generally has this structure:

```text
column_name + data_type + optional clauses and constraints
```

### company_id

```sql
company_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
```

- `company_id` — column name
- `INTEGER` — integer data type
- `GENERATED ALWAYS AS IDENTITY` — PostgreSQL automatically generates the value
- `PRIMARY KEY` — uniquely identifies every row and does not allow `NULL`

### name

```sql
name VARCHAR(100) NOT NULL UNIQUE
```

- `VARCHAR(100)` — variable-length text with a maximum length of 100 characters
- `NOT NULL` — the value must be supplied
- `UNIQUE` — duplicate company names are not allowed

### country

```sql
country VARCHAR(100) NOT NULL
```

The country must contain a non-null text value.

### is_remote_friendly

```sql
is_remote_friendly BOOLEAN NOT NULL DEFAULT FALSE
```

- `BOOLEAN` — stores true or false
- `NOT NULL` — must always contain a boolean value
- `DEFAULT FALSE` — PostgreSQL uses false when the column is omitted from an insertion

PostgreSQL commonly displays boolean results as:

```text
t = true
f = false
```

---

## 8. Indexes and B-tree

After creating the table, PostgreSQL displayed:

```text
"companies_pkey" PRIMARY KEY, btree (company_id)
"companies_name_key" UNIQUE CONSTRAINT, btree (name)
```

### companies_pkey

This is the automatically generated primary-key index for:

```text
company_id
```

It helps PostgreSQL:

- prevent duplicate primary-key values;
- quickly locate rows using `company_id`;
- support equality and range queries.

### companies_name_key

This is the automatically generated unique constraint and index for:

```text
name
```

It enforces the rule that two companies cannot have the same name.

### B-tree

B-tree is a balanced multiway search-tree index structure.

It is suitable for:

- equality queries;
- greater-than and less-than comparisons;
- range queries;
- sorting.

Examples:

```sql
WHERE company_id = 5
```

```sql
WHERE company_id > 2
```

```sql
ORDER BY company_id
```

B-tree is not the same as a binary tree. A B-tree node may contain multiple keys and have multiple child nodes.

---

## 9. Inserting data

The general syntax is:

```sql
INSERT INTO table_name (
    column_name
)
VALUES (
    value
);
```

`INTO` identifies the destination table.

Example:

```sql
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
```

`company_id` was omitted because PostgreSQL generated it automatically.

When `is_remote_friendly` was omitted:

```sql
INSERT INTO companies (
    name,
    country
)
VALUES (
    'Deepseek',
    'China'
);
```

PostgreSQL used:

```text
DEFAULT FALSE
```

The successful command result:

```text
INSERT 0 1
```

means:

- `INSERT` — insertion succeeded;
- `0` — no legacy row OID was returned;
- `1` — one row was inserted.

---

## 10. RETURNING

`RETURNING` immediately returns values from the newly inserted row:

```sql
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
```

This avoids needing a separate `SELECT` merely to obtain the newly generated identity value.

---

## 11. Querying data

The query used was:

```sql
SELECT
    company_id,
    name,
    country,
    is_remote_friendly
FROM companies
ORDER BY company_id;
```

- `SELECT` specifies which columns to return.
- `FROM companies` specifies the source table.
- `ORDER BY company_id` sorts the result by company identifier.

`INTO` and `FROM` describe opposite data directions:

```text
INTO
→ where data is written

FROM
→ where data is read
```

---

## 12. Constraint tests

### UNIQUE constraint

Attempting to insert `OpenAI` twice produced:

```text
duplicate key value violates unique constraint "companies_name_key"
```

The duplicate row was rejected.

### NOT NULL constraint

Attempting to insert a row with:

```sql
country = NULL
```

produced a not-null constraint error.

`NULL` means that no value is present. It is not the same as:

```text
''
```

which is an empty string.

---

## 13. Identity values may contain gaps

The successful rows received identifiers:

```text
1
2
5
```

The failed constraint tests consumed identity values `3` and `4`.

The approximate execution order was:

```text
generate identity value
→ validate constraints
→ insert row if validation succeeds
```

If validation fails, the row is not stored, but the identity sequence normally does not move backward.

Therefore, automatically generated identifiers guarantee uniqueness, but they do not guarantee consecutive numbering.

Syntax errors and missing-table errors usually occur before an identity value is generated, while constraint errors may occur after a value has already been generated.

---

## 14. Errors encountered

### Misspelled boolean value

Incorrect:

```sql
TREU
```

Correct:

```sql
TRUE
```

Because `TREU` was neither a known keyword nor a quoted string, PostgreSQL interpreted it as an identifier and searched for a column named `treu`.

PostgreSQL normally folds unquoted identifiers to lowercase.

### Misspelled table name

Incorrect:

```sql
INSERT INTO companie
```

Correct:

```sql
INSERT INTO companies
```

PostgreSQL reported that relation `companie` did not exist.

### Missing semicolon

Entering:

```sql
SHOW lc_ctype
```

without a semicolon caused `psql` to wait for more input.

The next entered line was appended to the same SQL statement, resulting in a syntax error.

### Misspelled locale parameter

Incorrect:

```sql
SHOW ls_ctype;
```

Correct:

```sql
SHOW lc_ctype;
```

`LC` refers to a locale category.

---

## 15. Final table data

The final successfully inserted rows are:

```text
company_id | name      | country       | is_remote_friendly
-----------+-----------+---------------+-------------------
1          | OpenAI    | United States | true
2          | Deepseek  | China         | false
5          | Anthropic | United States | true
```

The missing identifiers `3` and `4` are expected because two attempted insertions failed after identity values had been generated.
