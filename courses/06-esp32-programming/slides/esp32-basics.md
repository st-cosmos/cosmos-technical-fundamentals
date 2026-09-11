---
marp: true
theme: cosmos
paginate: true
footer: "06 · ESP32 프로그래밍"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 06</div>

# ESP32 프로그래밍

<div class="rule"></div>

<div class="subtitle">MCU 에 WiFi 가 들어있다 — 디지털·PWM·아날로그·Serial</div>

<div class="meta">
보드: ESP32 DevKit · IDE: VS Code + PlatformIO<br>
대상: 임베디드 입문 · Windows / macOS
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. ESP32 가 **뭔지** — MCU + WiFi 내장
2. **개발 환경** — VS Code + PlatformIO 확인, 첫 업로드
3. **디지털 출력** — LED 켜기
4. **디지털 입력** — 버튼·풀업·엣지
5. **PWM 출력** — 밝기 조절
6. **아날로그 입력** — 가변저항 → 밝기
7. **Serial 통신** — 디버깅·명령
8. ★ **WiFi + HTTP** — 웹서버 LED 따라 켜기

---

<!-- _class: section -->
<div class="eyebrow">PART 01</div>

# ESP32란 무엇인가

---

## MCU = 손톱만 한 컴퓨터

- **MCU**(마이크로컨트롤러) = CPU + 메모리 + **입출력 핀**이 한 칩에
- 화면도 OS 도 없지만 **전기 신호를 읽고 쓰는 일**에 특화
- 아두이노 우노도 MCU 보드. ESP32 는 훨씬 강력 + **무선 내장**

> ESP32 = **MCU + WiFi·Bluetooth** 가 칩 하나에

---

## 왜 ESP32 인가 — 한 줄이면 인터넷

```cpp
WiFi.begin("우리집_WiFi", "비밀번호");
```

| 항목 | 아두이노 우노 | **ESP32** |
|------|------|------|
| CPU | 16MHz 단일 | **240MHz 듀얼** |
| WiFi / BT | ❌ | ✅ **내장** |
| ADC | 10bit (0~1023) | **12bit (0~4095)** |
| 전압 | 5V | **3.3V** ⚠️ |

> 센서 읽기 → 판단 → **WiFi 로 서버 전송** 을 칩 하나로

---

## 보드 살펴보기

```
[USB]─ USB-UART칩 ─ ESP32 칩      ← 업로드 + Serial 한 선으로
 포트  (CP2102/CH340)
[EN]리셋  [BOOT]부트
 양옆: GPIO 핀들 · 내장 LED(GPIO2)
```

- **USB**: 코드 업로드 + Serial 통신
- **USB-UART 칩**: 드라이버가 필요할 수 있음
- **GPIO 핀**: LED·버튼·센서를 연결하는 곳

> ⚠️ **3.3V 부품** — 핀에 5V 넣지 않기

---

<!-- _class: section -->
<div class="eyebrow">PART 02</div>

# 개발 환경

<div class="lead-sub">VS Code + PlatformIO</div>

---

## 왜 PlatformIO? — 이미 설치되어 있다

- 공식 **Arduino 용 VS Code 확장은 지원 종료**(archived)
- VS Code 에서 ESP32 개발의 사실상 표준 = **PlatformIO**
- 컴파일러·보드·라이브러리를 **자동 관리** + 자동완성
- **00 강좌 스크립트가 설치** — 사이드바에 외계인(PlatformIO) 아이콘이 있으면 OK

```
1) (필요시) USB-UART 드라이버 → 2) examples/01 폴더 열기 → 3) Build → Upload → Serial Monitor
```

> ⚠️ 저장소 최상위가 아니라 **`examples/0N-*` 개별 폴더**를 여세요 (platformio.ini 가 있는 곳)

---

