# 03. CSS 기초 — 페이지 꾸미기

## 한 줄 요약

> **CSS = "무엇을(선택자) 어떻게(속성) 꾸밀지" 지정하는 언어.**
> HTML이 만든 뼈대에 색·여백·배치 같은 **인테리어**를 입힙니다.

## 1. CSS의 기본 문법

CSS는 **"어떤 요소를(선택자) → 어떻게(속성: 값)"** 형태로 씁니다.

```css
h1 {
  color: #6b4e9e;     /* 속성: 값; */
  font-size: 28px;
}
└┬┘ └────────┬───────┘
선택자      선언 블록 { ... }
```

| 부분 | 의미 |
|------|------|
| **선택자(Selector)** | 누구를 꾸밀지 (`h1`, `#id`, `.class`) |
| **속성(Property)** | 무엇을 바꿀지 (`color`, `font-size` …) |
| **값(Value)** | 어떻게 바꿀지 (`#6b4e9e`, `28px` …) |

> 💡 각 줄은 **세미콜론 `;`** 으로 끝납니다. `/* ... */` 는 **주석**이라 화면에 영향이 없습니다.

## 2. CSS를 적용하는 3가지 방법

CSS를 HTML에 연결하는 방법은 세 가지입니다. 보통 **외부 파일** 방식을 가장 권장합니다.

### ① 인라인(inline) — 태그에 직접

```html
<h1 style="color: #6b4e9e;">제목</h1>
```

간단하지만 재사용이 안 되고 지저분해집니다. 급할 때만 쓰세요.

### ② 내부(internal) — `<head>` 안의 `<style>`

```html
<head>
  <style>
    h1 { color: #6b4e9e; }
  </style>
</head>
```

한 파일 안에서 관리할 때 편리합니다.

### ③ 외부(external) — 별도 `.css` 파일 ✅ 권장

```html
<!-- index.html 의 <head> 안 -->
<link rel="stylesheet" href="style.css">
```

```css
/* style.css */
h1 { color: #6b4e9e; }
```

> 💡 **외부 파일**이 가장 깔끔합니다. HTML(구조)과 CSS(모양)가 분리되어, 여러 페이지가
> 같은 `style.css` 를 공유할 수 있습니다.

## 3. 선택자(Selector) — 누구를 꾸밀까

가장 많이 쓰는 선택자 세 가지입니다. ([02. HTML](02-html-basics.md)에서 붙인 이름표를 떠올리세요.)

| 선택자 | 의미 | 예 | 무엇을 고르나 |
|--------|------|----|--------------|
| **태그 선택자** | 그 태그 전부 | `p { ... }` | 모든 `<p>` |
| **클래스 선택자** | `.클래스명` | `.btn { ... }` | `class="btn"` 인 것들 |
| **아이디 선택자** | `#아이디` | `#on { ... }` | `id="on"` 인 **하나** |

```css
p        { color: gray; }       /* 모든 문단 */
.btn     { font-weight: bold; } /* class="btn" 전부 */
#on      { color: white; }      /* id="on" 하나 */
```

> 💡 `#id` 와 `.class` 의 차이는 HTML과 동일합니다. **하나만 콕 집을 땐 `#`**,
> **여러 개 묶을 땐 `.`** 입니다.

## 4. 자주 쓰는 속성들

### 색과 글자

```css
h1 {
  color: #6b4e9e;            /* 글자색 (우리 단체 메인 컬러 💜) */
  font-size: 28px;           /* 글자 크기 */
  font-weight: bold;         /* 굵게 */
  text-align: center;        /* 가운데 정렬 */
}
body {
  background-color: #f1ecf7; /* 배경색 (옅은 보라) */
  font-family: 'Malgun Gothic', sans-serif;  /* 글꼴 */
}
```

> 💡 색은 `red` 같은 이름, `#6b4e9e` 같은 **16진수 코드**, `rgb(107, 78, 158)` 등으로 쓸 수
> 있습니다. 이 강의의 메인 강조색은 **`#6b4e9e`(보라)** 입니다.

### 박스 모델 — 모든 요소는 상자다

화면의 모든 요소는 사실 **사각형 상자**입니다. 상자는 안쪽부터 바깥쪽으로 이렇게 구성됩니다.

