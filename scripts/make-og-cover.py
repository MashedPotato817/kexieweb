"""重建 og:image 分享配图（1200x630）：深蓝渐变背景 + 新版圆角 Logo + 站名/标语/英文。

用法：
  python scripts/make-og-cover.py

说明：
  - 左侧放置 assets/images/logo-kexie.png（新版圆角 logo）。
  - 右侧依次为主标题、标语、英文。
  - 输出 assets/images/og-cover.png。

依赖：pip install pillow
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

REPO = Path(__file__).resolve().parent.parent
LOGO = REPO / "assets" / "images" / "logo-kexie.png"
OUT = REPO / "assets" / "images" / "og-cover.png"

W, H = 1200, 630
FONT_REG = r"C:\Windows\Fonts\msyh.ttc"
FONT_BOLD = r"C:\Windows\Fonts\msyhbd.ttc"


def lerp(a, b, t):
    return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t)


def main():
    # 深蓝渐变背景（左上亮、右下深）
    img = Image.new("RGB", (W, H), (15, 26, 51))
    d = ImageDraw.Draw(img)
    top_left = (26, 42, 82)
    bottom_right = (10, 20, 42)
    for y in range(H):
        c = lerp(top_left, bottom_right, y / H)
        row_color = (int(c[0]), int(c[1]), int(c[2]))
        d.line([(0, y), (W, y)], fill=row_color)

    # 弧形高光（左上椭圆）
    overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    od = ImageDraw.Draw(overlay)
    od.ellipse([-300, -250, 900, 480], fill=(90, 130, 200, 40))
    img = Image.alpha_composite(img.convert("RGBA"), overlay).convert("RGB")
    d = ImageDraw.Draw(img)

    # 左侧 Logo（新版圆角），保持比例
    logo = Image.open(LOGO).convert("RGBA")
    logo_h = 340
    ratio = logo_h / logo.height
    logo = logo.resize((int(logo.width * ratio), logo_h), Image.LANCZOS)
    lx = 90
    ly = (H - logo_h) // 2
    img.paste(logo, (lx, ly), logo)

    # 右侧文字
    title = ["科技创新与", "智能创造协会"]
    slogan = "让好奇心，落地成创造。"
    eng = "SCIENCE · TECHNOLOGY · COMMUNITY"

    b1 = ImageFont.truetype(FONT_BOLD, 74)
    b2 = ImageFont.truetype(FONT_BOLD, 74)
    f_slogan = ImageFont.truetype(FONT_REG, 36)
    f_eng = ImageFont.truetype(FONT_REG, 26)

    tx = logo.width + lx + 70
    ty = 150
    for line in title:
        d.text((tx, ty), line, font=b1, fill=(255, 255, 255))
        ty += 92
    d.text((tx, ty + 50), slogan, font=f_slogan, fill=(110, 220, 230))
    d.text((tx, ty + 108), eng, font=f_eng, fill=(150, 160, 175))

    img.save(OUT, "PNG", optimize=True)
    print(f"已生成: {OUT} ({W}x{H})")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
