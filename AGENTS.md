# AI 协作与 Git 管理约定

本仓库是校园科学技术协会的静态网站。优先帮助非开发者完成小而清晰的内容更新，并将每次改动保持为可审阅的 Pull Request。

## 语言约定

- 本项目所有内容一律使用简体中文：AI 与协作者的对话、代码注释、日志、提交信息、文档与页面文案均以简体中文书写。
- 英文仅用于无法翻译的技术标识符、文件名、分支名、命令与库名。

## Git 工作流

- 所有开发和内容更新均从 `main` 新建工作分支；不得直接向 `main` 提交。
- 分支使用英文短横线命名并带类型前缀，例如 `feat/activity-resources`、`fix/contact-link`、`docs/contributing`、`chore/site-check`。
- 工作分支可随时提交，用于保存可用、未完成或实验性改动；提交信息采用 MAA 风格：`<类型>(<可选作用域>): <中文主体>`。
- 类型仅使用小写英文：`feat`、`fix`、`docs`、`chore`、`style`、`refactor`、`test`、`perf`。作用域使用英文，例如 `feat(resources): 添加讲座课件`。
- 未定稿或仍在试验中的分支必须使用 Draft Pull Request；只有负责人确认内容定稿后，才能标记为 Ready for review 或创建可合并的正式 PR。
- 通过 Pull Request 合并。只有负责人实际验证关键流程、确认暂定稳定且没有明显问题后，才能合并到 `main`。
- 任何 Agent 不得自行合并 PR。只有负责人明确说出“合并 PR #编号”或“merge PR #编号”后，Agent 才能执行合并；“继续执行”“检查通过”或“准备合并”不等同于合并授权。
- 提交信息、PR 描述和 merge 信息应清楚说明改动目的与结果。涉及多个文件、行为变化或重要流程时，正文使用 `-` 分点列出改动、资料来源和验证结果，不用含糊的一句话概括。
- 合并使用普通 merge，保留分支提交历史；禁止改写 `main` 历史。对远端进行 force-push 前，必须先取得负责人确认。
- 合并到 `main` 后推送远端，GitHub Pages 将自动发布。
- 涉及 Git 或 GitHub 的任务，读取 `.agents/skills/kexie-git-workflow/SKILL.md`；提交前使用其中的脚本检查提交信息。
- 不得绕过 GitHub 的 `main` 分支规则或必需检查；规则需要变更时，通过 PR 修改检查逻辑并由负责人确认后更新 Ruleset。

## 开始前

1. 阅读 `README.md`、本文件，以及与任务相符的 `.agents/skills/` 中的 `SKILL.md`。
2. 先查看现有页面和相邻内容，复用现有结构与措辞。
3. 只处理用户明确提供或已存在于仓库中的事实。不要编造活动日期、组织职位、联系方式、下载链接或校徽。

## 仓库边界

- 页面内容在 `index.html`；样式在 `styles.css`；轻量交互在 `script.js`。
- 可下载的活动资料放入 `assets/downloads/`；校徽、海报等图片放入 `assets/images/`。
- 内容贡献通常只改 `index.html` 和必要的 `assets/` 文件。未经明确要求，不改部署工作流、依赖、全局样式或已有导航结构。
- 保持中文简洁、友好、面向学生；链接文案要说明去向，图片须有有意义的替代文本。

## 处理方式

- 信息不完整时，保留明确的“待发布”状态，或先询问缺少的内容；不要用看似真实的示例内容替代。
- 若请求涉及新页面、视觉重设计、表单收集个人信息、外部服务或部署设置，先提出方案并等待负责人确认。
- 不直接推送或合并 `main`。在分支上完成改动，准备一个范围单一的 PR。

## 交付前检查

运行验证脚本：Windows 使用 `powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1`；macOS/Linux 使用 `pwsh -File scripts/validate-site.ps1`。在 PR 描述中写明：改动摘要、资料来源或待确认事项、验证结果。
