// 03-pwm-output — PWM 출력 (Pulse Width Modulation)
// LED 밝기를 0 → 255 → 0 으로 천천히 오르내려 "숨 쉬는" 효과를 낸다.
// analogWrite(핀, 0~255) 는 진짜 중간 전압이 아니라, 빠른 켜짐/꺼짐 반복의 평균(듀티)이다.
// 관련 문서: docs/05-pwm-output.md / 실습: exercises/03-pwm-fade.md
//
// 배선: GPIO23 ──[220Ω]──▶|── GND   (LED 긴 다리가 저항 쪽) — 내장 LED(GPIO2)로도 가능
#include <Arduino.h>

const int LED_PIN = 23;        // PWM 으로 밝기 조절할 LED
const int STEP_DELAY_MS = 5;  // 한 단계마다 기다리는 시간 (작을수록 빨리 숨 쉼)

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  Serial.println("PWM fade 시작 — LED 가 천천히 밝아지고 어두워집니다");
}

void loop() {
  // 0 → 255 : 점점 밝게
  for (int duty = 0; duty <= 255; duty++) {
    analogWrite(LED_PIN, duty);
    delay(STEP_DELAY_MS);
  }
  Serial.println("최대 밝기 (duty=255)");

  // 255 → 0 : 점점 어둡게
  for (int duty = 255; duty >= 0; duty--) {
    analogWrite(LED_PIN, duty);
    delay(STEP_DELAY_MS);
  }
  Serial.println("꺼짐 (duty=0)");
}
