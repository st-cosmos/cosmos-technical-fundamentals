# 02. Python 기초 — 변수 · 자료형 · 문자열 · 입출력

## 한 줄 요약

> Python 은 **세미콜론도, 중괄호도, 타입 선언도 없습니다.** 들여쓰기가 블록이고, 변수는 `이름 = 값` 으로 끝.
> 이 문서는 문법 **요약**입니다 — 코드를 `uv run python` 셸에 직접 쳐 보며 읽으세요.

## 1. 첫 프로그램과 주석

```python
print("안녕, 파이썬!")      # 화면에 출력. 이게 주석 (# 뒤는 무시)
```

- 문장 끝에 `;` 없음. 한 줄 = 한 문장.
- **대소문자 구별**: `print` 와 `Print` 는 다름.
- 여러 줄 주석은 `"""..."""` 로 감싸기도 합니다 (문서 문자열).

## 2. 변수 — 이름표 붙이기

```python
name = "철수"          # 문자열
count = 3              # 정수
ratio = 0.75           # 실수
is_on = True           # 참/거짓 (True / False — 대문자!)
nothing = None         # "값 없음"

count = count + 1      # 다시 대입 OK
count += 1             # 같은 뜻 (+=, -=, *=, /=)
```

- `const`/`let`/`int` 같은 선언 키워드가 **없습니다.** 그냥 `이름 = 값`.
- 이름 규칙: 소문자 + 밑줄 (`led_state`, `press_count`) — **snake_case**. 숫자로 시작 불가.
- 한 변수에 다른 종류의 값을 넣어도 되지만(`x = 1` 뒤에 `x = "a"`), 헷갈리니 피하세요.

## 3. 자료형

| 자료형 | 예 | 확인 |
|--------|----|------|
| `int` 정수 | `42`, `-7`, `0` | `type(42)` → `<class 'int'>` |
| `float` 실수 | `3.14`, `2.0` | |
| `str` 문자열 | `"안녕"`, `'hi'` (따옴표 둘 다 됨) | |
| `bool` 참/거짓 | `True`, `False` | |
| `NoneType` | `None` | 아직 값이 없음 |
| `list`, `dict`, `tuple`, `set` | [04](04-collections-modules-files.md) | 여러 값 묶음 |

### 형 변환

```python
int("42")        # 42       문자열 → 정수
float("3.5")     # 3.5
str(42)          # "42"     숫자 → 문자열
int(3.9)         # 3        소수점 버림
bool(0), bool("")   # False, False  (0 · 빈 것은 거짓, 나머지는 참)
```

> ⚠️ `"1" + 1` 은 오류입니다 (문자열 + 정수). `int("1") + 1` 또는 `"1" + str(1)` 로 맞춰야 합니다.
> JavaScript 처럼 알아서 붙여 주지 않습니다.

## 4. 연산자

```python
7 + 2, 7 - 2, 7 * 2     # 9, 5, 14
7 / 2                   # 3.5   (나누기는 항상 실수)
7 // 2                  # 3     (몫)
7 % 2                   # 1     (나머지)
2 ** 10                 # 1024  (거듭제곱)

7 == 7, 7 != 3          # True, True   (같다 / 다르다)
7 > 3, 7 <= 3           # True, False
1 < x < 10              # 범위 비교를 한 번에 (파이썬만의 편리함)

True and False          # False  (그리고)
True or False           # True   (또는)
not True                # False  (부정)
```

> 💡 `&&` `||` `!` 가 아니라 **영어 단어** `and` `or` `not` 입니다.

## 5. 문자열

```python
s = "LED 제어판"
len(s)                  # 7        길이
s[0]                    # "L"      첫 글자 (0부터)
s[-1]                   # "판"     뒤에서 첫 글자
s[0:3]                  # "LED"    슬라이스 [시작:끝) — 끝은 포함 안 함
s.upper()               # "LED 제어판" (영문만 대문자)
s.lower()
"  hi  ".strip()        # "hi"     앞뒤 공백 제거 (입력 처리에 필수)
s.replace("LED", "램프")  # "램프 제어판"
s.split(" ")            # ["LED", "제어판"]  나누기 → 리스트
", ".join(["a", "b"])   # "a, b"   리스트 → 문자열
"on" in s               # False    포함 여부
s.startswith("LED")     # True
```

