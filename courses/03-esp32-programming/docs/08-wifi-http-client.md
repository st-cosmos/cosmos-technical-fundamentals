# 08. WiFi + HTTP — 웹서버의 LED 를 따라 켜기 ★

> 🔗 이 실습의 **LED 서버**는 [06-web-server-python](../../06-web-server-python/README.md) 강좌에서 직접 만들게 되는 것과 같습니다.
> 지금은 서버 코드를 이해할 필요 없이 **완성 예제를 실행만** 하면 됩니다(uv 는 00 강좌에서 설치됨, 아래 6절).
> 06 강좌를 마친 뒤 이 서버가 어떻게 동작하는지 알게 되면, 여기 ESP32 코드가 더 잘 보입니다.

## 한 줄 요약

> ESP32 를 `WiFi.begin()` 으로 공유기에 연결한 뒤, `HTTPClient` 로 **LED 서버에 `GET /api/led`** 를 보내고 받은 상태대로
> **내장 LED 를 켜고 끕니다.** 웹 페이지에서 켠 LED 를 이 보드가 그대로 따라 켭니다. WiFi 비밀번호는 `config.h` 로
> 분리해 **git 에 올리지 않습니다.**

## 1. 전체 그림

ESP32 는 웹 페이지와 똑같이 "서버를 보는 하나의 클라이언트" 입니다.

```
[웹 페이지] ─PUT /api/led {on,by}─▶ [LED 서버(FastAPI)] ◀─GET /api/led─ [ESP32]
   (켜기/끄기)                        led = {on, by, time}                 │
                                                                          │
  ① WiFi.begin 으로 공유기 접속                                            │
  ② 1초마다 GET /api/led 요청 ────────────────────────────────────────────▶
  ③ 받은 on 값대로 내장 LED 켜기/끄기  (+ Serial 모니터에 출력)
```

서버는 06 강좌의 `examples/02-led-api` 를 그대로 실행합니다. (아래 6절)

## 2. WiFi 연결하기

ESP32 에 WiFi 가 내장되어 있어, `WiFi` 라이브러리만 include 하면 됩니다.

```cpp
#include <WiFi.h>

void setup() {
  Serial.begin(115200);

  WiFi.begin("WiFi이름(SSID)", "비밀번호");

  Serial.print("WiFi 연결 중");
  while (WiFi.status() != WL_CONNECTED) {   // 연결될 때까지 대기
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("연결됨! IP 주소: ");
  Serial.println(WiFi.localIP());           // 받은 IP 출력
}
```

| 요소 | 의미 |
|------|------|
| `WiFi.begin(ssid, pw)` | 지정한 WiFi 에 접속 시도 |
| `WiFi.status()` | 현재 연결 상태 코드 |
| `WL_CONNECTED` | "연결 완료" 상태 값 |
| `WiFi.localIP()` | 공유기가 ESP32 에 부여한 IP 주소 |

> ⚠️ ESP32 는 **2.4GHz WiFi 만** 지원합니다. 5GHz 전용 네트워크에는 연결되지 않으니 공유기의 **2.4GHz** SSID 를 쓰세요.
> (대학/회사의 로그인이 필요한 WiFi 도 어려울 수 있어, **휴대폰 핫스팟**이 실습엔 편합니다.)

## 3. 비밀정보 분리 — `config.h`

WiFi 비밀번호를 `main.cpp` 에 직접 적고 git 에 올리면 **비밀번호가 그대로 노출**됩니다. 그래서 비밀정보는 별도 파일
`include/config.h` 에 두고, 이 파일은 `.gitignore` 로 **커밋에서 제외**합니다. 대신 빈 양식 **`config.example.h`** 를
올려 두고 각자 복사해서 채웁니다.

`include/config.example.h` (git 에 올라감):

```cpp
#pragma once

#define WIFI_SSID     "여기에_WiFi_이름"
#define WIFI_PASSWORD "여기에_비밀번호"

// 서버를 띄운 PC의 IP와 포트 (예: http://192.168.0.10:8000)
#define SERVER_URL    "http://PC의_IP주소:8000"
```

```bash
# examples/06-wifi-led-client/include 폴더에서
cp config.example.h config.h     # Windows PowerShell 도 cp 가 됩니다
```

> 📌 **`config.h` 는 저장소 최상위 `.gitignore` 에 등록되어 있어 절대 커밋되지 않습니다.**

