# 실습 01. LED 제어판 (HTML/CSS/JS)

> 🎯 목표: **순수 HTML/CSS/JS만으로** 이름 입력 + 켜기/끄기 버튼 + **표시등**을 만들고, 버튼을
> 누르면 표시등이 켜지고/꺼지며 "누가 언제 바꿨는지" 기록이 아래 목록에 쌓이는 페이지를 만든다.
> **서버 없이** 브라우저만으로 동작 — 다음 강좌(06)에서 이 화면을 서버·ESP32에 연결합니다.
>
> 📎 관련 문서: [docs/04-javascript-basics.md](../docs/04-javascript-basics.md) ·
> 완성 코드: `examples/01-led-panel/`

## 준비물

- 웹 브라우저(크롬 권장)
- VS Code (편집기) — 다른 설치는 필요 없습니다
- (Python·서버 **불필요** — 이 실습은 파일만 있으면 됩니다)

## 전체 흐름

```
이름 입력 → [켜기]/[끄기] 클릭 → 표시등(ON/OFF) 바뀜 → 아래 목록(ul)에 "[시각] 이름 켰/껐" 추가
```

## 1단계. 파일 만들기

빈 폴더(예: `web-01`)를 만들고, 그 안에 **`index.html`** 파일 하나를 만듭니다.

## 2단계. 뼈대(HTML) 작성

`index.html` 에 이름 입력·버튼·표시등·빈 목록을 둡니다.

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>LED 제어판</title>
</head>
<body>
  <h1>💡 LED 제어판</h1>
  <div id="lamp" class="off">OFF</div>
  <input id="name" placeholder="이름">
  <button id="on">켜기</button>
  <button id="off">끄기</button>
  <ul id="history"></ul>

  <script>
    // 4단계 코드가 여기에 들어갑니다
  </script>
</body>
</html>
```

> 💡 `id` 는 자바스크립트가 요소를 **찾아 쓰는 이름표**입니다. `lamp`(표시등), `name`(이름),
> `on`/`off`(버튼), `history`(목록) 를 기억하세요.

## 3단계. 살짝 꾸미기(CSS) — 선택

`<head>` 안에 `<style>` 을 넣습니다. 강조색은 단체 색(`#6b4e9e`), 켜짐은 노랑(`#f5b301`).

```html
<style>
  body { font-family: 'Malgun Gothic', sans-serif; max-width: 420px; margin: 40px auto; text-align: center; }
  #lamp { width: 110px; height: 110px; border-radius: 50%; margin: 16px auto;
          display: flex; align-items: center; justify-content: center; font-weight: bold;
          border: 6px solid #e8e4f0; }
  .on  { background: #f5b301; color: #4a3a00; box-shadow: 0 0 30px #f5b301; }
  .off { background: #cfc9dc; color: #6c6c78; }
  button { background: #6b4e9e; color: white; border: none; padding: 8px 16px; border-radius: 6px; }
  #history { list-style: none; padding: 0; text-align: left; }
  #history li { border: 1px solid #e8e4f0; border-radius: 8px; padding: 8px 12px; margin-top: 6px; }
</style>
```

## 4단계. 동작(JS) 작성

`<script>` 안에 켜기/끄기 처리를 적습니다.

```js
const lamp = document.getElementById("lamp");
const nameInput = document.getElementById("name");
const history = document.getElementById("history");

// 켜기/끄기 → 표시등 바꾸고, 기록 한 줄을 맨 위에 추가
function setLed(on) {
  lamp.textContent = on ? "ON" : "OFF";
  lamp.className = on ? "on" : "off";        // CSS 색 바꾸기

  const by = nameInput.value.trim() || "익명";
  const time = new Date().toLocaleTimeString();
  const li = document.createElement("li");
  li.textContent = `[${time}] ${by} 님이 LED를 ${on ? "켰습니다" : "껐습니다"}`;
  history.prepend(li);                       // prepend: 맨 위(최신)에
}

document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));
```

## 확인

1. 파일 탐색기에서 `index.html` 을 **더블클릭**(또는 VS Code의 **Live Server**)으로 엽니다.
2. 이름을 넣고 **켜기** 를 누릅니다.
3. 표시등이 노랗게 **ON** 으로 바뀌고, 아래 목록에 "… 켰습니다" 가 쌓이면 성공! 🎉
   **끄기** 도 눌러 보세요.

> 💡 지금은 **내 화면 안에서만** 동작합니다. 이걸 **서버에 저장해 다 같이 보게**(그리고 실제
> ESP32 LED를 켜게) 만드는 것이 다음 강좌 06-web-server-python 의 목표예요.

## 막히면?

| 증상 | 확인 |
|------|------|
| 버튼을 눌러도 아무 일 없음 | `id` 철자 확인(`lamp`/`name`/`on`/`off`/`history`), `<script>` 가 `<body>` **끝**에 있는지 |
| `getElementById ... null` 에러 | 스크립트가 요소보다 **먼저** 실행됨 → `<script>` 를 목록 아래로 |
| 표시등 색이 안 바뀜 | CSS `.on`/`.off` 클래스가 있는지, `lamp.className` 을 바꾸는지 |
| 한글이 깨짐 | `<meta charset="UTF-8">` 있는지 |

## 더 해보기 (도전 과제)

1. **버튼 하나로 토글**: 켜기/끄기 대신 버튼 하나로 현재 상태를 뒤집기.
2. **삭제 버튼**: 각 기록 옆에 작은 "x" 버튼으로 그 항목 삭제.
3. **개수 표시**: "켠 횟수 N번" 을 보여 주고 누를 때마다 갱신.

> 📦 완성 코드: [`examples/01-led-panel/`](../examples/01-led-panel/) — `index.html` 을 더블클릭하면 바로 열립니다.
> 예제는 HTML·CSS·JS 를 **세 파일로 분리**해 둔 형태입니다(권장 구조). 실습에서 한 파일에 쓴 것과 비교해 보세요.

## 🎓 마무리

웹 페이지의 3종 세트를 모두 손으로 써 봤습니다. 다음 강좌에서 이 화면을 서버와 연결합니다.

➡️ 다음 강좌: [06-web-server-python](../../06-web-server-python/README.md)  (그 전에 [05-python-programming](../../05-python-programming/README.md) 으로 파이썬 기초를 다집니다)
