# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **jupyterlab-latex**, a JupyterLab extension for live-editing of LaTeX documents. It provides:
- Real-time LaTeX compilation and PDF preview
- SyncTeX support for editor-PDF synchronization
- Writing tools (text formatting, lists, tables, plots)
- Mathematical constants and symbols insertion

The extension consists of:
1. **Frontend (TypeScript)**: JupyterLab UI components and plugins
2. **Backend (Python)**: Server extension for LaTeX compilation

## Development Setup

### Prerequisites
- Node.js (for building TypeScript)
- Python 3.8+
- JupyterLab 4.0+
- LaTeX distribution (e.g., TeX Live, MiKTeX) with `pdflatex`, `xelatex`, or `tectonic`

### Installation
```bash
# Development install
pip install -e .

# Link with JupyterLab
jupyter labextension develop . --overwrite
jupyter server extension enable jupyterlab_latex

# Build TypeScript
jlpm run build
```

### Building
- `jlpm run build`: Build TypeScript and labextension
- `jlpm run build:prod`: Production build (clean + minified)
- `jlpm run watch`: Watch mode for development
- `jupyter labextension build .`: Build labextension

### Linting
- `jlpm run lint`: Run ESLint, Prettier, and Stylelint
- `jlpm run eslint`: Run ESLint only
- `jlpm run prettier`: Run Prettier formatting
- `jlpm run stylelint`: Run Stylelint

### Cleaning
- `jlpm run clean`: Clean build artifacts
- `jlpm run clean:all`: Clean everything (lib, labextension, lint cache)

## Architecture

### Frontend Structure (TypeScript)
**Location**: `src/`

- `index.ts`: Main plugin entry point
  - Defines JupyterFrontEndPlugin for LaTeX extension
  - Sets up commands, toolbar buttons, and context menu items
  - Manages PDF preview and SyncTeX synchronization

- `pdf.ts`: PDF viewer components
  - `PDFJSViewer`: PDF rendering widget
  - `PDFJSViewerFactory`: Document registry factory
  - `PDFJSDocumentWidget`: Widget wrapper

- `error.tsx`: Error panel component for LaTeX compilation errors

- `pagenumber.tsx`: Page number display component

### Backend Structure (Python)
**Location**: `jupyterlab_latex/`

- `__init__.py`: Server extension entry point
  - Registers `/latex/build` and `/latex/synctex` handlers
  - Sets up Tornado web handlers

- `build.py`: LaTeX compilation handler
  - `LatexBuildHandler`: Main API handler for compilation
  - `latex_cleanup()`: Context manager for file cleanup
  - `build_tex_cmd_sequence()`: Builds LaTeX command sequences
  - `filter_output()`: Filters LaTeX warnings/errors
  - `run_latex()`: Executes LaTeX commands

- `synctex.py`: SyncTeX handler for editor-PDF synchronization

- `config.py`: Configuration schema
  - `LatexConfig`: Configuration class with settings for:
    - `latex_command`: LaTeX engine (xelatex, pdflatex, tectonic)
    - `bib_command`: BibTeX command
    - `run_times`: Number of compilation passes
    - `shell_escape`: Security setting (restricted/allow/disallow)
    - `cleanup`: Whether to clean intermediate files
    - `manual_cmd_args`: Custom command arguments
    - `disable_bibtex`: Skip BibTeX compilation

- `util.py`: Utility functions
  - `run_command()`: Execute shell commands with async support

### Key Features

1. **Live Preview**: Opens PDF alongside .tex editor, auto-updates on save
2. **SyncTeX**: Click in PDF to jump to source, click in source to jump to PDF
3. **Toolbar**: Adds buttons for formatting (bold, italic), sub/superscripts, lists, tables, plots
4. **Menu**: Constants (π, φ) and symbols (≤, ≥, ∈) insertion
5. **Error Handling**: Shows compilation errors in a dedicated panel

### Communication Flow

1. User saves .tex file → `fileChanged` signal emitted
2. Frontend calls `/latex/build` API endpoint
3. Backend runs LaTeX compilation
4. PDF is generated/updated → displayed in PDF viewer
5. SyncTeX data generated for navigation

## Configuration

Users can configure the extension via `jupyter_notebook_config.py`:

```python
# Use pdflatex instead of xelatex
c.LatexConfig.latex_command = 'pdflatex'

# Custom compilation command
c.LatexConfig.manual_cmd_args = [
    'lualatex',
    '-interaction=nonstopmode',
    '-shell-escape',
    '{filename}.tex'
]

# Disable BibTeX compilation
c.LatexConfig.disable_bibtex = True

# Clean intermediate files
c.LatexConfig.cleanup = True
```

## Testing Approach

The project uses:
- TypeScript with ESLint for frontend
- Python for backend
- No dedicated test suite found in repository

## Important Files

- `package.json`: Frontend dependencies and scripts
- `pyproject.toml`: Python package configuration
- `schema/plugin.json`: JupyterLab settings schema
- `README.md`: User documentation
- `CHANGELOG.md`: Release notes

## Common Development Tasks

1. **Adding a new toolbar button**:
   - Create button in `EditorToolbarPanel` class in `src/index.ts`
   - Add icon SVG in `style/icons/`
   - Register command with `app.commands.addCommand()`

2. **Adding a new menu item**:
   - Add to `addLatexMenu()` function
   - Create command handler

3. **Modifying LaTeX compilation**:
   - Update `build_tex_cmd_sequence()` in `jupyterlab_latex/build.py`
   - Ensure SyncTeX flags are preserved

4. **Adding new symbols/constants**:
   - Extend the `constants` or `symbols` maps in `addLatexMenu()`

## Notes

- The extension uses PDF.js for rendering PDFs in the browser
- SyncTeX requires `.synctex.gz` files generated by LaTeX
- File cleanup is optional and controlled by `cleanup` config
- Manual command arguments support `{filename}` placeholder
