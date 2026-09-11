// 04-analog-input — 아날로그 입력(ADC) → PWM 출력으로 연결
// 가변저항(GPIO34)을 읽어 그 값으로 LED 밝기(PWM, GPIO23)를 조절한다.
// 보너스: 같은 값을 진짜 아날로그 전압(DAC, GPIO25)으로도 내보낸다(클래식 ESP32만).
// 관련 문서: docs/06-analog-input.md / 실습: exercises/04-analog-pot-brightness.md
#include <Arduino.h>

const int POT_PIN = 34;   // 가변저항 가운데 다리 (입력 전용 핀, ADC1)
const int LED_PIN = 23;   // PWM 출력으로 밝기 조절할 LED (GPIO23 ──[220Ω]──▶|── GND)
const int DAC_PIN = 25;   // 진짜 DAC 출력 (GPIO25 또는 26만 가능)

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

  dacWrite(DAC_PIN, duty);                  // DAC로 진짜 전압 출력(0~3.3V)

  Serial.printf("raw=%4d  volt=%.2fV  duty=%3d\n", raw, volt, duty);
  delay(100);
}
