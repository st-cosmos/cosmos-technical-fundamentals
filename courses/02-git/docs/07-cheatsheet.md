# 07. Git 치트시트 — 매일 쓰는 명령 한 장

> 앞 문서(03~05)를 **명령어 순서대로 압축한 참고표**입니다. 실습하다 "그 다음 뭐 치지?" 싶을 때 여기로 오세요.
> 코드 블록의 `# 지금 브랜치: xxx` 는 그 명령을 치는 브랜치입니다. `git status` 첫 줄 `On branch xxx` 와 맞는지 확인하세요.

## 한눈에

| 하고 싶은 일 | 명령 |
|--------------|------|
| 새 프로젝트를 git 으로 관리 시작 | `git init` → `git add .` → `git commit -m "..."` |
| GitHub 저장소와 연결하고 첫 push | `git remote add origin <주소>` → `git push -u origin main` |
| 브랜치 만들고 이동 | `git switch -c feature/이름` |
| 브랜치 이동 | `git switch develop` |
| 커밋 남기기 | `git add .` → `git commit -m "무엇을 왜"` |
| 내 브랜치를 최신 develop 위로 정리 | `git fetch origin` → `git rebase origin/develop` |
| develop 에 합치기 (merge 커밋 남김) | `git switch develop` → `git merge --no-ff feature/이름` |
| 올리기 / 받기 | `git push` / `git pull` |
| 지금 상태·이력 | `git status` / `git log --oneline --graph --all` |
| 막혔을 때 원상복구 | `git rebase --abort` / `git merge --abort` |

## 1. 프로젝트 git 초기화

```bash
cd ~/workspace/my-project          # 프로젝트 폴더로
git init                           # .git 폴더 생성 → 이제 이 폴더는 git 저장소
# 지금 브랜치: main  (00 강좌에서 init.defaultBranch main 설정)

# 커밋하면 안 되는 것 먼저 제외 (비밀정보·빌드 산출물·가상환경)
echo ".venv/"  >> .gitignore
echo ".pio/"   >> .gitignore
echo "config.h" >> .gitignore

git add .                          # 전부 스테이징
git commit -m "프로젝트 시작"        # 첫 커밋
```

GitHub 에 올리려면 **비어 있는 저장소**를 GitHub 에서 만든 뒤(README 없이):

```bash
# 지금 브랜치: main
git remote add origin https://github.com/우리팀/my-project.git   # 원격 등록 (1회)
git push -u origin main            # -u: 앞으로 git push 만 쳐도 되게 연결
```

> 이미 있는 팀 저장소에서 시작할 때는 `git init` 대신 `git clone <주소>` 한 줄입니다.

## 2. 브랜치 만들고 이동하기

```bash
git branch                         # 브랜치 목록 (* 가 지금 브랜치)
git switch -c feature/login        # 만들면서 이동 (-c = create)
# 지금 브랜치: feature/login
git switch develop                 # 있는 브랜치로 이동
# 지금 브랜치: develop
git branch -d feature/login        # 병합 끝난 브랜치 삭제 (안 합쳐졌으면 거부됨 → 안전)
```

- 새 브랜치는 **지금 서 있는 브랜치에서 갈라집니다.** feature 는 항상 최신 `develop` 에서 따세요.
  → `git switch develop && git pull` 먼저.
- 이름 규칙: `feature/기능`, `hotfix/버그`, `release/버전` ([04 문서](04-our-team-workflow.md))
- 작업 중인 파일이 있으면 이동이 막힐 수 있음 → 커밋하거나 `git stash` 로 잠시 치우기(`git stash pop` 으로 복구)

## 3. 커밋 남기기

```bash
git status                         # 무엇이 바뀌었나 (빨강 = 아직 add 안 됨, 초록 = 스테이징됨)
git diff                           # 바뀐 내용 줄 단위로
git add 파일 또는 폴더               # 커밋에 담기 (스테이징)
git add .                          # 전부 담기
git commit -m "수량 0 이하 입력 방지"  # 스냅샷 기록 — 메시지는 "무엇을 왜"
git log --oneline --graph --all    # 이력 그래프
```

되돌리기(커밋 전):

```bash
git restore 파일                   # 수정 취소 (add 전 상태로)
git restore --staged 파일          # add 취소 (수정은 남음)
git commit --amend -m "고친 메시지"  # 직전 커밋 메시지 수정 — push 전에만!
```

