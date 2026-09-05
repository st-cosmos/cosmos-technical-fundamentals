# 02. Git 기초

우리 팀을 위한 Git 입문 자료입니다. **Git이 처음인 사람**도 따라올 수 있도록 개념부터
실제 협업 방법, 그리고 가장 많이 막히는 **conflict(충돌) 해결**까지 다룹니다.

> 🎯 이 자료를 끝내면: 저장소를 만들어 커밋하고 GitHub 에 올리고, feature 브랜치에서 작업해 rebase 로
> 정리하고, 충돌이 나도 침착하게 해결할 수 있습니다.

## 누구를 위한 자료인가

- **선수**: [00-dev-environment-setup](../00-dev-environment-setup/README.md) (Git · VS Code · Git Graph 설치), [01-cli](../01-cli/README.md)
- 개발 환경: **Windows 다수 / macOS 일부**
- 원격 저장소: **GitHub**
- 브랜치 전략: **git-flow** · 코드 병합: **rebase 기본**
- 팀 규모: **3~5인 1팀**

## 폴더 구조

```
02-git/
├── docs/
│   ├── 01-what-is-git.md
│   ├── 02-installation-and-initial-setup.md
│   ├── 03-essential-commands.md
│   ├── 04-our-team-workflow.md              (git-flow + rebase + GitHub)
│   ├── 05-conflict-causes-and-resolution.md ★ 핵심
│   └── 06-github-collaboration-setup.md
├── exercises/
│   ├── 01-installation-and-first-commit.md
│   ├── 02-branch-and-rebase.md
│   └── 03-creating-and-resolving-conflicts.md
└── slides/
    └── git-basics.md
```

> 📎 PR/이슈 템플릿·CODEOWNERS·`.gitattributes` 같은 **협업 설정 파일의 실제 예시**는 이 교육 저장소의
> **최상위 폴더**(`.github/`, `.gitattributes`)에 있습니다. `docs/06` 에서 다룹니다.

## 학습 순서 (추천)

1. `docs/01` → `docs/02` 로 개념과 초기 설정
2. `exercises/01` 실습으로 첫 커밋 경험
3. `docs/03` 명령어 → `docs/04` 우리 팀 방식
4. `exercises/02` 브랜치/rebase 실습 — **Git Graph** 로 그래프를 보면서
5. `docs/05` conflict → `exercises/03` 충돌 직접 해결 ★
6. `docs/06` GitHub 설정 (팀 리더/리뷰어 위주)

## 실습용 저장소

실습은 모두 **내 PC 에 새로 만드는 연습용 저장소**에서 진행합니다. 이 교육 저장소 안에서 실습하지 마세요.
GitHub 에 올리는 단계는 **본인 계정의 새 저장소**를 만들어 사용합니다.

## 슬라이드

저장소 최상위에서 `npm run pdf -- 02-git`
