# 01. uv — Python 프로젝트 관리

## 한 줄 요약

> **uv = Python 버전 설치 · 가상환경 · 패키지 설치 · 프로젝트 관리를 하나로 처리하는 초고속 도구.**
> 동아리는 `pip`/`venv`/`pyenv` 대신 **uv 하나**로 통일합니다. 흐름은 `uv init` → `uv add` → `uv run` 세 개.

## 1. uv 가 뭔가요? 왜 쓰나요?

`uv` 는 Python 개발에 필요한 여러 도구를 **하나로 합친** 도구입니다. (Rust 로 만들어져 아주 빠릅니다.)

| 예전엔 이렇게 따로 | uv 로는 |
|--------------------|--------|
| Python 설치 (python.org / pyenv) | `uv python install` |
| 가상환경 만들기 (`python -m venv`) | (uv 가 **자동** 생성) |
| 패키지 설치 (`pip install`) | `uv add` |
| 버전 고정 (`requirements.txt`) | `uv.lock` (자동) |
| 프로젝트 실행 (activate 후 python) | `uv run` |

**왜 uv 를 쓰나:**

- ⚡ **빠름**: 설치가 pip 보다 수십 배 빠릅니다.
- 📦 **하나로 통합**: 도구를 여러 개 배울 필요 없이 `uv` 하나면 됩니다.
- 🔁 **재현성**: `uv.lock` 에 설치된 정확한 버전이 기록돼, 팀원 누구나 `uv sync` 한 줄로 **똑같은 환경**을 만듭니다.
- 🐍 **Python 도 관리**: 시스템에 어떤 Python 이 있든, 프로젝트가 필요한 버전을 uv 가 받아 씁니다.

> 💡 그래서 이 저장소의 모든 파이썬 예제는 `pip install ...` / `python -m venv ...` 를 **쓰지 않습니다.**
> 06 강좌의 서버도 `uv run uvicorn ...` 으로 실행합니다.

## 2. 설치 확인

00 강좌에서 이미 설치했습니다. 확인만:

```bash
uv --version        # uv 0.x.x
```

> 없으면 Windows `winget install --id astral-sh.uv`, macOS `brew install uv`. 설치 후 **터미널 새로 열기**.

## 3. 가상환경이 왜 필요한가 (개념만)

프로젝트 A 는 라이브러리 X 의 1.0 이, 프로젝트 B 는 2.0 이 필요하다면? 전역에 하나만 설치하면 충돌합니다.
그래서 **프로젝트마다 독립된 패키지 창고(가상환경, `.venv/`)** 를 둡니다.

예전엔 이 창고를 직접 만들고(`python -m venv`) 켜야(`activate`) 했지만, **uv 는 자동으로 만들고 `uv run` 이 알아서
그 안에서 실행**합니다. 여러분은 `.venv` 폴더가 있다는 것만 알면 됩니다. (git 에는 올리지 않음)

## 4. 프로젝트 한 바퀴 — init → add → run

```bash
uv init hello-uv           # ① 새 프로젝트 폴더 생성 (pyproject.toml, main.py 등)
cd hello-uv

uv add requests            # ② 패키지 추가 (.venv 자동 생성 + 설치 + uv.lock 기록)

uv run main.py             # ③ 프로젝트 환경에서 실행 (activate 불필요)
```

### 만들어지는 파일들

```
hello-uv/
├── pyproject.toml     프로젝트 설정 + 의존성 목록 (사람이 읽고 편집)  → 커밋
├── uv.lock            설치된 정확한 버전 기록 (자동 생성, 손대지 않음) → 커밋
├── .python-version    이 프로젝트가 쓰는 Python 버전                  → 커밋
├── main.py            시작 코드
├── README.md
└── .venv/             가상환경 (자동 생성)                            → .gitignore
```

`pyproject.toml` 은 이렇게 생겼습니다.

```toml
[project]
name = "hello-uv"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "requests>=2.32",        # uv add 가 여기에 추가
]
```

## 5. 자주 쓰는 명령

| 명령 | 하는 일 |
|------|---------|
| `uv init <이름>` | 새 프로젝트 생성. 이미 있는 폴더 안에서는 `uv init` (이름 없이) |
| `uv add <패키지>` | 의존성 추가 (`pyproject.toml`+`uv.lock` 갱신, `.venv` 에 설치) |
| `uv remove <패키지>` | 의존성 제거 |
| `uv run <명령>` | 프로젝트 가상환경 안에서 실행 — `uv run main.py`, `uv run python`, `uv run uvicorn main:app` |
| `uv sync` | `uv.lock` 대로 환경을 똑같이 맞추기 (남이 만든 프로젝트를 받았을 때 첫 명령) |
| `uv python install 3.12` | Python 3.12 설치 (보통 자동이라 직접 할 일 적음) |
| `uv python list` | 설치된/설치 가능한 Python 목록 |
| `uvx <도구>` | 설치 없이 도구 바로 실행 (예: `uvx ruff check .`) — npx 같은 느낌 |

> 💡 **남의 프로젝트를 받았다면**: `git clone` → 폴더로 이동 → `uv sync` → `uv run main.py`. 끝.
> `requirements.txt` 를 읽고 `pip install -r` 하던 시절의 모든 단계가 `uv sync` 하나입니다.

## 6. 대화형 셸 — 한 줄씩 실험하기

문법을 배울 때 가장 좋은 도구는 **대화형 셸(REPL)** 입니다. 한 줄 치면 바로 결과가 나옵니다.

```bash
uv run python          # 프로젝트 폴더 안에서 (프로젝트 밖이면 그냥 python)
```

```
>>> 1 + 2
3
>>> "안녕" * 3
'안녕안녕안녕'
>>> exit()             # 나가기 (또는 Ctrl + Z → Enter / macOS Ctrl + D)
```

다음 문서들의 코드 조각은 **이 셸에 직접 쳐 보면서** 읽으세요.

## 7. pip/venv 를 알던 사람을 위한 비교

| 예전 (pip + venv) | uv |
|-------------------|-----|
| `python -m venv .venv` | (불필요 — 자동) |
| `.venv\Scripts\activate` | (불필요 — `uv run` 이 알아서) |
| `pip install fastapi` | `uv add fastapi` |
| `pip install -r requirements.txt` | `uv sync` |
| `python main.py` | `uv run main.py` |
| `uvicorn main:app --reload` | `uv run uvicorn main:app --reload` |

## 다음 단계

🧪 실습 [`exercises/01-uv-first-project.md`](../exercises/01-uv-first-project.md) 로 첫 프로젝트를 만들어 실행한 뒤,
파이썬 문법으로 넘어갑니다.

➡️ [02. Python 기초 — 변수·자료형·문자열](02-python-basics.md)
