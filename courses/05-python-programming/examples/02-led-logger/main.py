"""05 Python — 예제 02: LED 이력 기록기 (콘솔).

이름과 on/off 명령을 입력받아 LED 상태와 변경 이력을 기록하고, 종료 시 JSON 파일에 저장한다.
다시 실행하면 파일에서 이력을 불러와 이어진다.

데이터 모양은 06-web-server-python 의 LED 서버와 같다:
    led     = {"on": bool, "by": str, "time": "HH:MM:SS"}
    history = [led, led, ...]

실행:
    uv run main.py
명령:
    on / off  — LED 켜기/끄기 (이름과 시각을 이력에 기록)
    list      — 이력 보기
    stats     — 통계
    quit      — 저장하고 종료
"""

import json
import sys
from datetime import datetime
from pathlib import Path

# Windows 콘솔(cp949)에서 한글·이모지 출력이 깨지거나 오류 나는 것을 막는다.
# (터미널에 직접 출력할 땐 보통 문제없지만, 파이프로 넘길 때 UnicodeEncodeError 가 날 수 있음)
sys.stdout.reconfigure(encoding="utf-8")
sys.stdin.reconfigure(encoding="utf-8")

FILE = Path("history.json")  # 이력 저장 파일 (실행한 폴더 기준)

led = {"on": False, "by": "아직 아무도", "time": "-"}  # 현재 상태
history: list[dict] = []  # [{on, by, time}, ...]


def now() -> str:
    """현재 시각을 HH:MM:SS 문자열로."""
    return datetime.now().strftime("%H:%M:%S")


def set_led(on: bool, by: str) -> dict:
    """상태를 바꾸고 이력에 한 줄 추가한 뒤, 새 상태를 돌려준다.

    06 강좌의 PUT /api/led 가 하는 일과 같다.
    """
    led["on"] = on
    led["by"] = by
    led["time"] = now()
    history.append(dict(led))  # 복사해서 넣기 (같은 딕셔너리를 공유하지 않도록)
    return led


def describe(entry: dict) -> str:
    state = "켰" if entry["on"] else "껐"
    return f"[{entry['time']}] {entry['by']} 님이 LED를 {state}습니다"


def status_line() -> str:
    lamp = "🟡 ON" if led["on"] else "⚪ OFF"
    if led["time"] == "-":
        return f"현재 상태: {lamp}"
    return f"현재 상태: {lamp}  (마지막: {led['by']}, {led['time']})"


def print_history(limit: int = 10) -> None:
    if not history:
        print("  (기록 없음)")
        return
    start = max(0, len(history) - limit)
    for i, h in enumerate(history[start:], start=start + 1):
        print(f"  {i}. [{h['time']}] {h['by']} {'켬' if h['on'] else '끔'}")
    if start > 0:
        print(f"  ... 이전 {start}건 생략")


def print_stats() -> None:
    on_count = len([h for h in history if h["on"]])
    off_count = len(history) - on_count
    by_count: dict[str, int] = {}
    for h in history:
        by_count[h["by"]] = by_count.get(h["by"], 0) + 1
    print(f"  켠 횟수 {on_count} · 끈 횟수 {off_count} · 총 {len(history)}건")
    if by_count:
        top = max(by_count, key=by_count.get)
        print(f"  가장 많이 바꾼 사람: {top} ({by_count[top]}회)")


def load() -> None:
    """파일이 있으면 이력을 불러오고, 마지막 항목으로 현재 상태를 복원한다."""
    global history
    try:
        history = json.loads(FILE.read_text(encoding="utf-8"))
    except FileNotFoundError:
        history = []  # 첫 실행
    except json.JSONDecodeError:
        print(f"⚠️ {FILE} 이 손상되어 새로 시작합니다")
        history = []
    if history:
        led.update(history[-1])


def save() -> None:
    FILE.write_text(json.dumps(history, ensure_ascii=False, indent=2), encoding="utf-8")


def main() -> None:
    load()
    print("💡 LED 이력 기록기 (명령: on / off / list / stats / quit)")
    print(status_line())

    while True:
        try:
            name = input("\n이름: ").strip() or "익명"
            cmd = input("명령: ").strip().lower()
        except (EOFError, KeyboardInterrupt):  # Ctrl+C / Ctrl+D 로도 정상 종료
            print()
            break

        if cmd == "quit":
            break
        elif cmd in ("on", "1"):
            print("→", describe(set_led(True, name)))
        elif cmd in ("off", "0"):
            print("→", describe(set_led(False, name)))
        elif cmd == "list":
            print_history()
        elif cmd == "stats":
            print_stats()
        else:
            print(f"알 수 없는 명령: {cmd!r}  (on / off / list / stats / quit)")
            continue
        print(status_line())

    save()
    print(f"기록 {len(history)}건을 {FILE} 에 저장했습니다. 안녕!")


if __name__ == "__main__":
    main()
