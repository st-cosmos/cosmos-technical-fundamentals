<#
.SYNOPSIS
  COSMOS 개발 환경 설치 확인 (Windows)

.DESCRIPTION
  각 도구의 버전을 출력하고 [OK]/[MISSING] 으로 표시합니다.
  설치 직후라면 반드시 "새 터미널(PowerShell 7)" 에서 실행하세요.
#>
#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"

$results = @()
function Check($name, [scriptblock]$probe, $hint) {
  $version = $null
  try { $version = (& $probe 2>$null | Select-Object -First 1 | Out-String).Trim() } catch { $version = $null }
  $ok = -not [string]::IsNullOrWhiteSpace($version)
  $script:results += [pscustomobject]@{
    상태 = $(if ($ok) { "[OK]" } else { "[MISSING]" })
    도구 = $name
    버전 = $(if ($ok) { $version } else { "-" })
    조치 = $(if ($ok) { "" } else { $hint })
  }
}

Check "PowerShell 7 (pwsh)" { pwsh -NoProfile -Command '$PSVersionTable.PSVersion.ToString()' } "winget install --id Microsoft.PowerShell"
Check "Git"                 { git --version }        "winget install --id Git.Git"
Check "VS Code (code)"      { code --version }       "winget install --id Microsoft.VisualStudioCode 후 새 터미널"
Check "Python"              { python --version }     "winget install --id Python.Python.3.12 (앱 실행 별칭 확인)"
Check "uv"                  { uv --version }         "winget install --id astral-sh.uv"
Check "Codex CLI"           { codex --version }      "winget install --id OpenAI.Codex"

# VS Code 확장
$exts = @()
try { $exts = code --list-extensions 2>$null } catch {}
foreach ($pair in @(@("PlatformIO 확장", "platformio.platformio-ide"), @("Git Graph 확장", "mhutchie.git-graph"))) {
  $name, $id = $pair
  $has = $exts -contains $id
  $results += [pscustomobject]@{
    상태 = $(if ($has) { "[OK]" } else { "[MISSING]" })
    도구 = $name
    버전 = $(if ($has) { $id } else { "-" })
    조치 = $(if ($has) { "" } else { "code --install-extension $id" })
  }
}

# Codex 로그인 (선택)
$login = (codex login status 2>&1 | Out-String).Trim()
$loggedIn = $login -match "(?i)logged in" -and $login -notmatch "(?i)not logged in"
$results += [pscustomobject]@{
  상태 = $(if ($loggedIn) { "[OK]" } else { "[TODO]" })
  도구 = "Codex 로그인 (선택)"
  버전 = $(if ($loggedIn) { "로그인됨" } else { "-" })
  조치 = $(if ($loggedIn) { "" } else { "codex login" })
}

# 현재 셸 안내
$shellNote = if ($PSVersionTable.PSVersion.Major -ge 7) { "PowerShell $($PSVersionTable.PSVersion) 에서 실행 중" } else { "지금은 PowerShell $($PSVersionTable.PSVersion) 입니다. 확인이 끝나면 앞으로는 PowerShell 7(pwsh) 을 쓰세요." }

Write-Host ""
Write-Host "COSMOS 개발 환경 확인 — Windows" -ForegroundColor Cyan
Write-Host $shellNote -ForegroundColor DarkGray
$results | Format-Table -AutoSize -Wrap

$missing = @($results | Where-Object { $_.상태 -eq "[MISSING]" })
if ($missing.Count -eq 0) {
  Write-Host "모든 도구가 설치되어 있습니다. 🎉  다음: git config, codex login, VS Code 첫 실행 (docs/02 5~7절)" -ForegroundColor Green
} else {
  Write-Host "$($missing.Count)개 항목이 빠져 있습니다. '조치' 열의 명령을 실행하고 새 터미널에서 다시 확인하세요. (docs/04 참고)" -ForegroundColor Yellow
}
