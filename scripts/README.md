# scripts 脚本说明

本目录存放网站的验证与工具脚本。

## 验证脚本（CI 强制）

- `validate-site.ps1`：校验站点结构、本地资源引用、外部链接出处登记（事实登记制核心）。
- `validate-git-conventions.ps1`：校验分支名、PR 标题、提交信息是否符合 MAA 规范。
- `check-pr-boundaries.ps1`：校验 PR 是否改动约定边界外文件（`.github/workflows`、`docs/` 等），支持 PR 描述「放行文件：<路径>」显式放行。
- `check-pr-description.ps1`：校验 PR 描述是否包含「改动内容 / 信息来源 / 检查」三要素。

## 本地校验脚本（可选）

- `verify-pr-ready.ps1`：本地 PR 前置自检（分支、提交信息、工作区、越界文件、head SHA）。有 AI 工具时可跑；纯人维护可跳过（CI 会兜底）。
- `check-merge-message.ps1`：校验拟填写的 merge commit 消息是否符合标准模板（标题 `<type>(<scope>): <中文主体>`、正文 `-` 分点、结尾「验证：...均通过。」、无 `0x3F` 乱码）。供 `gh pr merge` 前调用；verify-pr-ready 合并前自检也会调用它。

## 工具脚本

- `make-qr.py`：生成纯净二维码 PNG（深蓝填充、白底、高纠错）。依赖 `pip install qrcode pillow`。
- `compress-images.py`：压缩图片到适合网页显示的体积（等比缩放 + 重新编码，默认输出 JPEG，不覆盖原图）。用于大图瘦身，减少页面加载体积。依赖 `pip install pillow`。示例：`python scripts/compress-images.py assets/photos/科普知识竞赛.png --max-width 460`。
- `make-qr-pdf.py`：生成「科协招新二维码」A4 横向 PDF（顶部并排三 logo（南师大/电自院/科协），校名加字间距，三个二维码并排并标注）。输出到 `assets/downloads/科协招新二维码.pdf`。依赖 `pip install reportlab pillow`。
- `make-og-cover.py`：重建 og:image 分享配图（1200×630，深蓝渐变背景 + 新版圆角 Logo + 站名/标语/英文）。输出到 `assets/images/og-cover.png`。依赖 `pip install pillow`。

## 配置文件

- `protected-paths.txt`：约定边界外文件清单（正则），`verify-pr-ready.ps1` 与 `check-pr-boundaries.ps1` 共用，规则变更只改这一处。

## 运行方式

- 网站校验：`powershell -ExecutionPolicy Bypass -File scripts/validate-site.ps1`
- 提交规范检查：`powershell -ExecutionPolicy Bypass -File .agents/skills/kexie-git-workflow/scripts/check-commit-message.ps1 '<提交信息>'`
- merge 消息检查：`powershell -ExecutionPolicy Bypass -File scripts/check-merge-message.ps1 -Subject '<标题>' -BodyFile '<正文文件>'`