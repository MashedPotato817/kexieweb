"""生成「科协招新二维码」A4 横向 PDF。

顶部并排三个 logo（南师大 / 电自院 / 科协，高度对齐、宽度各随比例），
下方依次为校名、院名、协会名、副标题、三个二维码与说明。

用法：
  python scripts/make-qr-pdf.py

输出：assets/downloads/科协招新二维码.pdf

依赖：pip install reportlab（复用 Pillow 读取图片宽高比）
"""

from pathlib import Path

from PIL import Image
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas

REPO = Path(__file__).resolve().parent.parent
IMG_DIR = REPO / "assets" / "images"
QR_DIR = REPO / "assets" / "qrs"
OUT = REPO / "assets" / "downloads" / "科协招新二维码.pdf"

FONT = r"C:\Windows\Fonts\msyh.ttc"  # 微软雅黑 常规
FONT_BOLD = r"C:\Windows\Fonts\msyhbd.ttc"  # 微软雅黑 粗体

# 顶部三个 logo（文件名, 说明）
LOGOS = [
    ("logo-nnu.jpg", "南京师范大学"),
    ("logo-dianzi.jpg", "电气与自动化工程学院"),
    ("logo-kexie.png", "科技创新与智能创造协会"),
]

# 三个二维码（文件名, 说明文字, 群号/网址）
ENTRIES = [
    ("kexieweb-qr.png", "科协官方网站", "mashedpotato817.github.io/kexieweb"),
    ("QQgroup3-recuit-qr.png", "2026科协招新群", "群号 903526745"),
    ("QQgroup2-qr.png", "电自院科协活动宣传群", "群号 660593320"),
]


def logo_wh(filename, height):
    """返回 (width, height)，按图片原始宽高比在给定高度下计算宽度。"""
    with Image.open(IMG_DIR / filename) as im:
        w, h = im.size
    return (height * w / h, height)


def main():
    pdfmetrics.registerFont(TTFont("YaHei", FONT, subfontIndex=0))
    pdfmetrics.registerFont(TTFont("YaHei-Bold", FONT_BOLD, subfontIndex=0))

    page_w, page_h = landscape(A4)
    c = canvas.Canvas(str(OUT), pagesize=(page_w, page_h))
    c.setTitle("科协招新二维码")
    c.setAuthor("科技创新与智能创造协会")
    c.setFillColorRGB(0, 0, 0)

    # ---- 顶部三 logo：高度对齐、宽度各异、并排居中 ----
    logo_h = 26 * mm
    logo_gap = 12 * mm
    widths = [logo_wh(f, logo_h)[0] for f, _ in LOGOS]
    total_logo_w = sum(widths) + logo_gap * (len(LOGOS) - 1)
    logo_x0 = (page_w - total_logo_w) / 2
    logo_top_margin = 17 * mm           # logo 顶端距页面顶部（内容块垂直居中）
    logo_bottom = page_h - logo_top_margin - logo_h

    for i, (fname, _) in enumerate(LOGOS):
        x = logo_x0 + sum(widths[:i]) + i * logo_gap
        w, h = logo_wh(fname, logo_h)
        c.drawImage(str(IMG_DIR / fname), x, logo_bottom, width=w, height=h,
                    preserveAspectRatio=True, anchor="c", mask="auto")

    # ---- 文字区：从 logo 下方开始，整体下移 ----
    text_top = logo_bottom - 13 * mm    # 校名再往下放，与三 logo 拉开距离

    # 校名：逐字绘制，保证每个字之间为等宽间距（手动居中）
    school = "南京师范大学"
    school_font, school_size = "YaHei-Bold", 28
    c.setFont(school_font, school_size)
    char_w = pdfmetrics.stringWidth(school[0], school_font, school_size)
    char_gap = 6                        # 每字之间的等宽间距（pt）
    spaced_w = char_w * len(school) + char_gap * (len(school) - 1)
    x = (page_w - spaced_w) / 2
    for ch in school:
        c.drawString(x, text_top, ch)
        x += char_w + char_gap

    # 院名
    academy_y = text_top - 10 * mm
    c.setFont("YaHei-Bold", 20)
    c.drawCentredString(page_w / 2, academy_y, "电气自动化工程学院")

    # 协会名
    asso_y = academy_y - 9 * mm
    c.setFont("YaHei-Bold", 15)
    c.drawCentredString(page_w / 2, asso_y, "科技创新与智能创造协会")

    # 副标题
    sub_y = asso_y - 8 * mm
    c.setFont("YaHei", 12.5)
    c.drawCentredString(page_w / 2, sub_y, "扫码加入，一起玩转科学与技术")

    # ---- 三个二维码并排 + 说明 ----
    qr_size = 62 * mm
    qr_gap = (page_w - 3 * qr_size) / 4
    qr_top = sub_y - 16 * mm
    for i, (img, name, sub) in enumerate(ENTRIES):
        x = qr_gap + i * (qr_size + qr_gap)
        c.drawImage(str(QR_DIR / img), x, qr_top - qr_size, width=qr_size,
                    height=qr_size, preserveAspectRatio=True, anchor="c", mask="auto")
        text_x = x + qr_size / 2
        text_y = qr_top - qr_size - 13 * mm
        c.setFont("YaHei-Bold", 17)
        c.drawCentredString(text_x, text_y, name)
        c.setFont("YaHei", 14)
        c.drawCentredString(text_x, text_y - 9 * mm, sub)

    c.save()
    print(f"已生成: {OUT}")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
