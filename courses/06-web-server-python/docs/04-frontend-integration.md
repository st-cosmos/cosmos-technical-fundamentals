# 04. 프론트와 서버 연동 — fetch · PUT · polling

## 한 줄 요약

> 브라우저의 자바스크립트 `fetch` 로 서버에 **GET(가져오기)** 과 **PUT(바꾸기)** 을 합니다.
> 이름을 넣고 **켜기/끄기** 버튼을 누르면 서버의 LED 상태를 PUT 으로 바꾸고, **1초마다 GET을
> 반복(polling)** 해 "누가 언제 바꿨는지"를 화면에 보여줍니다. 이 서버는 뒤이어 **ESP32** 가
> 그대로 재사용해, 웹에서 켠 LED가 **실제 보드**에서 켜지게 됩니다.

## 1. 전체 그림

이번 장에서 만들 흐름입니다.

```
[브라우저 화면]                          [FastAPI 서버]
 이름 입력 + 켜기/끄기                    led = {on, by, time}
        │  ① 켜기 클릭                          │
        ├─ PUT /api/led {on:true, by} ─────────▶│ ② time 붙여 저장
        │◀────── {on:true, by, time} ───────────┤
        │                                        │
        │  ③ 1초마다 반복(polling)                │
        ├─ GET /api/led ───────────────────────▶│
        │◀────── {on, by, time} ────────────────┤
        ④ 받은 상태로 화면(표시등 + 안내문) 갱신
```

> 📌 서버 API는 [docs/03](03-rest-api.md) 에서 만든 그대로입니다.
> `GET /api/led`(조회), `PUT /api/led`(변경) 두 개만 씁니다.

## 2. fetch 기본 — async / await

`fetch` 는 서버에 요청을 보내고 **응답을 기다리는** 함수입니다. 응답이 언제 올지 모르므로
`async` 함수 안에서 `await` 로 "올 때까지 기다렸다 다음 줄 진행"하게 씁니다.

```js
async function load() {
  const res = await fetch("/api/led");  // ① 요청 보내고 응답 대기
  const led = await res.json();         // ② 응답 본문을 JSON으로 변환
  console.log(led);                     // ③ {on, by, time} 사용
}
```

| 단계 | 의미 |
|------|------|
| `await fetch(url)` | 요청 보내고 응답(Response) 받기 |
| `await res.json()` | 응답 본문을 JS 값(객체)으로 변환 |

> 💡 `await` 는 반드시 `async` 함수 안에서만 씁니다. 두 번의 `await` 가 보이는 이유는
> "응답이 오는 것"과 "본문을 읽어 변환하는 것"이 각각 기다림이 필요한 작업이기 때문이에요.

## 3. GET — LED 상태 가져오기

```js
async function fetchLed() {
  const res = await fetch("/api/led");
  const led = await res.json();   // {on, by, time}
  render(led);                    // 화면 그리기 (5장)
}
```

서버는 `{"on": true, "by": "철수", "time": "14:03:05"}` 형태의 **객체 하나**를 돌려줍니다.

## 4. PUT — LED 켜기/끄기 보내기

상태를 바꿀 때는 메서드·헤더·바디를 함께 지정합니다.

```js
async function setLed(on) {
  const by = document.getElementById("name").value.trim() || "익명";
  await fetch("/api/led", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },  // "JSON 보낸다" 표시
    body: JSON.stringify({ on, by }),                 // 객체 → JSON 문자열
  });
}
```

| 옵션 | 의미 |
|------|------|
| `method: "PUT"` | 바꾸기(변경) 요청 |
| `headers` | 바디가 JSON 형식임을 알림 |
| `body: JSON.stringify(...)` | JS 객체를 **JSON 문자열**로 바꿔 실어 보냄 |

> ⚠️ `body` 에는 객체를 그대로 넣을 수 없습니다. 반드시 `JSON.stringify()` 로 **문자열**로
> 바꿔야 하고, `Content-Type: application/json` 헤더가 있어야 서버가 JSON으로 알아듣습니다.

## 5. 화면 그리기 — render 함수

받은 상태 객체로 **표시등(ON/OFF)** 과 **안내문(누가·언제)** 을 갱신합니다.

