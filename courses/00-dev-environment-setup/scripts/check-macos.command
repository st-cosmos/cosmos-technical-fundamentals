#!/usr/bin/env bash
# ============================================================
# COSMOS 개발 환경 설치 확인 (macOS)
# 각 도구의 버전을 출력하고 [OK]/[MISSING] 으로 표시합니다.
# 실행: 이 파일 더블클릭 (새 터미널 창이라 방금 설치한 것이 바로 보임)
#       또는 새 터미널에서  bash scripts/check-macos.command
# ============================================================
set -u
MISSING=0

row() {  # $1=상태 $2=도구 $3=버전 $4=조치
  printf "  %-10s %-22s %-32s %s\n" "$1" "$2" "$3" "$4"
}
check() {  # $1=도구 $2=명령 $3=조치
  local v
  v="$(eval "$2" 2>/dev/null | head -1)"
  if [ -n "$v" ]; then row "[OK]" "$1" "$v" ""; else row "[MISSING]" "$1" "-" "$3"; MISSING=$((MISSING+1)); fi
}

printf "\n\033[36mCOSMOS 개발 환경 확인 — macOS\033[0m\n"
printf "  \033[90m%-10s %-22s %-32s %s\033[0m\n" "상태" "도구" "버전" "조치"

check "터미널(zsh)"   'echo "zsh $ZSH_VERSION${ZSH_VERSION:+ }$(zsh --version 2>/dev/null | cut -d" " -f2)"' ""
check "Git"           'git --version'          "xcode-select --install"
check "Homebrew"      'brew --version'         'eval "$(/opt/homebrew/bin/brew shellenv)" 후 ~/.zprofile 추가'
check "VS Code (code)" 'code --version'        "VS Code 에서 Shell Command: Install code command in PATH"
check "Python 3"      'python3 --version'      "기본 포함. 없으면 xcode-select --install"
check "uv"            'uv --version'           "brew install uv"
check "Codex CLI"     'codex --version'        "brew install codex"

EXTS="$(code --list-extensions 2>/dev/null)"
for pair in "PlatformIO 확장:platformio.platformio-ide" "Git Graph 확장:mhutchie.git-graph"; do
  name="${pair%%:*}"; id="${pair##*:}"
  if echo "$EXTS" | grep -qx "$id"; then row "[OK]" "$name" "$id" ""; else row "[MISSING]" "$name" "-" "code --install-extension $id"; MISSING=$((MISSING+1)); fi
done

LOGIN="$(codex login status 2>&1 | head -1)"
if echo "$LOGIN" | grep -qi "logged in" && ! echo "$LOGIN" | grep -qi "not logged in"; then
  row "[OK]" "Codex 로그인 (선택)" "로그인됨" ""
else
  row "[TODO]" "Codex 로그인 (선택)" "-" "codex login"
fi

echo
if [ "$MISSING" -eq 0 ]; then
  printf "\033[32m모든 도구가 설치되어 있습니다. 🎉  다음: git config, codex login, VS Code 첫 실행 (docs/03 5~7절)\033[0m\n"
else
  printf "\033[33m%d개 항목이 빠져 있습니다. '조치' 열의 명령을 실행하고 새 터미널에서 다시 확인하세요. (docs/04 참고)\033[0m\n" "$MISSING"
fi