## platformio.ini · 하단 버튼

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
```

| 하단 버튼 | 하는 일 | 단축키 |
|------|---------|--------|
| Build (체크) | 컴파일만 | `Ctrl+Alt+B` |
| Upload (화살표) | 컴파일 + 보드에 업로드 | `Ctrl+Alt+U` |
| Serial Monitor (플러그) | Serial 출력 보기 | `Ctrl+Alt+M` |

<div class="small"><code>monitor_speed</code> 와 코드의 <code>Serial.begin()</code> 은 <b>같은 값</b>이어야 글자가 안 깨짐 · 업로드가 <code>Connecting...</code> 만 반복 → 보드의 <b>BOOT 버튼</b> 누르고 있기</div>

---

<!-- _class: section -->
<div class="eyebrow">PART 03</div>

# 디지털 출력

<div class="lead-sub">HIGH / LOW 내보내기</div>

---

## 핀 다루는 함수 · 프로그램 뼈대

```cpp
void setup() { /* 처음 한 번 */ }
void loop()  { /* 끝없이 반복 */ }
```

```cpp
pinMode(핀, OUTPUT);           // 역할 정하기
digitalWrite(핀, HIGH / LOW);  // 출력
```

| 값 | 의미 | 전압 |
|----|------|------|
| HIGH | 켜짐/참 | 3.3V |
| LOW | 꺼짐/거짓 | 0V |

---

## Blink — LED 깜빡이기

```cpp
const int LED_PIN = 23;           // GPIO23 ─[220Ω]─▶|─ GND (내장 LED 는 2)
void setup(){ pinMode(LED_PIN, OUTPUT); }
void loop(){
  digitalWrite(LED_PIN, HIGH); delay(1000);
  digitalWrite(LED_PIN, LOW);  delay(1000);
}
```

외부 LED: `GPIO ──[220Ω]──▶|── GND` (긴 다리가 +, **저항 필수**)

> 핀 주의: GPIO34~39 **입력 전용** · GPIO6~11 **사용 금지** · 무난한 출력 핀 2·4·5

---

<!-- _class: section -->
<div class="eyebrow">PART 04</div>

# 디지털 입력

<div class="lead-sub">버튼 읽기</div>

---

## 버튼과 풀업

```cpp
pinMode(BUTTON_PIN, INPUT_PULLUP);  // 평소 HIGH, 누르면 LOW
int v = digitalRead(BUTTON_PIN);
```

- **플로팅** 문제(연결 안 된 핀은 값이 제멋대로) → 내부 풀업으로 평소 상태 고정
- 배선: `GPIO22 ─[버튼]─ GND` (저항 불필요)

> ⚠️ 풀업이라 **누르면 LOW** (로직 반대!) — 이 강좌에서 가장 많이 헷갈리는 것

---

## "눌린 순간"만 잡기 — 엣지 감지 + 디바운스

`loop()` 는 초당 수만 번 → 0.3초 누르면 LOW 가 수천 번. **HIGH→LOW 로 바뀐 순간**만:

```cpp
int lastButton = HIGH;
void loop() {
  int button = digitalRead(BUTTON_PIN);
  if (lastButton == HIGH && button == LOW) {   // 막 눌린 순간
    pressCount++;
    delay(50);                                  // 떨림(채터링) 무시
  }
  lastButton = button;
}
```

> 토글: 눌린 순간에 `ledOn = !ledOn;`

---

<!-- _class: section -->
<div class="eyebrow">PART 05</div>

# PWM 출력

<div class="lead-sub">빠른 점멸의 평균 = 밝기</div>

---

## PWM — 켜짐/꺼짐 비율로 중간값 흉내

```
밝게:   ████████████████████  듀티 90%
중간:   ██████████            듀티 50%
어둡게: ███                   듀티 15%
```

```cpp
analogWrite(LED_PIN, 128);    // 0 = 꺼짐, 255 = 최대, 128 = 절반
```

```cpp
for (int d = 0;   d <= 255; d++) { analogWrite(LED_PIN, d); delay(5); }  // 밝게
for (int d = 255; d >= 0;   d--) { analogWrite(LED_PIN, d); delay(5); }  // 어둡게
```

> LED 밝기 · 모터 속도 · 서보 각도 · 부저 음높이 — 전부 PWM
> (참고) 진짜 아날로그 전압은 `dacWrite(25, v)` — 클래식 ESP32 의 GPIO25/26 만

---

<!-- _class: section -->
<div class="eyebrow">PART 06</div>

# 아날로그 입력

<div class="lead-sub">0~3.3V 를 0~4095 숫자로</div>

---

## ADC — `analogRead`

```cpp
int raw = analogRead(34);        // 0 ~ 4095 (12bit)
float v = raw * 3.3 / 4095.0;    // 실제 전압
```

- 가변저항: 양 끝 3.3V/GND, **가운데**를 입력 핀에
- WiFi 병행 시 **GPIO34~39 (ADC1)** 만 안전 — 처음부터 이 핀 습관

```cpp
int duty = map(raw, 0, 4095, 0, 255);   // 범위 변환
analogWrite(LED_PIN, duty);             // 가변저항 → LED 밝기
```

> **입력(ADC) → map → 출력(PWM)** — 이 강좌의 입출력을 한 줄로 잇는 예제 (examples/04)

---

<!-- _class: section -->
<div class="eyebrow">PART 07</div>

# Serial 통신

<div class="lead-sub">화면 없는 보드를 들여다보는 창</div>

---

## 출력 — 디버깅의 기본

```cpp
void setup(){ Serial.begin(115200); }
void loop(){
  Serial.printf("가동 %lu초\n", millis()/1000);
  delay(1000);
}
```

- `print` / `println` / `printf`
- 의심 지점마다 흔적 남기기 → 원인 추적
- `millis()` = 켜진 뒤 흐른 ms — `delay` 없이 타이밍 재기
- ⚠️ 속도 **115200** 일치 안 하면 외계어

---

## 입력 — PC 에서 명령 받기

```cpp
if (Serial.available() > 0) {
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();                              // 공백/줄바꿈 제거 (중요!)
  if (cmd == "on")  digitalWrite(LED_PIN, HIGH);
  if (cmd == "off") digitalWrite(LED_PIN, LOW);
}
```

> 모니터 줄 끝(line ending)을 **LF/Newline** 으로
> 이제 진짜 강점 — **WiFi** 로 서버와 통신하기

---

<!-- _class: section -->
<div class="eyebrow">PART 08 ★</div>

# WiFi + HTTP

<div class="lead-sub">오늘의 마무리 — 웹서버의 LED 를 실제 보드가 따라 켠다</div>

---

## 전체 흐름

```
[웹 페이지] ─PUT /api/led─▶ [LED 서버] ◀─GET /api/led─ [ESP32]
   (켜기/끄기)               led={on,by}                 │
  ① WiFi.begin 연결                                       │
  ② 1초마다 GET /api/led ─────────────────────────────────▶
  ③ 받은 on 값대로 LED 켜기/끄기 (+ Serial)
