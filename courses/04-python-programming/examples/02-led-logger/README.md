# 예제 02 — LED 이력 기록기 (콘솔)

터미널에서 이름과 `on`/`off` 를 입력받아 LED 상태와 변경 이력을 기록하고, 종료 시 `history.json` 에 저장하는
프로그램입니다. 파이썬 기초 문법(변수·조건·반복·함수·리스트·딕셔너리·파일·예외)을 한 프로그램에 모두 썼습니다.

> 🔗 데이터 모양 `{"on", "by", "time"}` 은 **05-web-server-python 의 LED 서버와 같습니다.** 이 프로그램의 `set_led()`
> 가 05 강좌에서는 `PUT /api/led` 로, `led` 딕셔너리가 서버 상태로 그대로 옮겨집니다.

## 실행

```bash
uv run main.py
```

외부 패키지가 없어 바로 실행됩니다.

## 명령

| 명령 | 동작 |
|------|------|
| `on` / `off` (또는 `1` / `0`) | LED 켜기/끄기 — 이름·시각을 이력에 기록 |
| `list` | 최근 10건 이력 |
| `stats` | 켠/끈 횟수, 가장 많이 바꾼 사람 |
| `quit` (또는 Ctrl+C) | `history.json` 에 저장하고 종료 |

다시 실행하면 이전 이력과 마지막 상태가 복원됩니다. `history.json` 을 지우면 초기화.

## 코드에서 볼 것

| 부분 | 쓰인 문법 |
|------|-----------|
| `led`, `history` | 딕셔너리, 딕셔너리의 리스트 |
| `set_led()` | 함수, 인자, return, 딕셔너리 수정, `dict()` 복사 |
| `describe()`, `status_line()` | f-string, 삼항 조건식 |
| `print_history()` | 슬라이스 `[start:]`, `enumerate(start=)` |
| `print_stats()` | 리스트 컴프리헨션, `dict.get(k, 0)`, `max(key=)` |
| `load()` / `save()` | `pathlib.Path`, `json.loads/dumps`, `try/except`, `global` |
| `main()` | `while True` 입력 루프, `break`/`continue`, `input().strip().lower()` |

관련 실습: [`../../exercises/02-led-logger.md`](../../exercises/02-led-logger.md)
