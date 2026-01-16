# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the JupyterLab LaTeX extension, which provides live editing of LaTeX documents within JupyterLab. It allows users to compile and preview LaTeX documents in real-time, with features like SyncTeX support for bidirectional navigation between source and preview.

## Key Architecture Components

### Frontend (TypeScript/JavaScript)
- The extension is built using JupyterLab's extension system
- Core frontend functionality is in `src/index.ts`
- Uses JupyterLab's application framework, widget system, and services
- Implements a PDF viewer using pdfjs-dist for displaying compiled LaTeX output
- Provides toolbar buttons and context menu items for LaTeX editing tools
- Implements SyncTeX functionality for bidirectional navigation between editor and PDF

### Backend (Python)
- Server extension in `jupyterlab_latex/` directory
- Handles LaTeX compilation through the Jupyter Server API
- Uses `tornado.process.Subprocess` for executing LaTeX commands
- Provides API endpoints at `/latex/build` and `/latex/synctex`
- Configuration is handled through `jupyterlab_latex/config.py` using traitlets

### Build System
- Uses TypeScript for frontend with `tsc` compiler
- Uses JupyterLab's build system with `@jupyterlab/builder`
- Uses yarn for package management
- Builds both frontend and backend extensions

## Development Setup

To develop this extension, you need:
1. NodeJS for building the frontend
2. Python 3.8+ for the server extension
3. JupyterLab 4.0+ for running the development environment

Development commands:
- `jlpm install` - Install dependencies
- `jlpm build` - Build the extension
- `jlpm watch` - Watch for changes and rebuild automatically
- `jupyter labextension develop . --overwrite` - Link development version
- `jupyter server extension enable jupyterlab_latex` - Enable server extension

## Key Files and Directories

- `src/index.ts` - Main extension entry point
- `jupyterlab_latex/__init__.py` - Extension initialization
- `jupyterlab_latex/build.py` - LaTeX compilation handler
- `jupyterlab_latex/config.py` - Configuration handling
- `jupyterlab_latex/util.py` - Utility functions for running commands
- `package.json` - Extension metadata and build scripts
- `pyproject.toml` - Python package configuration
- `README.md` - Documentation and usage instructions

## Key Features

1. Real-time LaTeX compilation and preview
2. SyncTeX support for bidirectional navigation between source and PDF
3. Toolbar buttons for common LaTeX editing tasks (subscript, superscript, lists, etc.)
4. Context menu integration for preview and SyncTeX actions
5. Support for multiple LaTeX engines (xelatex, pdflatex, tectonic)
6. Configuration options for customizing compilation commands
7. BibTeX support for bibliography compilation
8. Error handling and display of compilation errors

## Testing

The extension can be tested by:
1. Installing in development mode
2. Opening a `.tex` file in JupyterLab
3. Using the preview toolbar button or context menu
4. Verifying that LaTeX compilation works and PDF is generated
5. Testing SyncTeX functionality by clicking in PDF and editor

## Common Development Tasks

1. Adding new toolbar buttons or menu items
2. Modifying LaTeX compilation commands or options
3. Enhancing error handling or display
4. Adding new LaTeX editing features
5. Improving SyncTeX integration
6. Customizing the extension's appearance or behavior