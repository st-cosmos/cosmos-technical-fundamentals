# 03. 디지털 출력 — LED 켜기

## 한 줄 요약

> **GPIO 핀으로 켜짐(HIGH=3.3V)/꺼짐(LOW=0V) 두 값을 내보내는 것**이 디지털 출력입니다.
> `pinMode(핀, OUTPUT)` 으로 역할을 정하고 `digitalWrite(핀, HIGH/LOW)` 로 내보냅니다. 첫 실습은 내장 LED 깜빡이기.

## 1. GPIO 와 "디지털"의 의미

**GPIO (General Purpose Input/Output)** = 범용 입출력 핀. ESP32 핀은 두 가지로 쓸 수 있습니다.

- **출력(Output)**: 핀에서 전압을 내보내 LED·부저 등을 제어 ← **이 문서**
- **입력(Input)**: 핀에 들어오는 전압을 읽어 버튼·센서 상태를 파악 ← [04. 디지털 입력](04-digital-input.md)

**디지털**은 값이 딱 두 개라는 뜻입니다.

| 디지털 값 | 의미 | ESP32 전압 |
|-----------|------|------------|
| `HIGH` (1) | 켜짐 / 참 | 3.3V |
| `LOW` (0) | 꺼짐 / 거짓 | 0V (GND) |

> ⚠️ ESP32는 **3.3V 로직**입니다. 핀에 **5V를 넣지 마세요.** 5V 부품을 연결할 땐 전압 분배(저항)나
> 레벨 시프터가 필요합니다.

## 2. 아두이노 프로그램의 뼈대

모든 아두이노 프로그램은 두 함수로 이뤄집니다.

```cpp
#include <Arduino.h>

void setup() {
  // 처음 한 번 실행: 핀 모드 설정, Serial 시작 등
}

void loop() {
  // 계속 반복 실행: 읽고 → 판단하고 → 출력
}
```

- `setup()` 은 전원이 들어올 때 **한 번**, `loop()` 는 그 뒤 **끝없이 반복**됩니다.
- 화면도 OS 도 없으니 프로그램은 "켜지면 영원히 도는 반복문" 입니다.

## 3. 출력 2개 함수

```cpp
pinMode(핀번호, OUTPUT);        // 이 핀을 '출력'으로 쓰겠다 (setup 에서 한 번)
digitalWrite(핀번호, HIGH);     // 3.3V 내보내기 (켜기)
digitalWrite(핀번호, LOW);      // 0V (끄기)
```

## 4. 예제 — 내장 LED 깜빡이기 (Blink)

가장 유명한 첫 프로그램. 보드 내장 LED(**GPIO2**)를 1초 간격으로 깜빡입니다.
(코드: `examples/01-digital-output/` · 실습: `exercises/01`)

```cpp
#include <Arduino.h>

const int LED_PIN = 2;   // GPIO2 = 보드 내장 LED

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);     // 출력으로 설정
  Serial.println("blink 시작!");
}

void loop() {
  digitalWrite(LED_PIN, HIGH);  // 켜기
  Serial.println("LED ON");
  delay(1000);                  // 1000ms = 1초 대기

  digitalWrite(LED_PIN, LOW);   // 끄기
  Serial.println("LED OFF");
  delay(1000);
}
```

| 요소 | 의미 |
|------|------|
| `const int LED_PIN = 2;` | 핀 번호에 **이름**을 붙여 둠. 나중에 핀을 바꿀 때 한 곳만 수정 |
| `delay(1000)` | 1000 밀리초(1초) 동안 **아무것도 안 하고 멈춤** |
| `Serial.println(...)` | PC 화면(Serial 모니터)에 글자 출력 — [07](07-serial-communication.md) 에서 자세히 |

> 💡 `delay()` 는 간단하지만 그동안 보드가 **아무 일도 못 합니다.** 버튼 입력을 동시에 받아야 하면 문제가 되는데,
> 그 해결(`millis()`)은 [07](07-serial-communication.md) 예제에서 봅니다.

## 5. 외부 LED 연결 (브레드보드)

내장 LED 말고 직접 LED를 붙이려면 **저항을 꼭 함께** 넣습니다. 저항이 없으면 과전류로 LED나 핀이 손상될 수 있습니다.

```
GPIO 핀 ──[ 220Ω 저항 ]──▶|── GND
                          LED
                       (긴 다리 +, 짧은 다리 -)
```

> 📌 LED는 방향이 있습니다. **긴 다리(+, 애노드)** 가 저항을 거쳐 GPIO 쪽, **짧은 다리(-, 캐소드)** 가 GND 쪽입니다.
> 거꾸로 꽂으면 안 켜지지만 망가지지는 않으니 뒤집어 다시 꽂으면 됩니다.

여러 개를 달아 순서대로 켜는 것도 같은 원리입니다.

```cpp
const int PINS[] = {2, 4, 5};              // LED 3개

void setup() {
  for (int i = 0; i < 3; i++) pinMode(PINS[i], OUTPUT);
}

void loop() {
  for (int i = 0; i < 3; i++) {            // 하나씩 차례로
    digitalWrite(PINS[i], HIGH);
    delay(200);
    digitalWrite(PINS[i], LOW);
  }
}
```

## 6. 핀 고를 때 주의 (클래식 ESP32)

ESP32 핀은 대부분 자유롭게 쓸 수 있지만, 몇 가지 예외가 있습니다.

| 핀 | 주의 |
|----|------|
| GPIO34~39 | **입력 전용** (출력 불가, 내부 풀업도 없음) |
| GPIO6~11 | 내장 플래시에 연결됨 — **사용 금지** |
| GPIO0, 2, 15 | 부팅(BOOT) 모드에 관여 — 일반 입출력은 가능하나 부팅 시 상태 주의 |
| GPIO2 | 보드 내장 LED |

> 💡 **무난한 선택**: 출력엔 GPIO2(내장 LED)·GPIO4·GPIO5, 입력엔 GPIO4 등을 쓰면 입문 단계에서 탈 없이 동작합니다.

## 정리

| 함수 | 하는 일 |
|------|---------|
| `pinMode(핀, OUTPUT)` | 핀을 출력으로 |
| `digitalWrite(핀, HIGH/LOW)` | 3.3V / 0V 내보내기 |
| `delay(ms)` | ms 밀리초 멈춤 |

## 다음 단계

내보내는 법을 익혔으니, 이제 반대로 **버튼 상태를 읽어** 옵니다.

➡️ [04. 디지털 입력 — 버튼 읽기](04-digital-input.md)

> 🧪 실습: [`exercises/01-blink-led.md`](../exercises/01-blink-led.md)
