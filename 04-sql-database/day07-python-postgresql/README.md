# AI Internship Tracker

A command-line application for tracking AI internship companies, positions, and job applications.

The project uses Python and PostgreSQL and demonstrates database design, parameterized SQL queries, transactions, error handling, and a simple repository layer.

## Features

- Add a company
- Add a position
- Add an application
- Update application status
- List all applications
- Filter applications by status
- Display summary statistics
- PostgreSQL-backed persistent storage
- Parameterized SQL queries
- Database error handling

## Project Structure

```text
day07-python-postgresql/
├── app.py
├── db.py
├── repository.py
├── requirements.txt
├── .env.example
├── schema.sql
├── seed.sql
├── queries.sql
└── README.md
```

## Requirements

- Python 3
- PostgreSQL
- Psycopg 3

## Setup

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Create a local environment file:

```bash
cp .env.example .env
```

Configure the database connection in `.env`:

```text
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=ai_internship_tracker
DB_USER=internship_app
DB_PASSWORD=your_password_here
```

Load the environment variables:

```bash
set -a
source .env
set +a
```

## Run

Start the CLI application:

```bash
python app.py
```

## CLI Menu

```text
AI Internship Tracker

1. Add company
2. Add position
3. Add application
4. Update application status
5. List all applications
6. Filter applications by status
7. Show summary statistics
0. Exit
```

## Database Architecture

The application uses the following main relationships:

```text
companies
    |
    | 1:N
    v
positions
    |
    | 1:0..1
    v
applications

positions
    |
    | N:N
    v
position_skills
    |
    v
skills
```

Database access is separated from the CLI:

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

## Security

Database credentials are loaded from environment variables.

The local `.env` file is excluded from Git and must not be committed.

SQL values are passed using Psycopg parameterized queries instead of string concatenation.

## Database Initialization

Create the PostgreSQL database before running the application.

The project includes:

```text
schema.sql
→ creates the database tables and constraints

seed.sql
→ inserts sample data

queries.sql
→ contains example SQL queries
```

After connecting to the target PostgreSQL database, initialize the schema:

```bash
psql -d ai_internship_tracker -f schema.sql
```

Optionally load the sample data:

```bash
psql -d ai_internship_tracker -f seed.sql
```

The application should use a dedicated PostgreSQL login role with the permissions required to read and modify the application tables.

After the database is initialized, configure `.env`, load the environment variables, and run:

```bash
python app.py
```
