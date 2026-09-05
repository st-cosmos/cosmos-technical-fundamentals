# 실습 03. LED 제어판 연결 — fetch + PUT + polling ★

> 🎯 목표: 이름을 넣고 **켜기/끄기 버튼으로 서버 LED 상태를 PUT** 하고, **1초마다 GET(polling)** 으로
> 현재 상태와 "누가 언제 바꿨는지"를 화면에 표시한다. **두 개의 브라우저 창**으로 서로 켜고 끄면 완성!
> 이 서버는 **ESP32**(03 강좌 선택 심화)가 그대로 재사용합니다.
>
> 📎 관련 문서: [docs/04-frontend-integration.md](../docs/04-frontend-integration.md) · 완성 코드: `examples/02-led-api/`

## 준비물

- [실습 02](02-led-api.md) 의 FastAPI 서버 (GET/PUT `/api/led`)
- 웹 브라우저(크롬 권장), VS Code

## 전체 흐름

```
[브라우저]                                  [FastAPI 서버]
 이름 입력 + 켜기/끄기                          led = {on, by, time}
     ├─ PUT /api/led {on, by} ───────────────▶  time 붙여 저장 → {on, by, time}
     │
     ├─ 1초마다 GET /api/led ─────────────────▶  {on, by, time}
     └─ 받은 상태로 화면(표시등 + 안내문) 다시 그리기 (모든 창이 같이 갱신)
```

## 1단계. 서버에 정적 파일 서빙 다시 추가

실습 02 의 `main.py` 에, 실습 01 에서 했던 정적 파일 서빙을 **맨 아래**에 다시 추가합니다.

```python
from fastapi.staticfiles import StaticFiles

# ↓ 다른 라우트들을 모두 정의한 "맨 마지막" 에 둡니다
app.mount("/", StaticFiles(directory="static", html=True), name="static")
```

그리고 `main.py` 옆에 **`static`** 폴더를 만들고, 그 안에 다음 단계의 `index.html` 을 둡니다.

> 📌 `app.mount("/")` 를 맨 아래 두는 이유: 위에서부터 매칭되므로, 먼저 두면 `/api/...`
> 요청까지 가로채 버립니다. API 라우트가 먼저, 정적 마운트가 마지막.

## 2단계. 화면(HTML/CSS) 만들기 — `static/index.html`

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>LED 제어판</title>
  <style>
    body { font-family: 'Malgun Gothic', sans-serif; max-width: 420px; margin: 40px auto; text-align: center; }
    h1 { color: #6b4e9e; }
    #lamp { width: 120px; height: 120px; border-radius: 50%; margin: 16px auto;
            display: flex; align-items: center; justify-content: center; font-weight: 700;
            border: 6px solid #e8e4f0; }
    .on  { background: #f5b301; color: #4a3a00; box-shadow: 0 0 32px #f5b301; }
    .off { background: #cfc9dc; color: #6c6c78; }
    #status { color: #6c6c78; min-height: 20px; }
    input { padding: 8px; }
    button { background: #6b4e9e; color: white; border: none; padding: 8px 16px; border-radius: 6px; }
  </style>
</head>
<body>
  <h1>💡 LED 제어판</h1>
  <div id="lamp" class="off">OFF</div>
  <p id="status">아직 아무도 바꾸지 않았습니다.</p>
  <input id="name" placeholder="이름">
  <button id="on">켜기</button>
  <button id="off">끄기</button>

  <script>
    // 3단계 코드가 여기에 들어갑니다
  </script>
</body>
</html>
```

## 3단계. 동작(JS) 작성 — `<script>` 안

```js
const lamp = document.getElementById("lamp");
const status = document.getElementById("status");
const nameInput = document.getElementById("name");

// 받은 상태로 화면을 다시 그린다
function render(led) {
  lamp.textContent = led.on ? "ON" : "OFF";
  lamp.className = led.on ? "on" : "off";     // CSS 색 바꾸기
  status.textContent =
    `마지막 변경: ${led.by} 님이 ${led.time} 에 LED를 ${led.on ? "켰습니다" : "껐습니다"}.`;
}

// GET: 현재 상태 가져오기
async function fetchLed() {
  const res = await fetch("/api/led");
  render(await res.json());
}

// PUT: 켜기/끄기 보내기
async function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  await fetch("/api/led", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ on, by }),        // 객체 → JSON 문자열
  });
  fetchLed();                                // 누른 직후 바로 갱신
}

