---
marp: true
theme: cosmos
paginate: true
footer: "04 · Python 프로그래밍"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 04</div>

# Python 프로그래밍

<div class="rule"></div>

<div class="subtitle">uv 로 프로젝트 관리 · 기초 문법 요약</div>

<div class="meta">
uv · 변수·조건·반복·함수 · 리스트·딕셔너리 · 파일·JSON·예외<br>
대상: 프로그래밍 언어를 하나 정도 살짝 본 부원
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. **uv** — Python 프로젝트·패키지·가상환경을 하나로 (`init` → `add` → `run`)
2. **기초 문법** — 변수·자료형·문자열·f-string·입출력
3. **조건·반복·함수** — `if` `for` `while` `def`
4. **컬렉션·모듈·파일·예외** — 리스트·딕셔너리·`import`·JSON·`try`
5. 🧪 **LED 이력 기록기** — 전부 써 보는 콘솔 프로그램

> 이 기초 위에 05 강좌의 **FastAPI 서버**가 올라갑니다. 딕셔너리 = 서버 상태 = JSON.

---

<!-- _class: section -->
<div class="eyebrow">PART 1</div>

# uv

<div class="lead-sub">설치·가상환경·패키지·실행을 하나로</div>

---

## 왜 uv?

| 예전엔 따로 | uv 로는 |
|-------------|--------|
| Python 설치 | `uv python install` (보통 자동) |
| 가상환경 `python -m venv` + `activate` | (자동 생성, `uv run` 이 알아서) |
| `pip install` | `uv add` |
| `requirements.txt` | `uv.lock` (자동) |
| `python main.py` | `uv run main.py` |

> ⚡ 빠르고 · 하나로 통합 · `uv.lock` 으로 **팀원 누구나 같은 환경**(`uv sync`). 동아리 공통 — `pip`/`venv` 안 씀.

---

## 프로젝트 한 바퀴

```bash
uv init hello-uv       # ① 프로젝트 생성 (pyproject.toml, main.py)
cd hello-uv
uv add requests        # ② 패키지 추가 (.venv 자동 + uv.lock 기록)
uv run main.py         # ③ 실행 (activate 불필요)
uv run python          # 대화형 셸 — 문법 실험은 여기서
```

| 파일 | 역할 | git |
|------|------|-----|
| `pyproject.toml` | 설정 + 의존성 목록 | 커밋 |
| `uv.lock` | 정확한 버전 | 커밋 |
| `.venv/` | 가상환경 | 제외 |

> 남의 프로젝트 받으면: `git clone` → `uv sync` → `uv run main.py`. 끝.

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# 기초 문법

<div class="lead-sub">세미콜론도 중괄호도 타입 선언도 없다</div>

---

## 변수 · 자료형 · 연산

```python
name = "철수"          # str        선언 키워드 없음, snake_case
count = 3              # int
ratio = 0.75           # float
is_on = True           # bool (대문자 True/False)
nothing = None

7 / 2, 7 // 2, 7 % 2, 2 ** 10      # 3.5, 3, 1, 1024
7 == 7, 1 < x < 10                 # 비교 · 범위 비교 한 번에
a and b, a or b, not a             # 영어 단어 (&& || ! 아님)

int("42"), str(42), float("3.5")   # 형 변환
```

> ⚠️ `"1" + 1` 은 오류 — JS 처럼 알아서 붙이지 않음. `int()`/`str()` 로 맞추기.

---

## 문자열 · f-string · 입출력

```python
s = "LED 제어판"
len(s), s[0], s[-1], s[0:3]          # 7, "L", "판", "LED"
s.strip(), s.lower(), s.split(" "), "LED" in s

f"{name} 님이 LED를 {'켰' if on else '껐'}습니다"    # ★ 문자열 조립은 f-string
f"전압={volt:.2f}V  밝기={ratio:.0%}"              # 서식

print("a", "b", sep=", ")
name = input("이름: ").strip()        # 항상 str → 숫자는 int(input(...))
```

```python
if is_on:
    print("켜짐")        # 블록 = 콜론(:) + 들여쓰기 4칸
print("블록 밖")
```

---

<!-- _class: section -->
<div class="eyebrow">PART 3</div>

# 조건 · 반복 · 함수

---

## if · for · while

```python
if raw > 3000:   level = "밝음"
elif raw > 1000: level = "중간"        # else if 아니라 elif
else:            level = "어두움"
label = "ON" if is_on else "OFF"       # 한 줄 조건식

for name in names:          print(name)          # 항목 순회 (인덱스 아님!)
for i in range(5):          print(i)             # 0~4
for i, n in enumerate(names): print(i, n)        # 번호 + 항목

while True:
    cmd = input("명령: ").strip()
    if cmd == "quit": break          # 탈출
    if cmd == "":     continue       # 다음 반복으로
```

