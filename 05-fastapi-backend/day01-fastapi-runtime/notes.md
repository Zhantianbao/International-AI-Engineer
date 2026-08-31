# FastAPI Day01 - Runtime and Routing

## 1. FastAPI and Uvicorn

FastAPI is a Python web framework used to build HTTP APIs.

```python
from fastapi import FastAPI

app = FastAPI()
```

`FastAPI` is a Python class.

`FastAPI()` creates a FastAPI application object.

`app` is the variable that refers to this specific web application.

FastAPI mainly handles:

- route definitions
- parameter extraction
- type conversion
- validation
- calling path operation functions
- generating HTTP responses
- generating OpenAPI information

Uvicorn is a web server.

It listens on an IP address and port, receives HTTP requests, communicates with the FastAPI application through ASGI, and sends HTTP responses back to clients.

FastAPI and Uvicorn are different:

```text
FastAPI
= defines and handles the web application

Uvicorn
= runs the web application and receives network requests
```

---

## 2. ASGI

ASGI = Asynchronous Server Gateway Interface

- Asynchronous: asynchronous
- Server: server
- Gateway: gateway
- Interface: interface

ASGI is not another server program.

It is an interface specification that defines how a Python web server and a Python web application communicate.

In this project:

```text
Uvicorn
↕
ASGI
↕
FastAPI
```

Uvicorn is the server implementation.

FastAPI is the web framework/application.

ASGI is the communication specification between them.

---

## 3. Running the Application

The application is started with:

```bash
python -m uvicorn app:app --host 127.0.0.1 --port 8000 --reload
```

`app:app` means:

```text
first app
→ Python module app.py

second app
→ variable named app inside app.py
```

Therefore Uvicorn loads:

```python
app = FastAPI()
```

from `app.py`.

`--host 127.0.0.1` makes Uvicorn listen on the local loopback interface.

`--port 8000` makes it listen on TCP port 8000.

Port 8000 is a common development port, but FastAPI does not require port 8000.

`--reload` enables development reload mode. Uvicorn watches source files and reloads the application when code changes.

---

## 4. IP, Port, and Path

For:

```text
http://127.0.0.1:8000/health
```

the important parts are:

```text
127.0.0.1
→ identifies the local machine

8000
→ identifies the network service on that machine

/health
→ identifies a path handled by the web application
```

A useful mental model is:

```text
IP
→ which machine

Port
→ which network service/process

Path
→ which API operation inside the web application
```

---

## 5. Python Decorators

A Python function is an object.

The difference between:

```python
hello
```

and:

```python
hello()
```

is:

```text
hello
→ the function object

hello()
→ call the function
```

Functions can be passed to other functions and returned from functions.

A basic decorator:

```python
@decorator
def hello():
    pass
```

can be understood approximately as:

```python
def hello():
    pass

hello = decorator(hello)
```

For a parameterized decorator:

```python
@app.get("/health")
def get_health():
    pass
```

the structure can be understood approximately as:

```python
decorator = app.get("/health")
get_health = decorator(get_health)
```

FastAPI uses this decorator mechanism to register route information.

---

## 6. FastAPI Route Registration

This code:

```python
@app.get("/health")
def get_health():
    return {"status": "ok"}
```

registers a relationship:

```text
HTTP Method: GET
Path: /health
Function: get_health
```

Conceptually:

```text
GET /health
→ get_health()
```

The decorator is executed when the application code is loaded and the route is registered.

The endpoint function is executed later when a matching HTTP request arrives.

These are two different stages.

---

## 7. Path Operation

A FastAPI path operation combines:

```text
HTTP Method
+
URL Path
+
Python Function
```

Example:

```python
@app.get("/health")
def get_health():
    ...
```

means:

```text
Method:
GET

Path:
/health

Path Operation Function:
get_health
```

FastAPI routing matches both the HTTP method and the path.

Therefore these are different operations:

```text
GET  /applications
POST /applications
```

even though the URL path is the same.

---

## 8. Path Parameters

Example:

```python
@app.get("/applications/{application_id}")
def get_application(application_id: int):
    return {"application_id": application_id}
```

Request:

```text
GET /applications/4
```

FastAPI maps:

```text
/applications/4
              ↓
application_id
              ↓
"4"
              ↓
application_id: int
              ↓
4 as a Python int
```

