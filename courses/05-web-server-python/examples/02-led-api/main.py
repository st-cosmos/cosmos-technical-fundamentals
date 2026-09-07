"""05 웹서버 — 예제 02: LED API + 제어판 (GET/PUT + fetch + polling).

프론트엔드(static/)와 REST API를 같은 FastAPI 서버가 함께 제공합니다.
- 웹 페이지에서 이름을 넣고 켜기/끄기 버튼 → PUT /api/led 로 서버 LED 상태 변경
- 1초마다 GET /api/led 로 현재 상태를 받아 "누가 언제 바꿨는지" 화면에 표시 (polling)

이 서버는 06-esp32-programming 의 WiFi 실습(examples/06-wifi-led-client)과 공유합니다.
ESP32 보드도 GET /api/led 로 같은 상태를 읽어 실제 LED를 켜고 끕니다.
(웹 페이지와 ESP32가 같은 서버를 보는 여러 클라이언트)

실행:
    uv run uvicorn main:app --reload
브라우저: http://localhost:8000   (창을 2개 띄우면 서로 실시간처럼 반영)
"""

from datetime import datetime
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

app = FastAPI()

# 서버가 들고 있는 LED 상태 (서버를 끄면 초기화됩니다)
led = {"on": False, "by": "아직 아무도", "time": "-"}


class LedCommand(BaseModel):
    on: bool
    by: str


# --- REST API (정적 파일 mount 보다 먼저 등록해야 우선 적용됩니다) ---
@app.get("/api/led")
def get_led():
    """현재 LED 상태와 마지막으로 바꾼 사람을 돌려줍니다."""
    return led


@app.put("/api/led")
def set_led(cmd: LedCommand):
    """LED 상태를 바꾸고, 누가 언제 바꿨는지 기록합니다."""
    led["on"] = cmd.on
    led["by"] = cmd.by
    led["time"] = datetime.now().strftime("%H:%M:%S")
    return led


# --- 웹 페이지(static/) 를 "/" 에 서빙 ---
# html=True 이면 "/" 요청 시 static/index.html 을 돌려줍니다.
STATIC_DIR = Path(__file__).parent / "static"
app.mount("/", StaticFiles(directory=STATIC_DIR, html=True), name="static")
