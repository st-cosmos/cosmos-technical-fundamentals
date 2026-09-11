# 09. WiFi + WebSocket — 서버가 밀어주는 대로 즉시 켜기 ★

## 한 줄 요약

> [08](08-wifi-http-client.md) 의 ESP32 는 **1초마다 서버에 물어봤습니다**(polling). 이번엔 서버와 **연결을 계속 열어 두고**,
> 누가 LED 를 바꾸면 서버가 **즉시 알려 주는**(push) WebSocket 으로 바꿉니다. 덤으로 **버튼(GPIO22)** 을 누르면 ESP32 쪽에서도
> 상태를 서버에 보내, 브라우저 ↔ 서버 ↔ 보드가 한 상태를 실시간으로 공유합니다.
> 서버는 05 강좌의 WebSocket 버전(`examples/03-led-websocket`)을 그대로 씁니다.

## 1. polling 과 WebSocket — ESP32 입장에서

| | 08 polling (`HTTPClient`) | 09 WebSocket (`WebSocketsClient`) |
|---|---|---|
| 상태 받기 | 1초마다 `GET /api/led` 요청 → 응답 | 서버가 바뀔 때만 **보내 줌** (`onEvent`) |
| 반영 지연 | 최대 1초 | 즉시 |
| 요청 수 | 변화 없어도 1초에 1번 | 변화 있을 때만 |
| ESP32 → 서버 | `PUT /api/led` (도전 과제) | `ws.sendTXT(...)` 한 줄 |
| 코드 모양 | `loop()` 에서 요청·응답을 순서대로 | **이벤트 함수**를 등록해 두고 `ws.loop()` 만 돌림 |

05 강좌 [docs/05](../../05-web-server-python/docs/05-websocket.md) 에서 브라우저가 한 일과 **정확히 같은 일**을 C++ 로 하는 것입니다.

```
[웹 페이지] ◀─────── ws ────────▶ [LED 서버] ◀──────── ws ────────▶ [ESP32]
  버튼 클릭 → ws.send({on,by})       led={on,by}       버튼(GPIO22) → ws.sendTXT({on,by})
  onmessage → 화면 갱신          ← broadcast →       onWsEvent → LED(GPIO23) 켜기/끄기
```

## 2. 라이브러리 — platformio.ini 한 줄

WebSocket 은 Arduino 코어에 내장돼 있지 않아 라이브러리를 씁니다. `platformio.ini` 에 한 줄 적으면 첫 빌드 때 자동으로 받습니다.

```ini
lib_deps = links2004/WebSockets@^2.6.1
```

> 💡 이게 PlatformIO 의 **패키지 관리자** 역할입니다. 04 강좌의 `uv add`, 03 강좌의 `npm install` 과 같은 자리.

## 3. 연결하기 — 주소는 host / port / path 로 따로

08 의 `SERVER_URL`(`"http://192.168.0.10:8000"`) 과 달리, WebSocket 라이브러리는 세 조각으로 받습니다. `config.h` 도 그렇게 나눴습니다.

```cpp
#include <WebSocketsClient.h>
WebSocketsClient ws;

void setup() {
  // ... WiFi 연결 (08 과 동일) ...
  ws.begin(SERVER_HOST, SERVER_PORT, SERVER_PATH);   // ws://192.168.0.10:8000/ws
  ws.onEvent(onWsEvent);                             // 무슨 일이 생기면 이 함수를 불러 달라
  ws.setReconnectInterval(2000);                     // 끊기면 2초마다 다시 시도
}

void loop() {
  ws.loop();   // ★ 매번 불러야 메시지를 받고 연결이 유지된다
}
```

> ⚠️ `loop()` 안에서 `delay(1000)` 처럼 **오래 멈추면 안 됩니다.** 그동안 `ws.loop()` 가 못 돌아 메시지를 놓치고 연결이 끊깁니다.
> 08 예제의 `delay(1000)` 이 사라진 이유입니다. 기다림이 필요하면 [07](07-serial-communication.md) 의 `millis()` 방식으로.

## 4. 이벤트 함수 — 연결됨 · 끊김 · 메시지

브라우저의 `ws.onopen / onclose / onmessage` 세 개가 C++ 에서는 **함수 하나 + `switch`** 로 합쳐져 있습니다.

