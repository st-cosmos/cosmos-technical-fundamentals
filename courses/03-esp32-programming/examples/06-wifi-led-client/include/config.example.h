// config.example.h — 설정 양식 (이 파일은 git에 올라갑니다)
//
// 사용법:
//   1) 이 파일을 같은 폴더에 config.h 로 복사한다.
//        Windows(PowerShell):  copy config.example.h config.h
//        macOS/Linux:          cp config.example.h config.h
//   2) config.h 의 값을 실제 환경에 맞게 채운다.
//   3) config.h 는 .gitignore 에 의해 커밋되지 않는다 (비밀번호 보호).
#pragma once

// 접속할 WiFi (2.4GHz 네트워크여야 함)
#define WIFI_SSID     "여기에_WiFi_이름"
#define WIFI_PASSWORD "여기에_비밀번호"

// 테스트 서버를 띄운 PC의 주소.
//   - PC의 실제 IP를 적는다 (localhost/127.0.0.1 은 ESP32에서 접근 불가)
//   - Windows: ipconfig 의 IPv4 주소 / macOS·Linux: ifconfig 또는 ip addr
//   - 예) "http://192.168.0.10:8000"
#define SERVER_URL    "http://PC의_IP주소:8000"
