---
title: "Skills Hub: Building an Enterprise Trust Layer for AI Agent Skills"
date: 2026-02-21
draft: false
summary: "How our team won Judges' Recognition at Anaconda's CKO 2026 hackathon in Portugal by building an enterprise trust layer for AI agent skills."
tags: ["Anaconda", "Agent Skills", "AI Governance", "Hackathon", "Python", "Conda"]
video: "/videos/skills-hub-demo.mp4"
image: "/img/skills-hub-thumb.jpeg"
---

*How our team won Judges' Recognition at Anaconda's CKO 2026 hackathon in Portugal*

## The setup

Every year, Anaconda brings the entire company together for CKO — part all-hands, part hackathon, part team building. This year it was in Portugal. The hackathon gives teams three days to build something from scratch, and this year I joined a team of eight to tackle a problem I'd been thinking about for months.

![The CKO 2026 venue — round tables, green-lit stage, and the whole company together in Portugal](/img/IMG_4936.jpeg)

![The hackathon structure: three days, three paths to glory](/img/IMG_4935.jpeg)

## The problem: AI assistants don't know your rules

Here's a scene that plays out a hundred times a day across the Python ecosystem: you open Claude Code in a project that has a perfectly good conda environment set up. You ask it to run the tests. And it fires off `pytest` with whatever system Python it finds first. No environment activation. No awareness that conda exists.

I know this scene well because I've lived it. The non-interactive shell that AI coding assistants spawn doesn't load your shell config, so `conda activate` fails with the unhelpful "Run 'conda init' first" error. I built a skill called snakehug to solve this — it teaches AI assistants the correct activation patterns for conda, mamba, and pixi, asks you which environment to use once, then remembers it for every future session.

But snakehug solving *my* problem on *my* machine is different from solving it for a team, a department, or an enterprise. That's the gap we went after.

## The bigger picture: a supply chain problem for AI behaviors

In December 2025, Anthropic released the Agent Skills (SKILL.md) open standard. Within eight weeks, 40+ major platforms adopted it — OpenAI Codex, GitHub Copilot, Cursor, Gemini CLI, Windsurf. The anthropics/skills repo hit 66,800 GitHub stars. Skills are simple by design: a directory with a SKILL.md file containing YAML frontmatter and markdown instructions.

The simplicity is the point — and the problem. The standard deliberately omits versioning, dependency resolution, signing, and sandboxing. Third-party marketplaces have appeared claiming 160,000+ skills, but these are mostly auto-indexed GitHub repos with no curation. Aikido Security recently found hallucinated npx commands spreading through hundreds of repos via unvetted skills.

This is essentially the npm supply chain attack, but for instructions that can execute arbitrary code on your machine. The ecosystem has the same shape as early package management: lots of content, no trust infrastructure.

## What we built: Skills Hub

Our hackathon project was Skills Hub — an enterprise trust layer for agent skills. The framing that clicked for us was: "Package Security Manager, but for AI behaviors." Anaconda already provides the trust layer between open-source packages and enterprise environments. Skills need the same thing.

In three days, the team shipped four components:

**A backend API** that stores, validates, and serves skills. Every skill goes through frontmatter validation before it's published. Skills are categorized by trust level — Anaconda-curated, company internal, and external — so security teams can control what reaches developers.

**A CLI extension** (`anaconda skills`) that plugs into the existing Anaconda CLI. Upload, list, install, and inspect skills with commands that feel familiar to anyone who's used `conda`. Authentication flows through the same `anaconda-auth` infrastructure that enterprises already trust.

**A web frontend** with a catalog UI showing skills organized by trust level with color-coded badges, search, filtering, and upload capabilities.

**An Anaconda Desktop integration** using the new Feature Modules system — a native sidebar panel that lets you browse and install skills without leaving the desktop app. This was my contribution, and dogfooding the new module system was a great way to put it through its paces.

## The demo that won it

For the hackathon presentation, we structured the demo as a before-and-after. I opened with one line of Portuguese ("Olá! Eu sou Konstantin... e o meu português acaba aqui"), then cut straight to the problem.

