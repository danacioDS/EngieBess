# BESS Engineering Model

Technical specification for the operational and financial simulation of Battery Energy Storage Systems (BESS), prepared for ENGIE RFP-264144-1.

## Documents (Markdown)

| Part | Title | Link |
|---|---|---|
| 0 | Introduction | [docs/part0-introduction.md](docs/part0-introduction.md) |
| 1 | Fundamentals and Conventions | [docs/part1-fundamentals.md](docs/part1-fundamentals.md) |
| 2 | Physical Asset Model | [docs/part2-physical-asset.md](docs/part2-physical-asset.md) |
| 3 | Degradation and Useful Life | pending |
| 4 | Services (Operating Modes) | [docs/part4-services.md](docs/part4-services.md) |
| 5 | Dispatch, Stacking, and Outputs | pending |

Supplementary:

- [Financial Approach](docs/financial/financial-approach.md)

## Formal PDF

The consolidated LaTeX document is built automatically on each push to main.

Download the latest PDF from the Actions tab of this repository.

## Local build

Requirements:

- pandoc
- latexmk
- A LaTeX distribution (TeX Live on Linux, MacTeX on macOS, MiKTeX on Windows)

Build:

    ./scripts/build.sh

The PDF is generated at latex/build/main.pdf.

## Repository structure

    EngieBess/
    |-- README.md
    |-- docs/
    |   |-- part0-introduction.md
    |   |-- part1-fundamentals.md
    |   |-- part2-physical-asset.md
    |   |-- part4-services.md
    |   `-- financial/
    |       `-- financial-approach.md
    |-- scripts/
    |   |-- md2tex.sh
    |   `-- build.sh
    |-- latex/
    |   |-- main.tex
    |   |-- sections/
    |   `-- build/
    `-- .github/
        `-- workflows/
            `-- build-pdf.yml

## Editing conventions

- Source of truth: docs/*.md. Edit these.
- Generated: latex/sections/*.tex. Do not edit manually.
- Manual: latex/main.tex. Edit as needed.
- Never committed: latex/build/ and LaTeX auxiliaries.

# EngieBess
git status
git add .
git commit -m "initial commits"
git push origin main 