### f-string — 값을 문자열 안에 넣기 ★

```python
name, on = "철수", True
f"{name} 님이 LED를 {'켰' if on else '껐'}습니다"    # "철수 님이 LED를 켰습니다"
f"밝기: {0.7567:.1%}"                                # "밝기: 75.7%"
f"값={raw:4d}  전압={volt:.2f}V"                      # 자리수·소수점 서식
```

따옴표 앞에 `f` 를 붙이고 `{}` 안에 변수나 식을 넣습니다. **문자열 조립은 거의 항상 f-string** 을 쓰세요.

### 여러 줄 문자열

```python
msg = """첫 줄
둘째 줄"""
```

## 6. 입출력

```python
print("안녕", "철수", 3)          # 안녕 철수 3   (띄어쓰기로 이어 출력)
print("a", "b", sep=", ")        # a, b          (구분자 지정)
print("진행 중...", end="")      # 줄바꿈 없이

name = input("이름: ")           # 사용자 입력 → 항상 문자열(str)
age = int(input("나이: "))       # 숫자로 쓰려면 변환
```

> ⚠️ `input()` 은 **항상 문자열**을 돌려줍니다. `input("숫자: ") + 1` 은 오류. `int(...)` 로 감싸세요.

## 7. 들여쓰기가 문법이다

```python
if is_on:
    print("켜짐")          # 4칸 들여쓰기 = if 블록 안
    print("한 줄 더")
print("블록 밖")           # 들여쓰기 없음 = if 와 무관
```

- 블록은 `{}` 가 아니라 **콜론(`:`) + 들여쓰기**로 표현합니다.
- 들여쓰기는 **스페이스 4칸**이 표준. VS Code 가 Tab 키를 자동으로 4칸으로 바꿔 줍니다.
- 같은 블록은 **같은 깊이**여야 합니다. 섞이면 `IndentationError`.

## 8. 자주 만나는 오류 읽는 법

```
Traceback (most recent call last):
  File "main.py", line 3, in <module>       ← 어느 파일, 몇 번째 줄
    print(nmae)
NameError: name 'nmae' is not defined        ← 오류 종류: 무슨 문제
```

| 오류 | 뜻 | 흔한 원인 |
|------|----|-----------|
| `NameError` | 그런 이름 없음 | 오타, 정의 전 사용 |
| `TypeError` | 자료형이 안 맞음 | `"1" + 1`, `len(5)` |
| `ValueError` | 값이 잘못됨 | `int("abc")` |
| `IndentationError` | 들여쓰기 문제 | 스페이스/탭 혼용, 깊이 불일치 |
| `SyntaxError` | 문법 오류 | 콜론 빠짐, 괄호 안 닫힘 |

> 💡 **마지막 줄부터** 읽으세요. 오류 종류와 메시지가 거기 있고, 위로 올라가면 몇 번째 줄인지 나옵니다.

### (Windows) 한글·이모지 출력이 깨지거나 `UnicodeEncodeError`

한국어 Windows 콘솔의 기본 인코딩(cp949)이 원인입니다. 프로그램 맨 위에 두 줄을 넣으면 해결됩니다.

```python
import sys
sys.stdout.reconfigure(encoding="utf-8")
sys.stdin.reconfigure(encoding="utf-8")
```

(이 저장소의 예제는 모두 이 줄이 들어 있습니다. 또는 환경변수 `PYTHONUTF8=1` 을 설정해도 됩니다.)

## 정리

| 개념 | 파이썬 방식 |
|------|-------------|
| 변수 | `이름 = 값`, 선언 키워드 없음, snake_case |
| 자료형 | `int` `float` `str` `bool` `None`, 변환은 `int()` `str()` … |
| 논리 | `and` `or` `not`, 비교 `==` `!=` `<` |
| 문자열 | `len` `[i]` `[a:b]` `.strip()` `.split()` `in`, **f-string** |
| 입출력 | `print()`, `input()` (항상 str) |
| 블록 | `:` + 들여쓰기 4칸 |

➡️ [03. 조건 · 반복 · 함수](03-control-flow-and-functions.md)