## 4. GET 요청 보내기 — `HTTPClient`

```cpp
#include <HTTPClient.h>
#include "config.h"

const int LED_PIN = 2;  // 내장 LED

void pollLed() {
  HTTPClient http;
  http.begin(String(SERVER_URL) + "/api/led");  // 요청할 주소

  int code = http.GET();                         // GET 요청 → HTTP 상태코드 반환
  if (code == 200) {                             // 200 = 성공(OK)
    String body = http.getString();              // 예: {"on":true,"by":"홍길동","time":"..."}
    bool on = body.indexOf("\"on\":true") >= 0;  // on 값만 확인
    digitalWrite(LED_PIN, on ? HIGH : LOW);      // 물리 LED 반영
    Serial.println(String("LED ") + (on ? "ON" : "OFF"));
  } else {
    Serial.printf("요청 실패, 상태코드: %d\n", code);
  }

  http.end();   // 연결 정리 (꼭 호출)
}
```

핵심 흐름은 항상 같습니다: `http.begin(URL) → http.GET() → 상태코드 확인 → http.getString() → http.end()`

| HTTP 상태코드 | 의미 |
|---------------|------|
| 200 | 성공 (OK) |
| 404 | 주소(경로)를 못 찾음 |
| 음수(-1 등) | 연결 자체 실패 (서버 주소/방화벽/네트워크 문제) |

> 💡 응답 JSON 에서 `on` 값만 필요하므로 문자열에 `"on":true` 가 들어 있는지만 확인합니다. JSON 을 제대로 파싱하려면
> `ArduinoJson` 라이브러리를 쓰지만, 이 범위에선 문자열 검색으로 충분합니다.

## 5. 전체 구조 (코드: `examples/06-wifi-led-client/`)

```cpp
void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  // ① WiFi 연결 (2절)
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    pollLed();            // ② 1초마다 GET → LED 반영 (4절)
  } else {
    WiFi.reconnect();     // 끊기면 재연결
  }
  delay(1000);
}
```

## 6. LED 서버 띄우기 (PC 에서)

서버는 따로 만들지 않습니다. **06-web-server-python 의 LED 서버 완성 예제**를 그대로 실행합니다. (첫 실행은 uv 가
의존성을 내려받느라 수십 초 걸립니다. 서버 코드의 의미는 06 강좌에서 배웁니다.)

```bash
# 저장소 최상위에서
cd courses/06-web-server-python/examples/02-led-api
uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

- `--host 0.0.0.0` 이어야 **ESP32 같은 다른 기기**에서 접속됩니다. (`localhost` 는 PC 자신만)
- ESP32 에는 PC 의 **실제 IP**(예: `192.168.0.10`)를 `SERVER_URL` 에 적습니다. ([01-cli 의 IP 확인](../../01-cli/docs/04-network-ip.md))
- ESP32 와 PC 는 **같은 WiFi** 에 있어야 합니다.

## 자주 막히는 문제

| 증상 | 원인 / 해결 |
|------|------------|
| WiFi 연결에서 멈춤(`....` 만 반복) | SSID/비번 오타, **5GHz 네트워크**(2.4GHz 로), 신호 약함. 핫스팟으로 시도 |
| 상태코드가 -1 또는 음수 | 서버 주소(IP/포트) 오타, 서버 미실행, **방화벽**이 포트 막음, PC 와 다른 WiFi |
| 브라우저는 되는데 ESP32 만 안 됨 | 서버를 `--host 0.0.0.0` 으로 안 띄움 / Windows 방화벽 인바운드 차단 |
| `config.h` 없다고 컴파일 에러 | `config.example.h` 를 `config.h` 로 복사하고 값 채우기 |

## 더 나아가기

- 버튼([04](04-digital-input.md))을 눌러 **`PUT /api/led` 로 상태를 바꾸기** — ESP32 도 쓰기 클라이언트로
- `ArduinoJson` 으로 응답 JSON 제대로 파싱하기
- 가변저항([06](06-analog-input.md)) 값을 서버에 올려 웹 페이지에 그래프로 보이기
- 06 강좌의 **WebSocket** 버전 서버에 붙이기 (polling 없이 즉시 반영)

➡️ 실습: [`exercises/06-wifi-led-client.md`](../exercises/06-wifi-led-client.md)
