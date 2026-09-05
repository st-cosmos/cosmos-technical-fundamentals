# 05. Python 프로그래밍 — 기초 문법 + uv

동아리에서 서버(FastAPI)·스크립트·데이터 처리에 쓰는 **Python** 의 기초 문법을 **요약 중심**으로 정리하고,
파이썬 프로젝트를 관리하는 동아리 표준 도구 **uv** 사용법을 익힙니다.

> 🎯 이 자료를 끝내면: `uv init` 으로 프로젝트를 만들고 `uv add` 로 패키지를 넣고 `uv run` 으로 실행할 수 있으며,
> 변수·조건·반복·함수·리스트·딕셔너리·파일·예외를 써서 작은 콘솔 프로그램(LED 이력 기록기)을 만들 수 있습니다.
> 이 기초 위에 [06-web-server-python](../06-web-server-python/README.md) 의 FastAPI 서버가 올라갑니다.

## 누구를 위한 자료인가

- **대상**: 프로그래밍 언어를 하나 정도 살짝 본 부원 (C/C++ 조금, 또는 04 강좌의 JS 정도)
- **선수**: [00](../00-dev-environment-setup/README.md) (Python · uv 설치), [01-cli](../01-cli/README.md)
- **도구**: 터미널 + VS Code (+ Python 확장), **uv** — `pip`/`venv` 는 쓰지 않습니다

## 폴더 구조

```
05-python-programming/
├── docs/
│   ├── 01-uv-basics.md                    uv 란? 설치 확인 · init/add/run/sync · pyproject.toml
│   ├── 02-python-basics.md                변수·자료형·연산·문자열·입출력
│   ├── 03-control-flow-and-functions.md   if · for/while · 함수 · 범위
│   └── 04-collections-modules-files.md    리스트·딕셔너리·튜플·집합 · 모듈 · 파일 · 예외
├── exercises/
│   ├── 01-uv-first-project.md             uv 로 첫 프로젝트 만들고 실행
│   └── 02-led-logger.md                   LED 이력 기록기 (콘솔) 만들기 ★
├── examples/
│   ├── 01-hello-uv/                       uv init 결과물 + 패키지 하나 추가
│   └── 02-led-logger/                     완성 예제 — 입력·리스트·딕셔너리·JSON 파일
└── slides/
    └── python-basics.md
```

## 학습 순서

1. 🧰 `docs/01` uv — 프로젝트 한 바퀴 → **`exercises/01`** 첫 프로젝트 실행
2. 🐍 `docs/02` 변수·자료형·문자열 → `docs/03` 조건·반복·함수 → `docs/04` 컬렉션·모듈·파일·예외
   (각 문서의 코드는 `uv run python` 대화형 셸에 한 줄씩 쳐 보며 읽기)
3. 🧪 **`exercises/02`** LED 이력 기록기 — 배운 것을 전부 써 보는 작은 프로그램 ★

## 예제 실행

```bash
cd courses/05-python-programming/examples/02-led-logger
uv run main.py
```

`uv run` 이 가상환경을 자동으로 만들고 필요한 Python 을 받아 실행합니다. `pip install` · `activate` 불필요.

## 이어지는 강좌

- [06-web-server-python](../06-web-server-python/README.md) — 여기서 배운 딕셔너리·함수·uv 가 그대로 FastAPI 서버가 됩니다

## 슬라이드

저장소 최상위에서 `npm run pdf -- 05-python`
