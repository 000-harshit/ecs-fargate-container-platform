import os
from flask import Flask, jsonify

app = Flask(__name__)
ROLE = os.getenv("APP_ROLE", "frontend")
BACKEND_URL = os.getenv("BACKEND_URL", "http://backend:5001")


@app.get("/")
def home():
    if ROLE == "backend":
        return jsonify(service="backend", message="Backend service is running")

    backend_status = "not checked"
    try:
        import urllib.request
        with urllib.request.urlopen(f"{BACKEND_URL}/health", timeout=2) as response:
            backend_status = response.read().decode("utf-8")
    except Exception as exc:
        backend_status = f"backend unavailable: {type(exc).__name__}"

    return (
        "<!doctype html><html><head><title>Fargate Demo</title></head>"
        "<body><h1>Container Platform Demo</h1>"
        "<p>Frontend service is running.</p>"
        f"<p>Backend response: <code>{backend_status}</code></p>"
        "<p>Try <a href='/health'>/health</a>.</p></body></html>"
    )


@app.get("/health")
def health():
    return jsonify(status="healthy", service=ROLE), 200


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8080" if ROLE == "frontend" else "5001"))
    app.run(host="0.0.0.0", port=port)
