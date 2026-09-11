# 실습 03. PWM 으로 LED 밝기 조절 (숨쉬는 LED)

> 🎯 목표: `analogWrite()` 로 LED 밝기를 **0→255→0** 으로 부드럽게 바꿔 숨 쉬듯 깜빡이게 한다.
> PWM 이 "빠른 켜짐/꺼짐의 평균" 임을 눈으로 확인한다.
>
> 📎 관련 문서: [docs/05-pwm-output.md](../docs/05-pwm-output.md) · 코드: `examples/03-pwm-output/`

## 준비물

- ESP32 DevKit + USB 케이블
- LED + 220Ω 저항, 브레드보드, 점퍼선 (없으면 내장 LED GPIO2 로 — 코드의 `LED_PIN` 을 2 로)

## 1. 회로 연결

```
GPIO23 ──[220Ω]──▶|── GND   (LED 긴 다리가 저항 쪽)
```

## 2. 코드 핵심

`examples/03-pwm-output/src/main.cpp`:

```cpp
for (int duty = 0; duty <= 255; duty++) {   // 점점 밝게
  analogWrite(LED_PIN, duty);
  delay(5);
}
for (int duty = 255; duty >= 0; duty--) {   // 점점 어둡게
  analogWrite(LED_PIN, duty);
  delay(5);
}
```

`analogWrite(핀, 0~255)` — 0 은 꺼짐, 255 는 최대, 128 은 절반 밝기.

## 3. 업로드 & 확인

1. `examples/03-pwm-output` 폴더 열기 → **Upload**
2. LED 가 **부드럽게** 밝아지고 어두워지면 성공 🎉 (약 1.3초 주기)
3. Serial Monitor 에 `최대 밝기` / `꺼짐` 이 번갈아 찍힘

## 4. PWM 을 "보는" 실험

`for` 문을 지우고 `loop()` 에 아래만 남겨 보세요.

```cpp
analogWrite(LED_PIN, 30);   // 아주 어둡게 고정
```

LED 를 눈앞에서 **빠르게 좌우로 흔들면** 점선처럼 끊어져 보입니다 — 실제로는 빠르게 켜지고 꺼지고 있다는 증거입니다.
(`digitalWrite(LED_PIN, HIGH)` 로 바꾸면 흔들어도 연속선으로 보임)

## 직접 해보기 (도전 과제)

1. **속도 바꾸기**: `STEP_DELAY_MS` 를 1 과 20 으로 바꿔 숨쉬는 속도 비교.
2. **최소 밝기 유지**: 0 까지 꺼지지 않고 30~255 사이에서만 오르내리게.
3. **버튼으로 밝기 단계**: [실습 02](02-button-led-control.md) 의 버튼을 붙여, 누를 때마다 밝기가 0 → 64 → 128 → 255 → 0 으로 바뀌게.
   (힌트: 엣지 감지 + `duty = (duty + 64) % 320` 같은 식, 또는 배열)
4. **두 LED 교차**: 하나가 밝아질 때 다른 하나는 어두워지게 (`analogWrite(LED2, 255 - duty)`).

## 막히면?

| 증상 | 해결 |
|------|------|
| LED 가 켜지기만 하고 밝기가 안 변함 | `analogWrite` 대신 `digitalWrite` 를 쓰지 않았는지, 핀 번호 확인 |
| 아주 희미하게만 켜짐 | 저항이 너무 크거나(220Ω 확인) LED 방향 반대 |
| 깜빡임이 눈에 보임 | 정상 아님 — `delay` 가 for 문 밖에 있는지 확인 |

➡️ 다음: [실습 04. 가변저항으로 LED 밝기 조절](04-analog-pot-brightness.md)
