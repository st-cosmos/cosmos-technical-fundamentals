#!/usr/bin/env bash
# ============================================================
# COSMOS 개발 환경 일괄 설치 (macOS)
# ------------------------------------------------------------
# Homebrew 로 아래 도구를 설치하고 VS Code 확장을 추가합니다.
# 이미 설치된 것은 건너뜁니다. 여러 번 실행해도 안전합니다.
#
#   - Homebrew                  (없으면 설치)
#   - Xcode Command Line Tools  (Git 포함, 없으면 설치 창 표시)
#   - Visual Studio Code        (brew --cask visual-studio-code)
#   - uv                        (brew uv)
#   - Codex CLI                 (brew codex, 실패 시 npm)
#   - VS Code 확장: platformio.platformio-ide, mhutchie.git-graph
#
# 실행:  Finder 에서 이 파일(install-macos.command) 더블클릭  (권장)
#        처음엔 macOS 가 막습니다 → 시스템 설정 → 개인정보 보호 및 보안 → "그래도 열기"
#        터미널로는:  bash scripts/install-macos.command
# 확인:  check-macos.command 더블클릭  (또는 새 터미널에서 bash scripts/check-macos.command)
# 이 스크립트는 다른 파일에 의존하지 않으므로 어느 폴더에서 실행해도 됩니다.
# ============================================================
set -u

FAILED=()
step() { printf "\n\033[36m==> %s\033[0m\n" "$1"; }
ok()   { printf "    \033[32m[OK]\033[0m %s\n" "$1"; }
skip() { printf "    \033[90m[SKIP]\033[0m %s (이미 설치됨)\n" "$1"; }
fail() { printf "    \033[31m[FAIL]\033[0m %s\n" "$1"; FAILED+=("$1"); }

# ---------- 1. Xcode Command Line Tools (git 포함) ----------
step "Xcode Command Line Tools (Git) 확인"
if xcode-select -p >/dev/null 2>&1; then
  ok "설치됨: $(git --version 2>/dev/null)"
else
  echo "    설치 창이 뜹니다. [설치] 를 누르고, 끝나면 이 스크립트를 다시 실행하세요."
  xcode-select --install 2>/dev/null || true
  fail "Xcode Command Line Tools — 설치 후 스크립트 재실행 필요"
fi

# ---------- 2. Homebrew ----------
step "Homebrew 확인"
if ! command -v brew >/dev/null 2>&1; then
  # Apple Silicon 기본 경로에 이미 있을 수 있음
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
if command -v brew >/dev/null 2>&1; then
  skip "Homebrew $(brew --version | head -1)"
else
  echo "    Homebrew 를 설치합니다. 관리자 비밀번호를 물으면 입력하고 Enter 를 누르세요."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    BREW_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    BREW_LINE='eval "$(/usr/local/bin/brew shellenv)"'
  fi
  if command -v brew >/dev/null 2>&1; then
    ok "Homebrew 설치 완료"
    # 새 터미널에서도 brew 가 보이도록 ~/.zprofile 에 추가
    if [ -n "${BREW_LINE:-}" ] && ! grep -qs "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
      echo "$BREW_LINE" >> "$HOME/.zprofile" && ok "~/.zprofile 에 brew 경로 추가"
    fi
  else
    fail "Homebrew 설치 실패 — https://brew.sh 안내를 따라 수동 설치 후 재실행"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  printf "\n\033[31mHomebrew 가 없어 더 진행할 수 없습니다.\033[0m\n"; exit 1
fi

# ---------- 3. brew 패키지 ----------
brew_formula() {   # $1=formula  $2=표시이름
  step "$2 설치"
  if brew list --formula "$1" >/dev/null 2>&1; then skip "$2"; return; fi
  if brew install "$1"; then ok "$2 설치 완료"; else fail "$2"; fi
}
brew_cask() {      # $1=cask  $2=표시이름  $3=앱 경로(이미 있으면 건너뜀)
  step "$2 설치"
  if brew list --cask "$1" >/dev/null 2>&1 || [ -d "$3" ]; then skip "$2"; return; fi
  if brew install --cask "$1"; then ok "$2 설치 완료"; else fail "$2"; fi
}

brew_cask    visual-studio-code "Visual Studio Code" "/Applications/Visual Studio Code.app"
brew_formula uv                 "uv"

step "Codex CLI 설치"
if command -v codex >/dev/null 2>&1; then
  skip "Codex CLI $(codex --version 2>/dev/null)"
elif brew install codex 2>/dev/null; then
  ok "Codex CLI 설치 완료 (brew)"
else
  echo "    brew 로 설치되지 않아 npm 으로 시도합니다."
  command -v node >/dev/null 2>&1 || brew install node
  if npm install -g @openai/codex; then ok "Codex CLI 설치 완료 (npm)"; else fail "Codex CLI"; fi
fi

# ---------- 4. VS Code 확장 ----------
step "VS Code 확장 설치 (PlatformIO, Git Graph)"
CODE_BIN="$(command -v code || true)"
[ -z "$CODE_BIN" ] && [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ] \
  && CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [ -n "$CODE_BIN" ]; then
  for ext in platformio.platformio-ide mhutchie.git-graph; do
    if "$CODE_BIN" --install-extension "$ext" --force >/dev/null 2>&1; then ok "$ext"; else fail "VS Code 확장 $ext"; fi
  done
else
  fail "code 명령을 찾을 수 없음 — VS Code 에서 'Shell Command: Install code command in PATH' 실행 후 재실행"
fi

# ---------- 5. 결과 ----------
printf "\n\033[36m============================================================\033[0m\n"
if [ ${#FAILED[@]} -eq 0 ]; then
  printf "\033[32m 설치가 끝났습니다.\033[0m\n"
else
  printf "\033[33m 일부 항목이 실패했습니다:\033[0m\n"
  for f in "${FAILED[@]}"; do printf "\033[33m   - %s\033[0m\n" "$f"; done
  printf "\033[33m docs/04-verify-and-troubleshoot.md 를 참고해 조치한 뒤 다시 실행하세요.\033[0m\n"
fi
cat <<'EOF'

 다음 단계:
   1) 이 창을 닫습니다.
   2) 같은 폴더의  check-macos.command  를 더블클릭해 확인합니다.
      (터미널로 하려면: 새 터미널에서  bash scripts/check-macos.command)
   3) git config / codex login / VS Code 첫 실행 (docs/03-macos-setup.md 5~7절)
============================================================
EOF
