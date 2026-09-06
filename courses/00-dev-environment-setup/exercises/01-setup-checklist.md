# 실습 01. 설치하고 체크리스트 채우기

> 🎯 목표: 내 PC 에 개발 도구를 **전부 설치**하고, 확인 스크립트로 검증한 뒤, 아래 체크리스트를 채운다.
> 이 체크리스트를 교육 담당자에게 보여 주면 이 강좌는 끝!
>
> 📎 관련 문서: Windows [docs/02](../docs/02-windows-setup.md) · macOS [docs/03](../docs/03-macos-setup.md) ·
> 문제 해결 [docs/04](../docs/04-verify-and-troubleshoot.md)

## 0단계. `workspace` 폴더

홈 폴더 안에 `workspace` 폴더를 만들고, 저장소 ZIP 을 그 안에 풉니다. (OS 문서 1절) 앞으로 모든 자료는 여기에.

## 1단계. 설치 스크립트 더블클릭

OS 에 맞는 문서를 따라 `scripts` 폴더의 설치 스크립트를 **더블클릭**합니다. (인터넷 속도에 따라 5~15분)

- Windows: `install-windows.cmd` · macOS: `install-macos.command`

## 2단계. 확인 스크립트 더블클릭

같은 폴더의 확인 스크립트를 더블클릭해 결과를 봅니다. (Windows: `check-windows.cmd` · macOS: `check-macos.command`)

터미널로 하려면 **새 터미널**(Windows 는 **PowerShell 7**)에서:

```powershell
# Windows
.\scripts\check-windows.ps1
```

```bash
# macOS
bash scripts/check-macos.command
```

## 3단계. 직접 버전 확인해 보기

스크립트 없이도 확인할 수 있어야 합니다. 아래를 한 줄씩 쳐서 **버전이 나오는지** 봅니다.

```bash
git --version
code --version
uv --version
codex --version
python --version        # macOS 는 python3 --version
```

## 4단계. 수동 설정

- [ ] `git config --global user.name` / `user.email` 설정 (이메일 = GitHub 계정 이메일)
- [ ] `codex login` → `codex login status` 로 로그인 확인
- [ ] VS Code 를 열어 PlatformIO 🛸 아이콘과 Git Graph 아이콘 확인

## ✅ 체크리스트 (채워서 제출)

| 항목 | 버전 / 상태 |
|------|-------------|
| OS (Windows / macOS) | |
| `~/workspace/cosmos-technical-fundamentals` 에 저장소가 있다 | ☐ |
| 터미널 (Windows: `pwsh` 버전) | |
| Git | |
| VS Code | |
| Python | |
| uv | |
| Codex CLI | |
| PlatformIO 확장 | ☐ |
| Git Graph 확장 | ☐ |
| Git 이름/이메일 설정 | ☐ |
| Codex 로그인 | ☐ |

## 막히면?

[docs/04-verify-and-troubleshoot.md](../docs/04-verify-and-troubleshoot.md) 의 표에서 증상을 찾으세요.
그래도 안 되면 **에러 메시지를 그대로 복사**해서 담당자에게 보여 주세요. (사진보다 글자 복사가 훨씬 빠릅니다)

## 🎓 마무리

축하합니다! 이제 다음 강좌 [01-cli](../../01-cli/README.md) 로 넘어가 터미널을 손에 익힙니다.
