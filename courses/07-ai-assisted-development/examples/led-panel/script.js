/*
  LED 제어판 — 참고 동작 (순수 JavaScript, 서버 없음)
  · 켜기/끄기를 누르면 표시등 색과 "변경 이력"이 바뀝니다.
  · 시각은 브라우저의 new Date() 로 만듭니다. (웹 강의의 정적 LED 제어판과 같은 방식)
*/
const lamp = document.getElementById("lamp");
const lampLabel = document.getElementById("lampLabel");
const nameInput = document.getElementById("nameInput");
const historyEl = document.getElementById("history");

/** 현재 시각을 "오후 3:21" 형태로 */
function nowLabel() {
  return new Date().toLocaleTimeString("ko-KR", { hour: "numeric", minute: "2-digit" });
}

/** 이력 한 줄을 맨 위에 추가 */
function addHistory(on, by, time) {
  const li = document.createElement("li");
  const dot = document.createElement("span");
  dot.className = "dot " + (on ? "on" : "off");
  const text = document.createElement("span");
  text.textContent = `[${time}] ${by} 님이 LED를 ${on ? "켰습니다" : "껐습니다"}`;
  li.append(dot, text);
  historyEl.prepend(li); // 최신이 위로
}

/** 켜기/끄기 공통 처리 */
function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  const time = nowLabel();

  lamp.classList.toggle("is-on", on);
  lampLabel.textContent = on ? "🟡 ON" : "⚪ OFF";
  addHistory(on, by, time);
}

document.getElementById("onButton").addEventListener("click", () => setLed(true));
document.getElementById("offButton").addEventListener("click", () => setLed(false));

// 디자인 시안과 같은 초기 상태(켜짐 + 예시 이력 2줄)로 시작
addHistory(false, "지민", "오후 3:19");
addHistory(true, "정우", "오후 3:21");