> ⚠️ 이미 push 한 커밋은 `--amend`·`reset` 대신 **`git revert <커밋>`** 으로 "되돌리는 커밋"을 새로 만듭니다.

## 4. rebase 로 정리한 뒤 `--no-ff` 로 merge 하기

feature 작업이 끝나면 **① 내 브랜치를 최신 develop 위로 rebase** 해서 이력을 직선으로 만들고,
**② develop 에서 `--no-ff` 로 merge** 해 "이 기능이 여기서 합쳐졌다" 는 merge 커밋을 남깁니다.

```
① rebase 전                 ② rebase 후                ③ --no-ff merge 후
develop  A─B─E              develop  A─B─E             develop  A─B─E───────M
            \                            \                          \       /
feature      C─D            feature       C'─D'        feature       C'─D'
```

```bash
# ① 내 feature 를 최신 develop 위로
git switch feature/login
# 지금 브랜치: feature/login   ← rebase 는 항상 내 feature 에 서서!
git fetch origin                   # 원격 최신을 받아만 둠
git rebase origin/develop          # 내 커밋을 최신 develop 위로 옮겨 붙임
#   충돌 나면: 파일 고치기 → git add 파일 → git rebase --continue  (05 문서)

# ② develop 으로 가서 --no-ff 로 합치기
git switch develop
# 지금 브랜치: develop
git pull                           # develop 을 최신으로 (rebase pull)
git merge --no-ff feature/login -m "Merge feature/login: 로그인 기능"
git push                           # 합친 develop 올리기
git branch -d feature/login        # 끝난 브랜치 정리
```

- `--no-ff` (no fast-forward): rebase 로 직선이 됐어도 **merge 커밋을 꼭 만듭니다.** 그래야 Git Graph 에서
  "어디부터 어디까지가 로그인 기능" 인지 보이고, 기능 단위로 되돌리기(`git revert -m 1 M`)도 됩니다.
- 옵션 없이 `git merge` 하면 fast-forward 되어 feature 커밋이 develop 에 그냥 이어 붙고 흔적이 사라집니다.
- 팀 저장소에서 develop 이 보호 브랜치면 ② 대신 **GitHub 에서 PR** 을 올리고 리뷰 후 **Create a merge commit** 버튼으로
  병합합니다. 그 버튼이 곧 `--no-ff` 라서 이력 모양은 같습니다 ([04 문서 4-4](04-our-team-workflow.md)).

## 5. push · pull

```bash
git push                           # 지금 브랜치를 원격의 같은 이름 브랜치로
git push -u origin feature/login   # 새 브랜치 첫 push (-u 는 처음 한 번만)
git push --force-with-lease        # rebase 로 이력이 바뀐 "내 feature" 만 — 절대 --force 아님

git pull                           # 원격 변경 받기 (우리 팀은 rebase pull 설정 → merge 커밋 안 생김)
git fetch origin                   # 받아만 두고 내 브랜치는 안 건드림 (rebase 전에)
```

| 상황 | 원인 | 해결 |
|------|------|------|
| `push` 가 `rejected` | 원격에 내가 모르는 새 커밋 | `git pull` 로 받아 정리 후 다시 push |
| `pull` 에서 충돌 | 같은 줄을 서로 다르게 수정 | 05 문서 절차: 고치기 → `add` → `git rebase --continue` |
| `push` 에 `--force` 가 필요하다고 함 | rebase 로 이력이 바뀜 | 내 feature 면 `--force-with-lease`, `main`/`develop` 이면 **하지 말고** 물어보기 |

## 6. 막혔을 때

```bash
git status                         # 항상 첫 번째 — 지금 뭘 해야 하는지 알려 줌
git rebase --abort                 # rebase 중 → 시작 직전으로
git merge --abort                  # merge 중 → 시작 직전으로
git stash / git stash pop          # 작업 중인 변경 잠시 치우기 / 되살리기
git log --oneline --graph --all    # 지금 그래프가 어떻게 생겼나 (VS Code Git Graph 와 같음)
```

---

⬅️ 이전: [06. GitHub 협업 설정](06-github-collaboration-setup.md)
🏠 처음으로: [README](../README.md)
