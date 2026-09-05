# 실습 02. LED API — GET / PUT `/api/led`

> 🎯 목표: 실습 01 의 서버에 **API** 를 붙인다. `GET /api/led`(상태 조회)와 `PUT /api/led`(상태 변경)를 만들고,
> 브라우저와 **자동 문서 `/docs`** 에서 직접 테스트한다.
>
> 📎 관련 문서: [docs/03-rest-api.md](../docs/03-rest-api.md) · 완성 코드: `examples/02-led-api/main.py` (API 부분)

## 준비물

- [실습 01](01-static-hosting.md) 의 프로젝트 (`uv init` + fastapi·uvicorn 추가 완료)
- 웹 브라우저(크롬 권장)

## 전체 흐름

```
main.py 에 led 상태 + GET/PUT 라우트 추가 → uv run 실행
   → 브라우저로 GET 확인 → /docs 에서 PUT 테스트
```

## 1단계. 프로젝트 열기

실습 01 에서 만든 폴더(`led-server`)로 이동합니다. 새로 시작하려면 `uv init led-server && cd led-server && uv add fastapi "uvicorn[standard]"`.

## 2단계. API 코드 작성

`main.py` 를 아래처럼 만듭니다. **정적 파일 mount 는 잠시 빼고** API 만 먼저 확인합니다. (실습 03 에서 다시 합칩니다)

```python
from datetime import datetime
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# LED 상태를 메모리에 저장 — 서버를 끄면 초기화됩니다
led = {"on": False, "by": "아직 아무도", "time": "-"}


class LedCommand(BaseModel):
    """PUT 으로 받을 데이터의 모양 (켤지/끌지 + 누가 바꿨는지)."""

    on: bool
    by: str


@app.get("/api/led")
def get_led():
    """현재 LED 상태를 돌려준다."""
    return led


@app.put("/api/led")
def set_led(cmd: LedCommand):
    """{on, by} 를 받아 상태를 바꾸고, 시각(time)을 붙여 저장한다."""
    led["on"] = cmd.on
    led["by"] = cmd.by
    led["time"] = datetime.now().strftime("%H:%M:%S")
    return led
```

> 📌 상태는 `{on, by, time}` 형태입니다. PUT 은 `{on, by}` 만 받고, **시각(time)은 서버가
> 붙입니다.** 05 강좌의 LED 이력 기록기와 같은 모양이고, 실습 03·ESP32 펌웨어도 이 규칙을 따릅니다.

## 3단계. 서버 실행

`main.py` 가 있는 폴더에서:

```bash
uv run uvicorn main:app --reload
```

`Uvicorn running on http://127.0.0.1:8000` 같은 줄이 뜨면 성공입니다.
끄려면 터미널에서 **Ctrl+C**.

> 💡 `uv run` = `.venv` 안에서 실행(activate 불필요). `main:app` = `main.py` 파일의 `app` 변수.
> `--reload` 는 코드를 고치면 자동 재시작.

## 4단계. 브라우저로 GET 확인

브라우저에서 열어 봅니다.

| 주소 | 보이는 것 |
|------|-----------|
| http://localhost:8000/api/led | `{"on":false,"by":"아직 아무도","time":"-"}` (초기 상태) |

## 5단계. `/docs` 에서 PUT 테스트

진짜 재미는 여기! **http://localhost:8000/docs** 를 엽니다.

1. **`PUT /api/led`** 항목을 펼치고 **"Try it out"** 클릭
2. 요청 바디에 다음을 입력:
   ```json
   { "on": true, "by": "철수" }
   ```
3. **Execute** → 아래 Response 에 `{"on": true, "by": "철수", "time": ...}` 가 보이면 성공 🎉
4. 다시 브라우저로 http://localhost:8000/api/led 를 열면, 방금 바꾼 상태가
   `time` 까지 붙어 들어 있습니다.

> 💡 별도 도구(Postman 등) 없이 `/docs` 만으로 GET·PUT 을 모두 테스트할 수 있습니다.
> FastAPI 가 코드에서 문서를 **자동 생성**해 주기 때문이에요.

## 확인

- [ ] `/api/led` GET 이 `{on, by, time}` 객체를 돌려준다
- [ ] `/docs` 에서 PUT 하면 바뀐 상태가 돌아온다
- [ ] PUT 후 GET 하면 방금 바꾼 `on`·`by`·`time` 이 보인다
- [ ] 서버를 껐다 켜면 상태가 다시 `false` 로 초기화된다(메모리 저장이라 정상)

## 막히면?

| 증상 | 확인 |
|------|------|
| `uvicorn: command not found` | `uv run` 으로 실행했는지, `uv add` 로 추가했는지 |
| `http://localhost:8000/` 가 404 | 정상 — 이 실습은 API 만 있음. 페이지는 실습 03 에서 다시 붙임 |
| `ModuleNotFoundError: fastapi` | `uv add fastapi "uvicorn[standard]"` 다시 |
| 브라우저에서 접속 안 됨 | 서버가 떠 있는지(터미널 로그), 주소가 `localhost:8000` 인지 |
| PUT 이 `422` | 바디 JSON 형식 오류 — `on` 은 true/false, 키 큰따옴표, 마지막 쉼표 없는지 |
| `Address already in use` | 다른 서버가 8000 사용 중 → 끄거나 `--port 8001` |

## 더 해보기 (도전 과제)

1. **기본값 처리**: `by` 가 빈 문자열이면 `익명` 으로 저장하기.
2. **상태 하나 더**: `fan`(선풍기) 상태를 추가해 `GET/PUT /api/fan` 만들어 보기.
3. **다른 기기에서 접속**: `uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000` 으로
   띄우고, 같은 WiFi의 다른 기기에서 `http://(PC의 IP):8000/docs` 접속해 보기.
   (ESP32도 이렇게 접속합니다!)

> 📦 완성 코드: [`examples/02-led-api/main.py`](../examples/02-led-api/main.py) 의 API 부분 (정적 파일 mount 는 실습 03)

➡️ 다음: [실습 03. LED 제어판 연결 (fetch + PUT + polling) ★](03-led-control.md)
