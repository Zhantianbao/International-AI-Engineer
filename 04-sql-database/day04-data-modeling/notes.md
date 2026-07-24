# SQL Day04 — Relational Data Modeling and Database Schema

## 1. Goal

Design and build the relational database schema for the AI Internship Tracker project.

The project database contains five tables:

```text
companies
positions
applications
skills
position_skills
```

The database structure is stored in:

```text
schema.sql
```

Initial test data is stored in:

```text
seed.sql
```

---

## 2. Entity, table, row, and column

An entity is a business concept that needs to be stored.

Examples:

```text
Company
Position
Application
Skill
```

In a relational database:

```text
Entity type
→ Table

Entity instance
→ Row

Attribute
→ Column
```

For example:

```text
Company entity
→ companies table

One specific company
→ one row in companies

Company name
→ name column
```

A table is a database structure used to store entities or relationships.

Not every table represents an independent entity. For example:

```text
position_skills
```

mainly represents the relationship between positions and skills.

---

## 3. Project tables

### companies

Stores company information.

Important columns:

```text
company_id
name
country
website_url
is_remote_friendly
created_at
```

### positions

Stores internship and job-position information.

Important columns:

```text
position_id
company_id
title
location
remote_type
employment_type
job_url
description
posted_at
created_at
```

### applications

Stores the application state for a position.

Important columns:

```text
application_id
position_id
status
applied_at
notes
created_at
updated_at
```

### skills

Stores standardized skill names.

Examples:

```text
Python
PostgreSQL
FastAPI
Git
Docker
Machine Learning
```

### position_skills

Connects positions and skills.

Important columns:

```text
position_id
skill_id
is_required
created_at
```

One row means:

> A particular position is associated with a particular skill.

---

## 4. Primary keys

`PRIMARY KEY` uniquely identifies one row in a table.

Examples:

```text
companies.company_id
positions.position_id
applications.application_id
skills.skill_id
```

A primary key:

```text
must be unique
cannot be NULL
```

Conceptually:

```text
PRIMARY KEY
→ Who am I?
```

The project uses identity columns:

```sql
company_id INTEGER GENERATED ALWAYS AS IDENTITY
```

PostgreSQL automatically generates values such as:

```text
1, 2, 3, 4...
```

---

## 5. Foreign keys

`FOREIGN KEY` connects rows in different tables.

Example:

```sql
CONSTRAINT fk_positions_company
    FOREIGN KEY (company_id)
    REFERENCES companies(company_id)
```

This relationship means:

```text
positions.company_id
→ references companies.company_id
```

The database verifies that a position cannot reference a company that does not exist.

Conceptually:

```text
PRIMARY KEY
→ Who am I?

FOREIGN KEY
→ Who do I belong to or reference?
```

A foreign key protects referential integrity and prevents orphan records.

---

## 6. One-to-many relationship

The relationship between companies and positions is one-to-many:

```text
companies 1 ──────< positions N
```

Meaning:

```text
One company can have many positions.
One position belongs to one company.
```

It is implemented with:

```text
positions.company_id
→ companies.company_id
```

Company information is stored once in `companies`.

Positions store only the corresponding `company_id`, avoiding repeated company names, countries, and websites.

---

## 7. One-to-zero-or-one relationship

The relationship between positions and applications is:

```text
positions 1 ────── 0..1 applications
```

Meaning:

```text
A position may have no application yet.
A position may have one application.
A position cannot have multiple application rows in the current design.
```

The foreign key ensures that the position exists:

```sql
FOREIGN KEY (position_id)
    REFERENCES positions(position_id)
```

The unique constraint ensures that the position appears at most once:

```sql
UNIQUE (position_id)
```

The two constraints answer different questions:

```text
FOREIGN KEY
→ Does this position exist?

UNIQUE
→ Does this position already have an application?
```

---

## 8. Many-to-many relationship

The relationship between positions and skills is many-to-many:

```text
positions N >──────< N skills
```

Meaning:

```text
One position can require many skills.
One skill can appear in many positions.
```

This relationship is implemented through the junction table:

```text
position_skills
```

Its combined primary key is:

