"""06 웹서버 — 예제 01: FastAPI 최소 서버 + 정적 파일 호스팅.

04-web-application 의 LED 제어판(static/)을 이 서버가 내려준다.
더블클릭으로 열던 index.html 이 http://localhost:8000/ 이 되고, 같은 WiFi 의 다른 기기에서도 열 수 있다.

실행:
    uv run uvicorn main:app --reload
    uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000   # 다른 기기에서 접속 허용
확인:
    http://localhost:8000/        LED 제어판 (static/index.html)
    http://localhost:8000/hello   JSON 응답
    http://localhost:8000/docs    자동 문서
"""

from datetime import datetime
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

app = FastAPI()


@app.get("/hello")
def hello():
    """가장 단순한 라우트: dict 를 돌려주면 JSON 으로 응답된다."""
    return {"message": "안녕, 서버!"}


@app.get("/api/time")
def server_time():
    """서버의 현재 시각. 요청마다 값이 달라지는 '동적' 응답의 예."""
    return {"time": datetime.now().strftime("%H:%M:%S")}


# --- 정적 파일(static/) 을 "/" 에 서빙 — 다른 라우트 뒤, 맨 마지막에 ---
# html=True: "/" 요청에 static/index.html 을 돌려준다.
# Path(__file__).parent 기준이라 어느 폴더에서 실행해도 static/ 을 찾는다.
STATIC_DIR = Path(__file__).parent / "static"
app.mount("/", StaticFiles(directory=STATIC_DIR, html=True), name="static")
