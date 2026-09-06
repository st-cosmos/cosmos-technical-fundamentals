# 실습 01. 터미널로 폴더 다루기

> 🎯 목표: 터미널을 열어 **폴더를 만들고(mkdir) · 오가고(cd) · 목록을 보고(ls) · 현재 위치를 확인(pwd)** 한다.
> 마지막엔 만든 폴더를 VS Code 로 연다. 손이 기억할 때까지 직접 쳐 보는 게 핵심!
>
> 📎 관련 문서: [docs/01](../docs/01-what-is-terminal.md) · [docs/02](../docs/02-navigating-folders.md)

## 준비물

- 터미널 (Windows 는 **PowerShell 7** — 00 강좌에서 설치)
- 확인용으로 **탐색기(Finder) 창**을 옆에 함께 열어 두세요. 터미널에서 한 일이 탐색기에 그대로 보입니다.

## 1단계. 터미널 열고 현재 위치 확인

```bash
pwd
```

> 결과(예): `C:\Users\나` (Windows) / `/Users/나` (macOS) — 보통 홈 폴더에서 시작합니다.
> 탐색기에서 같은 폴더를 열어 두세요.

## 2단계. 연습용 폴더 만들고 들어가기

```bash
cd ~/workspace             # 동아리 작업 폴더로 (00 강좌에서 만듦 — 실습 폴더는 전부 이 안에)
mkdir cosmos-practice      # 새 폴더(서랍) 만들기 → 탐색기에 나타나는지 확인!
cd cosmos-practice         # 그 안으로 들어가기
pwd                        # 잘 들어왔는지 위치 재확인 → .../workspace/cosmos-practice
```

## 3단계. 하위 폴더 만들고 목록 보기

```bash
mkdir day1
mkdir day2
ls                         # day1, day2 가 보이면 성공
```

## 4단계. 들어갔다 나오기 (cd 연습)

```bash
cd day1                    # day1 안으로
pwd                        # ...cosmos-practice/day1
cd ..                      # 한 칸 밖으로 (cosmos-practice 로 복귀)
pwd                        # ...cosmos-practice
cd day2                    # 이번엔 day2
cd ..
```

> 💡 폴더 이름은 앞 글자만 치고 **Tab** 을 누르면 자동완성됩니다. (`cd d` → Tab → Tab 을 더 누르면 후보가 바뀜)

## 5단계. 파일 만들고 내용 보기

```powershell
# Windows (PowerShell 7)
New-Item day1/hello.txt -ItemType File
"안녕 터미널" > day1/hello.txt
cat day1/hello.txt
```

```bash
# macOS
touch day1/hello.txt
echo "안녕 터미널" > day1/hello.txt
cat day1/hello.txt
```

## 6단계. VS Code 로 열기

```bash
code .                     # 지금 폴더(cosmos-practice)를 VS Code 로
```

VS Code 왼쪽 탐색기에 `day1`, `day2`, `day1/hello.txt` 가 보이면 성공. `` Ctrl + ` `` 로 VS Code 안 터미널을
열고 `pwd` 를 쳐 보세요 — 같은 폴더입니다.

## 확인

- [ ] `pwd` 로 현재 위치가 보인다
- [ ] `mkdir` 로 만든 폴더가 `ls` 목록과 **탐색기 양쪽에** 나타난다
- [ ] `cd 폴더` / `cd ..` 로 자유롭게 오갈 수 있다
- [ ] Tab 자동완성을 써 봤다
- [ ] `code .` 로 폴더를 VS Code 로 열었다

## 정리 (연습 폴더 지우기 — 선택)

```bash
cd ..                      # cosmos-practice 밖으로 나온 뒤
pwd                        # 홈인지 확인하고
rm -r cosmos-practice      # 폴더 삭제
```

> ⚠️ `rm -r` 은 폴더를 **휴지통 없이 바로** 지웁니다. `pwd` 와 대상 이름을 꼭 확인하세요.

## 막히면?

| 증상 | 확인 |
|------|------|
| `mkdir`/`ls` 가 안 먹힘 | 오타 확인. PowerShell 7 인지(`$PSVersionTable.PSVersion`) |
| 이름에 띄어쓰기 있는 폴더 이동 실패 | 따옴표로 감싸기: `cd "My Folder"` |
| 위치를 잃음 | `pwd` 로 현재 위치, `cd ~` 로 홈으로 복귀 |
| `code` 명령 없음 | 00 강좌 [문제 해결](../../00-dev-environment-setup/docs/04-verify-and-troubleshoot.md) |

➡️ 다음: [실습 02. 경로 읽기·쓰기 + 내 IP 확인](02-paths-practice.md)
