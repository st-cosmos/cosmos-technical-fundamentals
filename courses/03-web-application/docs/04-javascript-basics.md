# 04. JavaScript 기초 — 페이지에 동작 넣기

## 한 줄 요약

> **JavaScript = 화면 요소(DOM)를 "찾고 · 바꾸고 · 이벤트에 반응"하게 만드는 언어.**
> HTML(뼈대)·CSS(모양)에 이어, **버튼을 누르면 실제로 무언가 일어나게** 하는 동작 담당입니다.

## 1. JavaScript 연결하기

JS도 CSS처럼 HTML에 연결합니다. 보통 `<body>` **맨 끝**에 `<script>` 를 둡니다.

```html
<body>
  <!-- ... 내용 ... -->
  <script src="app.js"></script>   <!-- 외부 파일 (권장) -->
</body>
```

> 💡 `<script>` 를 **맨 아래**에 두는 이유: JS가 실행될 때 위쪽 HTML 요소들이 **이미 다
> 만들어져 있어야** 찾을 수 있기 때문입니다. 위에 두면 "요소를 못 찾음" 오류가 나기 쉽습니다.

> 🧪 빠르게 실험할 땐 F12 → **Console(콘솔)** 탭에 JS를 직접 쳐볼 수도 있습니다.
> `console.log("안녕")` 을 쳐보세요. 입력한 값이 콘솔에 출력됩니다.

## 2. 변수 — let 과 const

값을 담아두는 상자가 **변수**입니다. JS에서는 `let` 과 `const` 를 씁니다.

```js
let count = 0;          // 나중에 바뀔 수 있는 값
count = count + 1;      // OK

const name = "철수";    // 바뀌지 않는 값 (상수)
// name = "영희";       // ❌ 오류! const 는 다시 대입 불가
```

| 키워드 | 의미 | 언제 |
|--------|------|------|
| `const` | 한 번 정하면 안 바뀜 (상수) | **기본으로 이걸 쓰세요** |
| `let` | 나중에 값이 바뀔 수 있음 | 카운터처럼 변하는 값에 |

> 💡 원칙: **일단 `const` 로 쓰고, 바꿔야 할 때만 `let`.** 이렇게 하면 실수로 값이
> 바뀌는 것을 막아 안전합니다.

## 3. 함수 — 동작을 묶어두기

반복되는 동작이나 "이럴 때 이걸 해라"를 **함수**로 묶습니다.

```js
// 함수 정의
function greet(who) {
  return "안녕, " + who + "!";
}

// 함수 호출
const message = greet("철수");   // "안녕, 철수!"
```

요즘은 **화살표 함수** 형태도 많이 씁니다. 짧게 쓸 때 편리합니다.

```js
const greet = (who) => "안녕, " + who + "!";
```

## 4. DOM 선택 — 화면 요소 찾기

JS가 HTML 요소를 다루려면 먼저 그 요소를 **찾아야** 합니다. 이때 HTML에서 붙인
**id/class 이름표**([02. HTML](02-html-basics.md))를 사용합니다.

```js
// id 로 찾기 (가장 많이 씀)
const nameInput = document.getElementById("name");

// CSS 선택자로 찾기 (#id, .class, 태그 모두 가능)
const button = document.querySelector("#on");
const items  = document.querySelectorAll(".item");  // 여러 개
```

| 메서드 | 찾는 방법 | 결과 |
|--------|-----------|------|
| `getElementById("name")` | id로 | 요소 하나 |
| `querySelector("#on")` | CSS 선택자로 | **첫 번째** 하나 |
| `querySelectorAll(".item")` | CSS 선택자로 | **여러 개** (목록) |

> 💡 `querySelector` 는 CSS 선택자를 그대로 쓰니, `#`(id)·`.`(class)를 잊지 마세요.
> `getElementById` 는 id만 받으므로 `#` 를 **붙이지 않습니다.** (헷갈리기 쉬운 부분!)

## 5. 내용 바꾸기와 입력값 읽기

찾은 요소의 **내용을 바꾸거나**, 입력창의 **값을 읽을** 수 있습니다.

