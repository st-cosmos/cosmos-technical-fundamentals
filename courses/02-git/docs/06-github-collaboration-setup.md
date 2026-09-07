# 06. GitHub 협업 설정 (3~5인 팀)

GitHub 저장소를 만들면 끝이 아니라, **팀이 안전하게 협업하도록** 몇 가지 설정을
켜두는 게 좋습니다. 3~5인 소규모 팀에 딱 맞는, **꼭 필요한 것만** 정리했습니다.

> 이 설정들의 목표: ① `main`/`develop`을 실수로 망치지 않기 ② 모든 변경이
> **리뷰를 거치게** 하기 ③ 이력을 깔끔하게(rebase 로 정리 + `--no-ff` merge 커밋) 유지하기

## 0. 한눈에 보는 체크리스트

저장소 관리자(보통 팀 리더)가 한 번 설정하면 됩니다.

- [ ] **Branch protection** — `main`, `develop` 보호 (직접 push 금지, PR 필수)
- [ ] **PR 1명 이상 리뷰 승인** 필수
- [ ] **머지 방식 정리** — merge commit(`--no-ff`)만 허용, Squash·Rebase 버튼 끄기
- [ ] **머지된 브랜치 자동 삭제** 켜기
- [ ] **PR/이슈 템플릿, CODEOWNERS** 추가 (이 저장소에 이미 포함)
- [ ] (선택) **CI 통과를 머지 조건**으로

## 1. Branch protection rule (가장 중요)

**Settings → Branches → Add branch ruleset (또는 Add rule)** 에서 `main`과 `develop`에
규칙을 겁니다. 권장 옵션:

| 옵션 | 설정 | 이유 |
|------|------|------|
| Require a pull request before merging | ✅ | 직접 push 금지, 무조건 PR로 |
| Require approvals (1명 이상) | ✅ (1) | 최소 1명 리뷰 강제 |
| Dismiss stale approvals when new commits pushed | ✅ | 승인 후 코드 바뀌면 재리뷰 |
| Require status checks to pass | ✅ (CI 있으면) | 깨진 코드 머지 방지 |
| Require linear history | ☐ **끔** | 우리 팀은 `--no-ff` merge 커밋을 남기므로 켜면 병합이 막힘 |
| Do not allow bypassing the above settings | ✅ | 관리자도 규칙 따르게 |

> **Require linear history** 는 merge 커밋을 차단하는 옵션입니다. 우리 팀 규칙(rebase 로 정리 후
> `--no-ff` merge)과 충돌하므로 **켜지 않습니다.** 대신 PR 올리기 전 rebase 를 습관으로 합니다(04 문서 4-2).

## 2. 머지 방식 통일

**Settings → General → Pull Requests** 에서:

- ☑ Allow merge commits → **켜기** — 기본 메시지는 "Pull request title and description" 추천
- ☐ Allow squash merging → **끄기**
- ☐ Allow rebase merging → **끄기**
- ☑ **Automatically delete head branches** → 켜기 (머지된 feature 브랜치 자동 정리)

> 버튼을 **하나만** 남기는 게 핵심입니다. PR 의 "Create a merge commit" = 로컬의 `git merge --no-ff`.
> 결과가 같으니 로컬에서 합치든 GitHub 에서 합치든 이력 모양이 똑같아집니다.

## 3. 이 저장소에 이미 들어있는 협업 파일

아래는 코드로 관리되는 설정이라, 저장소에 두면 **모든 팀원에게 자동 적용**됩니다.
이 교육 저장소(`cosmos-technical-fundamentals`)의 **최상위 폴더**에 실제 예시가 들어 있으니 열어 보세요.

| 파일 | 역할 |
|------|------|
| `.github/pull_request_template.md` | PR 생성 시 설명 양식 자동 입력 |
| `.github/ISSUE_TEMPLATE/bug_report.md` | 버그 이슈 양식 |
| `.github/ISSUE_TEMPLATE/feature_request.md` | 기능 요청 양식 |
| `.github/CODEOWNERS` | 특정 경로 변경 시 자동으로 지정 리뷰어 요청 |
| `.gitignore` | 불필요한 파일이 커밋되지 않게 |
| `.gitattributes` | 줄바꿈(CRLF/LF) 통일 — OS 혼재 팀 필수 |

### CODEOWNERS 사용법

`.github/CODEOWNERS`에 "경로 → 책임자"를 적어두면, 그 경로를 바꾸는 PR에
**자동으로 리뷰어가 지정**됩니다. 예:

```
# 전체 기본 리뷰어
*               @team-lead

# 문서는 누구나
/docs/          @writer-a @writer-b
```

> GitHub 사용자명(@아이디)으로 적어야 하며, 해당 사용자는 저장소에 접근 권한이 있어야 합니다.
> 저장소의 `.github/CODEOWNERS`를 팀에 맞게 수정하세요.

## 4. 팀원 권한 (Collaborators)

**Settings → Collaborators** 에서 팀원을 초대합니다. 3~5인 팀이면:

- 대부분 **Write** 권한 (브랜치 push + PR 생성 가능, 단 보호된 브랜치는 PR로만)
- 저장소 관리자 1~2명만 **Admin**

## 5. (선택) 자동 검사 — GitHub Actions

여력이 되면 PR마다 **자동으로 빌드/테스트/린트**를 돌리는 CI를 추가하면 좋습니다.
초보 팀은 처음부터 무리할 필요 없고, 익숙해진 뒤 도입해도 됩니다. 이 교육 저장소 자체에는
선택적으로 "슬라이드가 정상 빌드되는지" 검사하는 워크플로를 둘 수 있습니다.

## 6. 요약

소규모 팀이 **이것만** 해도 협업 품질이 확 올라갑니다:

1. `main`/`develop`에 **branch protection** + **PR 1명 리뷰 필수**
2. **merge commit(`--no-ff`)으로 머지 통일**, Squash·Rebase 버튼 끄기, 머지 후 브랜치 자동 삭제
3. **PR/이슈 템플릿 + CODEOWNERS**로 리뷰 흐름 자동화

---

⬅️ 이전: [05. conflict 원인과 해결](05-conflict-causes-and-resolution.md)
➡️ 다음: [07. Git 치트시트](07-cheatsheet.md)
🏠 처음으로: [README](../README.md)
