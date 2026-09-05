---
marp: true
theme: cosmos
paginate: true
footer: "04 · 웹 애플리케이션"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 04</div>

# 웹 애플리케이션

<div class="rule"></div>

<div class="subtitle">HTML · CSS · JavaScript — 브라우저에서 동작하는 첫 페이지</div>

<div class="meta">
프론트엔드 3종 언어 · 개발자 도구<br>
대상: 웹이 처음인 부원 · 서버·Python 불필요
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. 웹은 **어떻게 동작하나** — 브라우저·서버·URL·HTTP
2. **HTML** — 문서의 뼈대: 태그·속성·id/class
3. **CSS** — 모양: 선택자·박스 모델·flex
4. **JavaScript** — 동작: 변수·함수·DOM·이벤트
5. **치트시트** — 주요 태그·문법 한 장 요약

> 마지막엔 **이름 입력 → 켜기/끄기 → 표시등 + 기록** 이 되는 LED 제어판을 완성합니다.
> (06 강좌에서 이 화면을 서버·ESP32 와 연결)

---

<!-- _class: section -->
<div class="eyebrow">PART 1</div>

# 웹은 어떻게 동작하는가

<div class="lead-sub">브라우저는 "요청"하고, 서버는 "응답"한다</div>

---

## 등장인물 둘 — 브라우저와 서버

| 등장인물 | 다른 이름 | 하는 일 |
|----------|-----------|---------|
| **브라우저** | 클라이언트 | 주소(URL)로 **요청**을 보내고, 결과를 화면에 **그림** 🎨 |
| **서버** | Server | 요청을 받아 알맞은 데이터를 **돌려줌** 📦 |

```
[브라우저]  ── HTTP 요청(Request)  ─▶  [서버]
[브라우저]  ◀─ HTTP 응답(Response) ──  [서버]
```

> 💡 식당 주문: 손님(브라우저)이 주문(요청) → 주방(서버)이 음식(응답).
> "서버" 는 거창한 게 아니라 **요청을 받아 응답하는 프로그램**. 06 강좌에서 노트북에 직접 띄움.

---

## URL — 인터넷의 주소

```
https://example.com:443/api/led?on=true
└─┬─┘   └────┬────┘ └┬┘ └──┬──┘ └──┬───┘
프로토콜    호스트   포트   경로     쿼리
```

| 부분 | 의미 | 예 |
|------|------|----|
| **프로토콜** | 통신 약속 | `https://` |
| **호스트** | 어느 서버 | `example.com` · `localhost`(내 PC) |
| **포트** | 몇 번 문 | `:443`, `:8000` |
| **경로** | 무엇을 | `/api/led` |

---

## 주소창에 Enter 를 치면

1. 🔎 **DNS**: 이름(`example.com`) → 실제 주소(IP)
2. 📨 **요청**: 브라우저가 `GET /` 전송
3. 🛠️ **서버 처리**: HTML 문서를 만들어 응답
4. 🎨 **렌더링**: HTML 해석 + 연결된 **CSS·JS·이미지**를 추가 요청해 화면 조립

> 🧪 **F12 → Network → F5** — 표의 한 줄 한 줄이 요청/응답 한 쌍. 직접 눈으로 확인!

---

## 웹 페이지의 3종 세트

| 언어 | 역할 | 비유 |
|------|------|------|
| **HTML** | 구조·내용 | 집의 **뼈대** 🦴 |
| **CSS** | 모양·색·배치 | **인테리어** 🛋️ |
| **JavaScript** | 동작·상호작용 | **전기·움직이는 것** ⚡ |

- HTML 만: 글자·버튼은 보이지만 밋밋, 눌러도 반응 없음
- + CSS: 색·여백·배치
- + JS: 버튼을 누르면 실제로 동작

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# HTML

<div class="lead-sub">태그로 구조를 만든다</div>

---

## 태그와 문서 골격

```html
<!DOCTYPE html>              <!-- HTML5 선언 -->
<html lang="ko">
  <head>                     <!-- 화면에 안 보이는 설정 -->
    <meta charset="UTF-8">   <!-- 한글이 깨지지 않게 (필수!) -->
    <title>내 첫 페이지</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>                     <!-- 화면에 보이는 내용 -->
    <h1>안녕하세요</h1>
    <script src="app.js"></script>   <!-- JS 는 맨 끝 -->
  </body>
</html>
```

