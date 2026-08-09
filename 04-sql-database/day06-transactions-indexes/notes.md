# SQL Day06 — Transactions, Indexes, and PostgreSQL Administration

## 1. Goal

Understand database reliability and performance, and practise basic PostgreSQL administration.

---

## 2. Transactions

A database transaction groups related database operations into one logical unit.

Basic structure:

```sql
BEGIN;

-- SQL operations

COMMIT;
```

or:

```sql
BEGIN;

-- SQL operations

ROLLBACK;
```

### BEGIN

`BEGIN` starts an explicit transaction.

In `psql`, the prompt changes from:

```text
ai_internship_tracker=#
```

to:

```text
ai_internship_tracker=*#
```

The `*` indicates that the current session is inside a transaction.

### COMMIT

`COMMIT` successfully ends the transaction and keeps its changes.

```text
BEGIN
→ perform changes
→ COMMIT
→ changes are accepted
```

### ROLLBACK

`ROLLBACK` ends the transaction and cancels changes that have not yet been committed.

```text
BEGIN
→ perform changes
→ ROLLBACK
→ return to the state before BEGIN
```

A rollback can cancel several SQL operations together.

---

## 3. Errors inside a PostgreSQL transaction

If a statement fails inside an explicit PostgreSQL transaction, the transaction enters an aborted state.

The `psql` prompt changes to something similar to:

```text
ai_internship_tracker=!#
```

Subsequent commands produce:

```text
current transaction is aborted,
commands ignored until end of transaction block
```

The transaction must normally be ended with:

```sql
ROLLBACK;
```

A syntax error such as a misspelled SQL keyword can also cause this behavior.

Without an explicit `BEGIN`, PostgreSQL normally runs each statement in its own automatically committed transaction.

Therefore an error in a later statement does not undo an earlier statement that was already committed.

---

## 4. ACID

`ACID` describes four important transaction properties.

### A — Atomicity

Atomicity means a transaction is treated as one logical unit.

```text
all operations succeed
or
the transaction is rolled back
```

Example:

```text
subtract money from account A
+
add money to account B
```

The system should not permanently perform only one half of the transfer.

### C — Consistency

Consistency means a successful transaction leaves the database in a state that satisfies its defined rules.

Examples include:

```text
PRIMARY KEY
FOREIGN KEY
NOT NULL
CHECK
UNIQUE
```

### I — Isolation

Isolation controls how concurrent transactions affect and observe each other.

Multiple transactions may run at the same time without being allowed to interfere arbitrarily.

### D — Durability

After a successful `COMMIT`, the change should remain reliably stored even after a client disconnect or system restart.

Summary:

```text
Atomicity   → all or nothing
Consistency → preserve valid database rules
Isolation   → control concurrent transactions
Durability  → committed data persists
```

---

## 5. Indexes

An index is an additional database data structure designed to make certain data access operations faster.

Example:

```sql
CREATE INDEX idx_positions_title
ON positions (title);
```

Remove it with:

```sql
DROP INDEX idx_positions_title;
```

The index does not replace the table.

The table stores the actual rows, while the index provides another access path to those rows.

---

## 6. Constraint indexes

PostgreSQL automatically creates indexes to support:

```text
PRIMARY KEY
UNIQUE
```

For example:

```text
pk_positions
uq_positions_job_url
```

appear when running:

```text
\di
```

They are indexes used to enforce corresponding constraints.

Other constraints do not automatically behave the same way:

```text
PRIMARY KEY → index automatically created
UNIQUE      → index automatically created
NOT NULL    → no index automatically created
CHECK       → no index automatically created
FOREIGN KEY referencing column
            → no index automatically created by PostgreSQL
```

A constraint describes a data rule.

An index is a data structure used for access and, in some cases, for implementing a constraint.

---

## 7. EXPLAIN

`EXPLAIN` shows the execution plan PostgreSQL intends to use.

Example:

```sql
EXPLAIN
SELECT *
FROM positions
WHERE title = 'AI Engineer Intern';
```

A possible result is:

