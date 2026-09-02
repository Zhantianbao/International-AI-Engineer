from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def get_health():
	return {"status": "ok"}

@app.get("/applications/{application_id}")
def get_application(application_id: int):
	return {
		"application_id": application_id,
		"python_type": type(application_id).__name__
	}

@app.get("/applications")
def get_applications(status: str):
	return {"status": status}

@app.post("/applications")
def create_application():
	return {"created": True}
