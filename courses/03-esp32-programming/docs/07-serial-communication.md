# 07. Serial 통신

## 한 줄 요약

> **Serial 통신은 ESP32와 PC가 USB 선으로 글자를 주고받는 통로**입니다. `Serial.print()` 로
> 보드 상태를 PC 화면에 찍어 **디버깅**하고, `Serial.read()` 로 PC가 보낸 명령을 받습니다.

## 1. Serial 통신이란?

**Serial(직렬) 통신** = 데이터를 한 비트씩 한 줄로 주고받는 방식. ESP32와 PC는 USB 케이블
하나로 연결되어, 이 위에서 **UART**라는 시리얼 통신을 합니다.

ESP32에게 Serial은 두 가지로 아주 중요합니다.

1. **디버깅 창**: 화면이 없는 ESP32의 속마음을 들여다보는 거의 유일한 창구. "여기까지
   실행됐나?", "센서 값이 뭐지?" 를 `Serial.print()` 로 확인합니다.
2. **명령 입력**: PC에서 글자를 보내 보드를 제어할 수 있습니다.

> 💡 [03](03-digital-output.md)~[06](06-analog-input.md)의 예제에서 이미 `Serial`을 썼습니다.
> Serial은 모든 실습의 기본 도구입니다.

## 2. 시작하기 — `Serial.begin()`

```cpp
void setup() {
  Serial.begin(115200);   // 통신 속도(baud rate) 설정
}
```

- **baud rate(보레이트)** = 초당 주고받는 신호 수. **115200** 을 표준으로 씁니다.
- ⚠️ **반드시** `platformio.ini` 의 `monitor_speed` 와 **같은 값**이어야 합니다. 다르면 글자가
  깨져서(외계어) 나옵니다. ([02](02-development-environment.md) 참고)

## 3. 출력 — print 계열

```cpp
Serial.print("값: ");      // 줄바꿈 없이 출력
Serial.println(123);       // 출력 후 줄바꿈

int n = 42;
Serial.println(n);                       // 변수 출력
Serial.printf("x=%d, v=%.2f\n", n, 3.3); // C 스타일 서식 (ESP32 지원)
```

| 함수 | 차이 |
|------|------|
| `print()` | 그대로 출력, 줄바꿈 없음 |
| `println()` | 출력 후 **줄바꿈** |
| `printf()` | `%d`, `%.2f`, `%s` 같은 **서식** 사용 (ESP32에서 편리) |

### 예: 1초마다 가동 시간 출력

```cpp
#include <Arduino.h>

void setup() {
  Serial.begin(115200);
  Serial.println("부팅 완료!");
}

void loop() {
  Serial.printf("가동 시간: %lu 초\n", millis() / 1000);
  delay(1000);
}
```

- `millis()` = 보드가 켜진 뒤 흐른 시간(밀리초). 시간 측정·타이밍 제어의 핵심 함수입니다.

## 4. Serial 모니터 열기

업로드 후 출력을 보려면 모니터를 엽니다.

- VS Code 하단 파란 바의 **🔌 (플러그) 아이콘** 클릭, 또는 `Ctrl+Alt+M`
- 터미널: `pio device monitor` (종료는 `Ctrl+C`)

> 모니터 속도가 코드와 다르면 우측 하단에서 baud를 115200으로 맞추세요. (보통 `monitor_speed`
> 설정으로 자동 적용됩니다.)

## 5. 입력 — PC에서 보드로 명령 보내기

Serial 모니터 입력창에 글자를 치면 ESP32가 받을 수 있습니다.

```cpp
#include <Arduino.h>

const int LED_PIN = 2;

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  Serial.println("명령 입력: on / off");
}

void loop() {
  if (Serial.available() > 0) {                 // 받은 글자가 있으면
    String cmd = Serial.readStringUntil('\n');  // 한 줄 읽기
    cmd.trim();                                  // 앞뒤 공백/줄바꿈 제거

    if (cmd == "on") {
      digitalWrite(LED_PIN, HIGH);
      Serial.println("LED 켜짐");
    } else if (cmd == "off") {
      digitalWrite(LED_PIN, LOW);
      Serial.println("LED 꺼짐");
    } else {
      Serial.println("알 수 없는 명령: " + cmd);
    }
  }
}
```

(이 예제가 실습 `exercises/05` · 코드 `examples/05-serial` 입니다.)

| 함수 | 하는 일 |
|------|---------|
| `Serial.available()` | 받은(버퍼에 쌓인) 글자 수. 0보다 크면 읽을 게 있음 |
| `Serial.read()` | 한 글자(byte) 읽기 |
| `Serial.readStringUntil('\n')` | 줄바꿈 전까지 한 줄 통째로 읽기 |
| `String.trim()` | 문자열 앞뒤 공백·줄바꿈 제거 |

> 💡 모니터 입력창 옆에서 **줄 끝(line ending)** 을 "**LF(`\n`)**" 또는 "**Newline**" 으로
> 설정해야 `readStringUntil('\n')` 가 제대로 동작합니다.

## 6. 디버깅에 Serial 잘 쓰기

코드가 의도대로 안 움직일 때, 의심되는 지점마다 `Serial.println` 으로 **"흔적"** 을 남기세요.

```cpp
Serial.println("setup 진입");
WiFi.begin(ssid, pw);
Serial.println("WiFi.begin 호출함");   // 여기까지 찍히나?
...
Serial.printf("WiFi 상태 코드: %d\n", WiFi.status());  // 값이 뭐지?
```

화면 없는 보드에서 **무슨 일이 일어나는지 보는 가장 빠른 방법**입니다. 다음 장의 WiFi
실습에서 연결이 안 될 때도 이 방법으로 원인을 찾습니다.

## 정리 — 여기까지가 필수 과정

**디지털 출력 · 디지털 입력 · PWM 출력 · 아날로그 입력 · Serial 통신** — ESP32 의 기본 다섯 가지를 모두
다뤘습니다. 🎉 실습 [`exercises/05`](../exercises/05-serial-monitor-chat.md) 로 마무리하세요.

## 다음 단계 (선택)

ESP32 의 진짜 강점 **WiFi 로 서버와 통신하기**는 선택 심화입니다. 06-web-server-python 강좌를 마친 뒤 돌아와도 됩니다.

➡️ [08. (선택) WiFi + HTTP — 웹서버의 LED 를 따라 켜기](08-wifi-http-client.md)
