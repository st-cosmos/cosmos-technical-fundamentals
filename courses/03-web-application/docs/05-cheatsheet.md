# 05. HTML · CSS · JavaScript 요약 치트시트

> 앞 문서(02~04)를 한 장으로 압축한 **참고표**입니다. 실습하다 "그 태그 뭐였지?" 싶을 때 여기로 오세요.
> 처음 읽는 분은 02~04 를 먼저 보고, 이 문서는 북마크해 두면 좋습니다.

## 1. HTML — 문서 골격

```html
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8">                        <!-- 한글 깨짐 방지, 필수 -->
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- 모바일 대응 -->
    <title>탭 제목</title>
    <link rel="stylesheet" href="style.css">      <!-- CSS 연결 -->
  </head>
  <body>
    ...화면에 보이는 내용...
    <script src="app.js"></script>                <!-- JS 는 body 맨 끝 -->
  </body>
</html>
```

## 2. HTML — 주요 태그

### 문서 구조·텍스트

| 태그 | 의미 | 예 |
|------|------|----|
| `<h1>`~`<h6>` | 제목 (h1 이 가장 큼, 페이지에 h1 은 하나) | `<h1>LED 제어판</h1>` |
| `<p>` | 문단 | `<p>설명 글</p>` |
| `<br>` | 줄바꿈 (빈 태그) | `첫 줄<br>둘째 줄` |
| `<hr>` | 가로 구분선 | `<hr>` |
| `<strong>` / `<em>` | 굵게(중요) / 기울임(강조) | `<strong>주의</strong>` |
| `<span>` | 인라인 묶음 (글자 일부) | `<span class="on">ON</span>` |
| `<div>` | 블록 묶음 (영역) | `<div class="card">...</div>` |
| `<!-- -->` | 주석 (화면에 안 보임) | `<!-- 메모 -->` |

### 의미 있는 영역 (시맨틱)

| 태그 | 용도 |
|------|------|
| `<header>` / `<footer>` | 머리말 / 꼬리말 |
| `<nav>` | 메뉴·링크 모음 |
| `<main>` | 본문 (페이지에 하나) |
| `<section>` / `<article>` | 주제별 구역 / 독립된 글 |

> 💡 전부 `<div>` 로 써도 동작하지만, 의미 있는 태그를 쓰면 코드를 읽기 쉽고 검색·접근성에 좋습니다.

### 목록·표

```html
<ul><li>순서 없는 항목</li></ul>       <!-- • 점 목록 -->
<ol><li>순서 있는 항목</li></ol>       <!-- 1. 2. 3. -->

<table>
  <thead><tr><th>이름</th><th>상태</th></tr></thead>
  <tbody><tr><td>철수</td><td>ON</td></tr></tbody>
</table>
```

### 링크·이미지

```html
<a href="https://example.com" target="_blank">새 탭으로 열기</a>
<a href="#history">같은 페이지의 id="history" 로 이동</a>
<img src="images/logo.png" alt="로고 설명" width="120">
```

### 입력 요소 (폼)

| 태그 / type | 용도 |
|-------------|------|
| `<input type="text">` | 한 줄 글자 |
| `<input type="number" min="0" max="255">` | 숫자 |
| `<input type="password">` | 비밀번호 (가려짐) |
| `<input type="checkbox">` / `type="radio"` | 체크박스 / 하나만 선택 |
| `<input type="range" min="0" max="255">` | 슬라이더 (LED 밝기에 딱) |
| `<input type="color">` | 색 선택 |
| `<textarea>` | 여러 줄 글자 |
| `<select><option>A</option></select>` | 드롭다운 |
| `<button>` | 버튼 |
| `<label for="name">이름</label>` | 입력칸 이름표 (클릭하면 해당 input 포커스) |
| `<form>` | 입력 요소 묶음 (Enter 로 제출) |

자주 쓰는 속성: `id`, `class`, `placeholder`(안내문), `value`(초깃값), `disabled`(비활성), `autocomplete="off"`

## 3. CSS — 문법과 선택자

```css
선택자 {
  속성: 값;        /* 세미콜론으로 끝 */
}
```

| 선택자 | 대상 | 예 |
|--------|------|----|
| `태그` | 그 태그 전부 | `p { }` |
| `.클래스` | class="..." 인 것들 | `.btn { }` |
| `#아이디` | id="..." 하나 | `#lamp { }` |
| `A B` | A 안의 모든 B | `#history li { }` |
| `A > B` | A 의 직계 자식 B | `.card > h1 { }` |
| `A, B` | A 또는 B | `h1, h2 { }` |
| `.a.b` | 클래스 a 와 b 둘 다 | `.lamp.on { }` |
| `:hover` | 마우스 올렸을 때 | `.btn:hover { }` |
| `:focus` | 포커스(입력 중) | `input:focus { }` |
| `:first-child` / `:last-child` | 첫/마지막 자식 | `li:first-child { }` |

**우선순위**: 인라인 `style=""` > `#id` > `.class` > `태그`. 같으면 **나중에 쓴 것**이 이김.

## 4. CSS — 자주 쓰는 속성

### 글자·색

```css
color: #6b4e9e;               /* 글자색: 이름(red) · 16진수(#rrggbb) · rgb(107,78,158) */
background: #f6f5f9;          /* 배경 */
font-family: 'Malgun Gothic', sans-serif;
font-size: 16px;              /* px · em · rem(루트 기준) · % */
font-weight: 700;             /* 400 보통, 700 굵게 */
text-align: center;           /* left · center · right */
line-height: 1.5;             /* 줄 간격 */
text-decoration: none;        /* 링크 밑줄 제거 */
```

### 박스 모델

```
┌── margin (바깥 여백) ──────────┐
│ ┌── border (테두리) ─────────┐ │
│ │ ┌── padding (안쪽 여백) ─┐ │ │
│ │ │       content          │ │ │
```

