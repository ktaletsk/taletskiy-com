---
title: "700 JupyterLab 4 Extensions!"
date: 2026-03-13
draft: false
summary: "The JupyterLab extension ecosystem just crossed 700 extensions compatible with JupyterLab 4. Here's what the latest wave tells us about where notebooks are heading."
tags: ["JupyterLab", "extensions", "Jupyter", "ecosystem"]
newsletter: jupyterlab-extensions
image: /img/700_extensions_collage.png
---

![700 extensions for JupyterLab 4, and counting!](/img/700_extensions_collage.png)

The JupyterLab extension ecosystem just crossed **700 extensions compatible with JupyterLab 4!**

That's 700 community-built plugins — from astronomical data viewers to reactive notebook editors, from genome browsers to workflow managers — created by hundreds of developers, research labs, and companies around the world.

## What Are JupyterLab Extensions?

Extensions are how JupyterLab becomes a Git client, a dashboard builder, a genomics viewer, or an AI workspace — without changing the core application. Install one with `pip install`, and it activates automatically.

![Popular JupyterLab extensions](/img/popular_extensions_collage.png)

This is by design: JupyterLab itself is built as a collection of extensions — the [file browser](https://github.com/jupyterlab/jupyterlab/tree/main/packages/filebrowser), the [notebook editor](https://github.com/jupyterlab/jupyterlab/tree/main/packages/notebook), the [terminal](https://github.com/jupyterlab/jupyterlab/tree/main/packages/terminal) are all plugins. The same architecture that powers the core lets the community build what they need. For background, see [99 ways to extend the Jupyter ecosystem](https://blog.jupyter.org/99-ways-to-extend-the-jupyter-ecosystem-11e5dab7c54).

## The Ecosystem at 700

- **700+ extensions compatible with JupyterLab 4**
- **~960 total extensions** published on PyPI
- **~9.8 million downloads/month**
- **100M+ total downloads** in the past year

By any measure, a substantial software layer has grown around JupyterLab.

## How We Got Here

The ecosystem crossed **600 JL4-compatible extensions in late October 2025**, days before [JupyterCon in San Diego](https://www.jupytercon.com/). At the conference, we ran a full-day [Extension Development for Everyone](https://jupytercon.github.io/jupytercon2025-developingextensions/) tutorial with hands-on rapid prototyping. By early March 2026, we hit **700**.

The ecosystem has been growing at a steady pace, averaging about 18 new extensions per month, with November 2025 setting an all-time monthly record of 33. Modern tooling is helping: better templates, documentation, and code generation tools have lowered the bar for what once required deep familiarity with TypeScript, Lumino, and JupyterLab internals.

## Where the Extensions Are

![Number of JupyterLab extensions by category](/img/extensions_per_category.png)

![Monthly PyPI downloads by category](/img/extensions_downloads_per_category.png)

Development & Version Control dominates both in count (267) and downloads (5.4M/month). Visualization & Dashboards (2.7M/month) and System & Resource Management (602K/month) round out the top three most downloaded categories. But the fastest-growing categories point to where things are heading. Here's what's new in 2026:

## JupyterLab's AI Layer Starts Taking Shape

AI isn't yet the biggest category in JupyterLab, but it may be the clearest signal of where new interaction patterns are emerging:

- **[jupyter-ai-acp-client](https://labextensions.dev/extensions/jupyter-ai-acp-client?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — Brings external AI agents into JupyterLab's chat via the Agent Communication Protocol. Ships with Claude Code and Kiro personas.
- **[nb-margin](https://labextensions.dev/extensions/nb-margin?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — Annotate cells with margin comments, and Claude Code edits them. A different paradigm from chat-based AI.
- **[jupyterlite-ai-kernels](https://labextensions.dev/extensions/jupyterlite-ai-kernels?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — AI-powered kernels for JupyterLite, from Jeremy Tuloup. AI-assisted computation entirely in the browser.
- **[jupyter-chat-components](https://labextensions.dev/extensions/jupyter-chat-components?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — Reusable chat UI components from Project Jupyter — building blocks for the next generation of AI tools.

These extensions reflect what the JupyterLab team identified as a 2026 priority: first-class integration with AI tooling.

## Reproducibility Gets a Toolchain

**[calkit-python](https://labextensions.dev/extensions/calkit-python?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** is the most downloaded new extension of 2026 (11,000+ monthly downloads). It gives notebooks project-scoped environments, graphical package management via Astral's `uv`, and one-click notebook pipelines with freshness tracking. Think "Makefiles for notebooks" meets "Poetry for Jupyter."

![Calkit manages notebook pipelines with environment tracking and one-click reruns. The orange 'run' button signals stale outputs that need to be regenerated.](/img/calkit_screenshot.png)

**[jupyter-projspec](https://labextensions.dev/extensions/jupyter-projspec?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** (from the fsspec contributors) takes a complementary approach — it brings [projspec](https://github.com/fsspec/projspec) into JupyterLab, letting you scan and analyze project structures directly from the notebook environment.

![jupyter-projspec integrates to system filebrowser to show the project metadata](/img/jupyter-projspec-hero.png)

## Marimo Comes to JupyterLab

[Marimo](https://marimo.io) — the reactive notebook editor — now runs inside JupyterLab. The official **[marimo-jupyter-extension](https://labextensions.dev/extensions/marimo-jupyter-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** from the Marimo team lets you open and edit `_mo.py` Marimo files directly in JupyterLab, bringing reactive execution to JupyterHub deployments without leaving the Jupyter environment. This matters for teams that want to adopt Marimo incrementally — you can keep your JupyterHub infrastructure and add Marimo as another file type alongside traditional notebooks.

## Science

- **[fitsview](https://labextensions.dev/extensions/fitsview?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — Stream FITS astronomical data slices directly in JupyterLab without downloading full files.
- **[jupyterlab-urdf-test](https://labextensions.dev/extensions/jupyterlab-urdf-test?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — 3D robot model viewer/editor (URDF + Three.js), from [jupyter-robotics](https://github.com/jupyter-robotics).
- **[climb-jupyter-igv](https://labextensions.dev/extensions/climb-jupyter-igv?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — Integrative Genomics Viewer with S3 access for bioinformatics.
- **[ggblab](https://labextensions.dev/extensions/ggblab?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — GeoGebra interactive geometry with bidirectional Python communication. Second most downloaded new extension of 2026.

## Accessibility

Accessibility has been a growing focus for JupyterLab core and extensions are starting to address it too:

- **[jupyterlab-a11y-checker](https://labextensions.dev/extensions/jupyterlab-a11y-checker?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — From UC Berkeley's [DSEP infrastructure team](https://github.com/berkeley-dsep-infra/jupyterlab-a11y-checker), this extension scans notebooks for WCAG 2.1 AA issues: missing alt text, heading structure, table headers, color contrast, and link text. Guided fix interfaces, optional AI suggestions, and a CLI for CI pipelines. Over 11,000 total downloads and a [documentation site](https://a11y-checker-guide.datahub.berkeley.edu/).
- **[jupyterlab-change-ui-font-size-fix](https://labextensions.dev/extensions/jupyterlab-change-ui-font-size-fix?utm_source=blog&utm_medium=post&utm_campaign=700_extensions)** — Fixes file browser icon misalignment when users change the UI font size — a small but real pain point for anyone who needs larger text.

## 27 Extensions, One Platform

[Stellars](https://github.com/stellarshenson/stellars-jupyterlab-ds) is a JupyterLab-based data science platform — GPU support, MLflow, TensorBoard, Optuna — assembled from **27 custom extensions** covering everything from [branding](https://labextensions.dev/extensions/jupyterlab-branding-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions) and [file icons](https://labextensions.dev/extensions/jupyterlab-vscode-icons-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions) to [kernel management](https://labextensions.dev/extensions/jupyterlab-kernel-terminal-workspace-culler-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions) and [diagram rendering](https://labextensions.dev/extensions/jupyterlab-drawio-render-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions), [VS Code file icons](https://labextensions.dev/extensions/jupyterlab-vscode-icons-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions), [trash management](https://labextensions.dev/extensions/jupyterlab-trash-mgmt-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions), [Mermaid-to-PNG conversion](https://labextensions.dev/extensions/jupyterlab-mmd-to-png-extension?utm_source=blog&utm_medium=post&utm_campaign=700_extensions), and more. JupyterLab is now flexible enough that one developer can assemble a domain-specific product entirely from extension building blocks.

## Want to Build Your Own?

The JupyterCon tutorial is fully available: [step-by-step materials](https://jupytercon.github.io/jupytercon2025-developingextensions/) and the complete [YouTube recording](https://www.youtube.com/watch?v=z-KZ6CjZjbM). It covers scaffolding, plugin architecture, publishing to PyPI, and rapid prototyping techniques. The tools have never been more accessible.

## How We Track This

The data behind this post comes from the [JupyterLab Extension Marketplace](https://labextensions.dev?utm_source=blog&utm_medium=post&utm_campaign=700_extensions), a community [project](https://github.com/orbrx/jupyter-marketplace) that tracks all published JupyterLab extensions using PyPI data. The marketplace refreshes automatically and provides download trends, category breakdowns, and discovery tools.

![JupyterLab Marketplace](/img/marketplace_screenshot.png)

For more on the data and methodology, see our [PyData Boston 2025 talk](https://www.youtube.com/watch?v=OWt3Yzhrs1E).

## What's Next

- **New interaction patterns** are still being figured out — chat-based assistance, cell annotations, agent protocols. Probably all of them for different use cases.
- **Reproducibility tooling** suggests the community is ready for opinionated workflow management built into the notebook experience.
- **Cross-notebook-format support** (Marimo, Quarto) hints at a future where JupyterLab is the IDE and the notebook format is a choice.

Ensuring extensions keep working as JupyterLab evolves is critical — the team has been [discussing extension compatibility testing](https://github.com/jupyterlab/frontends-team-compass/issues/301) at recent contributors calls.

For the [Marketplace](https://labextensions.dev?utm_source=blog&utm_medium=post&utm_campaign=700_extensions) itself, we're working on:

- **Deeper integration with JupyterLab Extension Manager** — deep links and "Install in JupyterLab" buttons to go from discovery to installation in one click.
- **Expanding Trove classifiers** to indicate Jupyter Notebook and JupyterLite support. All three use the same extension system, with important caveats: Notebook extensions need to target different UI elements, and JupyterLite extensions cannot have a server component.
- **Better contribution signals** — surfacing commits, PRs, and issues to help users gauge how actively maintained an extension is.

At 700 extensions, the community now shapes JupyterLab as much as the core team does. If you're building extensions, thank you! Every one of them makes Jupyter better for someone.
