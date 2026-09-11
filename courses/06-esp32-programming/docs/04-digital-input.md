# 04. 디지털 입력 — 버튼 읽기

## 한 줄 요약

> **핀에 들어온 전압이 HIGH 인지 LOW 인지 읽는 것**이 디지털 입력입니다. `digitalRead(핀)` 으로 읽고,
> 버튼은 **내부 풀업(`INPUT_PULLUP`)** 으로 연결해 "안 누름=HIGH, 누름=LOW" 로 만듭니다.
> "누르고 있는 동안"과 "눌린 순간(엣지)"을 구별하는 것이 핵심.

## 1. 입력 2개 함수

```cpp
pinMode(핀번호, INPUT);          // 입력으로 (외부 저항 있을 때)
pinMode(핀번호, INPUT_PULLUP);   // 입력 + 내부 풀업 저항 켜기 ← 버튼엔 이걸
int v = digitalRead(핀번호);     // HIGH(1) 또는 LOW(0)
```

## 2. 플로팅 문제와 "풀업"

버튼을 읽을 때 흔히 겪는 문제가 **플로팅(floating)** 입니다. 버튼이 안 눌린 동안 핀이 **아무 데도 연결되지 않으면**,
전압이 붕 떠서 HIGH 도 LOW 도 아닌 **제멋대로 값**이 읽힙니다. (손을 가까이 대기만 해도 값이 바뀜)

해결책은 **풀업/풀다운 저항**으로 "평소 상태"를 고정하는 것입니다. ESP32 는 **내부 풀업 저항**을 내장하고 있어서
코드 한 줄로 켤 수 있습니다.

```cpp
pinMode(BUTTON_PIN, INPUT_PULLUP);
```

이렇게 하면:

| 버튼 상태 | 읽히는 값 | 이유 |
|-----------|-----------|------|
| **안 누름** | `HIGH` | 내부 풀업이 핀을 3.3V 로 끌어올림 |
| **누름** | `LOW` | 버튼이 핀을 GND(0V) 에 연결 |

> 💡 `INPUT_PULLUP` 을 쓰면 로직이 **거꾸로**입니다. **눌렀을 때 `LOW`** 가 됩니다. 이 강좌에서 가장 많이
> 헷갈리는 부분이니 기억하세요!

### 버튼 배선

```
GPIO22 ──┐
         [버튼]
GND ─────┘
```

별도 저항 없이 한쪽은 GPIO, 다른 쪽은 GND 에 연결하면 됩니다. (내부 풀업이 저항 역할)

## 3. 예제 ① — 누르는 동안 LED 켜기

```cpp
#include <Arduino.h>

const int LED_PIN = 23;     // LED: GPIO23 ──[220Ω]──▶|── GND
const int BUTTON_PIN = 22;  // 버튼: GPIO22 ── GND

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);  // 평소 HIGH, 누르면 LOW
}

void loop() {
  if (digitalRead(BUTTON_PIN) == LOW) {   // 풀업이라 눌리면 LOW
    digitalWrite(LED_PIN, HIGH);
  } else {
    digitalWrite(LED_PIN, LOW);
  }
}
```

한 줄로 줄이면: `digitalWrite(LED_PIN, digitalRead(BUTTON_PIN) == LOW ? HIGH : LOW);`

## 4. "누르고 있는 동안" vs "눌린 순간" — 엣지 감지

`loop()` 는 1초에 **수만 번** 돕니다. 버튼을 0.3초만 눌러도 그동안 `digitalRead() == LOW` 가 **수천 번** 참이 됩니다.
그래서 "누른 횟수를 세라", "누를 때마다 토글하라" 같은 동작은 **"눌린 그 순간"(엣지)** 만 잡아야 합니다.

방법: **직전 값과 비교**해서 **HIGH → LOW 로 바뀐 순간**만 인식합니다.

```cpp
int lastButton = HIGH;      // 직전 상태 (풀업이라 평소 HIGH)

void loop() {
  int button = digitalRead(BUTTON_PIN);

  if (lastButton == HIGH && button == LOW) {   // 막 눌린 순간 (하강 엣지)
    // 여기서 한 번만 동작
  }

  lastButton = button;      // 다음 비교를 위해 저장
}
```

```
신호:  HIGH ─────┐         ┌───── HIGH
                 └─── LOW ─┘
                 ▲ 여기 한 번만 잡는다 (HIGH→LOW)
```

## 5. 채터링(바운스)과 디바운스

버튼은 누르는 순간 기계적으로 미세하게 떨려서, 한 번 눌러도 HIGH/LOW 가 **여러 번 빠르게** 바뀝니다(채터링).
그대로 두면 한 번 눌렀는데 3~4번으로 세어집니다. 가장 간단한 해결은 **눌린 순간 잠깐(50ms) 기다리기**입니다.

```cpp
if (lastButton == HIGH && button == LOW) {
  pressCount++;
  delay(50);   // 떨림이 가라앉을 때까지 무시 (간단 디바운스)
}
```

> 💡 `delay()` 없이 `millis()` 로 시간을 재는 더 나은 디바운스는 [07](07-serial-communication.md) 의 타이밍 기법을 익힌 뒤 도전해 보세요.

## 6. 예제 ② — 누른 횟수 세기 (코드: `examples/02-digital-input/`)

```cpp
#include <Arduino.h>

const int LED_PIN = 23;     // LED: GPIO23 ──[220Ω]──▶|── GND
const int BUTTON_PIN = 22;  // 버튼: GPIO22 ── GND

int lastButton = HIGH;
int pressCount = 0;

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  Serial.println("버튼을 눌러 보세요");
}

void loop() {
  int button = digitalRead(BUTTON_PIN);

  // (1) 누르고 있는 동안 LED 켜기
  digitalWrite(LED_PIN, button == LOW ? HIGH : LOW);

  // (2) 눌린 순간만 카운트 (엣지 감지 + 디바운스)
  if (lastButton == HIGH && button == LOW) {
    pressCount++;
    Serial.printf("버튼 눌림! 누적 %d 회\n", pressCount);
    delay(50);
  }
  lastButton = button;
}
```

### 응용 — 토글 스위치

눌린 순간에 상태를 뒤집으면 "누를 때마다 켜짐↔꺼짐" 이 됩니다.

```cpp
bool ledOn = false;
...
if (lastButton == HIGH && button == LOW) {
  ledOn = !ledOn;                         // 뒤집기
  digitalWrite(LED_PIN, ledOn ? HIGH : LOW);
  delay(50);
}
```

## 정리

| 개념 | 핵심 |
|------|------|
| `INPUT_PULLUP` | 평소 HIGH, **누르면 LOW** (로직 반대) |
| 배선 | `GPIO ─[버튼]─ GND`, 저항 불필요 |
| 엣지 감지 | 직전 값과 비교해 HIGH→LOW **순간**만 |
| 디바운스 | 눌린 뒤 `delay(50)` 으로 떨림 무시 |

## 다음 단계

켜짐/꺼짐 두 값만 다뤘다면, 이제 **밝기처럼 중간값**을 내보내는 PWM 으로 넘어갑니다.

➡️ [05. PWM 출력 — LED 밝기 조절](05-pwm-output.md)

> 🧪 실습: [`exercises/02-button-led-control.md`](../exercises/02-button-led-control.md)
