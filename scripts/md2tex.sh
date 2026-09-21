#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="${ROOT_DIR}/docs"
OUT_DIR="${ROOT_DIR}/latex/sections"
TMP_DIR="${ROOT_DIR}/.tmp_md"

mkdir -p "${OUT_DIR}" "${TMP_DIR}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is not installed." >&2
  exit 1
fi

shopt -s nullglob
found=0

for f in "${DOCS_DIR}"/part*.md; do
  found=1
  name="$(basename "${f}" .md)"
  tmp="${TMP_DIR}/${name}.md"
  out="${OUT_DIR}/${name}.tex"

  cp "${f}" "${tmp}"

  # Reemplazo de caracteres Unicode de cajas y flechas por ASCII
  sed -i \
    -e 's/┌/+/g' -e 's/┐/+/g' -e 's/└/+/g' -e 's/┘/+/g' \
    -e 's/├/+/g' -e 's/┤/+/g' -e 's/┬/+/g' -e 's/┴/+/g' -e 's/┼/+/g' \
    -e 's/─/-/g' -e 's/│/|/g' \
    -e 's/◄/</g' -e 's/►/>/g' -e 's/▼/v/g' -e 's/▲/^/g' \
    -e 's/↔/<=>/g' -e 's/→/->/g' -e 's/←/<-/g' \
    -e 's/┃/|/g' -e 's/━/-/g' -e 's/┏/+/g' -e 's/┓/+/g' \
    -e 's/┗/+/g' -e 's/┛/+/g' \
    "${tmp}"

  echo "Converting ${f} -> ${out}"
  pandoc "${tmp}" \
    -o "${out}" \
    --from markdown+tex_math_dollars+pipe_tables \
    --to latex \
    --top-level-division=section \
    --wrap=none \
    --no-highlight
done

rm -rf "${TMP_DIR}"

if [ "${found}" -eq 0 ]; then
  echo "No part*.md files found in ${DOCS_DIR}" >&2
  exit 1
fi

echo "Done. Output in ${OUT_DIR}."