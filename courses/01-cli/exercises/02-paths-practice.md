# 실습 02. 경로 읽기·쓰기 + 내 IP 확인 ★

> 🎯 목표: **절대 경로와 상대 경로**를 직접 써서 이동하고, `.` `..` `~` 가 어디를 가리키는지 몸으로 익힌다.
> 마지막에 **내 PC 의 IP** 를 찾아 메모한다. (ESP32·웹서버 실습에서 씀)
>
> 📎 관련 문서: [docs/03-paths.md](../docs/03-paths.md) · [docs/04-network-ip.md](../docs/04-network-ip.md)

## 1단계. 연습용 폴더 구조 만들기

홈 폴더에서 시작해 아래 구조를 만듭니다. (한 줄씩 치고 `ls` 로 확인하며)

```bash
cd ~
mkdir path-practice
cd path-practice
mkdir web esp32
mkdir web/static esp32/src
```

만들어진 구조:

```
~/path-practice/
   ├── web/
   │    └── static/
   └── esp32/
        └── src/
```

## 2단계. 상대 경로로 이동하기

지금 위치는 `~/path-practice` 입니다. 각 줄을 치고 **`pwd` 로 예상과 맞는지 확인**하세요.

```bash
cd web/static          # 두 칸 한 번에 들어가기      → ~/path-practice/web/static
pwd
cd ..                  # 한 칸 위                    → ~/path-practice/web
pwd
cd ../esp32            # 한 칸 위로 나가서 esp32 로   → ~/path-practice/esp32
pwd
cd src                 #                             → ~/path-practice/esp32/src
pwd
cd ../../web/static    # 두 칸 위 → web → static     → ~/path-practice/web/static
pwd
```

> 💡 `../../web/static` 을 치기 **전에** "어디로 갈까?" 를 먼저 예상해 보세요. 예상이 맞으면 경로를 읽을 수 있는 것입니다.

## 3단계. 절대 경로로 이동하기

지금 어디에 있든 **같은 곳**으로 가는 절대 경로를 씁니다. `pwd` 로 나온 값을 그대로 쓰면 됩니다.

```powershell
# Windows 예 (본인 경로로 바꾸세요)
cd C:\Users\나\path-practice\esp32\src
```

```bash
# macOS 예
cd /Users/나/path-practice/esp32/src
```

그다음 `cd ~` 로 홈에 갔다가, **같은 절대 경로를 다시 쳐서** 돌아와 보세요. 현재 위치와 무관하게 통하는 것을 확인합니다.

## 4단계. `~` 로 지름길

```bash
cd ~/path-practice/web       # 어디 있든 한 번에
pwd
cd ~                         # 홈으로
```

## 5단계. 파일을 상대 경로로 가리키기

`web/static` 에 파일을 만들고, **다른 폴더에서** 그 파일을 상대 경로로 읽어 봅니다.

```bash
cd ~/path-practice/web/static
echo "hello" > index.html          # 파일 만들기
cd ../../esp32/src                 # 멀리 이동
cat ../../web/static/index.html    # 여기서 저 파일을 상대 경로로 → hello 가 나오면 성공
cat ~/path-practice/web/static/index.html   # 같은 파일을 ~ 기준으로
```

## 6단계. 퀴즈 — 종이에 먼저 답하고 확인

지금 위치가 `~/path-practice/esp32/src` 일 때, 다음 명령 후 `pwd` 는?

| # | 명령 | 예상 | 실제 |
|---|------|------|------|
| 1 | `cd ..` | | |
| 2 | `cd ../web` (1번 이어서) | | |
| 3 | `cd static/../static` (2번 이어서) | | |
| 4 | `cd ~/path-practice` | | |
| 5 | `cd ../path-practice/esp32` (4번 이어서) | | |

<details>
<summary>답</summary>

1. `~/path-practice/esp32`
2. `~/path-practice/web`
3. `~/path-practice/web/static` (들어갔다 나왔다 다시 들어감)
4. `~/path-practice`
5. `~/path-practice/esp32` (한 칸 위로 나가서 다시 path-practice → esp32)

</details>

## 7단계. 내 PC 의 IP 확인

ESP32·웹서버 실습에서 쓸 **내 PC 의 IP** 를 미리 찾아 둡니다.

```powershell
# Windows
ipconfig                        # "무선 LAN 어댑터 Wi-Fi" 의 IPv4 주소
ipconfig | Select-String IPv4   # IPv4 줄만
```

```bash
# macOS
ipconfig getifaddr en0
```

찾은 주소(예: `192.168.0.10`)를 메모하세요. 그리고 **왜 `localhost` 를 다른 기기에서 쓸 수 없는지** 한 문장으로 설명해 보세요.

## 확인

- [ ] `cd ../..` 같은 상대 경로를 치기 전에 어디로 갈지 예상할 수 있다
- [ ] 절대 경로가 현재 위치와 무관하게 같은 곳을 가리키는 것을 확인했다
- [ ] `~` 가 홈 폴더의 지름길임을 알았다
- [ ] 다른 폴더에서 상대 경로로 파일을 읽었다
- [ ] 내 PC 의 IPv4 주소를 찾았다

## 정리 (선택)

```bash
cd ~
rm -r path-practice
```

## 🎓 마무리

축하합니다! **터미널 + 경로 + IP** 를 익혔습니다. 앞으로 모든 강좌에서 "어느 폴더에서 이 명령을 치는가" 를
의식하며 진행하면 됩니다.

➡️ 다음 강좌: [02-git](../../02-git/README.md)
