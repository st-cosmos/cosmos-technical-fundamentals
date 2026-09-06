# 05. Conflict(충돌) 원인과 해결 ★

초보자가 가장 무서워하고, 가장 많이 막히는 부분입니다. 하지만 **원리를 알면 충돌은
무섭지 않습니다.** 이 문서 하나만 제대로 이해하면 됩니다.

> **핵심 한 줄**: 충돌은 Git이 "**두 사람이 같은 곳을 다르게 고쳤는데, 나는 누가 맞는지
> 모르겠어. 네가 정해줘**" 라고 도움을 요청하는 것입니다. **에러가 아닙니다.**

## 1. 충돌은 언제 생기나

Git은 대부분의 병합을 **자동으로** 처리합니다. 서로 다른 파일, 또는 같은 파일이라도
다른 줄을 고쳤다면 알아서 합칩니다.

**충돌은 단 하나의 상황에서만 생깁니다:**

> **두 갈래가 "같은 파일의 같은 부분"을 "서로 다르게" 바꿨을 때.**

Git 입장에선 어느 쪽을 택할지 판단할 수 없으니, 사람에게 결정을 넘깁니다.

### 충돌이 잘 나는 대표 상황

| 상황 | 왜 충돌나나 |
|------|------------|
| 두 사람이 **같은 함수/같은 줄**을 각자 수정 | 같은 부분을 다르게 고침 — 전형적 |
| 한 명이 **삭제**한 파일을 다른 명이 **수정** | 지울지 살릴지 Git이 모름 |
| `pull`/`rebase`로 남의 변경을 받을 때 내 변경과 겹침 | 위와 동일, 합치는 시점에 드러남 |
| **줄바꿈(CRLF/LF)** 차이로 파일 전체가 바뀐 것처럼 보임 | OS 혼재 팀의 숨은 원인 (아래 6번) |

### 충돌을 "예방"하는 습관

충돌은 못 막지만 **줄일 수** 있습니다.

- **자주 pull** 받아 develop과의 격차를 작게 유지
- **PR/브랜치를 작게** — 오래 묵힌 큰 브랜치일수록 충돌 폭탄
- **같은 파일을 동시에 크게 손대야 한다면** 팀원과 미리 분담
- 줄바꿈/포맷터 설정을 팀에서 통일 (6번 참고)

## 2. 충돌이 나면 보이는 화면

`pull`이나 `rebase`, `merge` 도중 충돌이 나면 이런 메시지가 뜹니다.

```
CONFLICT (content): Merge conflict in src/cart.js
Automatic merge failed; fix conflicts and then commit the result.
```

그리고 해당 파일을 열면 이렇게 **충돌 표시(conflict marker)** 가 들어가 있습니다.

```
<<<<<<< HEAD
    const total = price * quantity;          ← 내 쪽(현재 브랜치) 내용
=======
    const total = price * qty * (1 - discount);   ← 상대 쪽 내용
>>>>>>> feature/discount
```

읽는 법:

- `<<<<<<< HEAD` ~ `=======` : **내 쪽** 변경
- `=======` ~ `>>>>>>> 브랜치명` : **상대 쪽** 변경
- 이 마커들을 **직접 지우고**, 최종적으로 맞는 코드만 남기면 됩니다.

> rebase 중이라면 "HEAD"가 옮겨붙이는 대상(베이스), 아래쪽이 내 커밋일 수 있습니다.
> 헷갈리면 마커 옆 **브랜치 이름**을 보고 판단하세요.

## 3. 해결 절차 (그대로 따라하기)

### 1단계 — 어디서 충돌났는지 확인

```bash
# 지금 상태: 내 feature 브랜치에서 rebase 진행 중
git status
# 첫 줄에 "You are currently rebasing branch 'feature/...' on '...'" 가 보이고,
# "Unmerged paths" 아래에 충돌난 파일 목록이 보입니다.
```

### 2단계 — 파일을 열어 직접 고치기

충돌난 파일을 에디터로 열고, 각 충돌 블록마다 **결정**합니다.

