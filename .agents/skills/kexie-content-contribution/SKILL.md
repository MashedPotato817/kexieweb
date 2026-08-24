---
name: kexie-content-contribution
description: Add or revise verified Chinese content for this school science-and-technology association website, including activity resources, recruitment notices, organization introduction, and contact information. Use when a contributor asks an AI agent to make a small, reviewable content change without altering site architecture.
---

# 科协网站内容贡献

> **给人看的摘要**：这个技能负责把已确认的协会信息（招新文案、活动资料、联系方式等）规范地写进网站。手动做时通常只改两个文件——`index.html`（页面内容）和 `docs/kexie-mes/README.md`（事实登记处）；改动的事实必须先登记，否则校验会失败。坑：不要编造任何日期、链接、职位；没有真实资料就保留「待发布」占位。

将用户给出的真实信息转为一项小而可审阅的网站更新。阅读 `references/content-schema.md` 后再编辑。

## 工作流

1. 提取已确认事实：标题、日期、地点、链接、文件与联系人。缺少的事实不补写。
2. 选择最小改动范围：通常为 `index.html`，有资料文件时再添加 `assets/downloads/` 中的文件。
3. 保持现有 HTML 结构、中文语气和响应式样式。复用 `resource-card`、`notice` 等已有类，不进行无关重排。
4. 如果没有真实下载文件或公开链接，展示“待发布”，不要创建空链接。
5. 运行 `scripts/validate-site.ps1`：Windows 使用 `powershell -ExecutionPolicy Bypass -File`，macOS/Linux 使用 `pwsh -File`。
6. 给出 PR 摘要：改了什么、事实来源或待确认事项、验证结果。

## 内容规则

- 使用准确、面向学生的短句；标题避免营销夸张和感叹号堆叠。
- 用 `YYYY 年 M 月 D 日` 表示明确日期；日期未知时不写日期。
- 外部链接使用完整 `https://` 地址；文件链接使用相对路径，例如 `assets/downloads/活动课件.pdf`。
- 图片必须提供具体的 `alt` 文本；不能以“图片”“海报”作为替代文本。
- 不在公开页面写个人手机号、私人账号、未公开群二维码、学生个人信息或凭据。
- 事实先登记：页面上新增或修改的事实性内容（日期、群号、联系方式、职位、数据、外部链接）必须先写入 `docs/kexie-mes/README.md` 登记，并在 PR 描述中注明来源；链接必须能在该登记处找到出处，否则 `scripts/validate-site.ps1` 会校验失败。
- 外部链接出处核对由 `scripts/validate-site.ps1` 自动执行：`index.html` 中的 `https://` 外链 URL 必须以字符串形式出现在 `docs/kexie-mes/README.md`。

## 何时停止并询问

停止编辑并向负责人确认：活动信息互相矛盾、涉及收集个人信息、需要新增页面/表单、要求改动样式体系，或提供的资料是否可公开不明确。
