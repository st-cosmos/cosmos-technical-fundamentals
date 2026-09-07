# 06. 아날로그 입력 — 가변저항 읽기

## 한 줄 요약

> **아날로그 입력**은 `analogRead(핀)` 으로 0~3.3V 전압을 **0~4095 숫자**로 읽는 것(ADC). 가변저항·조도센서·온도센서
> 같은 "연속적인 값"을 읽을 때 씁니다. 읽은 값을 `map()` 으로 변환해 [05](05-pwm-output.md)의 PWM 밝기에 연결하면
> **입력 → 출력**이 완성됩니다.

## 1. 디지털 vs 아날로그

- **디지털 입력**([04](04-digital-input.md)): 값이 HIGH/LOW **두 개뿐** (버튼)
- **아날로그 입력**: 0V 부터 3.3V 까지 **중간값이 연속적**으로 존재 (가변저항·센서)

가변저항을 돌리면 0~3.3V 가 **부드럽게** 변하는데, 이걸 읽는 게 아날로그 입력입니다.

## 2. ADC — `analogRead`

**ADC (Analog-to-Digital Converter)** = 아날로그 전압을 디지털 숫자로 바꾸는 변환기. ESP32 의 ADC 는 **12비트**라서
전압을 **0~4095** 범위 숫자로 돌려줍니다. (아두이노 우노는 10비트, 0~1023)

| 입력 전압 | `analogRead()` 결과 (대략) |
|-----------|---------------------------|
| 0V | 0 |
| 1.65V (절반) | 약 2048 |
| 3.3V | 약 4095 |

```cpp
#include <Arduino.h>

const int POT_PIN = 34;   // 입력 전용 핀(34~39)이 아날로그 입력에 적합

void setup() {
  Serial.begin(115200);
}

void loop() {
  int raw = analogRead(POT_PIN);          // 0 ~ 4095
  float volt = raw * 3.3 / 4095.0;        // 실제 전압(V)으로 환산
  Serial.printf("raw=%4d  volt=%.2fV\n", raw, volt);
  delay(200);
}
```

> 💡 `analogRead` 는 `pinMode` 가 필요 없습니다. 바로 읽으면 됩니다.

## 3. 가변저항(포텐셔미터) 배선

가변저항은 다리가 3개입니다. **양 끝**을 3.3V 와 GND 에, **가운데**를 입력 핀에 연결합니다.

```
3.3V ──┐
       [가변저항] 가운데 다리 ──▶ GPIO34 (읽기)
GND ───┘
```

손잡이를 돌리면 가운데 다리의 전압이 0~3.3V 사이에서 변합니다. (전압 분배)

> ⚠️ **핀 선택 주의**: 입력 전용 핀 **GPIO34~39 (ADC1)** 를 권장합니다. 다른 ADC 핀(ADC2)은 **WiFi 를 켜면 동작하지
> 않습니다.** 나중에 WiFi 와 함께 쓸 것을 생각해 처음부터 34~39 를 쓰는 습관을 들이세요.
>
> ⚠️ ESP32 ADC 는 양 끝(0V·3.3V 근처)에서 약간 부정확하고 값이 조금 흔들립니다. 정밀 측정이 목적이 아니면 입문
> 단계에선 신경 쓰지 않아도 됩니다. (흔들림이 거슬리면 여러 번 읽어 평균)

## 4. `map()` — 범위 변환

읽은 값(0~4095)을 다른 범위(예: PWM 의 0~255, 퍼센트 0~100)로 **비례 변환**하는 함수입니다.

```cpp
map(값, 입력min, 입력max, 출력min, 출력max)

int duty    = map(raw, 0, 4095, 0, 255);   // → PWM 밝기
int percent = map(raw, 0, 4095, 0, 100);   // → 퍼센트
```

> 💡 `map` 은 정수만 다룹니다. 소수가 필요하면 직접 계산: `raw * 3.3 / 4095.0`

## 5. 예제 — 가변저항으로 LED 밝기 조절 (코드: `examples/04-analog-input/`)

**아날로그 입력(ADC) → `map()` → PWM 출력** — 이 강좌의 입출력을 한 줄로 잇는 예제입니다.

```cpp
#include <Arduino.h>

const int POT_PIN = 34;   // 가변저항 가운데 다리 (입력 전용 핀, ADC1)
const int LED_PIN = 5;    // PWM 출력으로 밝기 조절할 LED

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  Serial.println("가변저항을 돌려 보세요");
}

void loop() {
  int raw = analogRead(POT_PIN);            // 0 ~ 4095 (12비트 ADC)
  float volt = raw * 3.3 / 4095.0;          // 실제 전압(V) 환산

  int duty = map(raw, 0, 4095, 0, 255);     // 0~4095 → 0~255 비례 변환
  analogWrite(LED_PIN, duty);               // PWM으로 LED 밝기 조절

  Serial.printf("raw=%4d  volt=%.2fV  duty=%3d\n", raw, volt, duty);
  delay(100);
}
```

배선: 가변저항(3.3V·GND·GPIO34) + LED(`GPIO5 ──[220Ω]──▶|── GND`)

> 📌 예제 코드에는 보너스로 `dacWrite(25, duty)` 한 줄이 더 있습니다. 멀티미터로 GPIO25 를 재면 진짜 전압이
> 변하는 것을 볼 수 있습니다. (클래식 ESP32 만 — 신형 보드는 그 줄을 지우세요)

## 6. 임계값 — 아날로그를 디지털 판단으로

센서 값이 "어느 수준을 넘으면" 동작하게 하려면 임계값과 비교합니다.

```cpp
if (raw > 2048) {          // 절반 이상 돌렸으면
  digitalWrite(LED_PIN, HIGH);
} else {
  digitalWrite(LED_PIN, LOW);
}
```

조도센서로 "어두워지면 불 켜기", 온도센서로 "뜨거우면 팬 돌리기" 가 모두 이 패턴입니다.

## 정리

| 구분 | 함수 | 값 범위 | 핀 |
|------|------|---------|----|
| 아날로그 입력 (ADC) | `analogRead()` | 0~4095 (12bit) | **GPIO34~39 권장** (WiFi 와 충돌 없음) |
| 범위 변환 | `map(v, 0, 4095, 0, 255)` | — | — |
| 전압 환산 | `raw * 3.3 / 4095.0` | 0~3.3V | — |

## 다음 단계

값을 읽고 내보내는 법을 모두 익혔습니다. 이제 그 값을 **PC 화면에서 보고, PC 에서 명령을 보내는** Serial 통신을
제대로 배웁니다. (사실 지금까지 예제가 계속 `Serial` 을 쓰고 있었죠!)

➡️ [07. Serial 통신](07-serial-communication.md)

> 🧪 실습: [`exercises/04-analog-pot-brightness.md`](../exercises/04-analog-pot-brightness.md)
