// 01-blink — 디지털 출력 (Digital Output)
// 내장 LED(GPIO2)를 1초 간격으로 깜빡인다. ESP32 첫 동작 확인용.
// 관련 문서: docs/03-digital-output.md / 실습: exercises/01-blink-led.md
#include <Arduino.h>

const int LED_PIN = 2;   // GPIO2 = 보드 내장 LED

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);   // 핀을 출력 모드로
  Serial.println("blink 시작!");
}

void loop() {
  digitalWrite(LED_PIN, HIGH);   // LED 켜기 (3.3V)
  Serial.println("LED ON");
  delay(1000);                   // 1초 대기

  digitalWrite(LED_PIN, LOW);    // LED 끄기 (0V)
  Serial.println("LED OFF");
  delay(1000);
}