```js
const lamp = document.getElementById("lamp");
const status = document.getElementById("status");

function render(led) {
  lamp.textContent = led.on ? "ON" : "OFF";
  lamp.className = "lamp " + (led.on ? "on" : "off");   // CSS 색 바꾸기
  status.textContent =
    `마지막 변경: ${led.by} 님이 ${led.time} 에 LED를 ${led.on ? "켰습니다" : "껐습니다"}.`;
}
```

> 💡 상태가 하나뿐이라 "받은 값으로 화면을 다시 칠하기"만 하면 됩니다. 채팅처럼 목록을
> 통째로 그릴 필요가 없어 더 단순해요.

## 6. polling — 1초마다 자동 갱신

서버에 **일정 간격으로 GET을 반복**해, 다른 사람(또는 ESP32)이 바꾼 상태도 자동으로 가져옵니다.
가장 단순한 "실시간 흉내내기"입니다.

```js
fetchLed();                       // 처음 한 번 즉시 로드
setInterval(fetchLed, 1000);      // 그 뒤 1초마다 반복
```

> 💡 진짜 실시간(바꾸자마자 즉시 푸시)은 **WebSocket** 으로 합니다 — 바로 다음 문서 [05](05-websocket.md).
> polling 은 "주기적으로 새로고침"하는 것이라 이해도 구현도 쉬워서 먼저 배웁니다.

## 7. 전체 자바스크립트 — 합치기

위 조각들을 모으면 이렇게 됩니다. (HTML에 `name`, `on`, `off`, `lamp`, `status` 가 있다고 가정)

```js
const lamp = document.getElementById("lamp");
const status = document.getElementById("status");
const nameInput = document.getElementById("name");

function render(led) {
  lamp.textContent = led.on ? "ON" : "OFF";
  lamp.className = "lamp " + (led.on ? "on" : "off");
  status.textContent =
    `마지막 변경: ${led.by} 님이 ${led.time} 에 LED를 ${led.on ? "켰습니다" : "껐습니다"}.`;
}

async function fetchLed() {
  const res = await fetch("/api/led");
  render(await res.json());
}

async function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  await fetch("/api/led", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ on, by }),
  });
  fetchLed();                          // 누른 직후 바로 갱신
}

document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));

fetchLed();                       // 첫 로드
setInterval(fetchLed, 1000);      // 1초 polling
```

## 8. CORS — 다른 주소에서 부를 때 한 줄

프론트(`index.html`)를 **서버가 함께 제공**하면(같은 주소, [docs/02 정적 파일](02-fastapi-static-hosting.md))
신경 쓸 게 없습니다. 하지만 페이지를 다른 주소/포트에서 열면 브라우저가 보안상 요청을
막는데(CORS), 이때 서버에 다음 한 줄을 추가하면 됩니다.

```python
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"])
```

> 📌 실습에서는 **정적 파일 서빙으로 같은 주소를 쓰는 것**을 권장합니다. 그러면 CORS를
> 만날 일이 거의 없습니다. (참고: ESP32는 브라우저가 아니라 CORS 제한을 받지 않습니다.)

## 9. Network 탭으로 확인하기

[docs/01](01-http-basics.md) 에서 본 개발자 도구 **Network** 탭을 켜 두면:

- `PUT /api/led` 가 켜기/끄기 클릭마다 `200` 으로 가는지
- `GET /api/led` 가 **1초마다** 또박또박 도는지

가 눈에 보입니다. 안 될 때 가장 먼저 열어 보세요.

## 정리

| 동작 | 코드 |
|------|------|
| 가져오기 | `await fetch(url)` → `await res.json()` |
| 바꾸기 | `method: "PUT"`, `headers`, `body: JSON.stringify(...)` |
| 화면 그리기 | 표시등 텍스트/클래스 + 안내문 갱신 |
| 자동 갱신 | `setInterval(fetchLed, 1000)` |

이제 모든 조각이 모였습니다. 실습에서 **두 브라우저 창**으로 서로 LED 를 켜고 꺼 보세요. 같은 서버에 **ESP32**
(03 강좌 마지막 실습)를 붙이면 **실제 LED** 가 따라 켜집니다. 🎉

➡️ 실습으로: [exercises/03-led-control.md](../exercises/03-led-control.md) · 다음 문서: [05. WebSocket](05-websocket.md)
