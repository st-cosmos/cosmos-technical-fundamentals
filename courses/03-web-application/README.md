# 03. 웹 애플리케이션 — HTML · CSS · JavaScript

**웹이 처음인 사람**을 위한 프론트엔드 입문입니다. 웹이 어떻게 동작하는지 큰 그림을 잡고, 웹 페이지를 만드는 세 가지
언어 **HTML(뼈대) · CSS(모양) · JavaScript(동작)** 를 직접 손으로 써 봅니다. 마지막엔 **주요 태그와 문법을 한 장으로
요약한 치트시트**를 드립니다.

> 🎯 이 자료를 끝내면: 이름 입력과 켜기/끄기 버튼이 있는 **LED 제어판** 웹 페이지를 서버 없이 브라우저만으로 만들 수
> 있습니다. 이 화면은 [05-web-server-python](../05-web-server-python/README.md) 에서 서버·ESP32 와 연결됩니다.

## 누구를 위한 자료인가

- **대상**: 웹/프로그래밍이 처음인 동아리 부원
- **선수**: [00](../00-dev-environment-setup/README.md) (VS Code), [01-cli](../01-cli/README.md) (경로 읽기)
- **도구**: 웹 브라우저(크롬 권장 — 개발자 도구 F12), **VS Code** (+ Live Server 확장 추천)
- **서버·Python 불필요** — 이 강좌는 파일과 브라우저만으로 진행합니다

## 폴더 구조

```
03-web-application/
├── docs/
│   ├── 01-how-the-web-works.md   브라우저·서버·URL·HTTP 큰 그림
│   ├── 02-html-basics.md         문서의 뼈대 — 태그·속성·id/class
│   ├── 03-css-basics.md          꾸미기 — 선택자·박스 모델·flex
│   ├── 04-javascript-basics.md   동작 — 변수·함수·DOM·이벤트
│   └── 05-cheatsheet.md          ★ 주요 태그 및 문법 요약 (참고표)
├── exercises/
│   └── 01-led-panel.md           LED 제어판 만들기 (정적 HTML/CSS/JS)
├── examples/
│   └── 01-led-panel/             완성 예제 — index.html · style.css · app.js
└── slides/
    └── web-application-basics.md
```

## 학습 순서

1. 📖 `docs/01` 웹이 동작하는 큰 그림 — F12 Network 탭으로 요청/응답 엿보기
2. 🧱 `docs/02` HTML → 🎨 `docs/03` CSS → ⚙️ `docs/04` JS — 각 문서 끝의 "직접 해보기"를 이어 가면 LED 제어판이 완성됨
3. 🧪 **`exercises/01`** 로 처음부터 다시 한 번 (손이 기억할 때까지)
4. 📋 `docs/05` 치트시트는 북마크 — 실습 중 "그 태그 뭐였지?" 할 때

## 예제 실행

`examples/01-led-panel/index.html` 을 **더블클릭**하면 브라우저에서 열립니다. 빌드·서버 불필요.
VS Code 의 **Live Server** 확장(우클릭 → Open with Live Server)으로 열면 저장할 때마다 자동 새로고침됩니다.

## 이어지는 강좌

- [04-python-programming](../04-python-programming/README.md) — 서버를 만들기 위한 파이썬 기초
- [05-web-server-python](../05-web-server-python/README.md) — 이 LED 제어판을 FastAPI 서버에 올리고, API·WebSocket 으로 연결

## 슬라이드

저장소 최상위에서 `npm run pdf -- 04-web`
