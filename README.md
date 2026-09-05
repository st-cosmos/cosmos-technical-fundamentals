# COSMOS 기술 기초 교육 자료

동아리/팀 신입을 위한 **기술 기초 교육 자료 모음**입니다. 8개 강좌가 **하나의 저장소(모노리포)** 에 들어 있으며, 모든 강좌가
같은 구조(**`docs/` 본문 · `exercises/` 실습 · `examples/` 예제 코드 · `slides/` 슬라이드**)와 공통 슬라이드 테마를 씁니다.

## 강좌 목록 (추천 순서)

| # | 강좌 (폴더) | 내용 | 예제 코드 |
|---|-------------|------|-----------|
| 00 | [dev-environment-setup](courses/00-dev-environment-setup/) | Windows/macOS 도구 일괄 설치 스크립트 + 확인 · Codex 로그인 | 설치·확인 스크립트 |
| 01 | [cli](courses/01-cli/) | 터미널 · `pwd`/`ls`/`cd`/`mkdir` · **절대/상대 경로** · `ipconfig` 로 내 IP | — |
| 02 | [git](courses/02-git/) | 버전 관리 · git-flow · rebase · **conflict 해결** · GitHub 협업 설정 | — |
| 03 | [esp32-programming](courses/03-esp32-programming/) | 디지털 출력 · 디지털 입력 · PWM · 아날로그 입력 · Serial (+선택: WiFi) | PlatformIO 프로젝트 6개 |
| 04 | [web-application](courses/04-web-application/) | HTML · CSS · JavaScript · **주요 태그/문법 치트시트** | LED 제어판 (정적) |
| 05 | [python-programming](courses/05-python-programming/) | **uv** 사용법 · Python 기초 문법 요약 | uv 프로젝트 2개 |
| 06 | [web-server-python](courses/06-web-server-python/) | FastAPI · **정적 파일 호스팅 · REST API · WebSocket** | FastAPI 서버 3개 |
| 07 | [ai-assisted-development](courses/07-ai-assisted-development/) | 에이전트 코딩 · **Codex CLI** · AGENTS.md · 검토와 git | LED 제어판 참고본 |

> 💡 **러닝 예제는 하나 — "LED 제어판".** 04 에서 화면(HTML/CSS/JS)을 만들고, 05 에서 콘솔 버전(딕셔너리·JSON)을 만들고,
> 06 에서 서버(API·WebSocket)에 올리고, 03 의 선택 심화에서 ESP32 가 그 서버를 읽어 실제 LED 를 켜고, 07 에서 AI 에게 같은
> 것을 말로 시켜 봅니다. 서버 데이터 규칙 `{on, by, time}` 은 전 강좌 공통.

## 저장소 구조

```
cosmos-technical-fundamentals/
├── README.md                ← 이 문서
├── package.json             슬라이드 빌드 (marp-cli 1개, 전 강좌 공용)
├── scripts/build-slides.mjs 모든 강좌의 slides/*.md → PDF/HTML
├── shared/marp-theme.css    ★ 공통 슬라이드 테마 — 이 파일만 바꾸면 전 강좌 반영
├── .github/                 PR·이슈 템플릿, CODEOWNERS (02-git 강좌의 실제 예시)
├── .gitignore  .gitattributes  .vscode/
└── courses/
    ├── 00-dev-environment-setup/   docs · exercises · slides · scripts/ · images/
    ├── 01-cli/                     docs · exercises · slides
    ├── 02-git/                     docs · exercises · slides
    ├── 03-esp32-programming/       docs · exercises · slides · examples/0N-*/  (PlatformIO)
    ├── 04-web-application/         docs · exercises · slides · examples/01-led-panel/
    ├── 05-python-programming/      docs · exercises · slides · examples/0N-*/  (uv)
    ├── 06-web-server-python/       docs · exercises · slides · examples/0N-*/  (uv + FastAPI)
    └── 07-ai-assisted-development/ docs · exercises · slides · examples/led-panel/
```

- **예제 코드는 강좌 폴더 안 `examples/`** 에 예제별 독립 폴더로 있습니다. 브랜치 이동·서브모듈 없이 clone 한 번이면 전부 받습니다.
- 각 예제 폴더는 그 자체로 완결된 프로젝트입니다: PlatformIO 는 `platformio.ini` 가 있는 폴더를 VS Code 로 열고, Python 은 그 폴더에서 `uv run ...`.

## 시작하기

```bash
git clone https://github.com/st-cosmos/cosmos-technical-fundamentals.git
cd cosmos-technical-fundamentals
code .                       # VS Code 로 열기 (추천 확장 안내가 뜸)
```

신입 부원은 **00 → 01 → 02 → …** 순서로 각 강좌 폴더의 `README.md` 부터 읽으면 됩니다.
(00 강좌는 Git 이 없어도 되도록 ZIP 다운로드 안내를 포함합니다.)

## 예제 실행 (요약)

| 강좌 | 방법 |
|------|------|
| 03 ESP32 | VS Code 로 `courses/03-esp32-programming/examples/0N-*` **개별 폴더** 열기 → PlatformIO Upload |
| 04 웹 | `courses/04-web-application/examples/01-led-panel/index.html` 더블클릭 |
| 05 Python | `cd courses/05-python-programming/examples/02-led-logger && uv run main.py` |
| 06 서버 | `cd courses/06-web-server-python/examples/02-led-api && uv run uvicorn main:app --reload` |
| 07 AI | `codex` 를 **실습용 폴더**에서 실행 (저장소 최상위에서 실행하지 않기) |

## 슬라이드 빌드 (공통)

모든 강좌 슬라이드는 [Marp](https://marp.app/) + 공통 테마 `shared/marp-theme.css` 로 작성되어 있습니다.

```bash
npm install                  # 1회 (marp-cli)
npm run pdf                  # 모든 강좌 slides/*.md → *.pdf
npm run pdf -- 02-git        # 특정 강좌만 (폴더 이름 일부)
npm run watch -- 01-cli      # 한 강좌 실시간 미리보기
npm run html                 # HTML 로
npm run clean                # 생성물 삭제
```

VS Code 에서는 **Marp for VS Code** 확장으로 미리보기/내보내기가 되며, `.vscode/settings.json` 에 공통 테마가 등록되어 있습니다.
슬라이드 frontmatter 는 `theme: cosmos` 한 줄이면 됩니다.

> 🎨 **슬라이드 템플릿 교체**: `shared/marp-theme.css` 한 파일만 바꾸면 8개 강좌 전체에 반영됩니다. 강조색은 `--accent`.

## 공통 규칙

- **생성물(PDF/HTML)·비밀정보(`config.h`, `.env`)·빌드 산출물(`.venv/`, `.pio/`, `node_modules/`)은 커밋하지 않습니다.**
  원본(Markdown/코드)만 관리합니다. (예제의 웹 페이지 `.html` 은 예외로 커밋)
- 줄바꿈은 `.gitattributes` 로 LF 정규화 (Windows/macOS 혼재 팀 필수).
- Python 은 **uv** 로만 관리합니다 (`pip`/`venv` 사용 안 함). `uv.lock` 은 커밋합니다.
- 강좌 문서의 상대 경로는 별도 언급이 없으면 **저장소 최상위 기준**입니다.

## 기여

- 오류·제안은 GitHub **Issues** 로 (템플릿: 오류 신고 / 내용 제안). PR 은 `.github/pull_request_template.md` 양식에 맞춰 주세요.
- 브랜치는 `main` 하나 + 짧은 topic 브랜치. 슬라이드를 고쳤다면 `npm run pdf -- <강좌>` 로 빌드 확인.
