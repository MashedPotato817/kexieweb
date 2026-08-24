# 贡献网站内容

不需要会写代码。可以用 AI 编程工具协助，也可以全程用 GitHub 网页手动完成——两种方式都支持。

## 降级维护指南（没有 AI 工具 / GitHub Actions 异常时）

如果你没有 AI 工具，或 GitHub Actions 暂时不可用，纯人工也能完成内容更新。全程只需要浏览器，不需要本地命令行或安装任何软件：

1. 打开仓库页面，进入 `index.html`（改文案）或 `assets/`（改图片/资料文件）。
2. 点击铅笔图标（编辑），在网页上直接修改内容。
3. 若改的是事实性内容（日期、群号、联系方式、链接等），**同步**编辑 `docs/kexie-mes/README.md` 登记出处（登记制要求，漏了会卡校验）。
4. 在页面底部填提交说明，选择「创建一个新分支并开始拉取请求」（Create a new branch and start a pull request），点击提交。
5. 在打开的 PR 页面填好描述（改动内容 / 信息来源 / 检查），创建 PR。
6. 等 CI 检查通过后，由负责人点 Merge 合并。合并后网站自动发布。

> 说明：`main` 分支受保护，不要直接在 main 上改；走上面的分支 + PR 流程即可。Force Push 不属于正常流程，除非负责人明确指示。

## 推荐提问方式（使用 AI 工具时）

把方括号中的内容替换成真实信息。没有的信息留空，让 AI 标记为“待确认”。

## 推荐提问方式

把方括号中的内容替换成真实信息。没有的信息留空，让 AI 标记为“待确认”。

```text
请阅读 AGENTS.md 和 .agents/skills/kexie-content-contribution/SKILL.md。
把以下活动资料添加到网站的“资源下载”区域：
- 标题：[资料名称]
- 类型：[课件 / 报名表 / 模板 / 回放 / 其他]
- 简介：[一句话说明]
- 文件：[仓库中的文件路径，或我将上传的文件]
不要编造日期、链接或联系方式。完成后运行仓库检查，并给我一段可直接放进 PR 的说明。
```

```text
请阅读 AGENTS.md 和 .agents/skills/kexie-content-contribution/SKILL.md。
将“加入我们”区域更新为以下已确认信息：[招新文案、时间、地点、报名链接]。
只修改完成这件事所必需的文件；如果信息不完整，请列出缺少项，不要猜测。
```

## 各工具入口

- **Codex**：在仓库根目录开始对话，使用上面的提示词。`AGENTS.md` 会提供项目规则。
- **Claude Code**：在仓库根目录运行 `claude`；`CLAUDE.md` 会导入同一套规则。
- **OpenCode**：在仓库根目录运行 OpenCode，或使用 `@content-contributor` 发起内容任务。

它们共用 `.agents/skills/` 下的规范，而不是各自保存一份容易失效的文案。不同工具对“skill”的自动发现机制不完全相同，因此提示词会明确让它读取该文件；这比复制多份规则更可靠。

涉及分支、提交或 PR 时，再让 AI 读取 `.agents/skills/kexie-git-workflow/SKILL.md`。例如：

```text
请阅读 AGENTS.md 和 .agents/skills/kexie-git-workflow/SKILL.md，
为当前改动创建规范分支、检查提交信息，并准备一个 PR；不要合并 main。
```

## 提交 PR 前

1. 确认没有把私人电话、身份证号、未公开的群二维码或学生个人信息放进公开网站。
2. 运行验证：Windows 用 `powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1`；macOS/Linux 用 `pwsh -File scripts/validate-site.ps1`。合并前 PR 还会被 CI 的边界检查（`check-pr-boundaries`）与描述检查（`check-pr-description`）校验。
3. 提交 PR，不直接改 `main`；PR 模板会提示需要补充的信息。

## 手动更新步骤清单（改群号 / 招新文案等事实性内容时）

按顺序逐项完成，避免遗漏「页面 + 登记处」双写：

1. **改页面**：编辑 `index.html` 中对应的内容（如群号、招新时间、联系方式）。
2. **同步登记**：编辑 `docs/kexie-mes/README.md`，把改动的链接/群号等写入登记处。这一步必做——`validate-site.ps1` 会核对外部链接出处，登记缺失会校验失败。
3. **本地验证**（可选）：有环境就运行 `scripts/validate-site.ps1`；没有环境就跳过，交给 CI 检查。
4. **提交**：在分支上提交，写明 `<类型>(<作用域>): <中文主体>`，正文必要时分点。
5. **建 PR**：描述填三要素（改动内容 / 信息来源 / 检查），等 CI 通过。
6. **合并**：负责人确认后合并，网站自动发布。

## AI Agent 完成清单

如果你是用 AI 工具协助开发，提交前请逐项确认以下内容：

1. **分支与工作区**：当前在 `<type>/<english-kebab-case>` 分支，不在 `main`；工作区无未提交或未跟踪的意外文件。
2. **校验脚本**：已运行 `powershell -ExecutionPolicy Bypass -File scripts/verify-pr-ready.ps1` 与 `scripts/validate-site.ps1`，通过后才允许创建或合并 PR。
3. **提交信息**：`<type>(<scope>): <中文主体>`，正文必要时分点说明改动目的、文件和验证结果。
4. **PR 描述三要素**：写明改动摘要、资料来源或待确认事项、验证结果；不要只写一句笼统说明。
5. **不编造信息**：未提供的信息保持“待公布/待发布”，不得猜测；私人信息不放进公开内容。
6. **事实先登记**：页面上新增或修改的事实性内容（日期、群号、联系方式、职位、数据、外部链接）先写入 `docs/kexie-mes/README.md` 并在 PR 描述注明来源；外部链接必须在登记处有出处，否则 `validate-site.ps1` 会失败。
7. **不越界改文件**：未经明确授权，不改部署工作流（`.github/workflows`）、全局文档（`README.md`、`CONTRIBUTING.md`、`CLAUDE.md`、`AGENTS.md`、skills）或 `docs/` 内容；确需修改时在 PR 描述写“放行文件：<路径>”。
8. **合并授权**：只有负责人明确说“合并 PR #编号”或“merge PR #编号”才能合并；“继续执行”“检查通过”“准备合并”都不算授权。
9. **未定稿用 Draft PR**：仍需继续开发的分支创建 Draft PR，负责人确认定稿后才转为 Ready for review。

涉及分支、提交或 PR 时，先读取 `.agents/skills/kexie-git-workflow/SKILL.md`。
