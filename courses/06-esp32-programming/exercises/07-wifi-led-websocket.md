# 실습 07. WebSocket 으로 즉시 반영 + 버튼으로 서버 바꾸기 ★

> 🎯 목표: 실습 06 의 polling 을 **WebSocket** 으로 바꿔, 브라우저에서 누르면 **즉시** LED(GPIO23) 가 켜지고,
> **버튼(GPIO22)** 을 누르면 반대로 브라우저 화면이 즉시 바뀌게 한다.
>
> 📎 관련 문서: [docs/09-wifi-websocket-client.md](../docs/09-wifi-websocket-client.md) · 펌웨어: `examples/07-wifi-led-websocket/` ·
> 서버: `courses/05-web-server-python/examples/03-led-websocket/`

## 준비물

- 실습 06 을 끝낸 상태 (WiFi 연결·`config.h`·PC IP 찾기에 익숙함)
- LED(GPIO23) + 버튼(GPIO22) 배선 — 실습 01·02 와 같음
- ESP32 와 **같은 2.4GHz WiFi** 에 연결된 PC, **uv**

## 전체 흐름

```
[웹 페이지] ◀──── ws ────▶ [LED 서버] ◀──── ws ────▶ [ESP32]
  버튼 클릭 → send             led={on,by}          버튼(GPIO22) → sendTXT
  onmessage → 화면          ← broadcast →         onWsEvent → LED(GPIO23)
```

## 1단계. WebSocket 서버 띄우기 (PC 에서)

이번엔 05 강좌의 **03 예제**(WebSocket 버전)입니다. 02 예제에는 `/ws` 가 없어 연결이 안 됩니다.

```bash
# 저장소 최상위에서
cd courses/05-web-server-python/examples/03-led-websocket
uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

브라우저에서 `http://localhost:8000` 을 **창 2개**로 열고 한쪽에서 켜기 → 다른 쪽이 즉시 바뀌는지 먼저 확인합니다.

## 2단계. config.h 만들기

`examples/07-wifi-led-websocket/include/` 에서 양식을 복사합니다. 실습 06 과 달리 **주소를 세 조각**으로 적습니다.

```bash
cp config.example.h config.h
```

```cpp
#define WIFI_SSID     "내_WiFi_이름"
#define WIFI_PASSWORD "내_WiFi_비번"
#define SERVER_HOST   "192.168.0.10"   // PC IP (실습 06 의 2단계와 같은 방법으로 찾기)
#define SERVER_PORT   8000
#define SERVER_PATH   "/ws"
```

## 3단계. 업로드 & 확인 — 서버 → ESP32

1. `examples/07-wifi-led-websocket` 폴더 열기 → **Upload**. 첫 빌드는 WebSocket 라이브러리를 내려받느라 조금 더 걸립니다.
2. **Serial Monitor** 를 열어 둡니다. 아래처럼 나오면 연결 성공:

```
WiFi 연결 중....
연결됨! ESP32 IP: 192.168.0.21
WebSocket 연결 시도: ws://192.168.0.10:8000/ws
WebSocket 연결됨 — 서버가 현재 상태를 바로 보내 줍니다
서버 push: OFF  {"on":false,"by":"아직 아무도","time":"-","viewers":2}
```

3. 브라우저에서 **켜기** → LED 가 **바로**(1초 기다림 없이) 켜지고 `서버 push: ON ...` 이 찍힙니다.
   실습 06 과 번갈아 해 보면 반응 속도 차이가 느껴집니다.

## 4단계. ESP32 → 서버 — 버튼 누르기

1. GPIO22 버튼을 한 번 누릅니다. Serial 에 `버튼 → 서버에 전송: {"on":true,"by":"ESP32"}` 가 찍히고,
2. 곧바로 `서버 push: ON ...` 이 **되돌아오면서** LED 가 켜집니다. (LED 는 서버가 확정한 상태만 따릅니다)
3. **브라우저 화면**을 보세요 — 표시등이 즉시 바뀌고 "누가 바꿨는지" 에 **ESP32** 가 뜹니다.
4. 한 번 더 누르면 꺼집니다. 창 2개 + 보드 버튼, 셋 중 어디서 바꿔도 **모두 즉시 같아지는지** 확인하세요.

## 직접 해보기 (도전 과제)

1. **누가 켰는지 LED 로 구분**: `"by":"ESP32"` 가 들어 있으면 두 번 깜빡이고 켜지기 (`indexOf` 로 확인).
2. **끊김 표시**: `WStype_DISCONNECTED` 에서 LED 를 빠르게 3번 깜빡여 "서버와 끊겼다" 를 알리기.
3. **길게 누르면 끄기, 짧게 누르면 켜기**: `millis()` 로 누른 시간을 재서 다른 명령 보내기.
4. **가변저항 값 올리기**: 실습 04 의 `analogRead(34)` 를 0.5초마다 `ws.sendTXT("{\"pot\":1234}")` 로 보내고, 서버 쪽(05 강좌)을 고쳐 웹 페이지에 숫자로 표시. (서버·펌웨어 양쪽을 고치는 종합 과제)

## 막히면? (가장 흔한 순서)

| 증상 | 확인 |
|------|------|
| `WebSocket 끊김` 만 반복 | 서버가 **03-led-websocket** 인지(02 는 `/ws` 없음), `SERVER_HOST`/`PORT`, `--host 0.0.0.0`, 방화벽 |
| WiFi 는 되는데 연결 시도만 반복 | PC 와 같은 WiFi 인지, PC IP 가 바뀌지 않았는지 (`ipconfig` 다시) |
| LED 가 안 바뀜 | Serial 의 `서버 push` 메시지에 `"on":true` 가 있는지 |
| 버튼이 반응 없음 | GPIO22 ── GND 배선, Serial 에 `버튼 → 서버에 전송` 이 찍히는지 |
| 얼마 뒤 끊김 | `loop()` 에 긴 `delay` 를 넣지 않았는지 (`ws.loop()` 가 계속 돌아야 함) |
| `config.h` 없음 컴파일 에러 | 2단계 복사 안 함 |

## ✅ 체크포인트

- [ ] 서버 → ESP32: 브라우저에서 누르면 LED 가 **즉시** 바뀐다
- [ ] ESP32 → 서버: 버튼을 누르면 브라우저 화면이 즉시 바뀌고 `ESP32` 가 표시된다
- [ ] polling(06) 과 WebSocket(07) 의 차이를 한 문장으로 설명할 수 있다
- [ ] `ws.loop()` 를 왜 계속 불러야 하는지 안다

## 🎓 마무리

03 강좌의 웹 페이지, 04 의 파이썬, 05 의 서버, 그리고 06 의 ESP32 가 **한 상태를 실시간으로 공유**하게 됐습니다.
07 강좌에서는 이 구성에 AI 에이전트로 기능을 더해 봅니다.

⬅️ 이전: [06. WiFi 로 웹서버의 LED 따라 켜기](06-wifi-led-client.md)
🏠 처음으로: [README](../README.md)
