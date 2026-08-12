# 内容位置速查

`index.html` 是当前唯一页面。

| 任务 | 位置 | 规则 |
| --- | --- | --- |
| 修改协会介绍 | `#about` | 只写已确认的宗旨、活动或成果。 |
| 发布招新 | `#join` | 写明已确认的时间、地点、报名方式；否则保留“招新信息待发布”。 |
| 添加资料 | `#resources` | 每项使用一个 `resource-card`；有文件时提供可下载链接。 |
| 修改联系方式 | `#contact` | 仅填写被批准公开的官方联系方式。 |
| 更换名称/校徽 | 页头、页脚 | 需负责人提供标准名称和授权资产。 |

## 资源卡片模板

将下面模板插入 `.resource-grid`。没有可公开的文件或链接时，不添加 `<a>`，并保留“待发布”说明。

```html
<article class="resource-card">
  <span class="resource-type">课件</span>
  <h3>活动名称课件</h3>
  <p>一句话说明资料内容与适用对象。</p>
  <a class="text-link" href="assets/downloads/文件名.pdf" download>下载资料 →</a>
</article>
```

