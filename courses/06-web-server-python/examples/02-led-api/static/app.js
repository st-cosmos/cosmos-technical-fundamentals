const lamp = document.getElementById("lamp");
const status = document.getElementById("status");
const nameInput = document.getElementById("name");

// 서버에서 받은 LED 상태로 화면을 갱신합니다.
function render(led) {
  lamp.textContent = led.on ? "ON" : "OFF";
  lamp.className = "lamp " + (led.on ? "on" : "off");
  // 누가 언제 어떤 값으로 바꿨는지 표시
  status.textContent =
    `마지막 변경: ${led.by} 님이 ${led.time} 에 LED를 ${led.on ? "켰습니다" : "껐습니다"}.`;
}

// 현재 LED 상태를 가져와 화면을 갱신합니다. (polling)
async function refresh() {
  const res = await fetch("/api/led");
  render(await res.json());
}

// 켜기/끄기 버튼 → 서버에 PUT 으로 상태 변경
async function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  await fetch("/api/led", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ on, by }),
  });
  refresh(); // 누른 직후 바로 반영
}

document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));

refresh(); // 처음 한 번
setInterval(refresh, 1000); // 1초마다 polling
