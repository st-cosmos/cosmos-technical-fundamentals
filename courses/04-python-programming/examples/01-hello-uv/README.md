# 예제 01 — uv 첫 프로젝트

`uv init` 으로 만든 최소 프로젝트에 외부 패키지(`cowsay`) 하나를 추가한 예입니다.

## 실행

```bash
uv sync            # (처음 한 번) uv.lock 대로 환경 재현
uv run main.py
```

`uv run` 만 해도 자동으로 환경을 만들어 실행합니다. `pip install`·`activate` 는 필요 없습니다.

## 파일

| 파일 | 역할 |
|------|------|
| `pyproject.toml` | 프로젝트 설정 + 의존성(`cowsay`) |
| `uv.lock` | 설치된 정확한 버전 (자동 생성, 커밋함) |
| `.python-version` | 이 프로젝트의 Python 버전 |
| `main.py` | 이름을 입력받아 소가 인사하는 프로그램 |

관련 실습: [`../../exercises/01-uv-first-project.md`](../../exercises/01-uv-first-project.md)
