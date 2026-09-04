# 二维码资源

`assets/qrs/` 文件夹用于存放网站使用的二维码图片。二维码均为使用对应链接重新生成的纯净图片，不含截图多余信息。

## 文件说明

- `kexieweb-qr.png`：网站访问二维码，指向本站地址 `https://mashedpotato817.github.io/kexieweb/`。
- `QQgroup-qr.png`：电自院科协成员内部群【科协小屋🏠】二维码，指向群链接 `https://qm.qq.com/q/8py73bnrZ6`（群号 797706466）。
- `QQgroup2-qr.png`：电自院科协活动宣传群二维码，指向群链接 `https://qm.qq.com/q/hEafZMdJ4s`（群号 660593320），展示在网站「联系」区块。
- `QQgroup3-recuit-qr.png`：2026科协招新群二维码，指向群链接 `https://qm.qq.com/q/XnoFCh1Di4`，展示在网站「联系」区块。

## 使用说明

- 网站「联系」区块当前展示招新群二维码（`QQgroup3-recuit-qr.png`）与宣传群二维码（`QQgroup2-qr.png`）。
- 需要重新生成二维码时，使用 `scripts/make-qr.py`（默认沿用现有样式，深蓝填充、白底、高纠错）：
  ```
  python scripts/make-qr.py <链接> --output assets/qrs/<文件名>.png
  ```
- 替换二维码时，请确认二维码所指代的链接（网站地址或群链接）仍有效，并保留有意义的 `alt` 文本。
- 不要在公开页面放个人账号或未公开群二维码。