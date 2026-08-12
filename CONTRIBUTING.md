# 贡献网站内容

不需要会写代码。请在 GitHub 上创建分支后，打开你常用的 AI 编程工具，在仓库根目录直接描述想做的事情即可。

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
2. 运行验证：Windows 用 `powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1`；macOS/Linux 用 `pwsh -File scripts/validate-site.ps1`。
3. 提交 PR，不直接改 `main`；PR 模板会提示需要补充的信息。
