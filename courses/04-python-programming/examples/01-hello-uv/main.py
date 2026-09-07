"""04 Python — 예제 01: uv 첫 프로젝트.

`uv init hello-uv` 가 만들어 준 main.py 에 입력 처리와 외부 패키지(cowsay) 사용을 더한 것.

실행:
    uv run main.py
"""

import sys

import cowsay

sys.stdout.reconfigure(encoding="utf-8")  # Windows 콘솔(cp949)에서 한글 출력 깨짐 방지
sys.stdin.reconfigure(encoding="utf-8")


def main():
    name = input("이름: ").strip() or "익명"   # 빈 입력이면 "익명"
    cowsay.cow(f"안녕, {name} 님! 파이썬 시작합니다.")


if __name__ == "__main__":   # 이 파일을 직접 실행했을 때만 main() 호출
    main()
