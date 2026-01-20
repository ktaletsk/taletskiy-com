# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands
- **Build**: `jlpm run build` - Compile the TypeScript source and generate JS bundles.
- **Watch Build**: `jlpm run watch` - Continuously rebuild on file changes while you develop.
- **Run JupyterLab (with extension enabled)**: `jupyter lab` - Launch a local JupyterLab instance that loads this extension. The server extension must be installed with `pip install -e .` or `conda install -c conda-forge jupyterlab-latex` beforehand.
- **Lint**: No dedicated lint step; TypeScript compilation (`jlpm run build`) will surface syntax errors. Ensure you have ESLint/TSLint configured in your editor if desired.
- **Run Tests** (if any): The repository does not expose a test runner command. If unit tests are added later, they would typically be executed via `pytest` or the JupyterLab testing framework (`jlpm run test`).
- **Format Code**: Use Prettier/TypeScript formatter configured in the project; simply save files after opening them to auto‑format.

## High‑Level Architecture Overview
```mermaid
flowchart TD
    subgraph Frontend (LabExtension)
        A[LaTeX UI Components] -->|Provides toolbar, dialogs, preview panel|
        B[LitElement / React components] --> C[Preview iframe]
    end
    subgraph Backend (Server Extension)
        D[Python entrypoint: jupyterlab_latex]
        E[LatexConfig] -->|Customizes LaTeX command, shell escape|
        F[Bibtex Helper] -->|Runs bibtex if .bib files exist|
        G[Compile Runner] -->|Executes latex_command with arguments|
    end
    A -->|Sends compile request to| D
    D --> E
    D --> F
    D --> G
```
- **LabExtension (`frontend`)**: Provides the UI for LaTeX preview, toolbar buttons (subscript/superscript/bold/etc.), table creation dialog, and plot insertion. It registers a command `latex:showPreview` that triggers compilation.
- **Server Extension (`backend`)**: Implements the core logic:
  - *LatexConfig* holds configuration values such as `latex_command`, `run_times`, `disable_bibtex`, etc., which can be overridden via JupyterLab's config system.
  - When a compile request arrives, it builds an argument list (default: `[latex_command, '-interaction=nonstopmode', '-halt-on-error', ... , '{filename}.tex']`).
  - It runs the LaTeX command in a subprocess to produce `*.pdf`. If `.bib` files are present and bibtex is enabled, it runs `bibtex` (or custom command) before recompiling.
- **Configuration**: Customization via Jupyter config (`jupyter_notebook_config.py`):
  ```python
  c.LatexConfig.latex_command = 'pdflatex'      # or 'xelatex', 'lualatex'
  c.LatexConfig.run_times   = 2                # multi‑pass for refs
  c.LatexConfig.disable_bibtex = False         # enable bibtex by default
  ```
- **Security**: The extension respects LaTeX's shell‑escape policy (`c.LatexConfig.shell_escape`). By default it is `restricted`; you can set to `allow` if needed.
- **Integration Points**:
  - *Toolbar*: Buttons call UI actions that emit events handled by the backend via Jupyter messages.
  - *Commands*: Registered with Lab's command palette (`latex:showPreview`, etc.).
  - *Mime Renderers*: The preview panel renders PDF output using an iframe or PDF.js viewer embedded in the frontend.

## Tips for Development
1. **Start a development server**: `conda env create -f environment.yml && conda activate jupyterlab-latex-env` (or use pip/conda as described). Then run `jlpm install` followed by `jlpm run watch` and open another terminal with `jupyter lab --watch`. Any change in TypeScript will trigger a rebuild automatically.
2. **Testing**: Currently no test suite is shipped; add unit tests under `tests/` using pytest if needed, e.g., `pytest -q` to run them.
3. **Debugging LaTeX Errors**: When compilation fails, the server writes logs to `<notebook_dir>/latex.log`. The frontend shows these in an error panel for user visibility.
4. **Adding New Features**:
   - For additional toolbar icons or plot types, extend `src/components/Toolbar.tsx` and implement corresponding backend handlers that generate LaTeX code snippets.
   - To support a new compilation engine (e.g., `tectonic`), modify `LatexConfig.manual_cmd_args` via config or expose an option UI in the frontend.
5. **Version Compatibility**: Ensure you are using JupyterLab ≥4.x and NodeJS 18+ to avoid breaking changes introduced after this extension's last release.

## Resources & References (from README)
- **BibTeX handling** – automatic if `.bib` files exist, configurable via `disable_bibtex` flag.
- **Multiple compile passes** – set `run_times = 2` for resolving references like `\ref{}`.
- **Custom compilation command** – use `manual_cmd_args` to override default LaTeX invocation.
- **Security settings** – control shell escape behavior with `shell_escape`.

*This CLAUDE.md summarizes essential commands and architectural knowledge needed to be productive when working on the jupyterlab-latex repository.*
