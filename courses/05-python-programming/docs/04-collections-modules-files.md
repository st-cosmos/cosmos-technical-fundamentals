# 04. 컬렉션 · 모듈 · 파일 · 예외

## 한 줄 요약

> 여러 값을 담는 **리스트 `[]`** 와 이름으로 찾는 **딕셔너리 `{}`** 가 파이썬 데이터의 90%. 여기에 `import` 로 모듈을
> 가져오고, 파일을 읽고 쓰고(JSON), `try/except` 로 오류를 다루면 실용적인 프로그램을 만들 수 있습니다.
> 06 강좌의 서버 상태 `{"on": True, "by": "철수"}` 가 바로 딕셔너리입니다.

## 1. 리스트 — 순서 있는 모음

```python
names = ["철수", "영희"]
names.append("민수")          # 끝에 추가 → ["철수", "영희", "민수"]
names.insert(0, "관리자")     # 맨 앞에 넣기
names[0]                      # "관리자"      (0부터)
names[-1]                     # "민수"        (뒤에서 첫)
names[1:3]                    # ["철수", "영희"]  슬라이스
len(names)                    # 4
"영희" in names               # True
names.remove("관리자")        # 값으로 삭제
names.pop()                   # 마지막 항목 꺼내며 삭제
names.sort()                  # 정렬 (원본 변경)
sorted(names, reverse=True)   # 정렬된 새 리스트
names.reverse()

for name in names:            # 순회
    print(name)
```

### 리스트 컴프리헨션 — 한 줄로 새 리스트

```python
raws = [100, 2000, 4000]
volts = [r * 3.3 / 4095 for r in raws]            # 각 항목 변환
bright = [r for r in raws if r > 1000]             # 조건에 맞는 것만 → [2000, 4000]
```

JS 의 `map`/`filter` 에 해당합니다. 처음엔 `for` 문으로 써도 되지만 파이썬 코드에서 매우 자주 보이니 읽을 줄은 알아야 합니다.

## 2. 딕셔너리 — 이름(키)으로 찾는 모음 ★

```python
led = {"on": False, "by": "아직 아무도", "time": "-"}

led["on"]                     # False         키로 읽기
led["on"] = True              # 바꾸기
led["count"] = 1              # 새 키 추가
led.get("brightness", 0)      # 없으면 기본값 0 (KeyError 방지)
"by" in led                   # True          키 존재 여부
del led["count"]              # 삭제
led.keys(), led.values()      # 키 목록 / 값 목록
len(led)

for key, value in led.items():        # 키·값 함께 순회
    print(key, "=", value)
```

- 키는 보통 문자열, 값은 무엇이든 (숫자·문자열·리스트·다른 딕셔너리).
- **JSON 과 모양이 같아서** 서버가 주고받는 데이터가 그대로 딕셔너리가 됩니다.

### 딕셔너리의 리스트 — 표 같은 데이터

```python
history = [
    {"on": True,  "by": "철수", "time": "14:03:05"},
    {"on": False, "by": "영희", "time": "14:05:10"},
]
history.append({"on": True, "by": "민수", "time": "14:06:00"})

for h in history:
    state = "켰" if h["on"] else "껐"
    print(f"[{h['time']}] {h['by']} 님이 LED를 {state}습니다")

on_count = len([h for h in history if h["on"]])     # 켠 횟수
```

이 구조가 실습 02(LED 이력 기록기)와 06 강좌 서버의 핵심 데이터입니다.

## 3. 튜플과 집합 (짧게)

```python
point = (10, 20)              # 튜플: 리스트와 같지만 변경 불가. 함수가 여러 값 돌려줄 때
x, y = point                  # 풀기(unpacking)

tags = {"led", "esp32", "led"}   # 집합: 중복 없음 → {"led", "esp32"}
"led" in tags                 # 빠른 포함 검사
set([1, 2, 2, 3])             # 리스트 중복 제거 → {1, 2, 3}
```

## 4. 모듈 — 남이 만든 코드 가져오기

```python
import math
math.sqrt(16)                 # 4.0

from datetime import datetime
datetime.now().strftime("%H:%M:%S")     # "14:03:05"  ← 06 서버가 time 을 만드는 방식

import random
random.randint(0, 4095)       # 가짜 센서 값

import json                   # 아래 6절
from pathlib import Path      # 파일 경로 다루기
```

| 형태 | 사용 |
|------|------|
| `import 모듈` | `모듈.함수()` 로 사용 |
| `from 모듈 import 이름` | `이름()` 으로 바로 사용 |
| `import 모듈 as 별명` | `별명.함수()` |

- **표준 라이브러리**(`math`, `json`, `datetime`, `random`, `pathlib`, `time`, `os`…)는 설치 없이 바로 import.
- **외부 패키지**(`fastapi`, `requests`…)는 `uv add 패키지` 후 import. ([01](01-uv-basics.md))

### 내 파일도 모듈

`utils.py` 에 함수를 만들어 두면 `main.py` 에서 `from utils import clamp` 로 가져옵니다. 같은 폴더면 됩니다.

## 5. 파일 읽고 쓰기

