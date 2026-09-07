# 02. 개발 환경 — VS Code + PlatformIO

## 한 줄 요약

> ESP32 코드는 **VS Code**에 **PlatformIO 확장**을 깔아서 작성·업로드합니다. 운영체제(Windows
> /macOS/Linux)가 달라도 과정은 거의 같고, **차이는 USB 드라이버와 포트 이름 정도**입니다.

## 왜 Arduino IDE가 아니라 VS Code + PlatformIO 인가?

ESP32는 **아두이노 프레임워크**로 프로그래밍합니다. 같은 코드를 올리는 도구(IDE)는 여러
가지가 있는데, 우리는 **VS Code + PlatformIO**를 씁니다. 이유는:

- **공식 Arduino용 VS Code 확장(`vscode-arduino`)은 개발이 중단(archived)되었습니다.** 그래서
  "VS Code에서 아두이노/ESP32 개발"의 사실상 표준은 현재 **PlatformIO**입니다.
- PlatformIO는 컴파일러·보드 정의·라이브러리를 **자동으로 관리**해 줍니다. 보드만 골라
  적으면 필요한 것을 알아서 내려받습니다.
- 자동완성·에러 표시·디버깅 등 **코드 에디터의 편의 기능**을 그대로 누릴 수 있어, 코드가
  길어질수록 유리합니다.

> 💡 **참고**: Espressif가 만드는 공식 Arduino-ESP32 "코어"는 버전 2.x / 3.x 가 있습니다.
> 우리가 쓰는 **클래식 ESP32 DevKit**과 기본 예제들은 PlatformIO 공식 플랫폼
> (`platform = espressif32`)으로 충분합니다. (최신 칩 ESP32-S3/C3/C6 등에서 Core 3.x가
> 필요하면 커뮤니티 포크 `pioarduino`를 쓰지만, 이 자료 범위에서는 필요 없습니다.)

## 0. 설치 순서 한눈에

```
1) VS Code 설치                        ← 00 강좌에서 완료
2) VS Code에 PlatformIO IDE 확장 설치   ← 00 강좌에서 완료 (Python 등은 자동으로 따라옴)
3) (필요 시) USB-UART 드라이버 설치       ← OS·보드별로 다름
4) 새 프로젝트 생성 (보드: esp32dev)
5) 빌드 → 업로드 → Serial 모니터로 동작 확인
```

## 1. VS Code 설치 — 이미 완료

[00-dev-environment-setup](../../00-dev-environment-setup/README.md) 에서 설치했습니다. 없다면 그 강좌의 스크립트를 실행하세요.

## 2. PlatformIO 확장 — 이미 완료, 확인만

00 강좌 스크립트가 **PlatformIO IDE** 확장을 함께 설치했습니다. VS Code 왼쪽에 외계인 모양 🛸 PlatformIO
아이콘이 있으면 준비된 것입니다. 없으면:

1. VS Code 왼쪽 **확장(Extensions)** 아이콘 클릭 (`Ctrl+Shift+X`)
2. 검색창에 **`PlatformIO IDE`** 입력 → 설치
3. 설치 후 **VS Code 재시작**.

> ⚠️ PlatformIO는 내부적으로 Python을 사용합니다. 설치 중 자동으로 처리되니, 처음 설치 시
> 수십 초~몇 분 정도 "PlatformIO Core 설치 중" 표시를 **기다려 주세요.**

> 📌 `PlatformIO IDE` 확장 하나면 됩니다. PlatformIO Core(CLI)가 그 안에 포함되어 있어
> **따로 설치할 필요가 없습니다.**

## 3. USB 드라이버 설치 (OS별 차이는 거의 여기뿐)

ESP32 보드의 USB-UART 칩이 **CP2102** 또는 **CH340** 인데, OS가 이 칩을 자동 인식하지 못하면
드라이버를 설치해야 합니다. (보드에 작게 적힌 칩 이름을 확인하세요.)

| OS | 해야 할 일 |
|----|-----------|
| **Windows** | 대개 자동 인식. 안 되면 칩에 맞는 드라이버 설치: **CP210x VCP Driver**(Silicon Labs) 또는 **CH340 driver**(WCH). 설치 후 장치관리자에서 `COMx` 포트 확인. |
| **macOS** | 최신 macOS는 보통 자동 인식. 안 되면 같은 CP210x/CH340 드라이버 설치 후 재부팅. 포트 이름은 `/dev/cu.usbserial-XXXX` 또는 `/dev/cu.SLAB_USBtoUART`. |
| **Linux** | 드라이버는 커널에 보통 내장. 다만 **포트 접근 권한**이 필요: 사용자를 `dialout` 그룹에 추가 → `sudo usermod -aG dialout $USER` 후 **재로그인**. 포트는 `/dev/ttyUSB0`(CP2102/CH340) 또는 `/dev/ttyACM0`. |

