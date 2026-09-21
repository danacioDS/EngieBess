#!/usr/bin/env python3
"""
Fix math cells in Markdown tables.

Detects cells in Markdown tables that look like LaTeX math
(start with '(' and contain greek letters or LaTeX commands)
and wraps them in $...$.

Usage:
    python3 scripts/fix-math.py docs/part*.md
"""

import re
import sys
from pathlib import Path

# Símbolos griegos y comandos LaTeX comunes en los símbolos de Part 1
GREEK_AND_LATEX = re.compile(
    r"\\(?:alpha|beta|gamma|delta|epsilon|eta|theta|lambda|mu|nu|xi|pi|rho|sigma|tau|phi|chi|psi|omega|Delta|Gamma|Theta|Lambda|Pi|Sigma|Phi|Psi|Omega|eta|sigma|tau|alpha|beta|pi|Delta|Th|SOC|SOH|EFC|PAC|PDC)\b"
)

# Patrón: | (contenido) | — celda de tabla que empieza con "(" y termina con ")" o antes de " |"
CELL_PATTERN = re.compile(r"\| (\\([^|]*)\\) \|")

def fix_cell(match: re.Match) -> str:
    content = match.group(1)
    return f"| $({content})$ |"

def fix_file(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    original = text

    # Envolver celdas que contienen LaTeX explícito
    # Patrón: | (\algo) |  donde "algo" contiene "\" (comando LaTeX)
    text = re.sub(
        r"\| \(([^|]*\\[^|]*)\) \|",
        lambda m: f"| $({m.group(1)})$ |",
        text,
    )

    # Envolver celdas que contienen símbolos griegos Unicode
    # (σ, τ, π, Δ, α, β, η, μ, etc.) sin $
    greek_unicode = "σ τ π Δ α β η μ λ θ ω φ ε".split()
    for g in greek_unicode:
        text = re.sub(
            rf"\| \(([^|]*{g}[^|]*)\) \|",
            lambda m: f"| $({m.group(1)})$ |",
            text,
        )

    if text != original:
        path.write_text(text, encoding="utf-8")
        return 1
    return 0

def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/fix-math.py docs/part*.md")
        return 1

    total = 0
    for arg in sys.argv[1:]:
        path = Path(arg)
        if not path.exists():
            print(f"Warning: {path} not found", file=sys.stderr)
            continue
        changed = fix_file(path)
        if changed:
            print(f"Fixed: {path}")
            total += 1

    print(f"\nTotal files modified: {total}")
    return 0

if __name__ == "__main__":
    sys.exit(main())