document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));

// polling: 1초마다 자동 갱신
fetchLed();                       // 처음 한 번 즉시
setInterval(fetchLed, 1000);      // 그 뒤 1초마다
```

> 💡 핵심 3가지: **PUT 로 바꾸기 → 바꾼 뒤 한 번 갱신 → setInterval 로 1초 polling**.
> polling 덕분에 *내가 안 바꾼* 상태(다른 창·ESP32에서 바꾼 것)도 자동으로 반영됩니다.

## 4단계. 실행

서버를 실행합니다 (실습 02와 동일).

```bash
uv run uvicorn main:app --reload
```

브라우저에서 **http://localhost:8000** 을 엽니다. 화면이 보이면 성공입니다.

## 확인 — 두 창으로 서로 제어

1. 브라우저 창을 **두 개** 띄우고 둘 다 http://localhost:8000 접속
2. **A 창**: 이름 `철수` → **켜기**
3. 길어야 **1초 안에 B 창에도** 표시등이 ON 으로 바뀌고 "철수 님이 ... 켰습니다" 가 뜨면 성공! 🎉
4. **B 창**에서 **끄기** 하면 A 창도 자동으로 OFF → 서로 제어 완성

> 💡 개발자 도구 **F12 → Network** 탭을 켜 두면, `PUT` 이 `200` 으로 가고
> `GET /api/led` 가 **1초마다** 또박또박 도는 걸 눈으로 볼 수 있습니다.

## 막히면?

| 증상 | 확인 |
|------|------|
| http://localhost:8000 가 JSON만 보임 | `app.mount("/")` 가 라우트 **맨 아래**인지, `static/index.html` 위치 |
| 눌러도 안 바뀜 | F12 Console 에러 확인, PUT 헤더/`JSON.stringify` 빠졌는지 |
| 다른 창에 안 뜸 | `setInterval(fetchLed, 1000)` 있는지, 서버 한 개만 떠 있는지 |
| 상태 형태가 이상 | 서버 PUT 이 `{on, by, time}` 으로 저장하는지(실습 02) |
| 새로고침하면 초기화 | 정상 — 서버 메모리 저장이라 서버를 끄면 `false` 로 |

## 더 해보기 (도전 과제)

1. **버튼 하나로 토글**: 켜기/끄기 대신 버튼 하나로 현재 상태를 뒤집기.
2. **내가 켠 것 강조**: 마지막으로 바꾼 사람이 나(이름 일치)면 안내문 색을 `#6b4e9e` 로.
3. **표시등 애니메이션**: 켜질 때 부드럽게 빛나도록 CSS `transition` 추가.
4. **polling 간격 실험**: 1000 → 300 으로 줄여 보고 Network 탭에서 요청 빈도 관찰.

## 🎓 마무리

축하합니다! 웹 개발의 한 바퀴 — **HTML/CSS/JS 로 화면 만들기 · FastAPI 로 서버 띄우기 ·
fetch 로 PUT/GET · polling 으로 갱신** — 을 모두 직접 완성했습니다.

이 LED 서버는 그냥 연습이 아닙니다. **ESP32**(03 강좌 선택 심화)가 이 서버에
붙으면, 방금 웹에서 켠 LED 가 **진짜 LED 로** 켜집니다. 웹 페이지와 ESP32는 같은 서버를 보는
여러 클라이언트일 뿐이에요.

다음 확장 아이디어:

- **WebSocket** 으로 진짜 실시간 반영 (polling 대신 서버가 즉시 푸시) → **바로 다음 실습 04**
- **데이터베이스**에 상태 저장 (서버를 꺼도 유지)
- 같은 서버에 **ESP32**([03 강좌 docs/08](../../03-esp32-programming/docs/08-wifi-http-client.md))를 붙여 실제 LED 켜기

> 📦 완성 코드: [`examples/02-led-api/`](../examples/02-led-api/) — `uv run uvicorn main:app --reload`

➡️ 다음: [실습 04. WebSocket 으로 실시간 반영](04-websocket.md)