```python
# 쓰기 (덮어쓰기). encoding 은 한글 깨짐 방지로 항상 지정
with open("log.txt", "w", encoding="utf-8") as f:
    f.write("첫 줄\n")
    f.write("둘째 줄\n")

# 이어 쓰기
with open("log.txt", "a", encoding="utf-8") as f:
    f.write("추가된 줄\n")

# 읽기
with open("log.txt", "r", encoding="utf-8") as f:
    content = f.read()            # 전체를 문자열로
    # 또는  for line in f:  줄 단위 순회
```

- `with open(...) as f:` 블록이 끝나면 **파일이 자동으로 닫힙니다.** 항상 이 형태로.
- 모드: `"r"` 읽기(기본) · `"w"` 쓰기(덮어씀) · `"a"` 추가.
- 경로는 **프로그램을 실행한 폴더 기준** 상대 경로 ([01-cli 경로](../../01-cli/docs/03-paths.md)). 스크립트 파일 위치 기준으로
  하려면 `Path(__file__).parent / "log.txt"`.

## 6. JSON — 딕셔너리를 파일/네트워크로

**JSON** 은 딕셔너리·리스트를 글자로 적은 형식입니다. 파일에 저장하거나 서버와 주고받을 때 씁니다.

```python
import json

led = {"on": True, "by": "철수", "time": "14:03:05"}

text = json.dumps(led, ensure_ascii=False)      # 딕셔너리 → JSON 문자열
# '{"on": true, "by": "철수", "time": "14:03:05"}'   (True → true 로 바뀜에 주목)

back = json.loads(text)                          # JSON 문자열 → 딕셔너리
back["by"]                                       # "철수"

# 파일로
with open("led.json", "w", encoding="utf-8") as f:
    json.dump(history, f, ensure_ascii=False, indent=2)     # 보기 좋게 저장

with open("led.json", "r", encoding="utf-8") as f:
    history = json.load(f)
```

| Python | JSON |
|--------|------|
| `dict` `{}` | object `{}` |
| `list` `[]` | array `[]` |
| `True` / `False` / `None` | `true` / `false` / `null` |
| `"문자열"` | `"문자열"` (큰따옴표만) |

> 💡 `ensure_ascii=False` 를 빼면 한글이 `이` 처럼 저장됩니다. 동작은 하지만 읽기 어려우니 붙이세요.

## 7. 예외 처리 — try / except

오류가 나면 프로그램이 죽습니다. 예상되는 오류는 잡아서 처리합니다.

```python
try:
    raw = int(input("값(0~4095): "))
except ValueError:
    print("숫자를 입력하세요")
    raw = 0

try:
    with open("led.json", encoding="utf-8") as f:
        history = json.load(f)
except FileNotFoundError:        # 첫 실행이라 파일이 없을 때
    history = []
```

```python
try:
    ...
except (ValueError, TypeError) as e:     # 여러 종류 한 번에, 오류 객체를 e 로
    print("문제:", e)
else:
    ...                                  # 오류가 없었을 때만
finally:
    ...                                  # 항상 실행 (정리 작업)
```

> ⚠️ `except:` 만 쓰면 **모든** 오류를 삼켜 버려 버그를 숨깁니다. 어떤 오류인지 **종류를 적으세요.**
> 직접 오류를 내려면 `raise ValueError("범위 초과")`.

## 8. 작은 프로그램 — 전부 합치기

```python
import json
from datetime import datetime
from pathlib import Path

FILE = Path("history.json")

def load():
    try:
        return json.loads(FILE.read_text(encoding="utf-8"))
    except FileNotFoundError:
        return []

def save(history):
    FILE.write_text(json.dumps(history, ensure_ascii=False, indent=2), encoding="utf-8")

history = load()
history.append({"on": True, "by": "철수", "time": datetime.now().strftime("%H:%M:%S")})
save(history)
print(f"기록 {len(history)}건 저장")
```

이 30줄이 실습 02 의 뼈대이고, 여기에 `while True` 입력 루프를 붙이면 LED 이력 기록기가 됩니다. 06 강좌에서는 같은
딕셔너리를 **파일 대신 HTTP 로** 주고받게 바뀔 뿐입니다.

## 정리

| 구조 | 만들기 | 읽기 | 쓰기 | 순회 |
|------|--------|------|------|------|
| 리스트 | `[a, b]` | `x[0]`, `x[-1]`, `x[1:3]` | `x.append(v)` | `for v in x` |
| 딕셔너리 | `{"k": v}` | `d["k"]`, `d.get("k", 기본)` | `d["k"] = v` | `for k, v in d.items()` |
| 튜플 | `(a, b)` | `t[0]`, `a, b = t` | 불가 | `for v in t` |
| 집합 | `{a, b}` | `v in s` | `s.add(v)` | `for v in s` |

- `import` / `from ... import ...` · 외부 패키지는 `uv add`
- `with open(path, mode, encoding="utf-8") as f:` · JSON 은 `json.dump/load` (`ensure_ascii=False`)
- `try: ... except 오류종류: ...`

## 🎓 마무리

파이썬 기초 문법 요약 끝! 🧪 [`exercises/02-led-logger.md`](../exercises/02-led-logger.md) 에서 배운 것을 전부 써 봅니다.
그다음 [06-web-server-python](../../06-web-server-python/README.md) 으로.
