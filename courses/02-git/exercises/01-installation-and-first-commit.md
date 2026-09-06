# 실습 01. 설치와 첫 커밋

> **목표**: 내 손으로 저장소를 만들고, 첫 커밋을 찍고, GitHub에 올려본다.
> **소요**: 약 20분 · **준비물**: Git 설치([02 문서](../docs/02-installation-and-initial-setup.md))

각 단계는 **직접 입력**하며 따라오세요. 중간중간 `git status`를 쳐서 상태를 확인하는 습관을
들이면 좋습니다.

## 0. 초기 설정 확인

```bash
git config --list
```

`user.name`, `user.email`이 보이지 않으면 [02 문서](../docs/02-installation-and-initial-setup.md)의
초기 설정을 먼저 하세요.

## 1. 연습용 저장소 만들기

```bash
cd ~/workspace            # 동아리 규칙: 실습 저장소도 ~/workspace 안에
mkdir git-practice
cd git-practice
git init
```

`git init`을 하면 이 폴더가 Git 저장소가 됩니다. (숨김 폴더 `.git`이 생김)

```bash
git status
# → 첫 줄 "On branch main" (지금 브랜치), "No commits yet" 가 보이면 정상
#   main 이 아니라 master 라면 00 강좌의 init.defaultBranch 설정을 빠뜨린 것 — git branch -M main 으로 바꾸면 됩니다
```

> 📍 이 실습들의 명령 예시에는 `# 지금 브랜치: xxx` 주석이 있습니다. 치기 전에 `git status` 첫 줄과 같은지 확인하세요.

## 2. 첫 파일 만들고 커밋하기

```bash
# 파일 생성 (또는 에디터로 만들어도 됨)
echo "# 내 첫 Git 프로젝트" > README.md

git status        # README.md가 빨간색(Untracked)으로 보임
```

이제 **add → commit** 흐름:

```bash
git add README.md
git status        # README.md가 초록색(staged)으로 바뀜

git commit -m "프로젝트 README 추가"
git status        # "nothing to commit" — 깨끗한 상태
```

🎉 첫 커밋 완료! 확인해봅시다:

```bash
git log --oneline
```

## 3. 한 번 더 — 수정하고 커밋

```bash
echo "Git 연습 중입니다." >> README.md

git status        # modified로 표시됨
git diff          # 무엇이 바뀌었는지 확인

git add README.md
git commit -m "README에 설명 한 줄 추가"

git log --oneline --graph    # 커밋 2개가 보임
```

## 4. GitHub에 올리기 (원격 연결)

먼저 GitHub에서 **빈 저장소**를 하나 만듭니다 (README 체크 없이).
그러면 안내 화면에 주소가 나옵니다. 그 주소로:

```bash
git remote add origin https://github.com/내계정/git-practice.git
git branch -M main
git push -u origin main
```

> 인증을 물어보면 [02 문서](../docs/02-installation-and-initial-setup.md)의 GitHub 인증 설정 참고.
> `gh auth login`을 미리 해두면 매끄럽습니다.

GitHub 저장소 페이지를 새로고침하면 방금 올린 파일과 커밋이 보입니다. 성공!

## ✅ 체크포인트

- [ ] `git init`으로 저장소를 만들었다
- [ ] add → commit 흐름을 이해했다
- [ ] `git status` / `git log` / `git diff`를 써봤다
- [ ] GitHub에 push해서 확인했다

## 🧹 (선택) 정리

연습용이라 지워도 됩니다. 폴더째 삭제하면 끝입니다.

---

➡️ 다음 실습: [02. 브랜치와 rebase](02-branch-and-rebase.md)
