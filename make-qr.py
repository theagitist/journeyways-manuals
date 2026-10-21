#!/usr/bin/env python3
"""Styled QR codes for the print documents: round dots, rounded finder eyes.

Usage: ./make-qr.py  (writes assets/qr-*.svg; needs qrencode)
The SVG has no quiet zone and a transparent background: place it on a light
card with at least 4 modules of padding (see aside/colophon in src/content.typ).
"""
import subprocess

INK, EYE = "#1A1A1A", "#B45309"  # body ink; dark amber (brand orange is too light to scan)
CODES = {
    "qr-components.svg": "https://journeyways.ca/components",
    "qr-components-es.svg": "https://journeyways.ca/es/components",
    "qr-components-fr.svg": "https://journeyways.ca/fr/components",
    "qr-licence-en.svg": "https://creativecommons.org/licenses/by-nc/4.0/",
    "qr-licence-es.svg": "https://creativecommons.org/licenses/by-nc/4.0/deed.es",
    "qr-licence-fr.svg": "https://creativecommons.org/licenses/by-nc/4.0/deed.fr",
}


def matrix(url):
    out = subprocess.run(["qrencode", "-t", "ASCII", "-m", "0", url],
                         capture_output=True, text=True, check=True).stdout
    return [[row[i] == "#" for i in range(0, len(row), 2)] for row in out.splitlines() if row]


def svg(m):
    n = len(m)
    eyes = [(0, 0), (n - 7, 0), (0, n - 7)]
    in_eye = lambda x, y: any(ex <= x < ex + 7 and ey <= y < ey + 7 for ex, ey in eyes)
    parts = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{n}" height="{n}" viewBox="0 0 {n} {n}">']
    for y in range(n):
        for x in range(n):
            if m[y][x] and not in_eye(x, y):
                parts.append(f'<circle cx="{x + .5}" cy="{y + .5}" r=".43" fill="{INK}"/>')
    for ex, ey in eyes:
        parts.append(f'<rect x="{ex + .5}" y="{ey + .5}" width="6" height="6" rx="1.8" fill="none" stroke="{EYE}" stroke-width="1"/>')
        parts.append(f'<rect x="{ex + 2}" y="{ey + 2}" width="3" height="3" rx="0.9" fill="{EYE}"/>')
    return "\n".join(parts + ["</svg>\n"])


for name, url in CODES.items():
    with open(f"assets/{name}", "w") as f:
        f.write(svg(matrix(url)))