```js
// 내용(텍스트) 바꾸기
const title = document.getElementById("title");
title.textContent = "새 제목으로 변경!";

// 입력창의 현재 값 읽기 (.value)
const nameInput = document.getElementById("name");
console.log(nameInput.value);   // 사용자가 입력한 글자
nameInput.value = "";           // 입력창 비우기
```

| 무엇 | 어떻게 | 쓰임 |
|------|--------|------|
| 텍스트 내용 | `요소.textContent` | 글자 읽기/바꾸기 |
| 입력값 | `input.value` | 입력창 내용 읽기/지우기 |

## 6. 요소 만들고 추가하기

화면에 **새 요소**(예: 목록 항목 `<li>`)를 만들어 붙일 수도 있습니다.

```js
const history = document.getElementById("history");

const li = document.createElement("li");  // <li> 새로 만들기 (아직 화면엔 없음)
li.textContent = "새 항목";               // 내용 채우기
history.appendChild(li);                  // history 의 자식으로 붙이기 → 화면에 등장!
```

| 단계 | 코드 | 의미 |
|------|------|------|
| ① 만들기 | `document.createElement("li")` | 새 `<li>` 생성 |
| ② 채우기 | `li.textContent = "..."` | 내용 넣기 |
| ③ 붙이기 | `부모.appendChild(li)` | 화면에 추가 |

## 7. 이벤트 — 클릭에 반응하기

"버튼을 **클릭하면** 이걸 해라" 같은 반응은 **이벤트 리스너**로 등록합니다.

```js
const button = document.getElementById("on");

button.addEventListener("click", () => {
  console.log("버튼이 눌렸어요!");   // 클릭할 때마다 실행
});
```

- `addEventListener("click", 함수)` = "click 이 일어나면 이 함수를 실행해줘"
- `"click"` 자리에 `"input"`, `"keydown"` 등 다른 이벤트도 올 수 있습니다.

## 8. 🧪 직접 해보기 — "켜기/끄기 → 표시등 + 기록" 완성

지금까지 배운 조각(찾기 → 읽기 → 만들기 → 붙이기 → 이벤트)을 하나로 합치면, 이 강의의
핵심 동작이 완성됩니다. [02·03](02-html-basics.md)에서 만든 LED 제어판에 `app.js` 를 연결합니다.

**1단계 — 요소 찾기**

```js
const lamp = document.getElementById("lamp");
const nameInput = document.getElementById("name");
const history = document.getElementById("history");
```

**2단계 — "표시등 바꾸고 기록 추가하는" 함수 만들기**

```js
function setLed(on) {
  lamp.textContent = on ? "ON" : "OFF";       // 표시등 글자
  lamp.className = on ? "on" : "off";         // CSS 색 바꾸기

  const by = nameInput.value.trim() || "익명"; // 이름 읽기(비면 익명)
  const time = new Date().toLocaleTimeString();
  const li = document.createElement("li");    // <li> 만들기
  li.textContent = `[${time}] ${by} 님이 LED를 ${on ? "켰습니다" : "껐습니다"}`;
  history.prepend(li);                        // 목록 맨 위에 붙이기
}
```

**3단계 — 버튼 클릭에 연결**

```js
document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));
```

이제 이름을 넣고 켜기/끄기를 누르면, 표시등이 바뀌고 아래에 기록이 **하나씩 쌓입니다!** 🎉

> 💡 지금은 DOM을 다루는 연습으로 화면 안에서만 동작합니다. 다음 목표는 **서버와 값을
> 주고받는** 것 — 다음 강좌 [05-web-server-python](../../05-web-server-python/README.md) 에서 이 화면을 서버에 붙여
> **누가 LED를 켰는지 다 같이 보는** 앱으로 발전시킵니다. (서버는 LED 상태를 `{on, by, time}` 형태로 주고받습니다.)

## 다음 단계

프론트엔드 3종 세트를 마쳤습니다! 이제 [`exercises/01`](../exercises/01-led-panel.md)로
정적 LED 제어판을 완성하세요. 자주 쓰는 태그·문법은 [05. 요약 치트시트](05-cheatsheet.md) 에 한 장으로 모아 두었습니다.

➡️ [05. HTML · CSS · JS 요약 치트시트](05-cheatsheet.md)