The parameter name in the path must correspond to the Python function parameter.

---

## 9. Query Parameters

Example:

```python
@app.get("/applications")
def get_applications(status: str):
    return {"status": status}
```

Request:

```text
GET /applications?status=applied
```

FastAPI maps:

```text
status=applied
↓
status = "applied"
```

A query parameter does not automatically perform a database query.

It only carries data from the HTTP request into the application.

The application may later use that value for:

- filtering
- searching
- sorting
- pagination
- database queries

---

## 10. Type Conversion and Validation

Python type annotations are used by FastAPI when processing request parameters.

Example:

```python
application_id: int
```

Request:

```text
GET /applications/4
```

results in:

```text
"4"
↓
FastAPI converts it
↓
4 as Python int
↓
validation succeeds
↓
get_application() is called
```

Request:

```text
GET /applications/abc
```

results in:

```text
"abc"
↓
FastAPI attempts int conversion
↓
conversion fails
↓
validation fails
↓
422 response
```

The endpoint function is not called when parameter validation fails.

This was verified by adding a temporary `print()` inside `get_application()`.

---

## 11. curl

cURL is a command-line network client.

It can be used to send HTTP requests to the FastAPI service.

Example:

```bash
curl http://127.0.0.1:8000/health
```

curl uses GET by default.

Therefore:

```bash
curl http://127.0.0.1:8000/health
```

is effectively a GET request.

For POST:

```bash
curl -X POST http://127.0.0.1:8000/applications
```

`-i` includes the HTTP response headers:

```bash
curl -i http://127.0.0.1:8000/health
```

---

## 12. OpenAPI

API = Application Programming Interface

- Application: application
- Programming: programming
- Interface: interface

OpenAPI is a standard for describing HTTP APIs in a machine-readable structure.

FastAPI generates an OpenAPI schema from application code.

For example:

```python
@app.get("/applications/{application_id}")
def get_application(application_id: int):
```

allows FastAPI to determine information such as:

```text
HTTP method:
GET

Path:
/applications/{application_id}

Parameter:
application_id

Parameter location:
path

Required:
true

Type:
integer
```

The generated OpenAPI description can be inspected at:

```text
/openapi.json
```

---

## 13. Swagger UI

UI = User Interface

- User: user
- Interface: interface

Swagger UI provides interactive API documentation.

FastAPI exposes it by default at:

```text
/docs
```

The relationship is:

```text
FastAPI route definitions
+
Python type annotations
↓
OpenAPI schema
↓
Swagger UI
↓
interactive /docs page
```

Swagger UI does not directly inspect the Python source code itself. It uses the OpenAPI description generated by FastAPI.

---

## 14. Complete Request Flow

Example request:

```text
GET /applications/4
```

Complete mental model:

```text
Client
↓
HTTP Request
↓
Uvicorn
↓
ASGI
↓
FastAPI Application
↓
Router
↓
Path and method matching
↓
Parameter extraction
↓
Type conversion and validation
↓
Path Operation Function
↓
Python return value
↓
FastAPI builds the response
↓
ASGI
↓
Uvicorn
↓
HTTP Response
↓
Client
```

For this specific request:

```text
curl
↓
GET /applications/4
↓
Uvicorn receives the request
↓
request is passed to FastAPI through ASGI
↓
FastAPI router matches:

GET /applications/{application_id}

↓
FastAPI extracts:

application_id = "4"

↓
type annotation requires int
↓
"4" becomes 4
↓
validation succeeds
↓
FastAPI calls:

get_application(application_id=4)

↓
function returns a Python dict
↓
FastAPI prepares the HTTP response
↓
Uvicorn sends the response
↓
curl receives it
```

---

## 15. Day01 Key Conclusions

FastAPI and Uvicorn solve different problems.

```text
FastAPI
→ web application/framework

Uvicorn
→ web server
```

ASGI defines how they communicate.

A route is primarily identified by:

```text
HTTP Method + Path
```

FastAPI decorators register path operations when the application is loaded.

FastAPI can map HTTP request data to Python function parameters.

Python type annotations allow FastAPI to perform type conversion and validation before the endpoint function runs.

FastAPI generates an OpenAPI schema automatically.

Swagger UI uses that schema to provide interactive documentation at `/docs`.
