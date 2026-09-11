// 04-serial — Serial 통신 (양방향)
// 1초마다 가동 시간을 출력하고, Serial 모니터로 "on"/"off" 명령을 받아 LED를 제어한다.
// 관련 문서: docs/07-serial-communication.md / 실습: exercises/05-serial-monitor-chat.md
//
// 사용법: 업로드 후 Serial 모니터에서 on 또는 off 입력 (줄 끝 = Newline/LF).
#include <Arduino.h>

const int LED_PIN = 23;  // LED: GPIO23 ──[220Ω]──▶|── GND (내장 LED 를 쓰려면 2)

unsigned long lastTick = 0;   // 마지막으로 시간 출력한 시각

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  Serial.println("준비 완료. 명령을 입력하세요: on / off");
}

void loop() {
  // (1) 입력 처리: PC가 보낸 한 줄을 읽어 명령 해석
  if (Serial.available() > 0) {
    String cmd = Serial.readStringUntil('\n');
    cmd.trim();   // 앞뒤 공백/줄바꿈 제거

    if (cmd == "on") {
      digitalWrite(LED_PIN, HIGH);
      Serial.println("-> LED 켜짐");
    } else if (cmd == "off") {
      digitalWrite(LED_PIN, LOW);
      Serial.println("-> LED 꺼짐");
    } else if (cmd.length() > 0) {
      Serial.println("-> 알 수 없는 명령: " + cmd);
    }
  }

  // (2) 출력: 1초마다 가동 시간 표시 (delay 없이 millis로 타이밍)
  if (millis() - lastTick >= 1000) {
    lastTick = millis();
    Serial.printf("가동 시간: %lu 초\n", millis() / 1000);
  }
}