- 내 것만 맞다 → 상대 쪽 + 마커 삭제
- 상대 것만 맞다 → 내 쪽 + 마커 삭제
- **둘 다 필요하다** → 둘을 합쳐 올바른 코드로 작성 (가장 흔함!)

> ⚠️ 흔한 실수: `<<<<<<<`, `=======`, `>>>>>>>` **마커를 지우지 않고** 저장하기.
> 마커는 코드가 아니라 표시일 뿐이니 **반드시 다 지워야** 합니다.

예시 — 둘 다 반영해 합친 결과:

```js
const total = price * quantity * (1 - discount);
```

VS Code를 쓰면 충돌 블록 위에 **"Accept Current / Accept Incoming / Accept Both"**
버튼이 떠서 클릭으로도 처리할 수 있습니다.

### 3단계 — 해결했다고 표시(add)

```bash
# 지금 상태: rebase 진행 중 (아직 feature 브랜치 이름이 아니라 "rebasing" 상태로 표시됨)
git add src/cart.js      # 충돌 해결한 파일을 add
git status               # 다른 충돌 파일이 남았는지 확인
```

### 4단계 — 마무리 (merge냐 rebase냐에 따라 다름)

```bash
# merge / pull(merge) 중이었다면:
git commit               # 병합 커밋 완성

# rebase / pull(rebase) 중이었다면 (우리 팀 기본):
git rebase --continue    # 다음 커밋으로 진행 (또 충돌나면 2~3단계 반복)
```

> rebase는 커밋을 하나씩 다시 쌓기 때문에 **충돌이 여러 번 연달아** 날 수 있습니다.
> 당황하지 말고 매번 같은 절차(고치고 → add → `--continue`)를 반복하면 됩니다.

## 4. 막혔을 때 — 비상 탈출

해결하다 꼬여서 **그냥 처음으로 돌아가고 싶다**면:

```bash
# rebase 중이라면
git rebase --abort

# merge 중이라면
git merge --abort

# pull 중이라면 (rebase pull이면 위 abort)
git merge --abort   # 또는 git rebase --abort
```

`abort`하면 **충돌 작업을 시작하기 직전 상태로 깨끗하게** 되돌아갑니다. 안전하니 겁내지 마세요.
정리한 뒤 다시 시도하면 됩니다.

## 5. 충돌이 무섭지 않게 — 마인드셋

- 충돌은 **잘못이 아니라 협업의 자연스러운 일부**입니다. 여러 명이 같이 고치면 당연히 생깁니다.
- Git은 **절대 멋대로 코드를 버리지 않습니다.** 양쪽을 다 보여주고 당신의 결정을 기다릴 뿐입니다.
- 모르면 **`git status`** 가 항상 "지금 뭘 해야 하는지" 안내해 줍니다.
- 정 안 되면 **`--abort`로 되돌리고** 팀원에게 물어보세요. 잃는 것 없습니다.

## 6. 숨은 충돌 원인 — 줄바꿈(CRLF/LF) ★ OS 혼재 팀 주의

우리 팀은 Windows/macOS/Linux가 섞여 있어, 이 문제가 **조용히** 충돌과 거대한
가짜 diff를 만듭니다.

- 증상: "한 줄도 안 고쳤는데 **파일 전체가 변경**으로 표시", 의미 없는 충돌
- 원인: Windows는 줄 끝이 `CRLF`, macOS/Linux는 `LF`. 설정이 다르면 Git이
  모든 줄을 "바뀌었다"고 인식
- 해결(이 교육 저장소 최상위에 이미 적용됨):
  - 저장소에 **`.gitattributes`** 로 `* text=auto eol=lf` 못 박기
  - 각자 `git config --global core.autocrlf`를 OS에 맞게 (Windows `true`, mac/Linux `input`)
    — [02 문서](02-installation-and-initial-setup.md) 참고

이 설정이 갖춰지면 줄바꿈발 충돌은 사라집니다.

---

⬅️ 이전: [04. 우리 팀 워크플로우](04-our-team-workflow.md)
➡️ 다음: [06. GitHub 협업 설정](06-github-collaboration-setup.md)
🛠️ 실습: [03. conflict 만들고 해결하기](../exercises/03-creating-and-resolving-conflicts.md) ★ 꼭 해보세요
