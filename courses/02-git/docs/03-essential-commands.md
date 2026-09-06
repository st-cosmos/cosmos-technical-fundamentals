# 03. 주요 명령어

외울 필요 없습니다. **흐름**을 익히고, 필요할 때 이 문서를 다시 보세요.
실무에서 쓰는 명령의 90%는 여기 있습니다.

## 0. 가장 먼저: 상태 확인 3종

작업하다 막히면 **항상 이 3개**부터 쳐보세요. 현재 상황을 알려줍니다.

```bash
git status      # 지금 어떤 파일이 변경/준비됐는지
git log --oneline --graph --all   # 커밋 이력을 그래프로
git diff        # 아직 add 안 한 변경 내용 보기
```

> 💡 `git log --graph` 가 글자로 그리는 그래프를 VS Code **Git Graph** 확장은 그림으로 보여 줍니다.
> 이 강좌 내내 터미널 명령과 Git Graph 화면을 **함께** 보면서 진행하면 브랜치가 훨씬 잘 보입니다.

> 📍 **이 강좌의 명령 예시에는 `# 지금 브랜치: xxx` 주석이 붙어 있습니다.** 같은 명령도 **어느 브랜치에서 치느냐**에
> 따라 결과가 달라지기 때문입니다. 명령을 치기 전에 `git status` 첫 줄(`On branch xxx`)이 주석과 같은지 확인하세요.
> 주석 줄은 복사해 붙여도 무시되므로 그대로 붙여넣어도 됩니다.

## 1. 기본 흐름: 작업 → add → commit → push

이 4단계가 Git 사용의 핵심입니다.

```bash
# 1) 파일을 수정한다 (에디터에서 작업)

# 2) 변경을 "커밋할 목록"에 담는다 (staging)
git add 파일이름        # 특정 파일
git add .              # 변경된 전체

# 3) 스냅샷으로 기록한다 (로컬 저장소에)
git commit -m "할 일 목록에 마감일 필드 추가"

# 4) GitHub(원격)로 올린다
git push
```

### staging(준비 영역)이 왜 있나?

`add`와 `commit`이 나뉜 이유는 **이번 커밋에 무엇을 포함할지 고를 수 있게** 하기 위해서입니다.
예: 5개 파일을 고쳤지만 그중 2개만 한 커밋으로 묶고 싶을 때.

```
작업 폴더  ──git add──▶  Staging  ──git commit──▶  로컬 저장소  ──git push──▶  GitHub
(수정 중)               (담는 중)                 (기록됨)                  (공유됨)
```

## 2. 원격과 주고받기

```bash
git clone <주소>     # 저장소를 처음 복제
git pull             # 원격의 최신 변경을 내 것으로 받아오기
git push             # 내 커밋을 원격에 올리기
git fetch            # 원격 변경을 "받아만" 두기(병합은 안 함)
```

> 우리 팀은 `pull` 시 **rebase**를 기본으로 씁니다. 이유와 설정은
> [04. 우리 팀 워크플로우](04-our-team-workflow.md)에서 다룹니다.

## 3. 브랜치 다루기

```bash
# 지금 브랜치: main
git branch                      # 브랜치 목록 (* 가 붙은 것이 지금 브랜치)
git switch -c feature/login     # 새 브랜치 만들고 그쪽으로 이동
# 지금 브랜치: feature/login   ← 여기서 작업하고 커밋
git switch main                 # main 브랜치로 이동
# 지금 브랜치: main
git branch -d feature/login     # 브랜치 삭제(병합 완료된 것)
```

> `git checkout` 으로도 같은 일을 할 수 있지만, 요즘은 역할이 명확한
> `git switch`(브랜치 이동) / `git restore`(파일 되돌리기)를 권장합니다.

## 4. 되돌리기 — 실수했을 때

상황별로 명령이 다릅니다. **당황하지 말고 상황을 먼저 확인**하세요.

| 상황 | 명령 | 설명 |
|------|------|------|
| add 전, 파일 수정을 취소 | `git restore 파일` | 마지막 커밋 상태로 되돌림 |
| add는 했는데 빼고 싶다 | `git restore --staged 파일` | staging에서만 내림 (수정은 유지) |
| 방금 커밋 메시지를 고치고 싶다 | `git commit --amend` | 마지막 커밋 수정 (push 전에만!) |
| 이미 push한 커밋을 되돌리고 싶다 | `git revert <커밋>` | 되돌리는 **새 커밋**을 만듦 (안전) |
| 로컬 커밋을 통째로 취소 | `git reset --soft HEAD~1` | 커밋만 취소, 변경은 유지 |

> ⚠️ **공유된(push된) 이력**에는 `reset`/`--amend`/`rebase` 같은 "이력 바꾸기"를
> 함부로 쓰지 마세요. 남이 받아간 이력과 어긋나 충돌의 원인이 됩니다.
> 공유된 커밋을 되돌릴 땐 **`git revert`** 가 안전합니다.

## 5. 임시 보관 — stash

작업 중인데 급히 다른 브랜치로 가야 할 때, **커밋하지 않고** 잠깐 치워둡니다.

```bash
# 지금 브랜치: feature/login  (작업 중, 아직 커밋 안 함)
git stash            # 현재 변경을 임시 보관
git switch main      # 다른 일 처리
# 지금 브랜치: main
git switch -         # 원래 브랜치로 복귀
# 지금 브랜치: feature/login
git stash pop        # 치워둔 변경 복원
```

## 6. 치트시트 (한눈에)

```bash
# 상태
git status
git log --oneline --graph --all
git diff

# 기본 흐름
git add .
git commit -m "메시지"
git push

# 원격
git pull              # 우리 팀은 rebase pull (04 문서 참고)
git fetch

# 브랜치
git switch -c feature/xxx
git switch main
git branch -d feature/xxx

# 되돌리기
git restore 파일              # 수정 취소
git restore --staged 파일     # add 취소
git revert <커밋>             # 공유된 커밋 안전하게 되돌리기

# 임시 보관
git stash / git stash pop
```

## 7. 좋은 커밋 메시지

커밋 메시지는 **미래의 나와 팀원에게 보내는 메모**입니다.

- 제목은 **무엇을 왜** 바꿨는지 한 줄로 (예: `로그인 실패 시 에러 메시지 노출 수정`)
- "수정", "ㅁㄴㅇㄹ", "임시" 같은 메시지는 나중에 이력을 못 읽게 만듭니다
- 한 커밋 = 한 가지 일 (여러 작업을 한 커밋에 섞지 않기)

---

⬅️ 이전: [02. 설치와 초기설정](02-installation-and-initial-setup.md)
➡️ 다음: [04. 우리 팀 워크플로우](04-our-team-workflow.md)
