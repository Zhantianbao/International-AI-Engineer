# FastAPI Day02 — Pydantic and API Contracts

## 1. Pydantic

Pydantic is a Python data validation library.

In FastAPI, Pydantic models are used to describe and validate request and response data.

Basic flow:

HTTP JSON Body
→ FastAPI
→ Pydantic validation
→ Python object
→ endpoint function

A Pydantic model inherits from `BaseModel`.

Example:

    class CompanyCreate(BaseModel):
        name: str
        country: str
        website_url: str | None = None
        is_remote_friendly: bool = False

The model describes what valid data should look like.

---

## 2. BaseModel

`BaseModel` is the base class provided by Pydantic.

A class that inherits from `BaseModel` becomes a Pydantic model.

Pydantic reads Python type annotations such as:

    name: str
    company_id: int
    is_remote: bool

and uses them to parse and validate incoming data.

---

## 3. Required, Default, Nullable, and Omitted Fields

Examples:

    x: str

- required
- cannot be omitted
- cannot be None

    x: str | None

- required
- cannot be omitted
- can be None

    x: str = "abc"

- can be omitted
- default value is "abc"
- cannot normally be None

    x: str | None = None

- can be omitted
- can be None
- default value is None

Important:

nullable != optional / omittable

`str | None` controls which values are allowed.

A default value such as `= None` controls what happens when the field is omitted.

---

## 4. Request Body

Example:

    @app.post("/companies")
    def create_company(company: CompanyCreate):
        return company

Because `company` is declared as a Pydantic model, FastAPI treats it as request body data.

Request flow:

Client
→ HTTP POST request
→ JSON body
→ FastAPI
→ JSON parsing
→ Pydantic parsing and validation
→ CompanyCreate Python object
→ create_company(company)

The endpoint receives a `CompanyCreate` object rather than the original JSON text.

Model fields can therefore be accessed with attributes such as:

    company.name
    company.country

---

## 5. Validation

Validation means checking whether data satisfies the rules defined by a model.

Validation may include:

- required fields
- data types
- type parsing/conversion
- nullable rules
- numeric constraints
- string length constraints

Example:

    employee_count: int = Field(gt=0)

This requires:

- the value to be usable as an integer
- the integer to be greater than 0

Example:

    status: str = Field(min_length=1)

This requires the string to contain at least one character.

---

## 6. Type Parsing and Conversion

Pydantic can perform reasonable type conversion.

Example input:

    "employee_count": "1000"

Model:

    employee_count: int

Pydantic can parse the string `"1000"` into the Python integer `1000`.

However:

    "employee_count": "many"

cannot be parsed as an integer.

This produced:

    type: int_parsing
    loc: ["body", "employee_count"]

and FastAPI returned HTTP 422.

---

## 7. Field()

`Field()` adds extra constraints or metadata to a Pydantic field.

Example:

    position_id: int = Field(gt=0)

`gt` means `greater than`.

Therefore:

    gt=0

means the value must be greater than 0.

Example:

    status: str = Field(min_length=1)

`min_length` means minimum length.

An empty string therefore fails validation.

Useful numeric constraint names include:

    gt = greater than
    ge = greater than or equal
    lt = less than
    le = less than or equal

---

## 8. Validation Errors

A typical FastAPI validation error contains:

    type
    loc
    msg
    input

`type`
→ type of validation failure

`loc`
→ location of invalid data

`msg`
→ human-readable error message

`input`
→ invalid input value

Example:

    "loc": ["body", "position_id"]

means the error occurred in the HTTP request body at the `position_id` field.

Pydantic can report multiple validation errors in one response.

For example:

    position_id = -100
    status = ""

produced two errors:

- `position_id` failed `gt=0`
- `status` failed `min_length=1`

---

## 9. Malformed JSON vs Invalid Model Data

Malformed JSON means the JSON syntax itself is invalid.

Example:

    {
      "name": "OpenAI,
      "country": "United States"
    }

FastAPI returned:

    type: json_invalid
    msg: JSON decode error

Flow:

HTTP body
→ JSON decoding
→ failure

The data cannot yet be validated against `CompanyCreate`.

This differs from valid JSON that violates a Pydantic model.

Example:

    {
      "country": "United States"
    }

The JSON syntax is valid, but `CompanyCreate` rejects it because `name` is missing.

---

## 10. Serialization and Deserialization

Deserialization can be understood here as:

external JSON data
→ Python data/object

Request direction:

JSON
→ parsing
→ validation
→ Pydantic Python object

Serialization is the opposite direction:

Python data/object
→ JSON-compatible response data

Response direction:

Python return value
→ response model processing
→ serialization
→ JSON response

---

## 11. Request Models and Response Models

Request and response schemas should often be separate.

Example request model:

    class CompanyCreate(BaseModel):
        name: str
        country: str
        website_url: str | None = None
        is_remote_friendly: bool = False

