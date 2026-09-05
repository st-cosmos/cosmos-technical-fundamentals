// 화면 요소 가져오기
const lamp = document.getElementById("lamp");
const nameInput = document.getElementById("name");
const history = document.getElementById("history");

// 켜기/끄기 → 표시등을 바꾸고, 기록 한 줄을 맨 위에 추가하는 함수
function setLed(on) {
  // 1) 표시등(램프) 바꾸기
  lamp.textContent = on ? "ON" : "OFF";
  lamp.className = "lamp " + (on ? "on" : "off"); // CSS 색 바꾸기

  // 2) "누가 언제 켰/껐는지" 기록(li)을 만들어 목록 맨 위에 추가
  const by = nameInput.value.trim() || "익명";
  const time = new Date().toLocaleTimeString();
  const li = document.createElement("li");
  li.textContent = `[${time}] ${by} 님이 LED를 ${on ? "켰습니다" : "껐습니다"}`;
  history.prepend(li); // prepend: 맨 위(최신)에 추가
}

// 버튼 클릭에 연결
document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));
