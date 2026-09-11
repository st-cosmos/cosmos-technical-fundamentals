// 07-wifi-led-websocket — WiFi 연결 + LED 서버에 WebSocket 으로 붙기
// 06 예제(1초마다 GET 으로 물어보기 = polling)를 WebSocket 으로 바꾼 버전.
//   - 서버와 연결을 유지하고, 누가 LED 를 바꾸면 서버가 "즉시" 새 상태를 보내 준다 (push)
//   - 버튼(GPIO22)을 누르면 ESP32 쪽에서도 상태를 서버에 보낸다 → 브라우저들이 즉시 갱신
// 즉 브라우저 ↔ 서버 ↔ ESP32 가 한 상태를 실시간으로 공유한다.
//
// 관련 문서: docs/09-wifi-websocket-client.md / 실습: exercises/07-wifi-led-websocket.md
// 먼저 include/config.example.h 를 config.h 로 복사하고 값을 채울 것.
// 서버는 courses/05-web-server-python/examples/03-led-websocket 을 실행해서 씀 (exercises/07 참고).
#include <WiFi.h>
#include <WebSocketsClient.h>   // lib_deps = links2004/WebSockets (platformio.ini)
#include "config.h"             // WIFI_SSID, WIFI_PASSWORD, SERVER_HOST, SERVER_PORT, SERVER_PATH

const int LED_PIN = 23;     // LED: GPIO23 ──[220Ω]──▶|── GND (내장 LED 를 쓰려면 2)
const int BUTTON_PIN = 22;  // 버튼: 한쪽은 GPIO22, 다른 쪽은 GND (INPUT_PULLUP)

WebSocketsClient ws;        // WebSocket 클라이언트 객체
bool ledOn = false;         // 서버가 마지막으로 알려 준 LED 상태
int lastButton = HIGH;      // 엣지 감지용 (풀업이라 평소 HIGH)

// 서버에서 무언가 일어날 때마다 호출되는 함수 (연결됨 / 끊김 / 메시지 도착)
void onWsEvent(WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_CONNECTED:
      Serial.println("WebSocket 연결됨 — 서버가 현재 상태를 바로 보내 줍니다");
      break;

    case WStype_DISCONNECTED:
      Serial.println("WebSocket 끊김 — 자동으로 다시 연결합니다");
      break;

    case WStype_TEXT: {                          // 서버 → ESP32 메시지 (JSON 텍스트)
      String msg = String((const char*)payload); // 예: {"on":true,"by":"철수","time":"14:03:05","viewers":2}
      ledOn = msg.indexOf("\"on\":true") >= 0;   // on 값만 확인 (06 예제와 같은 방식)
      digitalWrite(LED_PIN, ledOn ? HIGH : LOW); // 물리 LED 즉시 반영
      Serial.println(String("서버 push: ") + (ledOn ? "ON " : "OFF") + "  " + msg);
      break;
    }

    default:                                     // ping/pong 등은 라이브러리가 알아서 처리
      break;
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  // WiFi 연결 (06 예제와 동일)
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("WiFi 연결 중");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("연결됨! ESP32 IP: ");
  Serial.println(WiFi.localIP());

  // WebSocket 연결 — ws://SERVER_HOST:SERVER_PORT/ws
  ws.begin(SERVER_HOST, SERVER_PORT, SERVER_PATH);
  ws.onEvent(onWsEvent);            // 이벤트가 오면 위 함수 호출
  ws.setReconnectInterval(2000);    // 끊기면 2초마다 재연결 시도
  Serial.printf("WebSocket 연결 시도: ws://%s:%d%s\n", SERVER_HOST, SERVER_PORT, SERVER_PATH);
}

void loop() {
  ws.loop();   // ★ 매번 불러 줘야 메시지를 받고 연결을 유지한다 (delay 로 오래 멈추지 말 것)

  // 버튼이 "막 눌린 순간"(HIGH→LOW)에만 서버로 토글 명령 전송 (04 문서의 엣지 감지)
  int button = digitalRead(BUTTON_PIN);
  if (lastButton == HIGH && button == LOW) {
    String cmd = String("{\"on\":") + (ledOn ? "false" : "true") + ",\"by\":\"ESP32\"}";
    ws.sendTXT(cmd);                // 브라우저가 ws.send(...) 하는 것과 같은 일
    Serial.println("버튼 → 서버에 전송: " + cmd);
    delay(50);                      // 떨림(채터링) 무시
  }
  lastButton = button;
}
