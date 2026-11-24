
from flask import Flask, send_from_directory
from pathlib import Path

# 프로젝트 폴더 경로
BASE_DIR = Path(__file__).resolve().parent.parent
FRONTEND_DIR = BASE_DIR / "frontend"

app = Flask(
    __name__,
    static_folder=str(FRONTEND_DIR),
    static_url_path="/static"
)

@app.route("/")
def home():
    return send_from_directory(FRONTEND_DIR, "index.html")

if __name__ == "__main__":
    app.run(debug=True)
