---
title: "tinymo: building a tiny reactive notebook engine"
date: 2026-06-29
draft: false
summary: "I rebuilt marimo's reactive engine — static analysis, dependency graph, topological sort, scheduler, and reactivity — by hand, inside a live marimo notebook you can edit in the browser."
tags: ["marimo", "Python", "Reactive", "Notebooks", "AST", "Topological Sort"]
image: /img/tinymo-hero.png
---

How does a reactive notebook actually work? When you change one cell, how does it know which other cells to re-run — and in what order? To get a better idea, I built my own tiny engine from the first principles using only standard Python built-ins. 

And what a better way to demonstrate it than inside of an _actual_ marimo notebook! 

{{< marimo src="/notebooks/tinymo/" >}}

We build it in five chapters:

1. **Analyze** — pull each cell's defined and referenced variables out of its AST.
2. **Build the dependency graph** — connect references to the cells that define them.
3. **Topological sort** — Kahn's algorithm to find a valid execution order (and catch cycles).
4. **Scheduler** — `exec` the cells in order into a shared namespace.
5. **Reactivity** — when a cell changes, re-run it and everything downstream.

After each chapter there's a callout linking to where the same idea lives in real marimo's source, and how the real implementation differs from my toy one.