`<h1>내용</h1>` — 여는 태그 · 내용 · 닫는 태그(`/`). `<img>` `<input>` 은 닫는 태그 없음.

---

## 자주 쓰는 태그

| 태그 | 의미 | 태그 | 의미 |
|------|------|------|------|
| `<h1>`~`<h6>` | 제목 | `<a href>` | 링크 |
| `<p>` | 문단 | `<img src alt>` | 이미지 |
| `<div>` | 묶음 상자(블록) | `<input type>` | 입력창 |
| `<span>` | 작은 묶음(인라인) | `<button>` | 버튼 |
| `<ul>`/`<li>` | 목록 | `<form>` | 입력 양식 |
| `<table>` `<tr>` `<td>` | 표 | `<label>` | 입력칸 이름표 |

- **블록**(`div`,`p`,`h1`): 한 줄 통째 · **인라인**(`span`,`a`): 글자처럼
- 속성은 `이름="값"` — `href` `src` `type` `placeholder` `id` `class`

---

## id 와 class — 이름표

```html
<input id="name" class="field" placeholder="이름">
<button id="on" class="btn">켜기</button>
<ul id="history"></ul>
```

| 이름표 | 특징 | 비유 |
|--------|------|------|
| **`id`** | 페이지에서 **딱 하나** | 주민등록번호 |
| **`class`** | **여러 요소가 공유** | 같은 반 학생 |

> 하나만 콕 집을 땐 `id`, 여러 개 묶을 땐 `class`.
> CSS 는 `#name` / `.field`, JS 는 `getElementById("name")` 로 찾음.

---

<!-- _class: section -->
<div class="eyebrow">PART 3</div>

# CSS

<div class="lead-sub">무엇을(선택자) 어떻게(속성: 값)</div>

---

## 문법과 선택자

```css
h1 {
  color: #6b4e9e;     /* 속성: 값;  */
  font-size: 28px;
}
```

| 선택자 | 대상 | 예 |
|--------|------|----|
| 태그 | 그 태그 전부 | `p { }` |
| `.class` | class="btn" 인 것들 | `.btn { }` |
| `#id` | id="on" 하나 | `#on { }` |
| `A B` | A 안의 B | `#history li { }` |
| `:hover` | 마우스 올렸을 때 | `.btn:hover { }` |

> 연결 3가지(인라인/`<style>`/외부 파일) 중 **외부 `.css`** 가 표준 — 구조와 모양 분리.

---

## 박스 모델과 flexbox

<div class="cols">
<div>

```
┌── margin (바깥) ──────┐
│ ┌ border ──────────┐  │
│ │ ┌ padding(안쪽)┐ │  │
│ │ │  content    │ │  │
```

```css
#lamp {
  width: 110px; height: 110px;
  border-radius: 50%;     /* 원 */
  border: 6px solid #e8e4f0;
  margin: 16px auto;      /* 가운데 */
}
```

</div>
<div>

```css
.row {              /* 가로 나란히 */
  display: flex;
  gap: 8px;
  align-items: center;
}
.on  { background: #f5b301;
       box-shadow: 0 0 30px #f5b301; }
.off { background: #cfc9dc; }
```

</div>
</div>

> `padding`(안) · `margin`(밖) · `display: flex`(가로 배치) 만 알아도 대부분 됩니다.

---

<!-- _class: section -->
<div class="eyebrow">PART 4</div>

# JavaScript

<div class="lead-sub">찾고 · 바꾸고 · 반응한다</div>

---

## 변수와 함수

```js
const name = "철수";   // 바뀌지 않는 값 (기본으로 이걸)
let count = 0;         // 바뀔 수 있는 값
count += 1;

const led = { on: true, by: "철수" };      // 객체
const msg = `${led.by} 님이 켰습니다`;     // 템플릿 문자열

function greet(who) { return "안녕, " + who; }
const hi = (who) => "안녕, " + who;        // 화살표 함수
```

> 원칙: **일단 `const`, 바꿔야 할 때만 `let`.** 비교는 `===`.

---

## DOM — 찾고 바꾸고 반응