> 💡 **포트 이름 차이 요약**
> - Windows: `COM3`, `COM5` …
> - macOS: `/dev/cu.usbserial-...`
> - Linux: `/dev/ttyUSB0`, `/dev/ttyACM0`
>
> PlatformIO는 보통 포트를 **자동 감지**하므로, 잘 되면 직접 적을 일은 없습니다.

> ⚠️ **케이블 함정**: USB 케이블이 **충전 전용**이면 데이터가 통하지 않아 보드가 아예 안
> 잡힙니다. 데이터 전송이 되는 케이블을 쓰세요.

## 4. 첫 프로젝트 만들기

PlatformIO에서 새 프로젝트를 만드는 방법입니다. (이 자료의 `examples/` 폴더에는 이미 만들어진
프로젝트가 있으니, **직접 만드는 연습**으로 한 번 해 보고 이후엔 `examples/` 를 열어 써도 됩니다.)

1. PlatformIO 아이콘 🛸 클릭 → **PIO Home** → **New Project**
2. 항목 입력:
   - **Name**: 예) `hello-esp32`
   - **Board**: `Espressif ESP32 Dev Module` 검색해서 선택 (내부 이름은 `esp32dev`)
   - **Framework**: `Arduino`
3. **Finish** → 잠시 기다리면(처음엔 툴체인 다운로드로 시간이 걸림) 프로젝트가 생성됩니다.

### 만들어지는 구조

```
hello-esp32/
├── platformio.ini   ← 프로젝트 설정 (보드/프레임워크/Serial 속도 등)
├── src/
│   └── main.cpp     ← 우리가 코드를 쓰는 곳
├── include/         ← 헤더(.h) 파일
└── lib/             ← 직접 만든 라이브러리
```

### platformio.ini 핵심

이 자료의 모든 예제는 아래 설정을 씁니다.

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
```

- `platform = espressif32` : ESP32용 빌드 도구 모음
- `board = esp32dev` : 우리가 쓰는 클래식 ESP32 DevKit
- `framework = arduino` : 아두이노 문법(`setup()`/`loop()`, `digitalWrite()` 등) 사용
- `monitor_speed = 115200` : **Serial 모니터 속도.** 코드의 `Serial.begin(115200)` 과 **반드시
  일치**해야 글자가 안 깨집니다. ([07](07-serial-communication.md) 참고)

## 5. 빌드 · 업로드 · 모니터 (VS Code 하단 파란 바)

VS Code 화면 **맨 아래 파란색 상태 바**에 PlatformIO 버튼들이 있습니다.

| 아이콘 | 이름 | 하는 일 | 단축키 |
|--------|------|---------|--------|
| ✔️ (체크) | Build | 코드를 **컴파일**만 (보드 없어도 됨) | `Ctrl+Alt+B` |
| ➡️ (화살표) | Upload | 컴파일 후 **보드에 업로드** | `Ctrl+Alt+U` |
| 🔌 (플러그) | Serial Monitor | Serial 출력 보기 | `Ctrl+Alt+M` |
| 🗑️ | Clean | 빌드 결과물 삭제 | |

터미널로도 같은 일을 할 수 있습니다 (프로젝트 폴더 안에서):

```bash
pio run                  # Build
pio run --target upload  # Upload
pio device monitor       # Serial Monitor (종료: Ctrl+C)
```

## 6. 첫 동작 확인용 코드

새 프로젝트의 `src/main.cpp` 를 아래로 바꾸고 **업로드 → Serial 모니터**를 열어 보세요.
1초마다 메시지가 찍히고 내장 LED가 깜빡이면 환경 설정이 완벽히 끝난 것입니다. 🎉

```cpp
#include <Arduino.h>

void setup() {
  Serial.begin(115200);
  pinMode(2, OUTPUT);   // GPIO2 = 내장 LED
}

void loop() {
  digitalWrite(2, HIGH);
  Serial.println("안녕 ESP32!");
  delay(1000);
  digitalWrite(2, LOW);
  delay(1000);
}
```

## 자주 막히는 문제 (트러블슈팅)

| 증상 | 원인 / 해결 |
|------|------------|
| 보드가 포트에 안 잡힘 | ① 충전 전용 케이블 → 데이터 케이블로 교체 ② USB 드라이버 미설치 (3장) ③ (Linux) `dialout` 권한 |
| 업로드 중 멈추거나 `Connecting...` 만 반복 | 업로드 시작될 때 보드의 **BOOT 버튼을 누르고 있기** → 진행되면 떼기 |
| Serial 모니터가 외계어 | `monitor_speed` 와 `Serial.begin()` **속도 불일치** (둘 다 115200으로) |
| 첫 빌드가 너무 느림 | 정상입니다. 툴체인을 처음 한 번 내려받느라 그렇고, 이후엔 빨라집니다 |
| 업로드는 됐는데 동작 안 함 | 보드의 **EN(리셋) 버튼**을 한번 눌러 재시작 |

## 다음 단계

환경 설정이 끝나고 LED가 깜빡였다면, 이제 핀을 직접 다뤄 봅니다.

➡️ [03. 디지털 출력 — LED 켜기](03-digital-output.md)
