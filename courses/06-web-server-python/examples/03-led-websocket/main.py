"""06 웹서버 — 예제 03: LED 제어판 WebSocket 버전 (실시간 push).

브라우저는 WebSocket(/ws) 으로 연결을 유지하고, 누가 LED 를 바꾸면 서버가 연결된 모두에게 즉시 새 상태를 보낸다.
REST API(GET/PUT /api/led) 도 그대로 두어 ESP32(polling) 와 /docs 테스트가 함께 동작한다.
PUT 으로 바뀌어도 브라우저들에 broadcast 되므로, 어디서 바꾸든 모든 화면이 즉시 같아진다.

실행:
    uv run uvicorn main:app --reload
브라우저: http://localhost:8000  (창을 2개 띄우면 즉시 반영되는 것을 볼 수 있다)
확인:    F12 → Network → WS → Messages 에서 오가는 메시지 보기
"""

from datetime import datetime
from pathlib import Path

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

app = FastAPI()

# 서버가 들고 있는 LED 상태 (서버를 끄면 초기화됩니다)
led = {"on": False, "by": "아직 아무도", "time": "-"}

# 현재 연결된 WebSocket 클라이언트(브라우저)들
clients: set[WebSocket] = set()


class LedCommand(BaseModel):
    on: bool
    by: str


def apply(on: bool, by: str) -> None:
    """상태를 바꾸고 시각을 붙인다. (REST 와 WebSocket 이 공통으로 사용)"""
    led["on"] = on
    led["by"] = by or "익명"
    led["time"] = datetime.now().strftime("%H:%M:%S")


async def broadcast() -> None:
    """연결된 모든 브라우저에 현재 상태를 보낸다. 끊긴 연결은 정리."""
    for ws in list(clients):
        try:
            await ws.send_json(led)
        except Exception:
            clients.discard(ws)


# --- REST API (ESP32 polling · /docs 테스트용, 정적 mount 보다 먼저) ---
@app.get("/api/led")
def get_led():
    return led


@app.put("/api/led")
async def set_led(cmd: LedCommand):
    apply(cmd.on, cmd.by)
    await broadcast()  # REST 로 바꿔도 WebSocket 브라우저들이 즉시 갱신
    return led


# --- WebSocket ---
@app.websocket("/ws")
async def websocket_endpoint(ws: WebSocket):
    await ws.accept()  # ① 연결 수락
    clients.add(ws)
    await broadcast_viewers()  # ② 새 클라이언트 포함 모두에게 현재 상태 + 접속자 수
    try:
        while True:
            data = await ws.receive_json()  # ③ {"on": bool, "by": str} 대기
            apply(bool(data.get("on")), str(data.get("by") or ""))
            await broadcast()  # ④ 모두에게 push
    except WebSocketDisconnect:
        clients.discard(ws)  # ⑤ 창을 닫으면 여기로
        await broadcast_viewers()


async def broadcast_viewers() -> None:
    """접속자 수가 바뀌었을 때 모두에게 알린다 (도전 과제 1 의 예)."""
    for ws in list(clients):
        try:
            await ws.send_json({**led, "viewers": len(clients)})
        except Exception:
            clients.discard(ws)


# --- 웹 페이지(static/) 를 "/" 에 서빙 — 맨 마지막 ---
STATIC_DIR = Path(__file__).parent / "static"
app.mount("/", StaticFiles(directory=STATIC_DIR, html=True), name="static")