**Before:** A screen recording of Claude Code in a project with a conda environment. I ask it to run the tests. It uses bare `pytest` with system Python. No conda awareness. The environment is completely ignored.

**After:** Same project, same prompt, but now with snakehug installed. Claude Code detects conda, asks which environment to use, activates it correctly, and the tests pass. One SKILL.md file — completely different behavior.

Then the pivot: "But how does this skill reach every developer on your team safely?" Cut to the CLI uploading snakehug to Skills Hub, then to the web UI showing it in the catalog with trust badges and validated metadata, and finally a flash of the Desktop integration.

The whole thing ran just under two minutes. The judges gave us Judges' Recognition (honorable mention), which we were very happy with given the quality of the other projects.

![At the CKO 2026 stage](/img/IMG_4940.jpeg)

## How we built it: AI-assisted spec-driven development

The meta-story of the hackathon was almost as interesting as the project itself. We built the entire thing using AI-driven spec-driven development with open-source tools — primarily OpenCode and SpecKit.

![Early brainstorming — the whiteboard where Skills Hub took shape](/img/IMG_4939.jpeg)

The approach: before writing any code, you write a spec. The spec directory contains a formal specification, research notes, a data model, an implementation plan, and a task breakdown. Then the AI coding assistant implements against that spec. Each feature lived on a dedicated branch matching its spec number, with PRs reviewed and merged to main.

The backend accumulated 45 commits across 12 branches and 8 spec directories. The CLI had 21 commits across 5 branches and 6 spec directories. For three days of work, that's a remarkable amount of structured, traceable output. The specs serve double duty — they're the design documents *and* the context that makes AI assistance effective.

This isn't just an interesting development methodology. It's directly relevant to the enterprise story: if your team is going to use AI coding tools, you want reproducibility, auditability, and a paper trail. Spec-driven development gives you that.

## The skill I contributed: snakehug

Snakehug started as a personal itch — I was tired of Claude Code ignoring my conda environments. The core insight is that AI assistants spawn non-interactive shells, which don't load your shell config. So `conda activate` fails, and the assistant falls back to whatever Python is on the system PATH.

The skill works in three phases:

1. **First run:** Detect which environment managers are installed (conda, mamba, micromamba, pixi), ask the user which environment to use, test that activation actually works
2. **Save config:** Write the complete working activation command to the project's `CLAUDE.md`
3. **Future runs:** Automatically use the saved pattern — no prompting, no detection, just correct behavior

The key design decision was saving the *complete activation command* that works in a fresh shell, not just the environment name. Different managers need different invocation patterns (`source conda.sh && conda run` vs. `eval "$(mamba shell hook)"` vs. `pixi run`), and getting this wrong silently is worse than failing loudly.

For the hackathon, I refactored snakehug to the single SKILL.md format for compatibility with the Skills Hub API, and we used it as the flagship demo skill.

## What's next (and what didn't make the demo)

The piece we deliberately left out of the two-minute demo is skill-gen — a 12-phase pipeline that generates validated SKILL.md files from your team's real agent conversation logs. The idea is that instead of manually writing skills, you extract them from patterns in how your developers actually correct their AI assistants. More usage → more traces → better skills. Nobody else in the ecosystem is doing this.

We mentioned it as a teaser in the closing ("what we didn't show today") and it landed well as a "one more thing" during Q&A.

Whether Skills Hub becomes an Anaconda product is above my pay grade. But the gap is real: enterprises need a trust layer between the wild west of community skills and the developers who use them. Someone is going to build it. I'm glad we got to prototype what it could look like.

## Thanks

![Part of the Skills Hub team at CKO 2026](/img/IMG_4994.jpeg)

This was a genuine team effort. Anil Kulkarni led the project and kept us focused. Albert DeFusco built the backend and CLI infrastructure. Denis Dupeyron contributed the upload pipeline and source type system. Max Huang built the skill-gen pipeline. Anna Ratner designed the UI. Arisha Mays implemented it. And we had a great time in Portugal.

Oh, and we made a fado song about Skills Hub. Because when in Portugal.