```cpp
void onWsEvent(WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_CONNECTED:     Serial.println("연결됨"); break;     // onopen
    case WStype_DISCONNECTED:  Serial.println("끊김");   break;     // onclose
    case WStype_TEXT: {                                              // onmessage
      String msg = String((const char*)payload);   // {"on":true,"by":"철수","time":"14:03:05","viewers":2}
      bool on = msg.indexOf("\"on\":true") >= 0;   // on 값만 확인
      digitalWrite(LED_PIN, on ? HIGH : LOW);
      break;
    }
    default: break;   // ping/pong 등은 라이브러리가 처리
  }
}
```

- 서버는 **접속 직후** 현재 상태를 한 번 보내고, 이후엔 **누가 바꿀 때마다** 보냅니다(05 서버의 `broadcast()`). ESP32 는 받기만 하면 됩니다.
- JSON 파싱은 08 과 같이 `indexOf` 로 간단히. 제대로 하려면 `ArduinoJson` (도전 과제).

## 5. ESP32 → 서버 — 버튼으로 상태 바꾸기

서버의 `/ws` 는 `{"on": bool, "by": str}` 를 받으면 상태를 바꾸고 **모두에게** 다시 보냅니다. 브라우저가 `ws.send(JSON.stringify({on, by}))`
하던 것을 ESP32 는 `ws.sendTXT()` 로 합니다. [04](04-digital-input.md) 의 엣지 감지를 그대로 씁니다.

```cpp
int button = digitalRead(BUTTON_PIN);
if (lastButton == HIGH && button == LOW) {                 // 막 눌린 순간
  String cmd = String("{\"on\":") + (ledOn ? "false" : "true") + ",\"by\":\"ESP32\"}";
  ws.sendTXT(cmd);
  delay(50);                                               // 채터링 무시
}
lastButton = button;
```

보내고 나면 서버가 broadcast 하므로 **ESP32 자신에게도** 새 상태가 돌아와 LED 가 바뀝니다. 즉 LED 는 항상 "서버가 말한 상태"만 따릅니다.
그래서 버튼을 눌러도 `digitalWrite` 를 직접 하지 않습니다 — 웹 페이지의 "누가 바꿨는지" 에 `ESP32` 가 뜨는 것도 확인해 보세요.

## 6. 서버 띄우기

```bash
cd courses/05-web-server-python/examples/03-led-websocket
uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

08 과 같은 규칙입니다: `--host 0.0.0.0`, ESP32 에는 PC 의 **실제 IP**, 같은 **2.4GHz WiFi**. `config.h` 는 `.gitignore` 로 제외됩니다.

## 자주 막히는 문제

| 증상 | 원인 / 해결 |
|------|------------|
| `WebSocket 끊김` 만 반복 | `SERVER_HOST`/`SERVER_PORT` 오타, 서버가 **03-led-websocket** 이 아닌 02 (`/ws` 없음), `--host 0.0.0.0` 누락, 방화벽 |
| 연결은 되는데 LED 가 안 바뀜 | 서버 메시지에 `"on":true` 가 있는지 Serial 로 확인. 06 서버(polling 전용)엔 `/ws` 가 없음 |
| 버튼을 눌러도 서버에 안 감 | 버튼이 **GPIO22 ── GND** 인지, Serial 에 `버튼 → 서버에 전송` 이 찍히는지 |
| 처음엔 되다가 얼마 뒤 끊김 | `loop()` 에 긴 `delay` 가 있으면 `ws.loop()` 가 못 돎. `delay` 제거하고 `millis()` 로 |
| `WebSocketsClient.h` 를 못 찾음 | `platformio.ini` 의 `lib_deps` 확인 후 다시 빌드 (인터넷 필요) |

## 더 나아가기

- `ArduinoJson` 으로 `by`·`time`·`viewers` 까지 꺼내 Serial 에 예쁘게 출력
- 가변저항([06](06-analog-input.md)) 값을 0.5초마다 `ws.sendTXT` 로 올려 웹 페이지에 실시간 그래프
- 서버 쪽에 `{"brightness": 0~255}` 메시지를 추가하고 ESP32 는 `analogWrite` 로 밝기 반영 — 05·06 강좌 양쪽을 고치는 종합 과제

➡️ 실습: [`exercises/07-wifi-led-websocket.md`](../exercises/07-wifi-led-websocket.md)
