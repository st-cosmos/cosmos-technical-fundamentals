# 03. ESP32 프로그래밍

동아리 신입 부원을 위한 **ESP32 입문 자료**입니다. **마이크로컨트롤러가 처음인 사람**도 따라올 수 있도록, ESP32 가
무엇인지부터 개발 환경 확인, 그리고 **디지털 출력 · 디지털 입력 · PWM 출력 · 아날로그 입력 · Serial 통신** 다섯 가지
기본기를 하나씩 직접 손으로 해 봅니다.

> 🎯 이 자료를 끝내면: ESP32 에 코드를 올려 LED 를 켜고 밝기를 조절하고, 버튼·가변저항 값을 읽고, Serial 로 PC 와
> 대화할 수 있습니다. (선택 심화) WiFi 로 웹서버의 LED 상태를 읽어 실제 보드가 따라 켜지게 만듭니다.

## 누구를 위한 자료인가

- **대상**: 임베디드/하드웨어가 처음인 동아리 부원
- **선수**: [00](../00-dev-environment-setup/README.md) (VS Code + PlatformIO 설치), [01-cli](../01-cli/README.md).
  C/C++ 기초 문법(변수, 함수, 조건문/반복문) 정도면 충분
- **보드**: **ESP32 DevKit (ESP32-WROOM-32, 클래식 모델)** 기준
- **IDE**: **VS Code + PlatformIO 확장** (이유는 [docs/02](docs/02-development-environment.md))

## 준비물

| 항목 | 설명 |
|------|------|
| ESP32 DevKit 보드 | ESP32-WROOM-32 기반 (내장 LED: GPIO2) |
| USB 케이블 | **데이터 전송용** (충전 전용 케이블 ❌) |
| 브레드보드 + 점퍼선 | GPIO 실습용 |
| LED, 220Ω 저항 | 디지털 출력·PWM 실습 |
| 푸시 버튼(택트 스위치) | 디지털 입력 실습 |
| 가변저항(포텐셔미터, 10kΩ) | 아날로그 입력 실습 |
| (선택) 같은 WiFi 의 PC | WiFi 심화의 LED 서버 역할 |

> 💡 LED·버튼·가변저항이 없어도 **내장 LED 와 Serial 모니터만으로** 실습 1·5 는 가능합니다.

## 폴더 구조

```
03-esp32-programming/
├── docs/
│   ├── 01-esp32-introduction.md       ESP32란? (MCU + WiFi 내장)
│   ├── 02-development-environment.md  PlatformIO 확인 · 드라이버 · 새 프로젝트 · 빌드/업로드
│   ├── 03-digital-output.md           ① 디지털 출력 — LED 켜기
│   ├── 04-digital-input.md            ② 디지털 입력 — 버튼·풀업·엣지 감지
│   ├── 05-pwm-output.md               ③ PWM 출력 — 밝기 조절
│   ├── 06-analog-input.md             ④ 아날로그 입력 — 가변저항·ADC·map
│   ├── 07-serial-communication.md     ⑤ Serial 통신 — 디버깅과 명령 입력
│   └── 08-wifi-http-client.md         (선택) WiFi + HTTP — 웹서버 LED 따라 켜기
├── exercises/
│   ├── 01-blink-led.md
│   ├── 02-button-led-control.md
│   ├── 03-pwm-fade.md
│   ├── 04-analog-pot-brightness.md
│   ├── 05-serial-monitor-chat.md
│   └── 06-wifi-led-client.md          (선택)
├── examples/                          실습용 PlatformIO 프로젝트 (예제별 독립 폴더)
│   ├── 01-digital-output/             내장 LED 깜빡이기
│   ├── 02-digital-input/              버튼으로 LED 제어 + 횟수 세기
│   ├── 03-pwm-output/                 숨쉬는 LED (fade)
│   ├── 04-analog-input/               가변저항 → LED 밝기
│   ├── 05-serial/                     Serial 로 on/off 명령
│   └── 06-wifi-led-client/            (선택) WiFi 로 LED 서버 폴링
└── slides/
    └── esp32-basics.md
```

> 각 `exercises/0N` 은 같은 번호의 `examples/0N-*` 프로젝트와 짝을 이룹니다.

## 학습 순서

1. 📖 `docs/01` ESP32 가 뭔지 큰 그림
2. 🛠️ `docs/02` 개발 환경 확인 → **빈 프로젝트 빌드/업로드까지 성공**시키기 (여기가 첫 고비!)
3. 💡 `docs/03` + `exercises/01` — 디지털 출력 (LED)
4. 🔘 `docs/04` + `exercises/02` — 디지털 입력 (버튼)
5. 🌗 `docs/05` + `exercises/03` — PWM 출력 (밝기)
6. 🎚️ `docs/06` + `exercises/04` — 아날로그 입력 (가변저항 → 밝기)
7. 🖥️ `docs/07` + `exercises/05` — Serial 통신 ★ 필수 과정 마무리
8. 🌐 (선택) `docs/08` + `exercises/06` — WiFi 로 웹서버 LED 따라 켜기 (06 강좌 이후)

## 코드 실행 방법 (요약)

각 `examples/0N-*` 폴더는 **독립적인 PlatformIO 프로젝트**입니다. VS Code 에서 해당 폴더를 열거나(`File → Open Folder`),
터미널에서 폴더로 이동한 뒤:

```bash
pio run                 # 빌드(컴파일)만
pio run --target upload # 빌드 + 보드에 업로드
pio device monitor      # Serial 모니터 열기 (속도 115200)
```

> ⚠️ **이 저장소 최상위를 VS Code 로 열면 PlatformIO 가 프로젝트를 인식하지 못합니다.** 반드시 `examples/0N-*`
> **개별 폴더**를 여세요. (`platformio.ini` 가 있는 폴더가 하나의 프로젝트)

## 슬라이드

저장소 최상위에서 `npm run pdf -- 03-esp32`
