# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

- Build the extension:
  ```bash
   jlpm build:lib && jlpm build:labextension
  ```
  For production build:
  ```bash
   jlpm clean && jlpm build:prod
  ```

- Linting and formatting:
  ```bash
  jlpm run lint:check        # Run eslint and stylelint checks
  jlpm prettier              # Run prettier to format files
  jlpm fix                   # Auto-fix linting issues
  ```

- Watch mode for development:
  ```bash
  jlpm watch                 # Watch src and rebuild on changes
  ```

- Install the extension in development mode (after cloning):
  ```bash
  pip install -e .
  jupyter labextension develop . --overwrite
  jupyter server extension enable jupyterlab_latex
  ```

## Architecture Overview

The LaTeX extension consists of two primary components:

1. **LaTeX Front‑end Plugin** (`latexPlugin`) – registers commands, toolbar buttons, and context‑menu items for creating new `.tex` files, opening live previews, and handling SyncTeX mapping between editor and PDF.

2. **PDFJS Renderer** (`pdfjsPlugin`) – provides a viewer widget for rendering PDF files using PDF.js, tracks PDF widgets, and integrates with the notebook file browser.

Key concepts:
- Uses JupyterFrontEnd's plugin system to add commands like `latex:open-preview`, `latex:synctex-edit`, and `latex:synctex-view`.
- Leverages `WidgetTracker` and `IPDFJSTracker` for managing PDF widget lifecycle.
- SyncTeX integration enables forward (editor → PDF) and reverse (PDF → editor) navigation via `synctexEditRequest` and `synctexViewRequest` functions.
- Toolbar extensions add formatting shortcuts (subscript, superscript, fraction, alignment, list/tree generation, plot insertion) that operate on the current editor selection.

Configuration can be customized through `jupyter_notebook_config.py`, e.g., changing the LaTeX compilation command or disabling SyncTeX.

## Testing & Verification

- The project uses a CI pipeline defined in `.github/workflows/build.yml`. Steps include:
  - Installing dependencies (`python -m pip install .[test]`)
  - Running lint checks (`jlpm run lint:check`)
  - Building the extension and verifying server/labextension listings.
  - Running `python -m jupyterlab.browser_check` for browser compatibility validation.
- There is no dedicated unit‑test command; verification relies on manual preview testing in JupyterLab and automated CI checks.

## Customization Points

- **Compilation Command** – modify via `c.LatexConfig.manual_cmd_args` or `c.LatexConfig.synctex_command`.
- **Shell Escape Settings** – control with `c.LatexConfig.shell_escape`.

These sections give a concise map of typical development tasks and the overall extension architecture for anyone (including future Claude instances) who needs to work with this repository.