```css
width: 400px;  max-width: 100%;      /* 너비 (화면보다 커지지 않게) */
height: 110px;
padding: 8px 16px;                   /* 위아래 8, 좌우 16 */
margin: 40px auto;                   /* 위아래 40, 좌우 auto = 가운데 정렬 */
border: 1px solid #e8e4f0;           /* 두께 종류 색 */
border-radius: 8px;                  /* 모서리 둥글게 (50% = 원) */
box-shadow: 0 0 30px #f5b301;        /* 그림자/빛 번짐: x y 흐림 색 */
box-sizing: border-box;              /* width 에 padding·border 포함 (권장) */
```

### 배치

```css
display: block;     /* 한 줄 통째로 (div, p, h1) */
display: inline;    /* 글자처럼 (span, a) */
display: none;      /* 숨기기 */
display: flex;      /* 자식을 가로로 나란히 ↓ */
  gap: 8px;                    /* 자식 간격 */
  justify-content: center;     /* 가로 정렬: flex-start · center · space-between */
  align-items: center;         /* 세로 정렬 */
  flex-direction: column;      /* 세로로 쌓기 */
  flex: 1;                     /* (자식에) 남는 공간 채우기 */
display: grid;      /* 격자 배치 */
  grid-template-columns: 1fr 1fr 1fr;   /* 3열 */
position: absolute; top: 0; right: 0;   /* 부모(position: relative) 기준 고정 위치 */
```

### 변수·전환·반응형

```css
:root { --accent: #6b4e9e; }         /* 변수 정의 */
.btn { background: var(--accent); }  /* 사용 */

transition: background 0.2s;         /* 값이 바뀔 때 부드럽게 */

@media (max-width: 600px) {          /* 화면 폭 600px 이하일 때만 */
  .card { padding: 12px; }
}
```

## 5. JavaScript — 기본 문법

```js
// 변수
const name = "철수";        // 안 바뀜 (기본으로 이걸)
let count = 0;              // 바뀔 수 있음
count += 1;

// 자료형
const n = 42, f = 3.14;     // 숫자
const s = `안녕, ${name}`;   // 문자열 (백틱 = 템플릿, ${} 로 값 삽입)
const ok = true;            // 참/거짓
const arr = [1, 2, 3];      // 배열
const led = { on: true, by: "철수" };   // 객체
led.on; led["by"];          // 객체 값 읽기
arr.length; arr[0];         // 배열 길이, 첫 항목

// 조건·반복
if (led.on) { ... } else if (x > 1) { ... } else { ... }
const label = led.on ? "ON" : "OFF";      // 삼항 연산자
for (let i = 0; i < arr.length; i++) { ... }
for (const item of arr) { ... }            // 배열 순회
arr.forEach((item) => { ... });
arr.map((x) => x * 2);                     // 새 배열 만들기
arr.filter((x) => x > 1);                  // 조건에 맞는 것만

// 함수
function greet(who) { return "안녕, " + who; }
const greet2 = (who) => "안녕, " + who;    // 화살표 함수

// 비교는 === (타입까지 같음)
1 === 1;  "1" === 1;  // true, false
```

## 6. JavaScript — DOM (화면 다루기)

```js
// 찾기
const lamp  = document.getElementById("lamp");        // id (# 없이)
const btn   = document.querySelector("#on");           // CSS 선택자 (첫 하나)
const items = document.querySelectorAll("#history li"); // 여러 개

// 읽고 바꾸기
lamp.textContent = "ON";            // 글자
input.value;  input.value = "";     // 입력값 읽기 / 지우기
lamp.className = "lamp on";         // class 통째로
lamp.classList.add("on");           // class 추가 / remove / toggle("on", 조건)
lamp.style.background = "#f5b301";  // 인라인 스타일 (가능하면 class 로)
img.setAttribute("src", "a.png");   // 속성
el.hidden = true;                   // 숨기기

// 만들고 붙이기
const li = document.createElement("li");
li.textContent = "새 항목";
history.prepend(li);                // 맨 위에  (appendChild / append = 맨 아래)
li.remove();                        // 삭제

// 이벤트
btn.addEventListener("click", () => { ... });
input.addEventListener("input", (e) => console.log(e.target.value));   // 타이핑마다
input.addEventListener("keydown", (e) => { if (e.key === "Enter") ... });
form.addEventListener("submit", (e) => { e.preventDefault(); ... });   // 새로고침 막기

// 시간
setTimeout(() => { ... }, 1000);         // 1초 후 한 번
const id = setInterval(fn, 1000);        // 1초마다 반복  → clearInterval(id)
new Date().toLocaleTimeString();         // "오후 3:21:05"

// 디버깅
console.log("값:", led);                 // F12 → Console 에 출력
```

## 7. JavaScript — 서버 통신 미리보기 (05 강좌에서 자세히)

```js
const res = await fetch("/api/led");             // GET
const data = await res.json();

await fetch("/api/led", {                        // PUT / POST
  method: "PUT",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ on: true, by: "철수" }),
});
```

## 8. 개발자 도구 (F12) 단축 정리

| 탭 | 용도 |
|----|------|
| **Elements** | HTML 구조·적용된 CSS 확인, 값 실시간 수정 |
| **Console** | JS 오류 확인, `console.log` 출력, JS 직접 실행 |
| **Network** | 요청/응답 목록 (05 강좌에서 핵심) |
| 요소 선택(↖ 아이콘) | 화면 클릭 → 해당 HTML 로 이동 |

## 다음 단계

➡️ 실습 [`exercises/01-led-panel.md`](../exercises/01-led-panel.md) → 다음 강좌 [04-python-programming](../../04-python-programming/README.md)
