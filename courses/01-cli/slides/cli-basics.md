---
marp: true
theme: cosmos
paginate: true
footer: "01 · CLI 기초"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 01</div>

# CLI 기초

<div class="rule"></div>

<div class="subtitle">터미널 · 폴더 오가기 · 경로 · 내 IP</div>

<div class="meta">
Windows PowerShell 7 · macOS zsh<br>
대상: 터미널이 처음인 부원 · 이후 모든 강좌의 기본기
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. **터미널이란?** — 마우스 대신 "글자 명령"
2. **폴더 오가기** — `pwd` · `ls` · `cd` · `mkdir` (서랍장 비유)
3. ★ **경로** — 절대 경로 vs 상대 경로, `.` `..` `~`
4. **내 IP 확인** — `ipconfig` / `ifconfig`

> 핵심 한 줄: **터미널에서 하는 일 = 탐색기에서 폴더 여닫는 것.** 방법만 다릅니다.

---

<!-- _class: section -->
<div class="eyebrow">PART 1</div>

# 터미널이란?

<div class="lead-sub">마우스 대신 글자로 시키기</div>

---

## 하는 일은 똑같다, 방법만 다르다

| 하고 싶은 일 | 탐색기 / Finder | 터미널 |
|--------------|-----------------|--------|
| 폴더 만들기 | 우클릭 → 새 폴더 | `mkdir 새폴더` |
| 폴더 열기 | 더블클릭 | `cd 새폴더` |
| 상위로 | ← / ↑ 버튼 | `cd ..` |
| 안에 뭐 있나 | 창에 보이는 목록 | `ls` |
| 지금 어디 | 주소창 | `pwd` |

```
PS C:\Users\나\workspace>   ← 프롬프트 = 주소창 ("지금 이 폴더")
```

> 💡 `git`·`uv`·`codex`… 개발 도구는 다 터미널 명령. 명령은 **그대로 공유**할 수 있어 협업에 유리.

---

## 열기 · 기본 조작

| OS | 터미널 |
|----|--------|
| Windows | **PowerShell 7** (`pwsh`, 검은 아이콘) — 5.1(파란)과 구별 |
| macOS | 터미널(zsh) — `⌘ + Space` → 터미널 |
| 공통 | **VS Code 안** `` Ctrl + ` `` — 실습에서 가장 많이 씀 |

| 조작 | 키 |
|------|----|
| 직전 명령 | **↑** |
| **자동완성** | **Tab** ← 가장 중요한 습관 |
| 실행 멈추기 | **Ctrl + C** |
| 화면 지우기 | `clear` |

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# 폴더 오가기

<div class="lead-sub">폴더 = 서랍장</div>

---

## "지금 열어둔 서랍 하나"

터미널은 항상 **현재 폴더 하나** 안에 있습니다. 명령은 그 폴더 기준으로 동작.

```
pwd            # 지금 어느 서랍이야?    (현재 위치 = 주소창)
ls             # 이 서랍 안에 뭐가 있어? (목록)
cd workspace    # 저 서랍으로 이동       (더블클릭)
cd ..          # 한 칸 밖으로           (↑ 버튼)
cd ~           # 홈으로 한 번에
mkdir web-01   # 새 서랍 만들기         (우클릭 → 새 폴더)
```

> 💡 **`cd` 뒤엔 `pwd`, `mkdir` 뒤엔 `ls`** — 됐는지 눈으로 확인하는 습관.
> 탐색기 창을 옆에 열어 두면 터미널이 한 일이 그대로 보입니다.

---

## 조금 더 — OS 차이는 거의 없다

| 하고 싶은 일 | Windows (PowerShell 7) | macOS |
|--------------|------------------------|-------|
| 빈 파일 만들기 | `New-Item 파일 -ItemType File` | `touch 파일` |
| 내용 보기 | `cat 파일` | `cat 파일` |
| 복사 / 이동 | `cp` / `mv` | `cp` / `mv` |
| 삭제 | `rm 파일` · `rm -r 폴더` | 같음 |
| VS Code 로 열기 | `code .` | `code .` |

> ⚠️ `rm` 은 **휴지통 없이 바로 삭제**. 지우기 전 `pwd` + `ls` 로 대상 확인!
> 💡 PowerShell 7 은 `ls`·`cat`·`rm` 을 macOS 처럼 그대로 씀(별칭). 그래서 표가 거의 같다.

---

<!-- _class: section -->
<div class="eyebrow">PART 3 ★</div>

# 경로 (path)

<div class="lead-sub">절대 경로 vs 상대 경로</div>

---

## 경로 = 주소. 두 가지 쓰는 법

| | 우편 주소 비유 | 경로 |
|---|----------------|------|
| **절대** | "서울시 강남구 테헤란로 1" — 어디서 말해도 같은 곳 | `C:\Users\나\workspace\web-01` `/Users/나/workspace/web-01` |
| **상대** | "여기서 오른쪽 두 블록" — **지금 위치**에 따라 다름 | `workspace/web-01` `../web-02` |

**구별법**: `C:\` 또는 `/` 로 **시작하면 절대**, 아니면 상대.

> 📌 Windows 는 `\`, macOS 는 `/` — 하지만 PowerShell 도 `/` 를 이해하므로 이 자료는 `/` 로 통일.

---

## 상대 경로의 세 기호

<div class="cols">
<div>

| 기호 | 의미 | 비유 |
|------|------|------|
| `.` | 지금 폴더 자신 | "여기" |
| `..` | 한 칸 위 폴더 | "한 층 위" |
| `~` | 내 홈 폴더 | "우리 집" — 어디서든 통함 |

</div>
<div>

```
C:\Users\나\workspace\
   ├── web-01\   ← ★ 지금 여기
   │    └── css\style.css
   └── web-02\main.py