```sql
PRIMARY KEY (
    position_id,
    skill_id
)
```

The combination must be unique.

Valid combinations:

```text
position 1, skill 1
position 1, skill 2
position 2, skill 1
```

Invalid duplicate:

```text
position 1, skill 1
position 1, skill 1
```

The many-to-many relationship is converted into two one-to-many relationships:

```text
positions
    1
    |
    N
position_skills
    N
    |
    1
skills
```

---

## 9. Normalization and redundancy

Normalization organizes data so that each fact is stored in an appropriate place.

An unnormalized position table might store:

```text
company_name
company_country
company_website
required_skills = 'Python,PostgreSQL,Git'
```

This causes problems:

```text
company information is repeated
updates may become inconsistent
skills are difficult to query
skills may have different spellings
foreign keys cannot validate a comma-separated list
```

The normalized design stores:

```text
company information
→ companies

position information
→ positions

skill information
→ skills

position-skill relationships
→ position_skills
```

This reduces duplication and improves consistency.

---

## 10. Why skills are not stored as one string

This design is not recommended:

```text
required_skills = 'Python,PostgreSQL,Git'
```

It places multiple independent values inside one column.

Problems include:

```text
LIKE searches may produce incorrect matches
capitalization and spelling may be inconsistent
individual skills cannot be validated with foreign keys
renaming one skill requires string replacement
statistics and joins become more difficult
```

Using `skills` and `position_skills` allows each skill to be stored and validated independently.

---

## 11. Constraints

A constraint is a database rule that controls which data is valid.

### NOT NULL

```sql
name VARCHAR(150) NOT NULL
```

The value must be provided.

### UNIQUE

```sql
UNIQUE (name)
```

The value cannot be repeated.

Examples:

```text
company names
skill names
job URLs
```

In PostgreSQL, a normal `UNIQUE` constraint generally allows multiple `NULL` values because `NULL` represents an unknown or missing value.

### CHECK

```sql
CHECK (
    remote_type IN (
        'onsite',
        'hybrid',
        'remote'
    )
)
```

Only listed values are allowed.

### DEFAULT

```sql
DEFAULT FALSE
```

or:

```sql
DEFAULT CURRENT_TIMESTAMP
```

A default value is used when an insert does not explicitly provide the column.

### CONSTRAINT

```sql
CONSTRAINT ck_positions_remote_type
```

`CONSTRAINT` gives the constraint an explicit name.

The name makes errors and future schema maintenance easier to understand.

Naming prefixes used in this project:

```text
pk
→ primary key

fk
→ foreign key

uq
→ unique

ck
→ check
```

---

## 12. Preventing blank strings

`NOT NULL` prevents `NULL`, but it does not prevent:

```text
''
'     '
```

The project uses:

```sql
CHECK (BTRIM(name) <> '')
```

`BTRIM` removes whitespace from both ends.

Examples:

```text
' OpenAI ' → 'OpenAI'
'       '  → ''
```

Therefore:

```sql
BTRIM(name) <> ''
```

rejects empty and whitespace-only names.

---

## 13. URL validation

The schema contains checks such as:

```sql
CHECK (
    job_url IS NULL
    OR job_url ~ '^https?://'
)
```

The `~` operator performs a case-sensitive regular-expression match in PostgreSQL.

The pattern:

```text
^https?://
```

means:

```text
^
→ start of the string

http
→ required text

s?
→ optional letter s

://
→ required characters
```

Accepted examples:

```text
http://example.com
https://example.com
```

Rejected examples:

```text
www.example.com
example.com
ftp://example.com
```

This is only basic format validation, not complete URL verification.

---

## 14. DATE and TIMESTAMPTZ

### DATE

```sql
posted_at DATE
```

Stores a calendar date:

```text
2026-07-24
```

It does not store a time of day or time zone.

`posted_at` represents the date on which the external job was published and may be unknown, so it allows `NULL`.

### TIMESTAMPTZ

```sql
created_at TIMESTAMPTZ
```

Stores a precise point in time with time-zone-aware behavior.

Example display:

```text
2026-07-24 17:30:00+08
```

