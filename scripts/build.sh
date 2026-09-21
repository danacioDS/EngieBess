#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LATEX_DIR="${ROOT_DIR}/latex"
BUILD_DIR="${LATEX_DIR}/build"

# 1. Fix math cells in .md files
if command -v python3 >/dev/null 2>&1 && [ -f "${ROOT_DIR}/scripts/fix-math.py" ]; then
  echo "Fixing math cells..."
  python3 "${ROOT_DIR}/scripts/fix-math.py" "${ROOT_DIR}"/docs/part*.md || true
fi

# 2. Convert .md -> .tex
"${ROOT_DIR}/scripts/md2tex.sh"

# 3. Compile PDF
mkdir -p "${BUILD_DIR}"
cd "${LATEX_DIR}"

if ! command -v latexmk >/dev/null 2>&1; then
  echo "Error: latexmk is not installed." >&2
  exit 1
fi

latexmk -pdf -interaction=nonstopmode -outdir="${BUILD_DIR}" main.tex

echo "PDF generated at ${BUILD_DIR}/main.pdf"