# 실습 03. Conflict(충돌) 만들고 해결하기 ★

> **목표**: 일부러 충돌을 만들어 보고, 침착하게 해결하는 절차를 몸에 익힌다.
> **소요**: 약 30분 · **준비물**: [실습 02](02-branch-and-rebase.md) 완료, [05 문서](../docs/05-conflict-causes-and-resolution.md) 읽기

충돌은 직접 겪어봐야 안 무섭습니다. **안전한 연습 저장소**에서 일부러 만들어봅니다.

## 1. 연습 환경 준비

```bash
mkdir conflict-practice && cd conflict-practice
git init

# 여러 줄짜리 파일을 만듭니다
printf "1: 제목\n2: 내용\n3: 끝맺음\n" > doc.txt
git add doc.txt && git commit -m "문서 초안"

git switch -c develop
```

`doc.txt`의 2번 줄을 두 브랜치가 **서로 다르게** 고쳐서 충돌을 일으킬 겁니다.

## 2. 충돌의 씨앗 심기 — 두 브랜치가 같은 줄을 수정

### feature 브랜치 쪽 수정

```bash
git switch -c feature/edit-body
# 2번 줄을 "내용: 사과" 로 바꿉니다 (에디터로 doc.txt 열어 수정)
```

`doc.txt`를 이렇게 만드세요:

```
1: 제목
2: 내용 - 사과
3: 끝맺음
```

```bash
git add doc.txt && git commit -m "본문을 사과로"
```

### develop 쪽 수정 (같은 2번 줄!)

```bash
git switch develop
# 같은 2번 줄을 "내용: 바나나" 로 바꿉니다
```

`doc.txt`를 이렇게:

```
1: 제목
2: 내용 - 바나나
3: 끝맺음
```

```bash
git add doc.txt && git commit -m "본문을 바나나로"
```

이제 두 브랜치가 **같은 줄을 다르게** 바꿨습니다. 충돌 조건 완성!

## 3. ★ 충돌 일으키기 (rebase)

우리 팀 기본인 rebase로 합쳐봅니다.

```bash
git switch feature/edit-body
git rebase develop
```

이런 메시지가 뜨면 **성공적으로 충돌을 만든 것**입니다:

```
CONFLICT (content): Merge conflict in doc.txt
error: could not apply ... 본문을 사과로
```

## 4. 충돌 확인하고 해결하기

### 4-1. 어디서 났나

```bash
git status
# "Unmerged paths: doc.txt" 확인
```

### 4-2. 파일 열어보기

`doc.txt`를 열면 이렇게 보입니다:

```
1: 제목
<<<<<<< HEAD
2: 내용 - 바나나
=======
2: 내용 - 사과
>>>>>>> 본문을 사과로
3: 끝맺음
```

> rebase라 위(HEAD)가 **develop(바나나)**, 아래가 **내 커밋(사과)** 입니다.
> 헷갈리면 마커 옆 설명을 보세요.

### 4-3. 결정해서 고치기

세 가지 선택지 — 직접 골라 해보세요:

**(A) 둘 다 살리기 (실전에서 가장 흔함)**
```
1: 제목
2: 내용 - 사과와 바나나
3: 끝맺음
```

마커(`<<<<<<<`, `=======`, `>>>>>>>`)는 **반드시 전부 삭제**합니다.

### 4-4. 해결 표시 후 진행

```bash
git add doc.txt
git rebase --continue
```

충돌이 없으면 rebase가 끝납니다. 확인:

```bash
cat doc.txt
git log --oneline --graph --all
```

## 5. 비상 탈출 연습 — `--abort`

이번엔 일부러 중간에 포기하는 것도 해봅시다. (실수했을 때를 대비)

```bash
# 다시 충돌 상황을 만든 뒤... (3번 반복)
git rebase develop
# 충돌 발생!

git rebase --abort      # 시작 직전으로 깨끗하게 복구
git status              # 충돌 흔적 없이 원래대로
```

> 꼬였을 때 `--abort`로 언제든 되돌릴 수 있다는 걸 **몸으로 기억**하세요.
> 이걸 알면 충돌이 하나도 안 무섭습니다.

## 6. (도전) merge로도 해보기

같은 충돌을 merge 방식으로 겪어보면 마무리 명령이 다릅니다:

```bash
git switch develop
git merge feature/edit-body   # 충돌 발생
# doc.txt 고치고 마커 삭제
git add doc.txt
git commit                    # rebase의 --continue 대신 commit 으로 마무리
```

## ✅ 체크포인트

- [ ] 일부러 충돌을 만들어봤다
- [ ] 충돌 마커를 읽고 직접 해결했다 (마커 삭제 포함)
- [ ] `git add` → `git rebase --continue`로 마무리했다
- [ ] `git rebase --abort`로 되돌려봤다
- [ ] 충돌이 더 이상 무섭지 않다 😎

---

⬅️ 이전: [02. 브랜치와 rebase](02-branch-and-rebase.md)
🏠 처음으로: [README](../README.md)
