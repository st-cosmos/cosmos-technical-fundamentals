// LED 제어판 — WebSocket 버전
// 예제 02(polling) 와 비교: fetch/setInterval 이 사라지고, 서버가 push 하는 메시지를 onmessage 로 받는다.
const lamp = document.getElementById("lamp");
const status = document.getElementById("status");
const conn = document.getElementById("conn");
const nameInput = document.getElementById("name");

// 서버에서 받은 LED 상태로 화면을 갱신합니다. (예제 02 와 같음)
function render(led) {
  lamp.textContent = led.on ? "ON" : "OFF";
  lamp.className = "lamp " + (led.on ? "on" : "off");
  status.textContent = led.time === "-"
    ? "아직 아무도 바꾸지 않았습니다."
    : `마지막 변경: ${led.by} 님이 ${led.time} 에 LED를 ${led.on ? "켰습니다" : "껐습니다"}.`;
  if (led.viewers !== undefined) {
    conn.textContent = `🟢 연결됨 · 지금 ${led.viewers}명이 보고 있습니다`;
  }
}

let ws;

// WebSocket 연결. 끊기면 1초 뒤 자동 재연결 (서버 재시작·WiFi 끊김 대비)
function connect() {
  // 페이지가 http 면 ws, https 면 wss. location.host = "localhost:8000" 처럼 지금 페이지의 주소:포트
  const protocol = location.protocol === "https:" ? "wss" : "ws";
  ws = new WebSocket(`${protocol}://${location.host}/ws`);

  ws.onopen = () => {
    conn.textContent = "🟢 연결됨";
  };
  ws.onmessage = (event) => {
    render(JSON.parse(event.data)); // 서버가 push 할 때마다 (문자열 → 객체)
  };
  ws.onclose = () => {
    conn.textContent = "🔴 연결 끊김 — 다시 연결 중…";
    setTimeout(connect, 1000);
  };
}
connect();

// 켜기/끄기 버튼 → 서버로 전송 (fetch PUT 대신 ws.send)
function setLed(on) {
  if (ws.readyState !== WebSocket.OPEN) return; // 아직 연결 전이면 무시
  const by = nameInput.value.trim() || "익명";
  ws.send(JSON.stringify({ on, by })); // 객체 → JSON 문자열
  // 서버가 모두에게(나 포함) 새 상태를 push 하므로 여기서 render 를 부를 필요가 없다
}

document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));
