# 실습 05. Serial 모니터 대화 (Serial 통신)

> 🎯 목표: PC의 Serial 모니터에서 **명령(`on`/`off`)을 입력**해 LED를 제어하고, 보드는
> **가동 시간을 1초마다 출력**한다. 양방향 Serial 통신을 익힌다.
>
> 📎 관련 문서: [docs/07-serial-communication.md](../docs/07-serial-communication.md) · 코드: `examples/05-serial/`

## 준비물

- ESP32 DevKit + USB 케이블 (부품 불필요, **내장 LED** 사용)

## 1. 업로드 & 모니터 열기

1. `examples/05-serial` 폴더 열기 → **Upload**
2. **Serial Monitor** (`Ctrl+Alt+M`) 열기
3. `준비 완료. 명령을 입력하세요: on / off` 가 보이고, 1초마다 `가동 시간: N 초` 출력

## 2. 명령 보내기

Serial 모니터 **위쪽 입력창**에 글자를 치고 Enter:

- `on` 입력 → 내장 LED 켜짐, `-> LED 켜짐` 응답
- `off` 입력 → 내장 LED 꺼짐, `-> LED 꺼짐` 응답
- 아무거나 → `-> 알 수 없는 명령: ...`

> ⚠️ **줄 끝(line ending) 설정 주의**: 코드가 `readStringUntil('\n')` 로 한 줄을 읽습니다.
> 모니터의 줄 끝 설정이 **"LF"** 또는 **"Newline"** 이어야 명령이 제대로 인식됩니다.
> (PlatformIO 모니터는 입력 후 Enter를 누르면 됩니다.)

## 3. 코드에서 배울 점

```cpp
if (Serial.available() > 0) {                  // 받은 글자가 있나?
  String cmd = Serial.readStringUntil('\n');   // 한 줄 읽기
  cmd.trim();                                  // 공백/줄바꿈 제거 (중요!)
  if (cmd == "on") { ... }
}
```

- `trim()` 을 빼면 `"on\r"` 처럼 보이지 않는 문자가 붙어 비교가 실패할 수 있습니다.
- 출력 타이밍은 `delay()` 대신 **`millis()`** 로 재서, 입력 처리를 막지 않습니다.

## 직접 해보기 (도전 과제)

1. **밝기 명령**: `dim 128` 처럼 숫자를 받아 `analogWrite(LED_PIN, 숫자)` 로 밝기 조절.
   (힌트: `cmd.startsWith("dim ")`, `cmd.substring(4).toInt()`)
2. **상태 질의**: `status` 를 입력하면 현재 LED 상태와 가동 시간을 한 줄로 응답.
3. **에코 봇**: 받은 문장을 그대로 되돌려 보내기.

## 막히면?

| 증상 | 해결 |
|------|------|
| 명령을 쳐도 반응 없음 | 모니터 줄 끝을 **LF/Newline** 으로. `trim()` 호출 확인 |
| 글자가 깨짐(외계어) | 속도 115200 일치 확인 ([docs/07](../docs/07-serial-communication.md)) |
| 입력창이 안 보임 | PlatformIO 모니터 터미널에 직접 타이핑 후 Enter |

➡️ 다음: [실습 06. WiFi 로 웹서버의 LED 따라 켜기 ★](06-wifi-led-client.md) — 이 강좌의 마무리 실습
