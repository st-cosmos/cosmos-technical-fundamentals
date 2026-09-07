# 실습 02. LED 이력 기록기 (콘솔) ★

> 🎯 목표: 터미널에서 이름과 `on`/`off` 를 입력받아 **LED 상태와 변경 이력을 기록**하고, 종료해도 남도록 **JSON 파일에
> 저장**하는 프로그램을 만든다. 변수·조건·반복·함수·리스트·딕셔너리·파일·예외를 **전부** 씁니다.
> 03 강좌의 LED 제어판(웹)을 **글자 화면**으로 만드는 것이고, 05 강좌에서는 이것이 **서버**가 됩니다.
>
> 📎 관련 문서: [docs/02](../docs/02-python-basics.md) · [03](../docs/03-control-flow-and-functions.md) ·
> [04](../docs/04-collections-modules-files.md) · 완성 코드: `examples/02-led-logger/`

## 만들 것

```
$ uv run main.py
💡 LED 이력 기록기 (명령: on / off / list / quit)
현재 상태: ⚪ OFF

이름: 철수
명령: on
→ [14:03:05] 철수 님이 LED를 켰습니다
현재 상태: 🟡 ON  (마지막: 철수, 14:03:05)

이름: 영희
명령: list
  1. [14:03:05] 철수 켬
현재 상태: 🟡 ON  (마지막: 철수, 14:03:05)

이름:
명령: quit
기록 1건을 history.json 에 저장했습니다. 안녕!
```

다시 실행하면 이전 기록이 **파일에서 불러와져** 이어집니다.

## 1단계. 프로젝트 만들기

```bash
uv init led-logger
cd led-logger
```

외부 패키지는 필요 없습니다 (표준 라이브러리만).

## 2단계. 상태와 이력 — 데이터 모양 정하기

`main.py` 맨 위에 데이터 구조를 정합니다. **05 강좌 서버와 같은 모양**입니다.

```python
import json
from datetime import datetime
from pathlib import Path

FILE = Path("history.json")           # 이력 저장 파일 (실행한 폴더 기준)

led = {"on": False, "by": "아직 아무도", "time": "-"}     # 현재 상태
history = []                                               # [{on, by, time}, ...]
```

## 3단계. 함수 만들기

작은 함수로 나눕니다. 하나씩 만들고 `uv run python` 에서 `from main import *` 로 시험해도 좋습니다.

```python
def now():
    """현재 시각을 HH:MM:SS 문자열로."""
    return datetime.now().strftime("%H:%M:%S")


def set_led(on, by):
    """상태를 바꾸고 이력에 한 줄 추가한 뒤, 안내 문장을 돌려준다."""
    led["on"] = on
    led["by"] = by
    led["time"] = now()
    history.append({"on": on, "by": by, "time": led["time"]})
    state = "켰" if on else "껐"
    return f"[{led['time']}] {by} 님이 LED를 {state}습니다"


def status_line():
    lamp = "🟡 ON" if led["on"] else "⚪ OFF"
    if led["time"] == "-":
        return f"현재 상태: {lamp}"
    return f"현재 상태: {lamp}  (마지막: {led['by']}, {led['time']})"


def print_history():
    if not history:
        print("  (기록 없음)")
        return
    for i, h in enumerate(history, start=1):
        print(f"  {i}. [{h['time']}] {h['by']} {'켬' if h['on'] else '끔'}")
```

## 4단계. 파일 저장·불러오기

```python
def load():
    """파일이 있으면 이력을 불러오고 마지막 항목으로 현재 상태를 복원한다."""
    global history
    try:
        history = json.loads(FILE.read_text(encoding="utf-8"))
    except FileNotFoundError:
        history = []                      # 첫 실행
    except json.JSONDecodeError:
        print("⚠️ history.json 이 손상되어 새로 시작합니다")
        history = []
    if history:
        last = history[-1]
        led.update(on=last["on"], by=last["by"], time=last["time"])


def save():
    FILE.write_text(json.dumps(history, ensure_ascii=False, indent=2), encoding="utf-8")
```

> 💡 `led.update(...)` 는 딕셔너리 여러 키를 한 번에 바꿉니다. `global history` 는 함수 안에서 전역 리스트를
> **새로 대입**하기 때문에 필요합니다. (`history.append` 처럼 내용만 바꿀 땐 필요 없음)

## 5단계. 메인 루프

```python
def main():
    load()
    print("💡 LED 이력 기록기 (명령: on / off / list / quit)")
    print(status_line())

    while True:
        name = input("\n이름: ").strip() or "익명"
        cmd = input("명령: ").strip().lower()

        if cmd == "quit":
            break
        elif cmd == "on":
            print("→", set_led(True, name))
        elif cmd == "off":
            print("→", set_led(False, name))
        elif cmd == "list":
            print_history()
        else:
            print(f"알 수 없는 명령: {cmd}")
            continue                      # 상태 줄 출력 생략
        print(status_line())

    save()
    print(f"기록 {len(history)}건을 {FILE} 에 저장했습니다. 안녕!")


if __name__ == "__main__":
    main()
```

## 6단계. 실행

```bash
uv run main.py
```

`on`/`off` 를 몇 번 넣고 `quit` 으로 나온 뒤 `cat history.json` 으로 파일을 보고, **다시 실행**해 이력이 이어지는지 확인하세요.

## 확인

- [ ] `on`/`off` 입력에 따라 상태 줄이 바뀐다
- [ ] `list` 로 이력이 번호와 함께 나온다
- [ ] 이름을 비우면 `익명` 이 된다
- [ ] `quit` 후 `history.json` 이 생기고, 재실행 시 이력·상태가 복원된다
- [ ] 알 수 없는 명령을 넣어도 프로그램이 죽지 않는다

## 막히면?

| 증상 | 확인 |
|------|------|
| `IndentationError` | 들여쓰기 4칸 통일. 탭/스페이스 혼용 여부 |
| `KeyError: 'on'` | 딕셔너리 키 오타 (`"on"`, `"by"`, `"time"`) |
| `NameError: history` | `global history` 가 `load()` 안에 있는지 |
| 한글이 `이` 로 저장됨 | `json.dumps(..., ensure_ascii=False)` |
| 파일이 이상한 곳에 생김 | 경로는 **실행한 폴더 기준** — `pwd` 확인 ([01-cli 경로](../../01-cli/docs/03-paths.md)) |

## 더 해보기 (도전 과제)

1. **켠 횟수 통계**: `stats` 명령 → "켠 횟수 N, 끈 횟수 M, 가장 많이 바꾼 사람 OOO" (딕셔너리로 이름별 카운트)
2. **최근 5건만**: `list` 가 최근 5건만 보여 주게 (`history[-5:]`)
3. **입력 검증**: 이름이 20자를 넘으면 잘라내기, `on`/`off` 대신 `1`/`0` 도 받기
4. **함수 분리**: 명령 처리 부분을 `handle(cmd, name)` 함수로 빼서 `main()` 을 짧게
5. **05 예습**: `set_led` 가 딕셔너리를 **return** 하도록 바꿔 보기 — 05 강좌의 `PUT /api/led` 가 정확히 이 함수입니다

## 🎓 마무리

축하합니다! 파이썬 기초 문법을 **동작하는 프로그램**으로 묶어 봤습니다. 이 프로그램의 `led` 딕셔너리와 `set_led()` 함수는
05 강좌에서 **FastAPI 서버의 상태와 API** 로 거의 그대로 옮겨집니다.

➡️ 다음 강좌: [05-web-server-python](../../05-web-server-python/README.md)