---

## 함수 — def

```python
def set_led(on, by="익명"):              # 기본값
    state = "켰" if on else "껐"
    return f"{by} 님이 LED를 {state}습니다"

set_led(True)                           # '익명 님이 LED를 켰습니다'
set_led(by="영희", on=False)            # 키워드 인자

def read_sensor():
    return raw, volt                    # 여러 값 → 튜플
raw, volt = read_sensor()

def to_percent(raw: int, max_value: int = 4095) -> float:   # 타입 힌트 (FastAPI 가 검증에 사용)
    """raw 를 퍼센트로."""
    return raw / max_value * 100
```

> 함수 안 변수는 안에서만. 전역 수정은 `global` — 되도록 **인자로 받고 return** 으로.

---

<!-- _class: section -->
<div class="eyebrow">PART 4</div>

# 컬렉션 · 모듈 · 파일 · 예외

---

## 리스트 `[]` 와 딕셔너리 `{}` ★

```python
names = ["철수", "영희"]
names.append("민수");  names[0];  names[-1];  names[1:3];  len(names);  "영희" in names
volts = [r * 3.3 / 4095 for r in raws]          # 컴프리헨션 (map)
bright = [r for r in raws if r > 1000]          # (filter)

led = {"on": False, "by": "아직 아무도", "time": "-"}     # ← 05 서버의 상태 그대로
led["on"] = True;  led["by"];  led.get("x", 0);  "on" in led
for k, v in led.items(): print(k, v)

history = [ {"on": True, "by": "철수", "time": "14:03"}, ... ]   # 딕셔너리의 리스트 = 표
for h in history: print(f"[{h['time']}] {h['by']}")
```

<div class="small">튜플 <code>(a, b)</code> 변경 불가 · 집합 <code>{a, b}</code> 중복 없음</div>

---

## 모듈 · 파일 · JSON

```python
import json, random
from datetime import datetime
from pathlib import Path
datetime.now().strftime("%H:%M:%S")        # 05 서버가 time 을 만드는 방식
```

```python
with open("log.txt", "w", encoding="utf-8") as f:    # w 쓰기 · a 추가 · r 읽기
    f.write("한 줄\n")                                 # with → 자동으로 닫힘

text = json.dumps(led, ensure_ascii=False)   # dict → JSON 문자열 (True → true)
back = json.loads(text)                      # JSON → dict
json.dump(history, f, ensure_ascii=False, indent=2)   # 파일로
```

| Python | JSON |
|--------|------|
| `dict` / `list` | object / array |
| `True` `False` `None` | `true` `false` `null` |

---

## 예외 — try / except

```python
try:
    raw = int(input("값: "))
except ValueError:
    print("숫자를 입력하세요")

try:
    history = json.loads(FILE.read_text(encoding="utf-8"))
except FileNotFoundError:          # 첫 실행
    history = []
```

- 오류 **종류를 적기** — `except:` 만 쓰면 버그를 숨김
- Traceback 은 **마지막 줄부터** 읽기: `NameError` 오타 · `TypeError` 자료형 · `IndentationError` 들여쓰기

---

## 🧪 LED 이력 기록기 (exercises/02)

```python
led = {"on": False, "by": "아직 아무도", "time": "-"}
history = []

def set_led(on, by):
    led.update(on=on, by=by, time=now())
    history.append(dict(led))
    return led

while True:
    name = input("이름: ").strip() or "익명"
    cmd = input("명령: ").strip().lower()
    if cmd == "quit": break
    elif cmd == "on":  print(describe(set_led(True, name)))
    elif cmd == "off": print(describe(set_led(False, name)))
save()    # json.dump → history.json
```

> `led` 딕셔너리와 `set_led()` 가 05 강좌에서 **서버 상태와 `PUT /api/led`** 로 그대로 바뀝니다.

---

## 정리

- **uv**: `init` → `add` → `run`, 남의 것은 `sync`. `pip`/`venv`/`activate` 안 씀
- 문법: `이름 = 값`, 블록은 `:` + 들여쓰기, `and/or/not`, **f-string**
- `if/elif/else` · `for 항목 in 모음` · `while` + `break/continue` · `def` + 기본값·타입 힌트
- **리스트** `[]` · **딕셔너리** `{}` (= JSON = 서버 상태) · `import` · `with open` · `json` · `try/except`
- 실습 02 의 딕셔너리·함수가 05 의 서버가 된다

<div class="small">docs/ 코드는 <code>uv run python</code> 셸에 직접 쳐 보며 읽기 · 다음: 05-web-server-python</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">이제 실습</div>

# 직접 써 봅시다 🐍

<div class="rule"></div>

<div class="subtitle">exercises/01 uv 첫 프로젝트 → exercises/02 LED 이력 기록기</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>