```

</div>
</div>

| 상대 경로 (지금 web-01 에서) | 가리키는 곳 |
|-----------|-------------|
| `css/style.css` | web-01 안의 css 안의 style.css |
| `..` | `workspace` |
| `../web-02/main.py` | 한 칸 위 → web-02 → main.py |
| `~/workspace` | 홈 → workspace (현재 위치 무관) |

---

## 퀴즈 — `code ____` 빈칸을 채우세요

지금 위치는 `/Users/나/workspace/esp32`. VS Code 로 열려면 빈칸에 무엇을 쓸까요?

```
/Users/나/
   ├── Documents/
   └── workspace/
        ├── esp32/  ← ★ 여기      (src/main.cpp)
        └── web/    (static/index.html)
```

| 열고 싶은 것 | 명령 |
|--------------|------|
| ① 지금 폴더(esp32) 전체 | `code ____` |
| ② esp32 안의 `main.cpp` | `code ____` |
| ③ 옆 폴더 web 의 `index.html` | `code ____` |
| ④ 홈의 `Documents` 폴더 — **두 가지** 방법으로 | `code ____` / `code ____` |

<div class="small">답: ① <code>.</code> ② <code>src/main.cpp</code> ③ <code>../web/static/index.html</code> ④ <code>../../Documents</code> 또는 <code>~/Documents</code> (홈 기준이라 어디서든 같음)</div>

---

## 언제 무엇을 · 흔한 실수

| 상황 | 추천 |
|------|------|
| 터미널에서 잠깐 이동 | **상대** — 짧다 |
| 문서·스크립트에 적어 공유 | **상대**(프로젝트 기준) — 남의 PC 는 홈 이름이 다르다 |
| 길을 잃음 | `pwd` → `cd ~` 로 기준 다시 잡기 |

> ⚠️ 문서의 `cd courses/01-cli` 가 "폴더 없음" 이면 → **이미 그 안에** 있거나 시작 위치가 다른 것.
> `pwd` 로 확인. 이 저장소 문서는 **저장소 최상위 기준**.

> 💡 HTML `href="css/style.css"`, Python `open("data/x.json")` — **코드 안의 경로도 같은 규칙.**

---

<!-- _class: section -->
<div class="eyebrow">PART 4</div>

# 내 IP 확인

<div class="lead-sub">ESP32·친구가 내 PC 서버를 찾는 주소</div>

---

## ipconfig / ifconfig

실습에선 **내 PC 에 서버를 띄우고** ESP32·다른 사람이 접속합니다. 그때 **PC 의 실제 IP** 가 필요.

```powershell
ipconfig                        # Windows → "무선 LAN 어댑터 Wi-Fi" 의 IPv4 주소
ipconfig | Select-String IPv4   # IPv4 줄만
```

```bash
ipconfig getifaddr en0          # macOS
```

```
http://192.168.0.10:8000   ← 다른 기기에서   /   http://localhost:8000  ← 내 PC 에서
```

> ⚠️ `localhost`/`127.0.0.1` 은 **"그 기기 자신"**. ESP32 에서 localhost 로 접속하면 ESP32 자신을 찾아 실패.
> 다른 기기에선 **PC 의 실제 IP** + **같은 WiFi**. IP 는 바뀔 수 있으니 안 되면 **다시 확인**.

---

## 정리

- 터미널 = 글자로 시키는 탐색기. Windows 는 **PowerShell 7**, VS Code 안 터미널 활용
- 4개 명령: **`pwd` · `ls` · `cd` · `mkdir`** + **Tab** 자동완성
- **절대 경로**(`C:\`·`/` 로 시작) vs **상대 경로**(지금 폴더 기준) — `.` `..` `~`
- 막히면 `pwd` 로 "나는 지금 어디?" 부터
- **`ipconfig`** 로 내 IP — 실습 서버 접속용

<div class="small">실습: exercises/01 (폴더 오가기) · exercises/02 (경로 퀴즈 + IP) → 다음 강좌 02-git</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">이제 실습</div>

# 직접 쳐 봅시다 ⌨️

<div class="rule"></div>

<div class="subtitle">exercises/ 의 2개 실습 — 손이 기억할 때까지</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>