```text
Seq Scan on positions
```

`Seq Scan` means:

```text
Sequential Scan
→ scan the table sequentially
```

A table can have an index and PostgreSQL can still choose a sequential scan.

The optimizer chooses the plan it estimates to have the lowest cost.

For a table containing only a few rows, scanning the complete table may be cheaper than using an index.

---

## 8. EXPLAIN ANALYZE

`EXPLAIN ANALYZE` actually executes the query and reports both estimated and actual execution information.

Important fields include:

```text
cost
rows
width
actual time
loops
```

### cost

Example:

```text
cost=0.00..590.34
```

These values are optimizer cost units, not milliseconds.

The first value is startup cost.

The second value is estimated total cost.

### rows

The `rows` value beside `cost` is an estimate.

Example:

```text
rows=9
```

means PostgreSQL estimated approximately nine rows.

Inside:

```text
actual ... rows=1
```

the value is the number of rows actually produced.

### width

`width` is the optimizer's estimated average size of each result row in bytes.

### actual time

`actual time` contains real execution timing measured while the query runs.

### loops

`loops` shows how many times a plan node was executed.

---

## 9. Index experiment

A temporary experiment inserted approximately 50,000 test rows.

Without the custom title index:

```text
Seq Scan on positions

Rows Removed by Filter: 50002

Execution Time: approximately 2.874 ms
```

With:

```sql
CREATE INDEX idx_positions_title
ON positions (title);
```

the same rare-value lookup used:

```text
Index Scan using idx_positions_title
```

and execution time was approximately:

```text
0.040 ms
```

The exact speed ratio is specific to this experiment and should not be generalized.

The important observation is:

```text
without suitable index
→ sequentially scan many unrelated rows

with suitable index
→ optimizer can directly locate a small matching subset
```

---

## 10. Index selectivity

An index is particularly useful when a condition selects a relatively small portion of a table.

For a value occurring in almost every row, PostgreSQL may still prefer:

```text
Seq Scan
```

even when an index exists.

Therefore:

```text
index exists
≠
index must be used
```

The query optimizer decides.

---

## 11. Costs of indexes

Indexes improve some reads, but they are not free.

They:

```text
consume storage
require maintenance
can make INSERT more expensive
can make DELETE more expensive
can make UPDATE of indexed values more expensive
```

For example, an inserted row may require PostgreSQL to update both:

```text
the table
+
relevant indexes
```

Therefore indexes should be created according to actual query requirements rather than added to every column.

---

## 12. ANALYZE

```sql
ANALYZE positions;
```

updates PostgreSQL statistics about the table.

Statistics help the query optimizer estimate:

```text
table size
value distribution
common values
NULL distribution
expected matching row counts
```

This improves execution-plan decisions.

After inserting a large amount of experimental data, `ANALYZE` was used before comparing plans.

---

## 13. PostgreSQL roles and users

PostgreSQL uses roles as its permission identities.

A user can be understood as a role with permission to log in.

Example:

```sql
CREATE ROLE day06_reader NOLOGIN;
```

creates a role that cannot directly log in.

`CREATE USER` is essentially a convenient form of creating a role with `LOGIN`.

---

## 14. Privileges

A read-only experiment used:

```sql
GRANT USAGE
ON SCHEMA public
TO day06_reader;
```

and:

```sql
GRANT SELECT
ON TABLE positions
TO day06_reader;
```

`GRANT` gives a privilege.

`REVOKE` removes a privilege.

The role could successfully:

```sql
SELECT ...
FROM positions;
```

but an attempted:

```sql
INSERT INTO positions ...
```

failed with:

```text
permission denied for table positions
```

This demonstrated that permissions are enforced independently.

---

## 15. Schema

A schema is a namespace inside a PostgreSQL database.

Simplified hierarchy:

```text
PostgreSQL instance
→ database
    → schema
        → table
```

For example:

```text
ai_internship_tracker
→ public
    → positions
```

The complete table name can therefore be written as:

```sql
public.positions
```

---

## 16. SET ROLE

