// 02-button-led — 디지털 입력 (Digital Input)
// 버튼을 누르는 동안 LED가 켜진다. INPUT_PULLUP 사용(눌리면 LOW).
// 추가로 "눌린 순간"을 엣지 감지해 눌린 횟수를 Serial로 센다.
// 관련 문서: docs/04-digital-input.md / 실습: exercises/02-button-led-control.md
#include <Arduino.h>

const int LED_PIN = 2;      // 내장 LED
const int BUTTON_PIN = 4;   // 버튼: 한쪽은 GPIO4, 다른 쪽은 GND

int lastButton = HIGH;      // 직전 버튼 상태 (풀업이라 평소 HIGH)
int pressCount = 0;         // 누른 횟수

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);   // 내부 풀업: 평소 HIGH, 누르면 LOW
  Serial.println("버튼을 눌러 보세요");
}

void loop() {
  int button = digitalRead(BUTTON_PIN);

  // (1) 누르고 있는 동안 LED 켜기 (풀업이므로 LOW가 '눌림')
  digitalWrite(LED_PIN, button == LOW ? HIGH : LOW);

  // (2) HIGH -> LOW 로 바뀐 '눌린 순간'만 카운트 (엣지 감지 + 디바운스)
  if (lastButton == HIGH && button == LOW) {
    pressCount++;
    Serial.printf("버튼 눌림! 누적 %d 회\n", pressCount);
    delay(50);   // 채터링(떨림) 무시
  }
  lastButton = button;
}
