---
name: kexie-git-workflow
description: Manage this school science-and-technology association website with the repository's MAA-style Git workflow. Use when an AI agent needs to create a branch, write or validate commit messages, prepare a pull request, merge an approved PR, or diagnose repository history and workflow compliance.
---

# 科协 Git 协作流程

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
- 禁止使用自动生成的标题（如 `Create static.yml`）直接提交到 `main`。将自动生成文件视为普通改动：移到工作分支、审核、测试、再提交。

## PR 与合并

1. 推送工作分支并创建范围单一的 PR；PR 标题沿用规范提交格式。
2. 等待必需检查通过。负责人确认关键流程已验证、暂定稳定后才可合并。
3. 使用普通 merge，编辑 merge commit 标题为规范格式，避免默认的 `Merge pull request #...` 标题。
4. 合并后更新本地 `main` 并确认部署状态。禁止改写或 force-push `main`。

## Windows 命令

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1
powershell -ExecutionPolicy Bypass -File .agents/skills/kexie-git-workflow/scripts/check-commit-message.ps1 'feat(about): 补充协会宗旨'
```

