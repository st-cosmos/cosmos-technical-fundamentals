# 04. 우리 팀 워크플로우 (git-flow + rebase + GitHub)

이 문서는 **우리 팀이 실제로 일하는 방식**입니다. 앞 문서들이 "Git 사용법"이라면,
여기는 "우리 팀의 약속"입니다. 처음엔 복잡해 보여도, 매일 쓰는 흐름은 정해져 있습니다.

## 0. 우리 팀의 약속 (요약)

1. 브랜치 전략은 **git-flow**를 따른다.
2. 작업은 항상 **새 브랜치(feature)** 에서 하고, **PR(Pull Request)** 로 합친다.
3. 합칠 때는 **rebase 기본**. main 이력을 깔끔한 한 줄로 유지한다.
4. `main`/`develop`에는 **직접 push 하지 않는다** (PR로만).

## 1. git-flow — 브랜치 역할 나누기

git-flow는 브랜치마다 **역할**을 정해두는 전략입니다.

| 브랜치 | 역할 | 누가/언제 |
|--------|------|----------|
| `main` | **출시된 안정 버전**. 항상 동작하는 코드 | 릴리스 때만 갱신 |
| `develop` | **다음 릴리스를 위한 통합 브랜치**. 개발의 중심 | 기능들이 모이는 곳 |
| `feature/*` | **기능 하나를 개발**하는 작업 브랜치 | 개발자가 develop에서 분기 |
| `release/*` | 출시 직전 **마무리(버그픽스/버전)** | develop → main 가는 길목 |
| `hotfix/*` | 출시판의 **긴급 버그 수정** | main에서 분기 |

```
main     ●────────────────────●──────────────▶  (출시 v1.0)     (출시 v1.1)
          \                   /                \             /
develop    ●──●────●────●────●──────●────●──────●───────────●▶
              \    /     \   /        \  /
feature        ●──●       ●─●          ●─●   (각자 기능 개발)
```

### 매일 쓰는 건 결국 두 가지

릴리스/핫픽스는 가끔입니다. **일상 작업은 거의 항상 이 흐름**입니다:

> `develop`에서 `feature/내작업` 브랜치를 따서 → 개발 → PR → `develop`에 병합

### 브랜치 이름 규칙

```
feature/login-page        기능
feature/123-cart-bug      (이슈 번호를 앞에 붙이면 추적이 쉬움)
hotfix/payment-crash      긴급 수정
release/1.2.0             릴리스
```

> 도구로서의 `git flow` 확장 명령(`git flow feature start ...`)도 있지만, 필수는 아닙니다.
> 일반 git 명령(`git switch -c feature/...`)만으로 충분히 git-flow를 실천할 수 있습니다.

## 2. 일상 작업 흐름 (이것만 외우세요)

```bash
# 1) 최신 develop에서 출발
git switch develop
git pull                       # (우리 팀은 rebase pull — 아래 4번)

# 2) 작업 브랜치 생성
git switch -c feature/123-cart-bug

# 3) 작업하고 커밋 (여러 번 OK)
git add .
git commit -m "장바구니 수량 0 이하 입력 방지"

# 4) 원격에 내 브랜치 올리기
git push -u origin feature/123-cart-bug

# 5) GitHub에서 Pull Request 생성 (develop ← feature/123-cart-bug)
#    → 팀원 리뷰 → 승인 → 병합

# 6) 병합 후 정리
git switch develop
git pull
git branch -d feature/123-cart-bug
```

## 3. Pull Request(PR) — 코드 리뷰의 단위

PR은 "내 브랜치를 develop에 합쳐주세요" 하는 **요청 + 리뷰 공간**입니다.

- PR 하나 = **작업 하나**로 작게 유지 (리뷰하기 쉬움)
- 설명에 **무엇을/왜** 바꿨는지 적기 (템플릿이 자동으로 떠줍니다)
- 최소 **1명 이상 리뷰 승인** 후 병합 (팀 규칙)
- CI(자동 검사)가 있다면 통과 후 병합

> PR/리뷰 관련 GitHub 설정은 [06. GitHub 협업 설정](06-github-collaboration-setup.md) 참고.

## 4. ★ 우리는 rebase를 기본으로 씁니다

병합 방식에는 **merge**와 **rebase**가 있습니다. 우리 팀은 **rebase 기본**입니다.

### merge vs rebase — 그림으로

같은 상황(내가 작업하는 동안 develop에 새 커밋이 생김)을 두 방식으로 처리하면:

```
merge:  이력이 갈라졌다 합쳐진 흔적(merge commit)이 남음
   develop  A───B───────M
                 \     /
   feature        C───D

rebase: 내 커밋(C,D)을 최신 develop 위로 "옮겨 붙임" → 한 줄로 깔끔
   develop  A───B───C'──D'
```

- **merge**: 일어난 그대로(갈라짐+합침) 기록. 안전하지만 이력이 복잡해짐.
- **rebase**: 내 작업을 최신 베이스 위로 다시 쌓음. **이력이 직선이라 읽기 쉬움.**

### 4-1. pull을 rebase로 (각자 1회 설정)

```bash
git config --global pull.rebase true
```

이제 `git pull` 하면 원격 변경 위로 내 커밋이 rebase됩니다. (merge 커밋이 안 생김)

### 4-2. PR 올리기 전, 최신 develop 위로 정리

```bash
git switch feature/내작업
git fetch origin
git rebase origin/develop
# (충돌이 나면 해결 — 05 문서 참고)
git push --force-with-lease     # rebase로 이력이 바뀌었으니 강제 푸시 필요
```

### 4-3. ⚠️ rebase 황금률 두 가지

1. **공유된 브랜치(`main`, `develop`)는 rebase 하지 않는다.**
   내 개인 feature 브랜치만 rebase 대상입니다.
2. 강제 푸시는 **반드시 `--force-with-lease`** 를 쓴다.
   그냥 `--force`는 남의 작업을 덮어쓸 수 있습니다. `--force-with-lease`는
   "내가 본 이후 원격이 안 바뀌었을 때만" 밀어내서 안전합니다.

### 4-4. GitHub 병합 버튼은 어떤 걸?

PR 병합 시 GitHub은 3가지 버튼을 줍니다. 우리 팀 권장:

- **Rebase and merge** 또는 **Squash and merge** 사용
- **Create a merge commit** 은 끔 (저장소 설정에서 비활성화 권장 — 06 문서)

> **Squash and merge**: feature의 여러 커밋을 **한 개로 합쳐** develop에 올립니다.
> 작은 커밋이 많은 작업에 깔끔해서, 많은 팀이 기본으로 씁니다. 팀에서 하나로 통일하세요.

## 5. 흔한 막힘 포인트

- **"push가 거부됐어요(rejected)"** → 원격에 내가 모르는 새 커밋이 있다는 뜻.
  `git pull`(rebase)로 받아 정리한 뒤 다시 push.
- **rebase 도중 충돌** → [05. conflict 문서](05-conflict-causes-and-resolution.md)의 절차를 따르세요.
- **rebase가 무서워요** → 개인 feature 브랜치에서만 하면 안전합니다. 최악의 경우
  `git rebase --abort`로 시작 전 상태로 되돌릴 수 있습니다.

---

⬅️ 이전: [03. 주요 명령어](03-essential-commands.md)
➡️ 다음: [05. conflict 원인과 해결](05-conflict-causes-and-resolution.md) ★
🛠️ 실습: [02. 브랜치와 rebase](../exercises/02-branch-and-rebase.md)