```
┌─────────── margin (바깥 여백) ───────────┐
│  ┌──────── border (테두리) ──────────┐   │
│  │   ┌──── padding (안쪽 여백) ───┐   │   │
│  │   │      content (내용)       │   │   │
│  │   └──────────────────────────┘   │   │
│  └──────────────────────────────────┘   │
└──────────────────────────────────────────┘
```

| 속성 | 의미 |
|------|------|
| `padding` | 내용과 테두리 **사이** 여백 (상자 안쪽) |
| `border` | 테두리 |
| `margin` | 다른 요소와의 **바깥** 여백 |
| `width` / `height` | 너비 / 높이 |

```css
#history {
  border: 1px solid #ddd;     /* 두께 종류 색 */
  border-radius: 8px;         /* 모서리 둥글게 */
  padding: 12px;              /* 안쪽 여백 */
  margin-top: 16px;           /* 위쪽 바깥 여백 */
}
```

### 버튼 꾸미기 예제

```css
#on {
  background-color: #6b4e9e;  /* 보라 배경 */
  color: white;               /* 흰 글자 */
  border: none;               /* 기본 테두리 제거 */
  border-radius: 6px;
  padding: 8px 16px;          /* 위아래 8px, 좌우 16px */
  cursor: pointer;            /* 마우스 올리면 손가락 모양 */
}
```

## 5. flexbox — 가로로 나란히 배치하기

요소들을 **가로로 나란히** 두고 싶을 때 가장 쉬운 방법이 **flex**입니다.
부모 상자에 `display: flex` 를 주면, 자식들이 가로로 줄을 섭니다.

```css
.row {
  display: flex;       /* 자식들을 가로로 나란히 */
  gap: 8px;            /* 자식들 사이 간격 */
  align-items: center; /* 세로 가운데 정렬 */
}
```

```html
<div class="row">
  <input id="name" placeholder="이름">
  <button id="on">켜기</button>
  <button id="off">끄기</button>
</div>
```

> 💡 `display: flex` 만 알아도 "입력창 + 버튼 나란히 놓기" 같은 흔한 배치가 쉽게 됩니다.

## 6. 🧪 직접 해보기 — LED 제어판 꾸미기

[02. HTML](02-html-basics.md)에서 만든 `index.html` 옆에 `style.css` 를 만들고 연결해 봅시다.

1. `index.html` 의 `<head>` 안에 한 줄을 추가합니다.

```html
<link rel="stylesheet" href="style.css">
```

2. 같은 폴더에 `style.css` 를 만들고 아래를 입력합니다.

```css
body {
  font-family: 'Malgun Gothic', sans-serif;
  max-width: 420px;        /* 너무 넓어지지 않게 */
  margin: 40px auto;       /* 위아래 40px, 좌우 auto = 가운데 정렬 */
  text-align: center;
  background-color: #f1ecf7;
}
h1 { color: #6b4e9e; }

/* LED 표시등 — 켜지면 노랑, 꺼지면 회보라 */
#lamp {
  width: 110px; height: 110px; border-radius: 50%;
  margin: 16px auto; display: flex; align-items: center; justify-content: center;
  font-weight: bold; border: 6px solid #e8e4f0;
}
.on  { background: #f5b301; color: #4a3a00; box-shadow: 0 0 30px #f5b301; }
.off { background: #cfc9dc; color: #6c6c78; }

button {
  background-color: #6b4e9e; color: white; border: none;
  border-radius: 6px; padding: 8px 16px; cursor: pointer;
}
#history {
  list-style: none;        /* 목록 점(•) 제거 */
  padding: 0; text-align: left;
}
#history li {
  background: white;
  border: 1px solid #e8e4f0;
  border-radius: 6px;
  padding: 8px 12px;
  margin-top: 6px;
}
```

3. 저장하고 브라우저에서 새로고침해 보세요. 보라색 제목과 동그란 표시등이 보이면 성공입니다! 🎉

> 🧪 메인 색 `#6b4e9e` 를 다른 색(예: `#1e88e5`)으로 바꿔 저장해 보세요. 어디가 바뀌는지
> 보면 선택자와 속성이 어떻게 연결되는지 감이 옵니다.

## 다음 단계

이제 보기 좋아진 페이지에 **동작**을 넣어, 버튼을 누르면 실제로 목록이 쌓이게 만들어 봅시다.

➡️ [04. JavaScript 기초](04-javascript-basics.md)