```js
const lamp = document.getElementById("lamp");   // id 로 (# 없이)
const btn  = document.querySelector("#on");      // CSS 선택자 (# 필요)

lamp.textContent = "ON";                  // 글자 바꾸기
lamp.className = "lamp on";               // CSS 클래스 바꾸기
nameInput.value;                          // 입력값 읽기

const li = document.createElement("li");  // ① 만들기
li.textContent = "켰습니다";              // ② 채우기
history.prepend(li);                      // ③ 맨 위에 붙이기

btn.addEventListener("click", () => { /* 클릭마다 실행 */ });
```

> `<script>` 는 **body 맨 끝** — 요소가 다 만들어진 뒤 실행되어야 찾을 수 있음.

---

## 🧪 실습 — "이름 + 켜기/끄기 → 표시등 + 기록"

```js
function setLed(on) {
  lamp.textContent = on ? "ON" : "OFF";
  lamp.className = on ? "on" : "off";        // CSS 색 바꾸기
  const by = nameInput.value.trim() || "익명";
  const time = new Date().toLocaleTimeString();
  const li = document.createElement("li");
  li.textContent = `[${time}] ${by} 님이 LED를 ${on ? "켰습니다" : "껐습니다"}`;
  history.prepend(li);                       // 맨 위에 추가
}
document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));
```

> ⚠️ 이 기록은 **새로고침하면 사라짐** — 내 브라우저 안에만 존재.
> 이걸 **서버에 저장해 다 같이 보게**(+ ESP32 LED) 만드는 것이 06 강좌. (`exercises/01`)

---

<!-- _class: section -->
<div class="eyebrow">PART 5</div>

# 치트시트

<div class="lead-sub">docs/05 — 북마크해 두세요</div>

---

## HTML · CSS 요약 (전체는 docs/05)

<div class="cols">
<div>

**HTML**

| | |
|---|---|
| 골격 | `<!DOCTYPE>` `<html>` `<head>` `<body>` |
| 텍스트 | `h1~h6` `p` `strong` `span` `div` |
| 목록/표 | `ul li` `ol` `table tr td` |
| 링크/이미지 | `a href` `img src alt` |
| 입력 | `input type=…` `textarea` `select` `button` `label` |

</div>
<div>

**CSS**

| | |
|---|---|
| 선택자 | `태그` `.class` `#id` `A B` `:hover` |
| 박스 | `padding` `margin` `border` `border-radius` |
| 배치 | `display: flex` `gap` `align-items` |
| 변수 | `:root { --accent }` → `var(--accent)` |
| 전환 | `transition: background 0.2s` |

</div>
</div>

---

## JavaScript 요약 (전체는 docs/05)

| | |
|---|---|
| 변수·자료 | `const` / `let` · 객체 `{}` · 배열 `[]` · 템플릿 `` `${x}` `` |
| 흐름 | `if` · 삼항 `? :` · `for...of` · `map` `filter` |
| 찾기 | `getElementById("id")` · `querySelector("#id")` · `querySelectorAll(".c")` |
| 바꾸기 | `textContent` · `value` · `classList.add / remove / toggle` |
| 만들기 | `createElement` → `prepend` / `append` · `remove()` |
| 이벤트 | `addEventListener("click" \| "input" \| "keydown" \| "submit")` |
| 시간 | `setInterval` · `setTimeout` · `new Date().toLocaleTimeString()` |
| 디버깅 | `console.log` + **F12 Console** |

**개발자 도구 (F12)**: Elements(구조·CSS) · Console(오류·JS) · Network(요청/응답 — 06 에서 핵심)

---

## 정리

- 웹 = **요청 / 응답** 의 반복. F12 Network 로 눈으로 확인
- **HTML**(뼈대) · **CSS**(모양) · **JavaScript**(동작) — 세 파일로 분리
- `id`(하나) / `class`(여럿) 이름표 → CSS `#`/`.`, JS `getElementById`
- DOM: **찾기 → 바꾸기 → 만들기/붙이기 → 이벤트**
- 막히면 **F12 Console** 부터, 태그 헷갈리면 **docs/05**

<div class="small">다음: 05-python-programming (서버를 만들 파이썬) → 06-web-server-python (이 화면 + FastAPI 서버 + WebSocket)</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">이제 실습</div>

# 직접 만들어 봅시다 🚀

<div class="rule"></div>

<div class="subtitle">exercises/01 — LED 제어판을 처음부터 끝까지</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>
