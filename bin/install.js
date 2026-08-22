#!/usr/bin/env node
/**
 * code-quality-guard 跨平台安装器（YottaSkills）
 * 用法:
 *   npx -y @yottameta/code-quality-guard -g          # 安装到用户级目录（推荐）
 *   npx -y @yottameta/code-quality-guard             # 安装到检测到的项目级目录
 *   npx -y @yottameta/code-quality-guard --dir PATH  # 安装到指定目录
 *   npx -y @yottameta/code-quality-guard --list      # 列出支持的目录
 */
'use strict';
const fs = require('fs');
const path = require('path');
const os = require('os');

const SKILL_NAME = 'code-quality-guard';
const PKG_ROOT = path.join(__dirname, '..');

const PROJECT_DIRS = [
  '.claude/skills',
  '.cursor/skills',
  '.agents/skills',
  '.codex/skills',
  '.windsurf/skills',
  '.opencode/skills',
  '.gemini/skills',
  '.workbuddy/skills',
];

const USER_DIRS = [
  '.claude/skills',
  '.cursor/skills',
  '.codex/skills',
  '.config/agents/skills',
  '.windsurf/skills',
  '.config/opencode/skills',
  '.gemini/skills',
  '.workbuddy/skills',
];

function installTo(dest) {
  const target = path.join(dest, SKILL_NAME);
  fs.mkdirSync(target, { recursive: true });
  copyDir(PKG_ROOT, target, new Set(['package.json', 'bin', 'node_modules', '.git']));
  console.log('installed -> ' + target);
}

function copyDir(src, dst, skip) {
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    if (skip.has(entry.name)) continue;
    const s = path.join(src, entry.name);
    const d = path.join(dst, entry.name);
    if (entry.isDirectory()) {
      fs.mkdirSync(d, { recursive: true });
      copyDir(s, d, skip);
    } else if (entry.isFile()) {
      fs.copyFileSync(s, d);
    }
  }
}

function main() {
  const args = process.argv.slice(2);
  const isGlobal = args.includes('-g') || args.includes('--global');
  const list = args.includes('--list');
  let explicitDir = null;
  const di = args.indexOf('--dir');
  if (di !== -1 && args[di + 1]) explicitDir = args[di + 1];

  if (list) {
    console.log('支持的智能体技能目录（项目级，仅检测已存在）:');
    for (const d of PROJECT_DIRS) console.log('  ' + d);
    console.log('支持的智能体技能目录（用户级，-g 时创建）:');
    for (const d of USER_DIRS) console.log('  ~/' + d);
    return;
  }

  if (explicitDir) { installTo(explicitDir); return; }

  if (isGlobal) {
    for (const d of USER_DIRS) installTo(path.join(os.homedir(), d));
    console.log('完成。');
    return;
  }

  let installedAny = false;
  for (const d of PROJECT_DIRS) {
    if (fs.existsSync(d)) { installTo(d); installedAny = true; }
  }
  if (!installedAny) {
    console.log('未检测到项目级智能体目录。可手动复制，或用 -g 装到用户级。');
  }
}

main();
