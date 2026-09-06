<#
.SYNOPSIS
  COSMOS 개발 환경 일괄 설치 (Windows)

.DESCRIPTION
  winget 으로 아래 도구를 설치하고, VS Code 확장(PlatformIO, Git Graph)을 추가합니다.
  이미 설치된 것은 건너뜁니다. 여러 번 실행해도 안전합니다.

    - PowerShell 7          (Microsoft.PowerShell)
    - Git                   (Git.Git)
    - Visual Studio Code    (Microsoft.VisualStudioCode)
    - Python 3.12           (Python.Python.3.12)
    - uv                    (astral-sh.uv)
    - Codex CLI             (OpenAI.Codex)
    - VS Code 확장: platformio.platformio-ide, mhutchie.git-graph

.NOTES
  실행 방법:
    ① 더블클릭: 같은 폴더의 install-windows.cmd  (권장 — 터미널을 몰라도 됨)
    ② 터미널 (기본 PowerShell 5.1 에서도 동작):
         Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
         .\scripts\install-windows.ps1

  설치 후에는 check-windows.cmd 를 더블클릭 (또는 새 PowerShell 7 창에서 .\scripts\check-windows.ps1) 로 확인하세요.
  이 스크립트는 다른 파일에 의존하지 않으므로 어느 폴더에서 실행해도 됩니다.
#>
#Requires -Version 5.1
$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$failed = New-Object System.Collections.Generic.List[string]

function Write-Step($msg) { Write-Host ""; Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Skip($msg) { Write-Host "    [SKIP] $msg (이미 설치됨)" -ForegroundColor DarkGray }
function Write-Fail($msg) { Write-Host "    [FAIL] $msg" -ForegroundColor Red }

# ---------- 0. 동아리 작업 폴더 (~\workspace) ----------
Write-Step "동아리 작업 폴더 확인 (~\workspace)"
$workspace = Join-Path $HOME "workspace"
if (Test-Path $workspace) {
  Write-Ok "$workspace (이미 있음)"
} else {
  New-Item -ItemType Directory -Path $workspace | Out-Null
  Write-Ok "$workspace 생성 — 앞으로 모든 동아리 자료·프로젝트는 이 안에 둡니다"
}

# ---------- 1. winget 확인 ----------
Write-Step "winget 확인"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Fail "winget 을 찾을 수 없습니다. Microsoft Store 에서 '앱 설치 관리자(App Installer)' 를 업데이트한 뒤 다시 실행하세요."
  exit 1
}
Write-Ok ("winget " + (winget --version))

# ---------- 2. winget 패키지 ----------
function Test-WingetInstalled($id) {
  $out = winget list --id $id --exact --accept-source-agreements 2>$null | Out-String
  return ($out -match [regex]::Escape($id))
}

function Install-Package($id, $name) {
  Write-Step "$name 설치"
  if (Test-WingetInstalled $id) { Write-Skip $name; return }
  winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -eq 0 -or (Test-WingetInstalled $id)) {
    Write-Ok "$name 설치 완료"
  } else {
    Write-Fail "$name 설치 실패 (winget 종료코드 $LASTEXITCODE)"
    $failed.Add($name)
  }
}

Install-Package "Microsoft.PowerShell"        "PowerShell 7"
Install-Package "Git.Git"                     "Git"
Install-Package "Microsoft.VisualStudioCode"  "Visual Studio Code"
Install-Package "Python.Python.3.12"          "Python 3.12"
Install-Package "astral-sh.uv"                "uv"
Install-Package "OpenAI.Codex"                "Codex CLI"

# ---------- 3. PATH 새로 읽기 (이 세션에서 code/git 등을 바로 쓰기 위해) ----------
Write-Step "PATH 갱신"
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")
Write-Ok "완료"

# ---------- 4. VS Code 확장 ----------
Write-Step "VS Code 확장 설치 (PlatformIO, Git Graph)"
$code = Get-Command code -ErrorAction SilentlyContinue
if (-not $code) {
  $candidate = Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin\code.cmd"
  if (Test-Path $candidate) { $code = $candidate } else { $code = $null }
} else { $code = $code.Source }

if ($code) {
  foreach ($ext in @("platformio.platformio-ide", "mhutchie.git-graph")) {
    & $code --install-extension $ext --force 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Ok $ext } else { Write-Fail $ext; $failed.Add("VS Code 확장 $ext") }
  }
} else {
  Write-Fail "code 명령을 찾을 수 없어 확장을 설치하지 못했습니다. 터미널을 새로 열고 다시 실행하세요."
  $failed.Add("VS Code 확장")
}

# ---------- 5. 결과 ----------
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
if ($failed.Count -eq 0) {
  Write-Host " 설치가 끝났습니다." -ForegroundColor Green
} else {
  Write-Host " 일부 항목이 실패했습니다:" -ForegroundColor Yellow
  $failed | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
  Write-Host " docs/04-verify-and-troubleshoot.md 를 참고해 조치한 뒤 다시 실행하세요." -ForegroundColor Yellow
}
Write-Host ""
Write-Host " 다음 단계:" -ForegroundColor Cyan
Write-Host "   1) 아무 키나 눌러 이 창을 닫습니다."
Write-Host "   2) 같은 폴더의  check-windows.cmd  를 더블클릭해 확인합니다."
Write-Host "      (터미널로 하려면: 시작 메뉴에서 'PowerShell 7' 을 새로 열고  .\scripts\check-windows.ps1)"
Write-Host "   3) git config / codex login / VS Code 첫 실행 (docs/02-windows-setup.md 5~7절)"
Write-Host "============================================================" -ForegroundColor Cyan
