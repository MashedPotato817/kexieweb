"""压缩图片到适合网页显示的体积，等比缩放并输出新文件（不覆盖原图）。

用法示例：
  python scripts/compress-images.py assets/photos/科普知识竞赛.png --max-width 460
  python scripts/compress-images.py assets/images/logo.png --max-width 68 --output assets/images/logo-sm.png --format png
  python scripts/compress-images.py assets/photos/foo.jpg --max-width 800 --quality 78

说明：
  - 输出文件默认加 `_thumb` 后缀（保持原格式），可通过 --output 指定完整输出路径。
  - 仅当原图宽度超过 --max-width 时才会缩放；否则保持原尺寸，仅重新编码压缩。
  - 原图始终保留，绝不原地覆盖。
  - 默认输出 JPEG（兼容性最好）；用 --format png 保留透明通道时选 png。

依赖：pip install pillow
"""

import argparse
import sys
from pathlib import Path

from PIL import Image


def parse_args(argv):
    parser = argparse.ArgumentParser(description="压缩图片（等比缩放 + 重新编码，不覆盖原图）")
    parser.add_argument("input", help="输入图片路径")
    parser.add_argument("--max-width", type=int, default=1280,
                        help="目标最大宽度（像素），原图更宽时等比缩到该宽度（默认 1280）")
    parser.add_argument("--quality", type=int, default=80, help="JPEG/WebP 压缩质量 1-100（默认 80）")
    parser.add_argument("--format", default="jpeg", choices=["jpeg", "webp", "png"],
                        help="输出格式（默认 jpeg，兼容性最好）")
    parser.add_argument("--output", "-o", default=None, help="输出文件路径（默认：<原文件名>_thumb.<ext>）")
    return parser.parse_args(argv)


def main(argv):
    args = parse_args(argv)
    src = Path(args.input)
    if not src.is_file():
        print(f"输入文件不存在: {src}", file=sys.stderr)
        return 1

    try:
        image = Image.open(src)
        image.load()
    except Exception as exc:
        print(f"无法读取图片 {src}: {exc}", file=sys.stderr)
        return 1

    original_size = src.stat().st_size

    if image.mode in ("RGBA", "LA", "P") and args.format in ("jpeg", "webp"):
        image = image.convert("RGB")

    if image.width > args.max_width:
        height = round(image.height * args.max_width / image.width)
        image = image.resize((args.max_width, height), Image.LANCZOS)

    if args.output:
        out = Path(args.output)
    else:
        out = src.with_name(f"{src.stem}_thumb.{args.format}")

    out.parent.mkdir(parents=True, exist_ok=True)
    save_kwargs = {"format": args.format.upper()}
    if args.format in ("jpeg", "webp"):
        save_kwargs["quality"] = args.quality
        save_kwargs["optimize"] = True
    image.save(out, **save_kwargs)

    new_size = out.stat().st_size
    pct = (new_size / original_size * 100) if original_size else 0
    print(f"已生成: {out} ({image.width}x{image.height})")
    print(f"体积: {original_size / 1024:.0f}KB -> {new_size / 1024:.0f}KB ({pct:.0f}%)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
