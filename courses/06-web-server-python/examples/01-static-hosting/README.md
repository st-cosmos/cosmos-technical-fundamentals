# 예제 01 — 정적 파일 호스팅

FastAPI 최소 서버가 **04 강좌의 LED 제어판(`static/`)** 을 내려줍니다. 페이지 동작은 04 와 같고(브라우저 안에서만 기록),
달라진 것은 **주소가 `http://` 가 되어 다른 기기에서도 열 수 있다**는 점입니다.

## 실행

```bash
uv run uvicorn main:app --reload
```

| 주소 | 내용 |
|------|------|
| http://localhost:8000/ | LED 제어판 (`static/index.html`) |
| http://localhost:8000/hello | `{"message": "안녕, 서버!"}` |
| http://localhost:8000/api/time | 서버 현재 시각 (요청마다 달라지는 동적 응답) |
| http://localhost:8000/docs | 자동 문서 |

다른 기기에서 접속: `uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000` 후 `http://<PC IP>:8000`

## 구조

```
01-static-hosting/
├── main.py            FastAPI 서버 (라우트 2개 + static mount)
├── pyproject.toml
└── static/            04-web-application/examples/01-led-panel 과 같은 파일
    ├── index.html
    ├── style.css
    └── app.js
```

> 📌 `app.mount("/")` 는 **맨 아래**. 위에서부터 매칭되므로 먼저 두면 `/hello` 까지 가로챕니다.

관련 실습: [`../../exercises/01-static-hosting.md`](../../exercises/01-static-hosting.md)
