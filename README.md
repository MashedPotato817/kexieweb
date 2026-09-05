# 校园科学技术协会网站

这是可直接部署到 GitHub Pages 的静态网站，面向全校学生和科协成员，用于介绍组织、发布招新信息，并集中放置活动资料。

## 本地预览

直接双击 `index.html` 即可查看；若浏览器限制本地资源，也可在 VS Code 中使用 Live Server 预览。

## 日常更新

- 修改网站文案：编辑 `index.html` 中对应的区块。
- 添加活动资料：将文件放到 `assets/downloads/`，再在“资源下载”区域添加一张资源卡片和链接。
- 维护站点图标与 Logo：当前已使用正式协会 Logo；如需更新站点 Logo，请将经确认的素材放入 `assets/images/`，并同步更新 `index.html` 的引用（素材说明见 `assets/logos/README.md`）。
- 修改样式：编辑 `styles.css`。

## 更多入口

- 如何改内容、提 Pull Request：见 `CONTRIBUTING.md`。
- AI 与协作规则、Git 约定：见 `AGENTS.md`。
- 后续工作计划与已评估事项：见 `docs/roadmap.md`。
- 合并到 `main` 后会自动发布，发布范围仅站点文件（`index.html`、`styles.css`、`script.js`、`404.html` 与 `assets/`）；部署配置见 `.github/workflows/deploy-pages.yml`。
