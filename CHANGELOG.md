# 更新日志

## v0.3.3 (2026-08-28)

中英双语 README 对齐（老张拍板「英文门面 + 中文全档」）：

- **README.md 改为英文**：作为 GitHub / npm / ClawHub 首页的英文门面（翻译 + 精简，覆盖定位 / 核心价值 / 工作流程 / 风险矩阵 / 目录结构 / 安装 / 使用 / 升级卸载 / FAQ / 来源与许可全流程）。
- **新增 README.zh-CN.md**：原中文完整主文档整体平移，顶部加语言切换链接。
- **新增 NOTICE + .npmignore**：对齐 YottaMeta 技能家族标准（品牌声明 + npm 打包排除）。
- **package.json**：files 加 README.zh-CN.md；版本 0.3.2 → 0.3.3。
- 版本对齐：package.json / SKILL frontmatter / CHANGELOG / 文档。
- 边界（B 方案）：references / 测试注释不翻译；SKILL 触发描述保持中文。

## 历史版本

- **v0.3.2 (2026-08-27)**：banner 标题改「元质代码质量守护」对齐元字辈功能后缀。
- **v0.3.1 (2026-08-27)**：中文名定稿元质 + banner 统一。
- **v0.3.0 (2026-08-27)**：更名 yotta-code-quality（原 code-quality-guard 家族对齐）。
- **v0.2.5**：README risk matrix canonical 修正 + 做厚介绍 + 补 history 配置口径。
- **v0.2.4**：README 顶部加 hero banner + 可点击徽章行；banner 入 assets/。
- **v0.2.3**：install 自动检测/PROJECT_DIRS 兜底分支补齐 17 类规范目录。
- **v0.2.2**：--list 与 README 方式三一致；去除环境变量真实路径显示。
- **v0.2.1**：--list 不再解析本机真实路径，改显示通用默认目录。
- **v0.2.0**：扩充智能体表支持国内 Trae/Qwen/Comate/CodeBuddy/Kimi。
- **v0.1.7**：README 措辞规范（.agents 通用约定中性表述）。
- **v0.1.6**：方式三简化——不确定目录交给用户。
- **v0.1.5 / v0.1.4**：--dir 自定义目录安装说明。
- **v0.1.3**：新增 npx 一行安装（bin 跨平台安装器）。
- **v0.1.2**：安装说明重构为三种方式（npm 推荐 / install.sh / 手动复制）。