It is appropriate for database record creation and update times.

Important limitation:

```sql
updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
```

sets the initial value during insertion, but it does not automatically change whenever the row is updated.

The application must explicitly update `updated_at`, or a database trigger can be added later.

---

## 15. Delete behavior

### ON DELETE RESTRICT

Used between companies and positions:

```sql
ON DELETE RESTRICT
```

A company cannot be deleted while positions still reference it.

This prevents positions from becoming orphan records.

### ON DELETE CASCADE

Used for:

```text
positions → applications
positions → position_skills
skills → position_skills
```

Example:

```sql
ON DELETE CASCADE
```

Deleting a position automatically deletes:

```text
its application
its position-skill relationships
```

The related company and skill records are not automatically deleted.

---

## 16. Application constraints

Allowed status values:

```text
planned
applied
interview
offer
rejected
withdrawn
```

The schema also contains:

```sql
CHECK (
    status = 'planned'
    OR applied_at IS NOT NULL
)
```

Meaning:

```text
planned
→ applied_at may be NULL

all other statuses
→ applied_at must be provided
```

The time-order constraint is:

```sql
CHECK (
    updated_at >= created_at
)
```

An update time cannot be earlier than the creation time.

---

## 17. schema.sql

`schema.sql` contains the complete database structure:

```text
tables
columns
data types
primary keys
foreign keys
unique constraints
check constraints
default values
delete rules
```

It begins with:

```sql
BEGIN;
```

and ends with:

```sql
COMMIT;
```

The schema is recreated as one transaction.

`DROP TABLE` statements remove child tables before parent tables because child tables contain foreign keys that depend on parent tables.

The file is executed with:

```bash
sudo -u postgres psql \
  -d ai_internship_tracker \
  -v ON_ERROR_STOP=1 \
  -f schema.sql
```

`ON_ERROR_STOP=1` causes `psql` to stop when an error occurs.

---

## 18. seed.sql

`seed.sql` inserts initial test data.

The current seed data contains:

```text
3 companies
3 positions
2 applications
6 skills
9 position-skill relationships
```

It uses joins and unique business values instead of relying completely on hard-coded identity numbers.

For example, positions are connected to companies using company names during insertion, and skills are connected to positions using job URLs and skill names.

This makes the seed process easier to understand and less dependent on specific generated IDs.

---

## 19. Valid and invalid insert testing

Valid inserts confirmed that normal records can be stored.

Invalid inserts tested:

```text
duplicate company name
blank company name
invalid website URL
position referencing a missing company
invalid remote type
duplicate job URL
application without required applied_at
duplicate application for one position
duplicate position-skill relationship
```

The database correctly rejected invalid data through:

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
CHECK
```

Delete tests also confirmed:

```text
ON DELETE RESTRICT
ON DELETE CASCADE
```

Transactions and `ROLLBACK` were used to test deletion without permanently changing the seed data.

---

## 20. Useful psql commands

List tables:

```sql
\dt
```

Describe a table:

```sql
\d positions
```

Show the current database:

```sql
SELECT current_database();
```

Clear an unfinished SQL input buffer:

```sql
\r
```

Exit `psql`:

```sql
\q
```

Prompt meanings:

```text
database=#
→ ready for a new statement

database-#
→ the current statement is unfinished
```

---

## 21. Current understanding

I understand the overall database model:

```text
companies
→ have positions

positions
→ may have one application

positions
↔ skills through position_skills
```

I also understand the basic purposes of:

```text
primary keys
foreign keys
unique constraints
check constraints
default values
junction tables
delete rules
```

However, this was a low-energy study day.

Most of the SQL was copied and executed according to the workflow. I verified that the schema, seed data, and constraints worked, but I did not investigate every syntax detail deeply.

This means the practical workflow is complete, but some knowledge still needs repetition before it becomes independent skill.

Topics to revisit later:

```text
writing CREATE TABLE without a template
choosing constraints independently
designing business rules
writing seed queries with joins
understanding transactions more deeply
deciding between RESTRICT and CASCADE
updating updated_at automatically
```

The goal today was completion and first exposure, not complete memorization.
