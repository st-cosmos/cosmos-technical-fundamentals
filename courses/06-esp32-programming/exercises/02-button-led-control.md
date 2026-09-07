# 실습 02. 버튼으로 LED 제어 (디지털 입력)

> 🎯 목표: **버튼을 눌러 LED를 켜고**, 누른 **횟수를 Serial로 센다.** 디지털 입력과
> 풀업(pull-up), 엣지 감지를 익힌다.
>
> 📎 관련 문서: [docs/04-digital-input.md](../docs/04-digital-input.md) · 코드: `examples/02-digital-input/`

## 준비물

- ESP32 DevKit + USB 케이블
- 푸시 버튼(택트 스위치)
- 점퍼선 2개, 브레드보드

## 1. 회로 연결

버튼 한쪽 다리를 **GPIO4**, 다른 쪽 다리를 **GND** 에 연결합니다.

```
GPIO4 ──[ 버튼 ]── GND
```

> 💡 별도 저항이 필요 없습니다. 코드에서 **내부 풀업**(`INPUT_PULLUP`)을 켜기 때문입니다.
> 그래서 버튼을 안 누르면 HIGH, 누르면 LOW가 읽힙니다.

## 2. 코드 핵심

`examples/02-digital-input/src/main.cpp` 의 두 동작:

```cpp
pinMode(BUTTON_PIN, INPUT_PULLUP);   // 평소 HIGH, 누르면 LOW

// (1) 누르고 있는 동안 LED 켜기
digitalWrite(LED_PIN, button == LOW ? HIGH : LOW);

// (2) HIGH→LOW 로 바뀐 '눌린 순간'만 횟수 세기
if (lastButton == HIGH && button == LOW) {
  pressCount++;
  Serial.printf("버튼 눌림! 누적 %d 회\n", pressCount);
  delay(50);   // 떨림(채터링) 무시
}
lastButton = button;
```

## 3. 업로드 & 확인

1. **Upload** (`Ctrl+Alt+U`)
2. **Serial Monitor** (`Ctrl+Alt+M`) 열기
3. 버튼을 누르면:
   - 누르는 동안 **내장 LED가 켜짐**
   - 누를 때마다 Serial에 `버튼 눌림! 누적 N 회`

## 왜 "엣지 감지"를 할까?

`loop()` 는 1초에 수만 번 돕니다. 버튼을 0.3초만 눌러도 그동안 `button == LOW` 가 수천 번
참이 됩니다. **"눌린 순간"(HIGH→LOW)만** 잡아야 한 번 누른 걸 한 번으로 셀 수 있습니다.

## 직접 해보기 (도전 과제)

1. **토글 버튼 만들기**: 누를 때마다 LED가 켜졌다↔꺼졌다 바뀌도록. (힌트: 눌린 순간에
   `ledState = !ledState;` 후 `digitalWrite(LED_PIN, ledState)`)
2. **디바운스 값 실험**: `delay(50)` 을 `0` 으로 바꿔 보고, 한 번 눌렀는데 여러 번 세지는지
   관찰. 다시 50으로 복구.
3. **외부 LED**로 분리해서 버튼-LED를 따로 배선해 보기.

## 막히면?

| 증상 | 해결 |
|------|------|
| 버튼 안 눌렀는데 값이 제멋대로 | 배선 확인. `INPUT_PULLUP` 으로 설정했는지 확인 |
| 한 번 눌렀는데 여러 번 카운트 | 디바운스(`delay(50)`)·엣지 감지 코드 확인 |
| LED가 거꾸로 동작 | 풀업이라 **누르면 LOW**임을 기억 (로직 반대) |

➡️ 다음: [실습 03. PWM 으로 LED 밝기 조절](03-pwm-fade.md)
