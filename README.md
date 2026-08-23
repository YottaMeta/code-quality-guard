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
├── install.sh                # 一键安装到 17 类智能体（含国内 Trae/Qwen/Comate/CodeBuddy/Kimi）
└── LICENSE                   # MIT
```

## 安装

三种方式任选其一，技能文件统一从 **npm** 获取（GitHub 无代理时较慢，npm 可配国内镜像加速）。

### 方式一：npm（推荐，一行安装）
```bash
# 国内加速（可选）：npm config set registry https://registry.npmmirror.com
npx -y @yottameta/code-quality-guard -g
npx -y @yottameta/code-quality-guard --dir <你的技能目录>   # 任意智能体：指定目录安装
```
> 智能体不在预置列表里？用 `--dir` 指定它的 skills 目录，或手动复制（方式三）。`--list` 可查看各智能体对应的默认目录。想手动拿文件也可 `npm pack @yottameta/code-quality-guard` 解包后按方式二/三安装。

### 方式二：install.sh 一键安装
获取技能文件夹后（`npm pack` 解包或 `git clone`），进入技能文件夹：
```bash
bash install.sh -g    # 用户级；bash install.sh --list 查看全部目录
bash install.sh --agent codex   # 指定智能体（--list 可查看可用项）
bash install.sh       # 项目级：自动检测已存在的 .claude/.cursor/.codex 等 skills 目录
bash install.sh --dir /path/to/skills
```
> Windows 用户：装有 Git Bash 即可用；否则用方式三手动复制。

### 方式三：手动复制
把整个 `code-quality-guard` 文件夹复制到目标智能体的 skills 目录。常见位置（用户级；Windows 用 `%USERPROFILE%`，Linux/macOS 用 `~`）：

| 智能体 | 用户级目录 | 项目级目录 |
|---|---|---|
| Codex | `%USERPROFILE%\.codex\skills\code-quality-guard\` | `.codex\skills\` |
| Claude Code | `%USERPROFILE%\.claude\skills\code-quality-guard\` | `.claude\skills\` |
| Cursor | `%USERPROFILE%\.cursor\skills\code-quality-guard\` | `.cursor\skills\` |
| Windsurf | `%USERPROFILE%\.codeium\windsurf\skills\code-quality-guard\` | `.windsurf\skills\` |
| opencode | `%USERPROFILE%\.config\opencode\skills\code-quality-guard\` | `.opencode\skills\` |
| Gemini | `%USERPROFILE%\.gemini\skills\code-quality-guard\` | `.gemini\skills\` |
| Goose | `%USERPROFILE%\.config\goose\skills\code-quality-guard\` | `.goose\skills\` |
| Amp | `%USERPROFILE%\.config\agents\skills\code-quality-guard\` | `.agents\skills\` |
| Kiro | `%USERPROFILE%\.kiro\skills\code-quality-guard\` | `.kiro\skills\` |
| WorkBuddy | `%USERPROFILE%\.workbuddy\skills\code-quality-guard\` | `.workbuddy\skills\` |
| Trae Code CLI | `%USERPROFILE%\.traecli\skills\code-quality-guard\` | `.traecli\skills\` |
| Trae IDE（国内） | `%USERPROFILE%\.trae-cn\skills\code-quality-guard\` | `.trae\skills\` |
| Qwen Code | `%USERPROFILE%\.qwen\skills\code-quality-guard\` | `.qwen\skills\` |
| Comate | `%USERPROFILE%\.comate\skills\code-quality-guard\` | `.comate\skills\` |
| CodeBuddy | `%USERPROFILE%\.codebuddy\skills\code-quality-guard\` | `.codebuddy\skills\` |
| Kimi | `%USERPROFILE%\.kimi\skills\code-quality-guard\` | `.kimi\skills\` |
| 通用 AGENTS.md | `%USERPROFILE%\.agents\skills\code-quality-guard\` | `.agents\skills\` |

> Codex 默认目录若设置了环境变量 `CODEX_HOME`，以该变量为准；opencode 若设置 `XDG_CONFIG_HOME` 同理。`.agents\skills` 并非通用目录，仅 OpenCode / Cursor / Cline / Amp / Kimi / Gemini CLI / GitHub Copilot 等会读取，**Claude Code 与 Codex 默认不读**。不确定时用 `--dir` 指定，或让该智能体自行安装。

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