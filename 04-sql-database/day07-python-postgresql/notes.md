# Day07 Notes — Python + PostgreSQL

## 1. Psycopg 3

Psycopg is a PostgreSQL database driver for Python.

Install:

```bash
python -m pip install "psycopg[binary]"
```

Import:

```python
import psycopg
```

## 2. Database Connection

Database credentials are read from environment variables instead of being hard-coded.

```python
import os
import psycopg


def get_connection():
    return psycopg.connect(
        host=os.environ["DB_HOST"],
        port=os.environ["DB_PORT"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    )
```

The local `.env` file contains real credentials and must not be committed.

`.env.example` contains only placeholder values and can be committed.

## 3. Connection and Cursor

A connection represents a connection to PostgreSQL.

```python
conn = get_connection()
```

A cursor executes SQL and fetches query results.

```python
cur = conn.cursor()
cur.execute("SELECT ...")
rows = cur.fetchall()
```

Using context managers simplifies cleanup:

```python
with get_connection() as conn:
    with conn.cursor() as cur:
        cur.execute(...)
```

With a Psycopg connection context manager:

- normal exit -> COMMIT
- exception -> ROLLBACK
- connection is closed when the context exits

## 4. Parameterized SQL

Never build SQL using user input with f-strings or string concatenation.

Unsafe pattern:

```python
sql = f"SELECT * FROM applications WHERE status = '{status}'"
```

Use Psycopg parameters:

```python
cur.execute(
    """
    SELECT *
    FROM applications
    WHERE status = %s;
    """,
    (status,),
)
```

`%s` is a Psycopg parameter placeholder.

For one parameter:

```python
(status,)
```

The comma creates a one-element tuple.

Parameterized queries keep SQL structure separate from data and reduce SQL injection risk.

## 5. Fetching Results

Fetch one row:

```python
row = cur.fetchone()
```

Fetch all remaining rows:

```python
rows = cur.fetchall()
```

A normal PostgreSQL result row is represented as a Python tuple.

## 6. RETURNING

PostgreSQL can return values from an inserted or updated row.

```sql
INSERT INTO companies (...)
VALUES (...)
RETURNING company_id, name;
```

Python can then use:

```python
row = cur.fetchone()
```

This avoids issuing another SELECT just to retrieve the generated ID.

## 7. Transactions

Explicit transaction control:

```python
conn.commit()
conn.rollback()
```

`COMMIT` permanently saves the transaction.

`ROLLBACK` discards uncommitted changes.

The current transaction can see its own uncommitted changes.

PostgreSQL sequences are not rolled back, so generated identity values can contain gaps.

## 8. Error Handling

Psycopg database errors inherit from:

```python
psycopg.Error
```

Example:

```python
try:
    ...
except psycopg.Error as exc:
    print(exc)
```

A foreign key violation occurs when a row references another row that does not exist.

Example relationship:

```text
applications.position_id
        |
        v
positions.position_id
```

The foreign key protects referential integrity.

## 9. Repository Layer

The project separates the CLI from database access.

```text
app.py
  |
  v
repository.py
  |
  v
db.py
  |
  v
PostgreSQL
```

`app.py` handles:

- user input
- menus
- output
- user-facing error messages

`repository.py` handles:

- INSERT
- SELECT
- UPDATE
- parameterized SQL
- database access

`db.py` handles:

- PostgreSQL connection creation

## 10. Repository Operations

Implemented operations:

```text
add_company()
add_position()
add_application()
update_application_status()
list_applications()
list_applications_by_status()
get_summary_statistics()
```

## 11. SQL Functions Used

`COALESCE` returns the first non-NULL value.

```sql
COALESCE(applied_at, CURRENT_DATE)
```

Meaning:

```text
applied_at has a value
-> keep it

applied_at is NULL
-> use CURRENT_DATE
```

Conditional aggregate:

```sql
COUNT(*) FILTER (WHERE status = 'applied')
```

This counts only rows whose status is `applied`.

## 12. Python Input Processing

Remove leading and trailing whitespace:

```python
value.strip()
```

Convert text to lowercase:

```python
value.lower()
```

Convert user input to an integer:

```python
int(value)
```

Invalid integer input raises:

```text
ValueError
```

Parse an ISO date:

```python
date.fromisoformat("2026-08-10")
```

## 13. Security

Do not commit:

```text
.env
database passwords
virtual environments
__pycache__
```

Use environment variables for credentials.

Use parameterized SQL for values supplied to SQL statements.

Use a dedicated PostgreSQL application role instead of connecting the application as the PostgreSQL superuser.