```sql
SET ROLE day06_reader;
```

temporarily uses another role's privileges.

After switching from the PostgreSQL superuser to the restricted role, the `psql` prompt changed from:

```text
#
```

to:

```text
>
```

indicating that the current effective role was not a superuser.

Return to the previous role with:

```sql
RESET ROLE;
```

---

## 17. Role dependencies

A role could not initially be dropped because privileges had been granted to it.

PostgreSQL reported dependencies on:

```text
schema public
table positions
```

The privileges were removed first:

```sql
REVOKE SELECT
ON TABLE positions
FROM day06_reader;

REVOKE USAGE
ON SCHEMA public
FROM day06_reader;
```

Then:

```sql
DROP ROLE day06_reader;
```

succeeded.

---

## 18. PostgreSQL service

The service was inspected with:

```bash
systemctl status postgresql
```

On this Ubuntu installation the service showed:

```text
active (exited)
```

This does not mean that PostgreSQL itself is stopped.

The Debian/Ubuntu `postgresql.service` acts as a service-management wrapper, while the actual PostgreSQL server processes continue running separately.

---

## 19. PostgreSQL processes

Processes were inspected with:

```bash
ps -ef | grep '[p]ostgres'
```

The server used a main PostgreSQL process together with background processes including:

```text
checkpointer
background writer
walwriter
autovacuum launcher
stats collector
logical replication launcher
```

The `[p]ostgres` regular-expression pattern matches `postgres` while avoiding matching the `grep` command itself.

---

## 20. PostgreSQL port

Listening TCP sockets were inspected with:

```bash
sudo ss -ltnp | grep 5432
```

The result showed PostgreSQL listening on:

```text
127.0.0.1:5432
```

This means:

```text
5432
→ PostgreSQL TCP port

127.0.0.1
→ local IPv4 loopback interface
```

The PostgreSQL process listening on the port matched the actual PostgreSQL server process.

---

## 21. PostgreSQL configuration

The running server reported:

```text
config_file
→ /etc/postgresql/14/main/postgresql.conf

data_directory
→ /var/lib/postgresql/14/main

port
→ 5432

listen_addresses
→ localhost
```

These values can be inspected with:

```sql
SHOW config_file;
SHOW data_directory;
SHOW port;
SHOW listen_addresses;
```

---

## 22. PostgreSQL logs

PostgreSQL logs were found under:

```text
/var/log/postgresql/
```

The active log file was:

```text
postgresql-14-main.log
```

It contained errors generated during the Day06 experiments, including:

```text
relation does_not_exist does not exist

current transaction is aborted

permission denied for table positions

role day06_reader cannot be dropped because some objects depend on it
```

This demonstrated that server logs are useful for diagnosing database errors.

Systemd service events were also inspected with:

```bash
sudo journalctl -u postgresql --no-pager -n 20
```

The PostgreSQL log file and systemd journal provide different kinds of operational information.

---

## 23. Database backup

A plain SQL backup was created with:

```bash
pg_dump ai_internship_tracker
```

The output was redirected into:

```text
ai_internship_tracker_backup.sql
```

A plain SQL dump contains SQL commands capable of reconstructing database objects and data.

---

## 24. Database restore

A separate test database was created:

```text
ai_internship_tracker_restore_test
```

The SQL backup was piped into `psql` and restored there.

After restoration, the database contained all five expected tables:

```text
companies
positions
applications
skills
position_skills
```

The restored row counts were:

```text
companies        3
positions        3
applications     2
skills           6
position_skills  9
```

These counts matched the original project database.

Therefore the backup and restore workflow was successfully verified.

---

## 25. Day06 summary

Day06 covered three major areas:

```text
database reliability
→ transactions and ACID

database performance
→ indexes, statistics, and EXPLAIN

database administration
→ roles, privileges, service, processes,
  ports, logs, backup, and restore
```

The central lesson is that a database system is more than SQL queries.

A production backend also needs to understand:

```text
how changes are protected
how queries are executed
how access is controlled
how the database service is observed
and how data can be recovered
```
