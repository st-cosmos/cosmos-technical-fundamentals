# 실습 06. (선택) WiFi 로 웹서버의 LED 따라 켜기 ★

> 🔗 **선택 심화**. [06-web-server-python](../../06-web-server-python/README.md) 의 LED 서버가 필요합니다.
>
> 🎯 목표: ESP32 를 WiFi 에 연결하고, **내 PC 에 띄운 LED 서버**에 **`GET /api/led`** 를 보내 받은 상태대로
> **내장 LED 를 켜고 끈다.** 브라우저에서 켜기/끄기를 누르면 ESP32 의 LED 가 따라 켜지는, 이 강좌의 대미.
>
> 📎 관련 문서: [docs/08-wifi-http-client.md](../docs/08-wifi-http-client.md) · 펌웨어: `examples/06-wifi-led-client/` ·
> 서버: `courses/06-web-server-python/examples/02-led-api/`

## 준비물

- ESP32 DevKit + USB 케이블
- ESP32 와 **같은 WiFi** 에 연결된 PC (서버 역할)
- **2.4GHz WiFi** (또는 휴대폰 핫스팟)
- **uv** (서버 실행용 — 00 강좌에서 설치)

## 전체 흐름

```
[웹 페이지] ─PUT /api/led {on,by}─▶ [LED 서버] ◀─GET /api/led─ [ESP32]
   (켜기/끄기)                                                    │
   ① ESP32가 WiFi 연결                                            │
   ② 1초마다 GET /api/led ────────────────────────────────────────▶
   ③ 받은 on 값대로 내장 LED 켜기/끄기 (+ Serial 출력)
```

## 1단계. LED 서버 띄우기 (PC 에서)

```bash
# 저장소 최상위에서
cd courses/06-web-server-python/examples/02-led-api
uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

브라우저에서 `http://localhost:8000` 을 열면 **LED 제어판**(이름 + 켜기/끄기)이 보입니다.

> ⚠️ `--host 0.0.0.0` 이어야 ESP32 가 접속할 수 있습니다.

## 2단계. PC 의 IP 주소 찾기

| OS | 명령 |
|----|------|
| Windows | `ipconfig` → "IPv4 주소" (예: `192.168.0.10`) |
| macOS | `ipconfig getifaddr en0` |

([01-cli 의 IP 확인](../../01-cli/docs/04-network-ip.md) 참고)

## 3단계. config.h 만들기

`examples/06-wifi-led-client/include/` 폴더에서 양식을 복사합니다.

```bash
cp config.example.h config.h
```

`config.h` 를 열어 채웁니다.

```cpp
#define WIFI_SSID     "내_WiFi_이름"
#define WIFI_PASSWORD "내_WiFi_비번"
#define SERVER_URL    "http://192.168.0.10:8000"   // 2단계에서 찾은 PC IP
```

> 📌 `config.h` 는 `.gitignore` 로 커밋에서 제외됩니다. 비밀번호가 git 에 올라가지 않습니다.

## 4단계. 업로드 & 확인

1. `examples/06-wifi-led-client` 폴더 열기 → **Upload**
2. **Serial Monitor** 를 열어 두고, PC 브라우저에서 `http://localhost:8000` 의 **켜기** 를 누릅니다.
3. 1초 안에 **ESP32 의 내장 LED 가 켜지고**, Serial 모니터에도 다음처럼 나오면 성공 🎉

```
WiFi 연결 중....
연결됨! ESP32 IP: 192.168.0.21
서버 상태: OFF  {"on":false,"by":"아직 아무도","time":"-"}
서버 상태: ON   {"on":true,"by":"철수","time":"14:03:21"}
```

4. 웹 페이지에서 **끄기** 를 누르면 1초 안에 LED 가 꺼집니다. 친구와 **두 브라우저 창**으로 서로 켜고 꺼 보세요 —
   모두 같은 ESP32 의 LED 를 제어합니다.

## 직접 해보기 (도전 과제)

1. **외부 LED**: GPIO2 대신 다른 핀에 저항+LED 를 달고 `LED_PIN` 을 바꿔 제어.
2. **요청 주기 바꾸기**: `delay(1000)` 을 200~2000 사이로 조절해 반응 속도 비교.
3. **ESP32 도 쓰기 클라이언트로**: 버튼(GPIO4, 실습 02)을 눌러 `PUT /api/led` 로 상태를 바꿔 보기.
   웹 페이지의 "누가 바꿨는지" 에 `ESP32` 가 뜨게. (힌트: `http.addHeader("Content-Type","application/json")`,
   `http.PUT("{\"on\":true,\"by\":\"ESP32\"}")`)

## 막히면? (가장 흔한 순서)

| 증상 | 확인 |
|------|------|
| `WiFi 연결 중....` 에서 멈춤 | SSID/비번 오타, **5GHz** 가 아닌지 → 핫스팟으로 |
| 상태코드 음수/실패 | 서버를 `--host 0.0.0.0` 으로 띄웠는지, `SERVER_URL` IP·포트 정확한지, **방화벽** |
| 브라우저는 되는데 ESP32 만 실패 | PC 방화벽이 8000 포트 인바운드 차단 → 허용 |
| LED 가 안 켜짐 | 웹에서 **켜기** 를 눌렀는지, `LED_PIN`(2)이 보드 내장 LED 맞는지 |
| `config.h` 없음 컴파일 에러 | 3단계 복사 안 함 |

## 🎓 마무리

축하합니다! ESP32 의 핵심 한 바퀴 — **GPIO 입출력 · PWM · 아날로그 · Serial · WiFi 통신** — 을 모두 직접 해봤습니다.
특히 마지막엔 **웹 페이지로 켠 LED 를 실제 보드가 따라 켜는** 걸 만들어, 웹과 하드웨어가 같은 서버로 이어진다는 걸
눈으로 확인했습니다.
