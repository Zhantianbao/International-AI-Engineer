import os

from flask import Flask, jsonify


app = Flask(__name__)


@app.get("/")
def home():
    return jsonify(
        status="ok",
        message="Day07 deployment works",
    )


@app.get("/health")
def health():
    return jsonify(status="healthy")


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    app.run(host="127.0.0.1", port=port)
