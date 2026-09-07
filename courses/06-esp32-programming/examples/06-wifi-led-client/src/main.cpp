// 06-wifi-led-client — WiFi 연결 + LED 상태 서버에 HTTP GET 요청
// WiFi에 접속한 뒤, 1초마다 로컬 서버의 /api/led 에 GET 요청을 보내고
// 받은 상태(on/off)대로 내장 LED를 켜고 끈다. (Serial 모니터에도 출력)
//
// 이 서버는 05-web-server-python 강좌에서 만든 것과 같은 LED 서버다. 즉 브라우저의
// 웹 페이지에서 켜기/끄기를 누르면, 이 ESP32 보드가 그 상태를 읽어 실제 LED를 켠다.
// (ESP32는 웹 페이지와 똑같이 "서버를 보는 하나의 클라이언트")
//
// 관련 문서: docs/08-wifi-http-client.md / 실습: exercises/06-wifi-led-client.md
// 먼저 include/config.example.h 를 config.h 로 복사하고 값을 채울 것.
// 서버는 courses/05-web-server-python/examples/02-led-api 를 실행해서 씀 (exercises/06 참고).
#include <WiFi.h>
#include <HTTPClient.h>
#include "config.h"   // WIFI_SSID, WIFI_PASSWORD, SERVER_URL 정의

const int LED_PIN = 2;  // 내장 LED (보드에 따라 다르면 바꾸기)

// 서버에서 LED 상태를 받아와 내장 LED에 반영한다.
void pollLed() {
  HTTPClient http;
  http.begin(String(SERVER_URL) + "/api/led");

  int code = http.GET();                        // 요청 → HTTP 상태코드 반환
  if (code == 200) {                            // 200 = 성공
    String body = http.getString();             // 예: {"on":true,"by":"홍길동","time":"14:03:05"}
    bool on = body.indexOf("\"on\":true") >= 0; // on 값만 확인
    digitalWrite(LED_PIN, on ? HIGH : LOW);     // 물리 LED 반영
    Serial.println(String("서버 상태: ") + (on ? "ON" : "OFF") + "  " + body);
  } else {
    Serial.printf("요청 실패 (상태코드 %d). 서버 주소/실행/방화벽을 확인하세요.\n", code);
  }
  http.end();                                   // 연결 정리
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);

  // WiFi 연결
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("WiFi 연결 중");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("연결됨! ESP32 IP: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    pollLed();
  } else {
    Serial.println("WiFi 끊김, 재연결 시도");
    WiFi.reconnect();
  }
  delay(1000);   // 1초마다 상태 확인
}