```

```cpp
HTTPClient http;
http.begin(String(SERVER_URL) + "/api/led");
if (http.GET() == 200) {
  bool on = http.getString().indexOf("\"on\":true") >= 0;
  digitalWrite(LED_PIN, on ? HIGH : LOW);
}
http.end();
```

<div class="small">비밀정보(SSID/비번/주소)는 <code>config.h</code> 로 분리 → git 제외 · ESP32 는 <b>2.4GHz 만</b> · 서버는 05 강좌에서 만든 LED 서버를 <code>uv run … --host 0.0.0.0</code> 으로 띄움</div>

---

## WebSocket 버전 — 물어보지 않고 받는다 (examples/07)

```
[웹 페이지] ◀── ws ──▶ [LED 서버] ◀── ws ──▶ [ESP32]
  클릭 → send            broadcast          버튼(GPIO22) → sendTXT
  onmessage → 화면                          onWsEvent → LED(GPIO23)
```

```cpp
WebSocketsClient ws;                              // lib_deps = links2004/WebSockets
void onWsEvent(WStype_t type, uint8_t* payload, size_t len) {
  if (type == WStype_TEXT) {                      // 서버가 push 한 {"on":true,...}
    bool on = String((const char*)payload).indexOf("\"on\":true") >= 0;
    digitalWrite(LED_PIN, on ? HIGH : LOW);
  }
}
ws.begin(SERVER_HOST, 8000, "/ws"); ws.onEvent(onWsEvent);   // setup
ws.loop();  /* 매번 */  ws.sendTXT("{\"on\":true,\"by\":\"ESP32\"}");  // 버튼 → 서버
```

> polling 은 **최대 1초 지연 + 빈 요청**, WebSocket 은 **즉시 + 변화 있을 때만**. `loop()` 에 긴 `delay` 금지 — `ws.loop()` 가 계속 돌아야 함

---

<!-- _class: section -->
<div class="eyebrow">WRAP-UP</div>

# 정리

---

## 오늘의 핵심

- ESP32 = **MCU + WiFi 내장**, 3.3V
- 환경 = **VS Code + PlatformIO**, 보드 `esp32dev`, `examples/0N` 폴더 열기
- **디지털 출력** `digitalWrite` · **입력** `INPUT_PULLUP` + 엣지 감지
- **PWM** `analogWrite(0~255)` · **아날로그 입력** `analogRead(34)` + `map`
- **Serial**: 출력으로 디버깅, 입력으로 제어, 115200
- **WiFi + GET** 으로 웹서버 LED 따라 켜기 — 웹과 하드웨어가 한 서버를 공유
- **WebSocket** 으로 즉시 반영 + 버튼으로 서버 상태 바꾸기 — 브라우저 ↔ 서버 ↔ 보드 실시간

<span class="small">자세한 내용은 docs/, 직접 해보기는 exercises/ + examples/</span>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">이제 실습</div>

# 보드에 올려 봅시다 🔌

<div class="rule"></div>

<div class="subtitle">exercises/ — LED → 버튼 → PWM → 가변저항 → Serial → WiFi → WebSocket 순서로</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>
