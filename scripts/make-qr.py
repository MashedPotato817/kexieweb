"""生成可复用的纯净二维码图片。

用法示例：
  python scripts/make-qr.py https://qm.qq.com/q/xxxx --output assets/qrs/QQgroup-qr.png
  python scripts/make-qr.py https://example.com --output assets/qrs/foo-qr.png --box-size 8 --fill '#10233f'

依赖：pip install qrcode pillow
"""

import argparse
import sys

from pathlib import Path


def parse_args(argv):
    parser = argparse.ArgumentParser(description="生成纯净二维码图片")
    parser.add_argument("url", help="二维码指向的链接（网站地址、群链接等）")
    parser.add_argument("--output", "-o", required=True, help="输出 PNG 文件路径")
    parser.add_argument("--fill", default="#10233f", help="二维码前景色（默认 #10233f）")
    parser.add_argument("--back", default="white", help="二维码背景色（默认 white）")
    parser.add_argument("--box-size", type=int, default=16, help="每模块像素数（默认 16）")
    parser.add_argument("--border", type=int, default=4, help="白边模块数（默认 4）")
    parser.add_argument("--error-correction", default="H", choices=["L", "M", "Q", "H"],
                        help="纠错级别（默认 H）")
    return parser.parse_args(argv)


def main(argv):
    args = parse_args(argv)
    try:
        import qrcode
        from qrcode.constants import ERROR_CORRECT_H, ERROR_CORRECT_M, ERROR_CORRECT_L, ERROR_CORRECT_Q
    except ImportError:
        print("缺少依赖，请先运行：pip install qrcode pillow", file=sys.stderr)
        return 1

    error_map = {"L": ERROR_CORRECT_L, "M": ERROR_CORRECT_M, "Q": ERROR_CORRECT_Q, "H": ERROR_CORRECT_H}
    qr = qrcode.QRCode(
        version=None,
        error_correction=error_map[args.error_correction],
        box_size=args.box_size,
        border=args.border,
    )
    qr.add_data(args.url)
    qr.make(fit=True)
    image = qr.make_image(fill_color=args.fill, back_color=args.back).convert("RGB")

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    image.save(out, "PNG", optimize=True)
    print(f"已生成: {out} ({image.width}x{image.height})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))