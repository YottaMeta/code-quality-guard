# code-quality-guard（代码质量守卫）

面向 **Cursor / Codex / WorkBuddy / 通用 Agent** 的结对代码审查技能。把「代码质量审查」作为可复用的技能，让智能体在交付前像资深工程师一样通读代码、定位劣化、给出可执行的修复方案。

## 核心理念

- **铁律（Iron Law）：** `症状 → 根源 → 后果 → 修复`（Symptom → Source → Consequence → Remedy）。先诊断、再给修复建议，不盲改。
- **默认只读：** 只出报告，不动代码；除非你明确要求 `--fix`（按 Remedy 修）。
- **健康分（Health Score）：** 每次审查的扣分指数（0–100，非绝对评级），便于跨次追踪趋势。

## 风险矩阵（方法论源自 12 本经典软件工程著作）

| 类别 | 范围 | 说明 |
|------|------|------|
| **R1–R6** | 生产劣化 | 可维护性、复杂度、并发/资源、错误处理、接口契约、配置漂移等六大生产风险 |
| **T1–T6** | 测试劣化 | 覆盖率盲点、脆弱测试、无断言、mock 滥用、集成缺口、性能回归等六大测试风险 |
| **R7**（编辑扩展） | 发布 / 供应链安全 | 仓库或脚本中的明文密钥（云 AK/SK、签名私钥、token）；发布产物开启交互式 DevTools；updater 跳过校验等 |
| **UX1**（编辑扩展） | 首屏 / 状态清晰度 | 空窗口、splash 不居中、状态文案与门禁不符等桌面端首屏体验问题 |
| **anti-over-flag** | 防过度告警 | 抑制噪声告警，避免「狼来了」式疲劳 |

详细定义见 `references/decay-risks.md`、`references/test-decay-risks.md`、`references/editorial-extensions.md`。

## 目录结构

```
code-quality-guard/
├── SKILL.md                  # 入口 + 按模式按需加载的路由
├── references/
│   ├── common.md             # 配置 / 模板 / 评分（单一信息源）
│   ├── decay-risks.md        # R1–R6 生产风险
│   ├── test-decay-risks.md   # T1–T6 测试风险
│   ├── editorial-extensions.md # R7 / UX1 / 防过度告警
│   ├── source-coverage.md    # 书籍矩阵（深度模式）
│   ├── pr-review-guide.md    # 7 步 PR 审查
│   ├── examples.md           # 语气 / 评分校准
│   ├── AGENTS-template.md    # 可选：丢进仓库当 AGENTS.md 强制规范
│   └── hooks.json            # 可选：PreToolUse 拦截 rm -rf / git push --force
├── install.sh                # 一键安装到 7 类智能体
└── LICENSE                   # MIT
```

## 安装

> 先拿到技能文件：`git clone https://github.com/YottaMeta/code-quality-guard.git`（或 GitHub ZIP / `npm pack @yottameta/code-quality-guard` 解包），再按系统选择方式。

### Linux / macOS / Windows（Git Bash）——脚本
```bash
./install.sh codex               # 用户级（默认装到 ~/.codex/skills）
./install.sh codex --project     # 当前项目级
./install.sh cursor              # 其他平台见 ./install.sh --list
./install.sh --dir /path/to/skills
./install.sh --list
```

### Windows（无 Git Bash）——手动复制
把整个 `code-quality-guard` 文件夹复制到目标 skills 目录（如 `%USERPROFILE%\.codex\skills\code-quality-guard\`）。

### npm 双源
npm 包是分发源（文件与 GitHub 一致）：
```bash
npm pack @yottameta/code-quality-guard
tar -xzf yottameta-code-quality-guard-0.1.1.tgz
cd package && bash install.sh codex
```

### npx skills
```bash
npx skills add YottaMeta/code-quality-guard -g    # Windows 建议加 --copy
```

## 使用

对话中说「review this PR」「结对评审」「发版前扫一眼」，或直接调用 `/code-quality-guard`。

可选参数：

- `--fix` / 「按 Remedy 修」→ 进入修复模式
- `--triage` / 「逐条处理」→ 交互式忽略 / 延期
- 在 `.code-quality.yaml` 设 `history: true` → 生成 `.code-quality-history.json` 趋势记录

> `AGENTS-template.md` 与 `hooks.json` 是**附加件**，不装也不影响审查。

## 来源与许可

- **方法论**蒸馏自 12 本经典软件工程著作及开源社区质量审查实践（MIT）；原始方法论版权归 hyhmrright，本技能在其基础上重写为单一自包含、跨智能体通用的版本，并增补 R7 / UX1 / 按需加载会话契约。
- **许可：** MIT —— 详见 `LICENSE`（版权人：hyhmrright（原始方法论）+ YottaMeta（本打包））。
