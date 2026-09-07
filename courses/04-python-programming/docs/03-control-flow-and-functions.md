# 03. 조건 · 반복 · 함수

## 한 줄 요약

> `if / elif / else` 로 갈라지고, `for` 로 순회하고, `while` 로 조건이 참인 동안 반복하고, `def` 로 함수를 만듭니다.
> 전부 **콜론(`:`) + 들여쓰기** 구조입니다.

## 1. 조건문 — if / elif / else

```python
raw = 2500

if raw > 3000:
    level = "밝음"
elif raw > 1000:          # else if 가 아니라 elif
    level = "중간"
else:
    level = "어두움"

print(level)              # 중간
```

- 조건에 **괄호 불필요** (`if (raw > 3000)` 도 되지만 안 씀).
- 여러 조건: `if 0 < raw and raw < 4096:` 또는 `if 0 < raw < 4096:`
- **한 줄 조건식**(삼항): `label = "ON" if is_on else "OFF"`

### 참/거짓으로 취급되는 값

```python
if name:            # 빈 문자열 "" 이면 거짓, 뭐라도 있으면 참
if items:           # 빈 리스트 [] 는 거짓
if count:           # 0 은 거짓
if value is None:   # None 비교는 == 대신 is
```

## 2. for — 순회하기

파이썬의 `for` 는 "i 를 0 부터 n 까지" 가 아니라 **"모음 안의 각 항목에 대해"** 입니다.

```python
names = ["철수", "영희", "민수"]

for name in names:               # 각 항목에 대해
    print(name)

for i in range(5):               # 0, 1, 2, 3, 4   (횟수 반복은 range)
    print(i)

for i in range(1, 11, 2):        # 1, 3, 5, 7, 9   (시작, 끝 미포함, 간격)
    print(i)

for i, name in enumerate(names):     # 번호와 항목 함께
    print(i, name)                   # 0 철수 / 1 영희 / ...

for ch in "LED":                 # 문자열도 순회 가능
    print(ch)
```

> 💡 C 의 `for (int i = 0; i < n; i++)` 은 `for i in range(n):`. 그런데 대부분은 인덱스가 필요 없고
> 항목만 필요하니 `for item in items:` 를 먼저 떠올리세요.

## 3. while — 조건이 참인 동안

```python
count = 0
while count < 3:
    print("깜빡", count)
    count += 1

while True:                      # 무한 반복 (서버·메뉴 루프에 흔함)
    cmd = input("명령 (on/off/quit): ").strip()
    if cmd == "quit":
        break                    # 반복 탈출
    if cmd == "":
        continue                 # 이번 회차 건너뛰고 다음 반복으로
    print("받은 명령:", cmd)
```

| 키워드 | 뜻 |
|--------|----|
| `break` | 반복문을 즉시 빠져나감 |
| `continue` | 나머지를 건너뛰고 다음 반복으로 |

## 4. 함수 — def

```python
def greet(name):                     # 정의: def 이름(매개변수):
    return f"안녕, {name}!"          # 결과 돌려주기

message = greet("철수")              # 호출
print(message)                       # 안녕, 철수!
```

### 기본값·키워드 인자

```python
def set_led(on, by="익명"):          # by 는 안 주면 "익명"
    state = "켰" if on else "껐"
    return f"{by} 님이 LED를 {state}습니다"

set_led(True)                        # '익명 님이 LED를 켰습니다'
set_led(False, "영희")               # '영희 님이 LED를 껐습니다'
set_led(by="민수", on=True)          # 이름으로 지정 (순서 무관)
```

### 여러 값 돌려주기

```python
def read_sensor():
    raw = 2048
    volt = raw * 3.3 / 4095
    return raw, volt                 # 튜플로 묶여 반환

raw, volt = read_sensor()            # 받을 때 풀기
```

### return 이 없으면 None

```python
def log(msg):
    print(f"[LOG] {msg}")            # 돌려주는 값 없음 → None
```

### 타입 힌트 (선택이지만 권장)

```python
def to_percent(raw: int, max_value: int = 4095) -> float:
    return raw / max_value * 100
```

`raw: int` 는 "정수가 올 것" 이라는 **표시**일 뿐 강제하지 않습니다. 하지만 읽기 쉽고, VS Code 자동완성이 좋아지며,
05 강좌의 FastAPI 는 이 힌트를 **실제 검증**에 씁니다.

### 문서 문자열 (docstring)

```python
def clamp(value, low, high):
    """value 를 low~high 범위로 자른다."""
    return max(low, min(value, high))
```

## 5. 변수의 범위 (scope)

```python
total = 0                    # 전역 변수

def add(n):
    result = total + n       # 읽기는 OK
    return result            # result 는 함수 안에서만 존재

def reset():
    global total             # 함수 안에서 전역 변수를 바꾸려면 global 선언
    total = 0
```

> 💡 함수 안에서 만든 변수는 함수가 끝나면 사라집니다. 전역 변수를 함수에서 **바꾸는** 건 헷갈리기 쉬우니,
> 값을 **인자로 받고 return 으로 돌려주는** 스타일을 기본으로 하세요.

## 6. 작은 프로그램 — 지금까지를 합치면

```python
def describe(raw):
    """ADC 값(0~4095)을 설명 문장으로."""
    percent = raw / 4095 * 100
    if percent > 70:
        level = "밝음"
    elif percent > 30:
        level = "중간"
    else:
        level = "어두움"
    return f"raw={raw} ({percent:.0f}%) → {level}"

for raw in [100, 2000, 4000]:
    print(describe(raw))
```

```
raw=100 (2%) → 어두움
raw=2000 (49%) → 중간
raw=4000 (98%) → 밝음
```

## 정리

| 구문 | 형태 |
|------|------|
| 조건 | `if 조건:` / `elif 조건:` / `else:` · 한 줄 `a if 조건 else b` |
| 반복 | `for 항목 in 모음:` · `for i in range(n):` · `while 조건:` · `break` / `continue` |
| 함수 | `def 이름(인자, 기본=값):` … `return 값` · 타입 힌트 `-> float` |
| 범위 | 함수 안 변수는 안에서만. 전역 수정은 `global` (되도록 피하기) |

➡️ [04. 컬렉션 · 모듈 · 파일 · 예외](04-collections-modules-files.md)
