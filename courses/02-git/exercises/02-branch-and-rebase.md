# 실습 02. 브랜치와 rebase

> **목표**: feature 브랜치를 만들어 작업하고, rebase로 최신 develop 위에 깔끔하게 올려본다.
> **소요**: 약 25분 · **준비물**: [실습 01](01-installation-and-first-commit.md) 완료, [04 문서](../docs/04-our-team-workflow.md) 읽기

이번 실습은 우리 팀 일상 흐름(**develop → feature → rebase → 병합**)을 손으로 체험합니다.

## 1. 연습 환경 준비

```bash
cd ~/workspace
mkdir branch-practice && cd branch-practice
git init
# 지금 브랜치: main
echo "line 1" > app.txt
git add app.txt && git commit -m "초기 파일"

# develop 브랜치를 만들어 기준으로 삼습니다
git switch -c develop
# 지금 브랜치: develop
```

## 2. feature 브랜치에서 작업

```bash
git switch -c feature/add-greeting
# 지금 브랜치: feature/add-greeting
echo "안녕하세요" >> app.txt
git add app.txt && git commit -m "인사말 추가"

echo "반갑습니다" >> app.txt
git add app.txt && git commit -m "환영 문구 추가"

git log --oneline --graph --all
```

내 feature 브랜치에 커밋 2개가 쌓였습니다.

## 3. 그 사이 develop이 앞서나간 상황 만들기

실제로는 **다른 팀원이** develop에 커밋을 올린 상황입니다. 흉내내봅시다.

```bash
git switch develop
# 지금 브랜치: develop  (다른 팀원 역할)
echo "공지: 점검 예정" >> notice.txt
git add notice.txt && git commit -m "점검 공지 추가"

git log --oneline --graph --all
```

이제 develop과 내 feature가 **갈라진** 상태입니다.

## 4. ★ rebase로 최신 develop 위에 올리기

```bash
git switch feature/add-greeting
# 지금 브랜치: feature/add-greeting   ← rebase 는 내 feature 브랜치에 서서!
git rebase develop
```

성공하면 내 커밋 2개가 **develop의 최신 커밋 뒤로 옮겨 붙습니다.** 확인:

```bash
git log --oneline --graph --all
```

> 이 실습에서는 서로 **다른 파일/줄**을 고쳤기 때문에 충돌 없이 깔끔하게 됩니다.
> 같은 줄을 고쳤다면 충돌이 나는데, 그건 [실습 03](03-creating-and-resolving-conflicts.md)에서 다룹니다.

## 5. develop에 병합 (PR을 흉내내기)

실제로는 GitHub에서 PR로 합치지만, 로컬에서 결과를 봅니다.

```bash
git switch develop
# 지금 브랜치: develop   ← 합치기는 "받는 쪽" 브랜치에 서서
git merge feature/add-greeting     # rebase 해뒀으니 깔끔하게(fast-forward) 합쳐짐
git log --oneline --graph --all
```

이력이 **한 줄로 직선**인 것을 확인하세요. 이게 rebase 기반 워크플로우의 효과입니다.

## 6. 정리

```bash
# 지금 브랜치: develop  (지우려는 브랜치 위에 서 있으면 지울 수 없음)
git branch -d feature/add-greeting
```

## 💡 실전 팁 — 원격이 있을 때

실제 협업에서는 4번 전에 원격 최신을 받아옵니다:

```bash
# 지금 브랜치: feature/add-greeting  (내 feature 브랜치)
git fetch origin                # 원격 최신을 받아만 둠
git rebase origin/develop
# 충돌 해결 후
git push --force-with-lease     # rebase로 이력이 바뀌었으니
```

> ⚠️ `--force-with-lease`를 쓰세요. 그냥 `--force`는 위험합니다. ([04 문서](../docs/04-our-team-workflow.md))

## ✅ 체크포인트

- [ ] feature 브랜치를 만들어 작업했다
- [ ] develop이 앞서간 상황에서 `git rebase develop`을 해봤다
- [ ] rebase 후 이력이 직선이 되는 걸 확인했다
- [ ] `--force-with-lease`가 왜 필요한지 이해했다

---

⬅️ 이전: [01. 설치와 첫 커밋](01-installation-and-first-commit.md)
➡️ 다음: [03. conflict 만들고 해결하기](03-creating-and-resolving-conflicts.md) ★
