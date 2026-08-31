# scripts 脚本说明

本目录存放网站的验证与工具脚本。

## 验证脚本（CI 强制）

- `validate-site.ps1`：校验站点结构、本地资源引用、外部链接出处登记（事实登记制核心）。
- `validate-git-conventions.ps1`：校验分支名、PR 标题、提交信息是否符合 MAA 规范。
- `check-pr-boundaries.ps1`：校验 PR 是否改动约定边界外文件（`.github/workflows`、`docs/` 等），支持 PR 描述「放行文件：<路径>」显式放行。
- `check-pr-description.ps1`：校验 PR 描述是否包含「改动内容 / 信息来源 / 检查」三要素。

## 本地校验脚本（可选）

- `verify-pr-ready.ps1`：本地 PR 前置自检（分支、提交信息、工作区、越界文件、head SHA）。有 AI 工具时可跑；纯人维护可跳过（CI 会兜底）。

## 工具脚本

- `make-qr.py`：生成纯净二维码 PNG（深蓝填充、白底、高纠错）。依赖 `pip install qrcode pillow`。

## 配置文件

- `protected-paths.txt`：约定边界外文件清单（正则），`verify-pr-ready.ps1` 与 `check-pr-boundaries.ps1` 共用，规则变更只改这一处。

## 运行方式

- 网站校验：`powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1`
- 提交规范检查：`powershell -ExecutionPolicy Bypass -File .agents/skills/kexie-git-workflow/scripts/check-commit-message.ps1 '<提交信息>'`