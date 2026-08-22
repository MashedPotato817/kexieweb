# 校园科学技术协会网站

这是一个可直接部署到 GitHub Pages 的静态网站。它面向全校学生和科协成员，用于介绍组织、发布招新信息，并集中放置活动资料。

## 本地预览

直接双击 `index.html` 即可查看；若浏览器限制本地资源，也可在 VS Code 中使用 Live Server 预览。

## 日常更新

- 修改网站文案：编辑 `index.html` 中对应的区块。
- 添加活动资料：将文件放到 `assets/downloads/`，再在“资源下载”区域添加一张资源卡片和链接。
- 更换站点图标：当前使用抽象 brand-mark 占位；协会 Logo 征集结束后，将选中作品放入 `assets/images/` 并在 `index.html` 更新引用（征集说明见 `assets/logos/README.md`）。
- 修改样式：编辑 `styles.css`。

## 多人协作约定

1. 不直接向 `main` 推送；每项改动从 `main` 新建分支。
2. 分支使用英文短横线和类型前缀，例如 `feat/activity-resources`、`fix/contact-link`、`docs/contributing`。
3. 提交信息采用 MAA 风格：`<类型>(<可选作用域>): <中文主体>`，例如 `feat(resources): 添加机器人工作坊课件`。
4. 提交 Pull Request，描述改了什么、附上页面截图；由项目负责人完成关键流程验证后，以普通 merge 合并。
5. 不对 `main` 强制推送或改写历史；工作分支若需 force-push，先征得负责人确认。
6. 只有合并到 `main` 的内容会自动发布。

### GitHub 规则设置

本仓库已为 `main` 启用 **Settings → Rules → Rulesets → Protect main**。它会：

- 要求通过 Pull Request 合并；
- 要求 `validate`、`validate-git-conventions`、`check-pr-boundaries`、`check-pr-description` 四项检查通过；
- 合并前要求分支与 `main` 保持最新；
- 仅允许普通 merge，保留分支提交历史；
- 禁止删除或 force-push `main`。

当前只有一名维护者，因此规则不要求他人审批；负责人仍负责在检查通过后确认并 merge。若要调整规则，先通过 PR 更新仓库内的检查逻辑，再由负责人修改对应 Ruleset。

## GitHub Pages 发布

1. 将仓库推送到 GitHub。
2. 在仓库 **Settings → Pages → Build and deployment** 选择 **GitHub Actions**。
3. 合并到 `main` 后，工作流会自动发布。网站地址通常为：
   `https://<你的 GitHub 用户名>.github.io/<仓库名>/`
4. 发布范围仅站点文件（`index.html`、`styles.css`、`script.js`、`404.html` 与 `assets/`），仓库中的协作文档与 `docs/` 不会随 Pages 发布。
5. 发布后，将这个地址生成二维码并用于海报、签到台或活动资料。二维码本质上是网站链接，手机扫码即可打开。

首次发布的占位信息已替换为已确认内容；后续内容更新按 `CONTRIBUTING.md` 的流程进行。
