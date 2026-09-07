# 실습 01. LED 깜빡이기 (디지털 출력)

> 🎯 목표: ESP32에 코드를 올려 **내장 LED를 1초 간격으로 깜빡인다.** 개발 환경이 제대로
> 동작하는지 확인하는 첫 실습.
>
> 📎 관련 문서: [docs/03-digital-output.md](../docs/03-digital-output.md) · 코드: `examples/01-digital-output/`

## 준비물

- ESP32 DevKit 보드 + 데이터 USB 케이블 (부품 없이 **내장 LED**만으로 가능)
- (선택) 외부 LED + 220Ω 저항 + 브레드보드

## 1. 프로젝트 열기

VS Code에서 **`examples/01-digital-output`** 폴더를 엽니다. (`File → Open Folder...`)

> PlatformIO는 폴더 안의 `platformio.ini` 를 보고 자동으로 프로젝트를 인식합니다.

## 2. 코드 살펴보기

`src/main.cpp` 의 핵심은 세 부분입니다.

```cpp
const int LED_PIN = 2;            // 내장 LED는 GPIO2

void setup() {
  pinMode(LED_PIN, OUTPUT);       // 이 핀을 '출력'으로
}

void loop() {
  digitalWrite(LED_PIN, HIGH);    // 켜고
  delay(1000);                    // 1초 기다리고
  digitalWrite(LED_PIN, LOW);     // 끄고
  delay(1000);                    // 1초 기다리고 (반복)
}
```

## 3. 업로드

1. ESP32를 USB로 연결
2. VS Code 하단 파란 바의 **➡️ Upload** 클릭 (또는 `Ctrl+Alt+U`)
3. `SUCCESS` 가 뜨면 완료. 보드의 파란/빨간 내장 LED가 **1초마다 깜빡**입니다. 🎉

## 4. Serial로 확인

**🔌 Serial Monitor** (`Ctrl+Alt+M`) 를 열면 `LED ON` / `LED OFF` 가 1초마다 번갈아 찍힙니다.

## 직접 해보기 (도전 과제)

1. **깜빡임 속도 바꾸기**: `delay(1000)` 을 `delay(200)` 으로 → 더 빠르게.
2. **비대칭 깜빡임**: 켜진 시간은 짧고(100ms) 꺼진 시간은 길게(900ms) → 심장박동처럼.
3. **외부 LED 달기**: GPIO5에 `220Ω 저항 + LED + GND` 를 연결하고 `LED_PIN = 5` 로 변경.
   (LED 긴 다리가 +쪽)

## 막히면?

| 증상 | 해결 |
|------|------|
| 업로드 실패 / 포트 못 찾음 | [docs/02 트러블슈팅](../docs/02-development-environment.md) — 케이블·드라이버·권한 |
| 업로드는 됐는데 안 깜빡임 | EN(리셋) 버튼 한번 누르기. 보드에 따라 내장 LED가 없거나 다른 핀일 수 있음 |
| Serial 글자 깨짐 | 속도 115200 확인 |

➡️ 다음: [실습 02. 버튼으로 LED 제어](02-button-led-control.md)
