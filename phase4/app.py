from flask import Flask, render_template

app = Flask(__name__)


@app.get("/")
def index():
    return render_template("index.html")


if __name__ == "__main__":
    app.run()

# 기본 플라스크 개발환경을 ai를 사용해 생성함