Example response model:

    class CompanyResponse(BaseModel):
        company_id: int
        name: str
        country: str
        website_url: str | None = None
        is_remote_friendly: bool

`CompanyCreate` does not contain `company_id` because the client should not generate the database identifier.

`CompanyResponse` contains `company_id` because the server can return the generated identifier.

Mental model:

Request Model
→ what the client is allowed or required to send

Response Model
→ what the server promises or allows to return

---

## 12. response_model

Example:

    @app.post("/companies", response_model=CompanyResponse)

`response_model` defines the expected response structure.

Simplified response flow:

endpoint return value
→ CompanyResponse validation
→ output filtering
→ serialization
→ JSON response

It provides several important benefits:

- response validation
- output filtering
- serialization
- OpenAPI documentation

During the experiment, the endpoint returned an extra field:

    internal_note

but `CompanyResponse` did not define it.

The field was therefore filtered out of the HTTP response.

This helps prevent internal or sensitive fields from being exposed accidentally.

---

## 13. Response Validation

Request validation checks client input.

If client data is invalid:

Client
→ request validation failure
→ endpoint does not execute
→ HTTP 422

Response validation checks server output.

During the experiment, `CompanyResponse` required:

    company_id: int

but the endpoint returned:

    "company_id": "not-an-integer"

The request itself was valid and the endpoint executed, but response validation failed.

FastAPI produced a response validation error and the client received:

    500 Internal Server Error

This distinction is important:

Request validation failure
→ client input problem

Response validation failure
→ server implementation problem

---

## 14. API Contract

API means:

Application Programming Interface

An API contract is the agreement between client and server about how an API must be used.

It includes information such as:

- HTTP method
- path
- request parameters
- request body structure
- required fields
- optional fields
- data types
- validation rules
- response structure
- possible status codes

Example:

    POST /companies

Request contract:

    CompanyCreate

Response contract:

    CompanyResponse

Pydantic models help define data contracts in Python.

FastAPI converts these models into OpenAPI schemas.

---

## 15. Schema, OpenAPI, and Swagger UI

A schema describes the structure and rules of data.

Relationship:

Pydantic models
→ FastAPI
→ OpenAPI schema
→ Swagger UI

Pydantic Model
→ Python representation of the data model

OpenAPI
→ machine-readable description of the API

Swagger UI
→ graphical web interface that displays and tests the OpenAPI-described API

FastAPI provides Swagger UI at:

    /docs

and the generated OpenAPI document at:

    /openapi.json

`CompanyCreate`, `CompanyResponse`, `PositionCreate`,
`PositionResponse`, `ApplicationCreate`, and
`ApplicationResponse` appeared automatically in the generated API schemas.

---

## 16. Pydantic Validation vs PostgreSQL Constraints

Pydantic validation and PostgreSQL constraints protect different layers.

Pydantic:

HTTP Request
→ application/API layer
→ Pydantic validation

Examples:

- field must be an integer
- value must be greater than 0
- string must not be empty

PostgreSQL:

SQL operation
→ database layer
→ database constraints

Examples:

- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- NOT NULL
- CHECK

Example:

    position_id = 999999

Pydantic may accept it because:

- it is an integer
- it is greater than 0

However, PostgreSQL can reject it if no position with ID 999999 exists and a FOREIGN KEY constraint requires one.

Therefore:

Pydantic validation
→ rejects bad API data early

PostgreSQL constraints
→ preserve final database integrity

Both layers are necessary.

---

## 17. Day02 Endpoints

Implemented temporary endpoints:

    POST /companies
    POST /positions
    POST /applications

Each endpoint currently uses:

    Create request model
    +
    Response model
    +
    response_model

The endpoints intentionally do not persist data to PostgreSQL yet.

Generated IDs are temporary demonstration values.

---

## 18. Final Request/Response Mental Model

Request:

Client
→ HTTP JSON Body
→ FastAPI
→ JSON parsing
→ Pydantic parsing / conversion / validation
→ Pydantic Python object
→ endpoint function

Response:

endpoint function
→ Python return value
→ response model
→ response validation
→ output filtering
→ serialization
→ JSON response
→ Client

---

## 19. Day02 Conclusions

After Day02:

- Pydantic models define structured API data.
- `BaseModel` turns Python classes into Pydantic models.
- Type annotations and `Field()` define validation rules.
- Required, nullable, default, and omitted fields are different concepts.
- FastAPI automatically validates request bodies before calling endpoint functions.
- Invalid client data normally produces HTTP 422.
- Request and response models should often be separated.
- `response_model` validates, filters, serializes, and documents output data.
- Response validation failure represents a server-side problem.
- Pydantic models contribute to the API contract.
- FastAPI automatically generates OpenAPI schemas and Swagger documentation.
- Pydantic validation and PostgreSQL constraints protect different layers of the system.
