---
name: kexie-git-workflow
description: Manage this school science-and-technology association website with the repository's MAA-style Git workflow. Use when an AI agent needs to create a branch, write or validate commit messages, prepare a pull request, merge an approved PR, or diagnose repository history and workflow compliance.
---

# 科协 Git 协作流程

> **给人看的摘要**：这个技能定义本仓库的分支、提交、PR 与合并流程。核心规则：所有改动从 `main` 新建分支；提交信息用 `<类型>(<作用域>): <中文主体>`；未定稿用 Draft PR；只有负责人明确说「合并 PR #编号」才能合并。手动操作时用 GitHub 网页建分支和 PR 即可，不需要本地命令行。坑：合并前核对 PR 编号和 head SHA，不要在 PowerShell 里用 `\n` 拼多行信息。

执行涉及 Git 或 GitHub 的任务时，先阅读根目录 `AGENTS.md`。此 skill 将规则转为可执行检查，避免直接提交到 `main`、非规范提交和重复部署。

## 提交前

1. 运行 `git status --short --branch`，确认工作区和目标文件；存在无关改动时停止并询问。
2. 若当前在 `main`，从最新 `main` 创建分支。分支使用 `<type>/<english-kebab-case>`，例如 `feat/organization-info`。
3. 将改动限制为一个明确目的；运行与变更对应的检查，网站内容变更至少运行 `scripts/validate-site.ps1`。
4. 使用 `scripts/check-commit-message.ps1` 检查提交信息。

## 规范

- 分支类型：`feat`、`fix`、`docs`、`chore`、`style`、`refactor`、`test`、`perf`。
- 提交格式：`<type>(<optional-scope>): <中文主体>`。scope 必须为英文小写短横线形式。
- 示例：`feat(about): 补充协会宗旨与活动方向`、`fix(contact): 修正官方邮箱链接`、`chore(pages): 删除重复部署工作流`。
- 提交标题保持简洁，提交正文按需要使用 `-` 分点摘要，说明改动目的、主要文件或行为变化、资料来源和验证结果。例如：

  ```text
  feat(site): 更新组织介绍与联系方式

  - 更新组织介绍和四个部门信息
  - 替换联系方式占位内容并添加宣传群二维码
  - 通过网站校验脚本
  ```

- PR 描述和 merge 信息同样使用清晰的分点摘要；涉及多个文件、行为变化或重要流程时不得只写一句笼统说明。
- 禁止使用自动生成的标题（如 `Create static.yml`）直接提交到 `main`。将自动生成文件视为普通改动：移到工作分支、审核、测试、再提交。

## PR 与合并

1. 未定稿、仍需继续开发或等待负责人审阅的分支，使用 Draft PR：`gh pr create --draft`。Draft PR 不得转为可合并状态，除非负责人确认内容已定稿。
2. 内容定稿后，推送工作分支并创建范围单一的正式 PR；PR 标题沿用规范提交格式，描述使用分点摘要。
3. 等待必需检查通过。负责人确认关键流程已验证、暂定稳定且明确授权合并后才可合并。
4. 任何 Agent 不得根据“执行计划”“检查通过”或“准备合并”等表述推断合并授权；只有负责人明确说“合并 PR #编号”或“merge PR #编号”时，才能执行合并。
5. 合并前核对 PR 编号、base/head 分支、必需检查和 head SHA；使用 `--match-head-commit <head-sha>`，确保合并的是已审阅版本。
6. 使用普通 merge，编辑 merge commit 标题为规范格式，并用正文分点记录合并内容，避免默认的 `Merge pull request #...` 标题。多行正文必须使用真实换行，不要在 PowerShell 中使用 `\n` 或 `` `n `` 代替换行。

   **编码要求（重要）**：PowerShell 标准输入/管道默认按系统 ANSI（GBK）编码，中文会变乱码（`?`）。不要用 `$mergeBody | gh pr merge --body-file -` 直接传中文正文。正确做法是先用无 BOM UTF-8 写入文件，再 `--body-file`：`gh pr merge` 用 `--subject` 传标题（命令行参数不受影响），中文正文走文件。合并后用字节级检查复核（统计 `0x3F` 数量），不要依赖控制台显示。

   Windows 示例：

```powershell
$nl = [Environment]::NewLine
$body = "- 说明改动目的" + $nl + "- 列出主要文件或行为变化" + $nl + "- 记录资料来源和验证结果" + $nl
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("$env:TEMP\merge-body.txt", $body, $utf8)
gh pr merge 11 --merge --subject "chore(workflow): 更新协作规则" --body-file "$env:TEMP\merge-body.txt" --match-head-commit '<head-sha>'
```

7. `gh pr merge` 报错、无输出或被中止后，先运行 `gh pr view <number> --json state,mergeCommit` 核查是否已经合并，不得直接重试。合并后更新本地 `main`、确认部署状态并清理分支。禁止改写或 force-push `main`。

## Windows 命令

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1
powershell -ExecutionPolicy Bypass -File .agents/skills/kexie-git-workflow/scripts/check-commit-message.ps1 'feat(about): 补充协会宗旨'
```
