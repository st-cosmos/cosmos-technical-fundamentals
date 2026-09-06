# 실습 01. uv 로 첫 프로젝트 만들고 실행

> 🎯 목표: `uv init` 으로 프로젝트를 만들고, `uv run` 으로 실행하고, `uv add` 로 패키지를 하나 넣어 본다.
> 앞으로 모든 파이썬 실습(06 서버 포함)의 출발점.
>
> 📎 관련 문서: [docs/01-uv-basics.md](../docs/01-uv-basics.md) · 완성 예: `examples/01-hello-uv/`

## 준비물

- 터미널 (Windows 는 PowerShell 7), `uv --version` 이 나오는 상태 (00 강좌)
- 인터넷 연결 (첫 실행 시 Python·패키지 다운로드)

## 1단계. 프로젝트 만들기

동아리 작업 폴더로 이동해서:

```bash
cd ~/workspace             # 프로젝트는 전부 ~/workspace 안에 (00 강좌 규칙)
uv init hello-uv           # 프로젝트 폴더 생성
cd hello-uv
ls                         # pyproject.toml, main.py, .python-version, README.md
```

`main.py` 를 열어 보세요. 이미 `main()` 함수와 `print(...)` 가 들어 있습니다.

## 2단계. 실행하기

```bash
uv run main.py
```

> 처음 실행 때 uv 가 가상환경(`.venv`)을 자동으로 만들고, 필요하면 Python 도 받습니다.
> `Hello from hello-uv!` 가 나오면 성공! 🎉  `ls -Force`(mac: `ls -a`) 로 `.venv` 폴더가 생겼는지 보세요.

## 3단계. 코드 고쳐 보기

`main.py` 의 `print` 를 f-string 으로 바꿔 봅니다.

```python
def main():
    name = input("이름: ").strip() or "익명"
    print(f"안녕, {name} 님! 파이썬 시작합니다.")


if __name__ == "__main__":
    main()
```

```bash
uv run main.py
```

> 💡 `if __name__ == "__main__":` 는 "이 파일을 직접 실행했을 때만 main() 을 부른다" 는 관용구입니다.
> 다른 파일에서 import 할 때는 실행되지 않습니다.

## 4단계. 패키지 추가해 보기

간단한 패키지(`cowsay`)를 추가해, 설치와 사용을 체험합니다.

```bash
uv add cowsay
```

`pyproject.toml` 의 `dependencies` 에 `cowsay` 가 추가되고 `uv.lock` 이 생긴 것을 확인하세요. 그리고 `main.py` 에:

```python
import cowsay

def main():
    name = input("이름: ").strip() or "익명"
    cowsay.cow(f"안녕, {name} 님!")
```

```bash
uv run main.py
```

소가 말풍선으로 인사하면 성공입니다. 🐄

## 5단계. 대화형 셸

```bash
uv run python
```

```
>>> 1 + 2
>>> "안녕" * 3
>>> import cowsay; cowsay.tux("펭귄도 됩니다")
>>> exit()
```

다음 문서(docs/02~04)의 코드는 여기에 쳐 보며 읽으세요.

## 6단계. 남이 만든 프로젝트 받아 보기 (재현성 체험)

이 저장소의 예제로 연습합니다.

```bash
cd ../../courses/05-python-programming/examples/01-hello-uv     # 경로는 본인 위치에 맞게
uv sync                    # uv.lock 대로 환경 재현 (pip install -r 대신)
uv run main.py
```

`uv sync` 한 줄로 **똑같은 버전**의 환경이 만들어집니다.

## 확인

- [ ] `uv init` 으로 `pyproject.toml` 이 생겼다
- [ ] `uv run main.py` 가 실행되고 `.venv/` 가 생겼다
- [ ] `uv add cowsay` 후 `pyproject.toml` 에 `cowsay`, `uv.lock` 파일이 생겼다
- [ ] `uv run python` 셸에서 한 줄 계산을 해 봤다
- [ ] 다른 프로젝트에서 `uv sync` 를 해 봤다

## 막히면?

| 증상 | 확인 |
|------|------|
| `uv: command not found` | 00 강좌 설치 확인. **터미널 새로 열기** |
| 다운로드가 느림/막힘 | 학교·회사 네트워크 방화벽일 수 있음 → 핫스팟으로 시도 |
| `uv add` 가 실패 | `uv init` 한 **프로젝트 폴더 안**에서 실행하는지 (`ls` 로 `pyproject.toml` 확인) |
| `ModuleNotFoundError: cowsay` | `python main.py` 로 실행하지 않았는지 — **`uv run`** 으로 |

➡️ 다음: [docs/02 파이썬 기초](../docs/02-python-basics.md) → [실습 02. LED 이력 기록기](02-led-logger.md)
