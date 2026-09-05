#!/usr/bin/env node
/**
 * 슬라이드 일괄 빌드 스크립트
 *
 *   npm run pdf                 # 모든 강좌의 slides/*.md → PDF
 *   npm run pdf -- 02-git       # 이름에 "02-git" 이 포함된 강좌만
 *   npm run html -- 04          # HTML 로
 *   npm run watch -- 01-cli     # 한 강좌 미리보기(실시간)
 *   npm run clean               # 생성된 pdf/html/pptx 삭제
 *
 * 공통 테마는 shared/marp-theme.css 하나입니다. 슬라이드 frontmatter 의
 * `theme: cosmos` 가 이 파일을 가리킵니다.
 */
import { spawnSync } from "node:child_process";
import { existsSync, readdirSync, statSync, unlinkSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const THEME = join(ROOT, "shared", "marp-theme.css");
const COURSES_DIR = join(ROOT, "courses");
// marp-cli 의 JS 엔트리를 node 로 직접 실행 (OS 별 .cmd/셸 차이 없음)
const MARP_JS = join(ROOT, "node_modules", "@marp-team", "marp-cli", "marp-cli.js");

const [, , mode = "pdf", filter = ""] = process.argv;

function slideFiles() {
  const out = [];
  for (const course of readdirSync(COURSES_DIR).sort()) {
    if (filter && !course.includes(filter)) continue;
    const dir = join(COURSES_DIR, course, "slides");
    if (!existsSync(dir) || !statSync(dir).isDirectory()) continue;
    for (const f of readdirSync(dir)) {
      if (f.endsWith(".md")) out.push(join(dir, f));
    }
  }
  return out;
}

function run(args) {
  if (!existsSync(MARP_JS)) {
    console.error("marp-cli 가 없습니다. 저장소 최상위에서 `npm install` 을 먼저 실행하세요.");
    process.exit(1);
  }
  const r = spawnSync(process.execPath, [MARP_JS, ...args], { stdio: "inherit" });
  if (r.status !== 0) process.exitCode = r.status ?? 1;
}

const files = slideFiles();
if (files.length === 0) {
  console.error(`슬라이드를 찾지 못했습니다. (filter="${filter}")`);
  process.exit(1);
}

if (mode === "clean") {
  for (const f of files) {
    for (const ext of ["pdf", "html", "pptx"]) {
      const target = f.replace(/\.md$/, `.${ext}`);
      if (existsSync(target)) {
        unlinkSync(target);
        console.log("삭제:", target);
      }
    }
  }
} else if (mode === "watch") {
  if (files.length > 1) {
    console.error("watch 는 한 강좌만 지정하세요. 예) npm run watch -- 02-git");
    process.exit(1);
  }
  run(["--theme-set", THEME, "--preview", "--watch", "--allow-local-files", files[0]]);
} else {
  for (const f of files) {
    const out = f.replace(/\.md$/, `.${mode}`);
    console.log(`빌드: ${f} → ${out}`);
    run(["--theme-set", THEME, `--${mode}`, "--allow-local-files", f, "-o", out]);
  }
}
