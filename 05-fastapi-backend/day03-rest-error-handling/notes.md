# Day03 - REST and Error Handling

## 1. Main Goal

The goal of Day03 is to convert database CRUD thinking into a well-defined HTTP API.

SQL CRUD focuses on how the server manipulates stored data:

- Create -> INSERT
- Read -> SELECT
- Update -> UPDATE
- Delete -> DELETE

REST API design focuses on how clients interact with resources through HTTP:

- POST -> create a resource
- GET -> retrieve a resource
- PATCH -> partially update a resource
- DELETE -> delete a resource

SQL CRUD and REST CRUD are related, but they are not the same thing.

The database layer answers questions about data.
The API layer must additionally define resource URLs, HTTP methods, status codes, and error responses.

## 2. REST Resources

REST stands for Representational State Transfer.

A resource is an object exposed by the API, such as:

- companies
- positions
- applications

Examples:

- `/companies` represents the company collection.
- `/companies/1` represents one specific company.
- `/applications/1/status` represents a status-related operation on one application.

The HTTP method is part of the API contract.

## 3. HTTP Status Codes

### 200 OK

The request was processed successfully.

Example:

`GET /companies/1`

The company exists and is returned successfully.

### 201 Created

The request successfully created a new resource.

Example:

`POST /companies`

A new company is created.

201 is more precise than a generic 200 because it tells the client that resource creation succeeded.

### 204 No Content

The request succeeded, but there is no response body.

Example:

`DELETE /applications/1`

The application was successfully deleted, so the server does not need to return another JSON object.

204 is still a successful response.

### 404 Not Found

The request itself is valid, but the requested resource does not exist.

Example:

`GET /companies/999`

`999` is a valid integer, so validation succeeds, but company 999 does not exist.

Deleting an application once may return 204.
Deleting the same application again returns 404 because it no longer exists.

### 409 Conflict

The request is structurally valid, but the operation conflicts with the current state of the system.

Example:

Creating a company named `Anthropic` succeeds the first time:

`201 Created`

Trying to create the same company again returns:

`409 Conflict`

This is not 422 because the input data is valid.
It is not 500 because the server is working correctly.

### 422 Unprocessable Entity

The request data does not satisfy the API contract.

Example:

`GET /companies/abc`

If `company_id` must be an integer, `abc` cannot be converted into an integer.

Pydantic request-body validation errors are another common example.

Validation normally happens before endpoint business logic executes.

### 500 Internal Server Error

The server encounters an unexpected internal failure.

Possible causes include:

- programming errors
- unexpected exceptions
- database connection failures
- infrastructure failures

500 is different from controlled business errors such as 404 and 409.

## 4. HTTPException

FastAPI's `HTTPException` intentionally stops normal endpoint execution and returns a controlled HTTP error.

Example:

    if company is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Company not found",
        )

The API layer translates an internal condition such as "no company was found" into an HTTP-level meaning such as `404 Not Found`.

## 5. Repository Layer

Repository is the data-access layer.

Current simplified flow:

API Layer
-> Repository
-> Python dictionary

Future real flow:

API Layer
-> Repository
-> Psycopg
-> PostgreSQL

The current dictionary is only a temporary replacement for the database so that HTTP semantics can be learned independently.

The repository deals with data operations such as:

- create a company
- find a company
- find a company by name
- update application status
- delete an application

It should not normally decide HTTP status codes such as 404 or 409.

## 6. Why Repository Should Not Know HTTP

A repository may later be used by:

- FastAPI endpoints
- background jobs
- command-line tools
- tests
- agents

Therefore, repository functions should communicate data or domain results rather than HTTP responses.

Example:

Repository:

`get_company(999) -> None`

API Layer:

`None -> 404 Not Found`

This keeps the data-access layer independent from HTTP.

## 7. Error Boundary

A future database-backed request may flow through these layers:

PostgreSQL
-> Psycopg
-> Repository
-> API Layer
-> HTTP Response

Each layer understands errors differently.

PostgreSQL may report a database-specific constraint error.

Psycopg exposes it as a Python exception.

The repository understands the data operation.

The API layer understands HTTP semantics and decides what the client should receive.

Examples:

- duplicate resource -> 409 Conflict
- missing resource -> 404 Not Found
- unexpected internal failure -> 500 Internal Server Error

## 8. Why Raw PostgreSQL Errors Should Not Be Exposed

Raw database errors are usually not appropriate API responses because:

- clients should not depend on database implementation details
- raw errors may expose table names, column names, constraint names, or internal structure
- database messages are often too low-level for API clients
- the API should communicate stable business meaning instead

Instead of exposing a raw PostgreSQL unique-constraint error, the API can return:

    {
      "detail": "Company already exists"
    }

with:

`409 Conflict`

## 9. PATCH

PATCH means applying a partial modification to an existing resource.

Example:

`PATCH /applications/1/status`

Only the application's status is changed:

`applied -> interviewing`

The rest of the application does not need to be replaced.

## 10. Day03 Request Flow

Retrieve an existing company:

Client
-> GET /companies/1
-> FastAPI routing
-> path parameter validation
-> API endpoint
-> repository.get_company(1)
-> company found
-> 200 OK

Retrieve a missing company:

Client
-> GET /companies/999
-> validation succeeds
-> repository returns None
-> API layer raises HTTPException
-> 404 Not Found

Duplicate company creation:

Client
-> POST /companies
-> Pydantic validation succeeds
-> existing company is detected
-> API layer raises HTTPException
-> 409 Conflict

## 11. Status Code Mental Model

Do not memorize status codes only as numbers.

Ask:

1. Is the request data valid?
2. Does the target resource exist?
3. Does the operation conflict with the current state?
4. Did the server complete the operation successfully?
5. Does a successful response need a body?

Typical results:

- normal success -> 200
- resource created -> 201
- success without response body -> 204
- resource missing -> 404
- state conflict -> 409
- request validation failure -> 422
- unexpected server failure -> 500