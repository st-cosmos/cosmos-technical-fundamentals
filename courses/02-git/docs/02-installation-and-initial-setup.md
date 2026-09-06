# 02. 설치와 초기설정

우리 팀은 **Windows 다수 / macOS 일부**입니다. 설치 확인과,
모든 팀원이 **공통으로 해야 하는 초기 설정**을 정리합니다. (00 강좌에서 이름/이메일을 이미 설정했다면
`git config --list` 로 확인하고 넘어가도 됩니다.)

> 초기 설정은 처음 한 번만 하면 됩니다. 특히 **줄바꿈(autocrlf) 설정**은 OS 혼재 팀에서
> 충돌을 줄이는 핵심이라 꼭 맞춰주세요.

## 1. 설치 확인

Git 은 [00-dev-environment-setup](../../00-dev-environment-setup/README.md) 에서 **이미 설치**했습니다
(Windows: winget `Git.Git`, macOS: Xcode Command Line Tools). 터미널에서 확인만 합니다.

```bash
git --version        # git version 2.x 가 나오면 OK
```

> 참고: 안 나오면 00 강좌의 [문제 해결](../../00-dev-environment-setup/docs/04-verify-and-troubleshoot.md) 을
> 보세요. 직접 설치하려면 Windows 는 `winget install --id Git.Git`, macOS 는 `xcode-select --install`.

### 커밋 그래프를 눈으로 — Git Graph 확장

00 강좌에서 VS Code 에 **Git Graph** 확장도 설치했습니다. 브랜치·커밋·병합을 **그림으로** 보여 주므로,
이 강좌의 rebase·conflict 를 이해할 때 큰 도움이 됩니다. VS Code 왼쪽 **Source Control** 패널 상단의
**Git Graph 아이콘**을 누르면 열립니다. (터미널의 `git log --oneline --graph --all` 과 같은 내용)

## 2. 공통 초기 설정 (모든 OS 필수)

### 2-1. 이름과 이메일 — 커밋에 새겨지는 신원

```bash
git config --global user.name "홍길동"
git config --global user.email "gildong@example.com"
```

> ⚠️ 이메일은 **GitHub 계정에 등록된 이메일**과 같게 하세요. 그래야 커밋이 GitHub에서
> 내 계정과 연결됩니다.

### 2-2. 기본 브랜치 이름을 main 으로

```bash
git config --global init.defaultBranch main
```

### 2-3. ★ 줄바꿈(line ending) 설정 — OS 혼재 팀 필수

Windows와 macOS/Linux는 줄 끝 처리 방식이 달라(CRLF vs LF), 설정을 안 맞추면
**내용은 같은데 파일 전체가 바뀐 것처럼 보이는** diff와 불필요한 충돌이 생깁니다.

```bash
# Windows
git config --global core.autocrlf true

# macOS / Linux
git config --global core.autocrlf input
```

> 저장소에는 `.gitattributes`로 한 번 더 못을 박아둡니다(이 교육 저장소 최상위에 이미 포함). 개인 설정과
> 저장소 설정을 함께 두면 가장 안전합니다. 자세한 배경은
> [05. conflict 문서](05-conflict-causes-and-resolution.md)에서 다룹니다.

### 2-4. 기본 에디터 (선택)

커밋 메시지 등을 작성할 때 열리는 에디터입니다. VS Code를 쓴다면:

```bash
git config --global core.editor "code --wait"
```

### 2-5. 설정 확인

```bash
git config --list
```

## 3. GitHub 인증 설정

GitHub에 push/pull 하려면 인증이 필요합니다. **비밀번호 입력 방식은 더 이상 안 됩니다.**
아래 둘 중 하나를 선택하세요.

### 방법 A. GitHub CLI (가장 쉬움, 추천)

```bash
# 설치: https://cli.github.com/
gh auth login
```

화면 안내(브라우저 로그인)를 따라가면 끝입니다. 이후 push/pull이 자동 인증됩니다.

### 방법 B. Personal Access Token (PAT)

1. GitHub → Settings → Developer settings → **Personal access tokens** 에서 토큰 발급
2. `git clone`/`push` 시 **비밀번호 자리에 토큰**을 입력
3. 매번 입력이 번거로우면 자격증명 저장:
   ```bash
   # Windows: Git Credential Manager가 기본 포함되어 자동 저장됩니다.
   # macOS:
   git config --global credential.helper osxkeychain
   ```

> SSH 키 방식도 있지만, 처음에는 **GitHub CLI(gh)** 가 가장 간단합니다.

## 4. 첫 저장소 받아오기 (clone)

팀 저장소를 내 컴퓨터로 복제합니다.

```bash
cd ~/workspace                 # 동아리 규칙: 모든 저장소는 ~/workspace 안에 (00 강좌)
# GitHub 저장소 페이지의 Code 버튼에서 주소 복사 후
git clone https://github.com/우리팀/저장소이름.git
cd 저장소이름
# 지금 브랜치: main  (git status 첫 줄 "On branch main" 으로 확인)
```

이제 준비 완료입니다. 직접 첫 커밋을 만들어보려면 실습으로 넘어가세요.

---

⬅️ 이전: [01. Git이란 무엇인가](01-what-is-git.md)
➡️ 다음: [03. 주요 명령어](03-essential-commands.md)
🛠️ 실습: [01. 설치와 첫 커밋](../exercises/01-installation-and-first-commit.md)
