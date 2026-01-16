---
title: Ollama Models in Claude Code
date: 2026-01-15
draft: true
summary: "A little experiment evaluating local models for agentic tasks in Claude Code"
tags: ["Claude Code", "Ollama", "Local models", "qwen", "devstral"]
---
## Intro

Ollama just [released](https://github.com/ollama/ollama/releases/tag/v0.14.0) Anthropic API compatibility (support for the `/v1/messages` API) in January 2026, so I decided to try local models in Claude Code.

In practice, this means Claude Code can talk to Ollama directly using the same **Anthropic-style Messages API** it expects. Before this, getting Claude Code to drive local models typically required a compatibility layer / router (e.g. LiteLLM) to translate between API shapes (OpenAI-style backends ↔ Anthropic `/v1/messages`).

- Ollama docs: https://docs.ollama.com/integrations/claude-code
- Anthropic API compatibility: https://docs.ollama.com/api/anthropic-compatibility

> **TL;DR**
> 1. **[devstral-small-2](https://ollama.com/library/devstral-small-2) is the winner** - best quality, fastest, zero interventions
> 2. **You MUST configure context window** - Ollama defaults to 4K, not the advertised 128K+
> 3. **Expect 17-24 min for tasks that take seconds on cloud** - but it works!

## My Setup

| Spec | Value |
| ------- | -------------------- |
| Machine | MacBook Pro |
| Chip | Apple M4 Pro |
| RAM | 48 GB unified memory |
| Ollama | v0.14.0 |

### Configuration

Ollama docs outline how to set the endpoint, the key and a model. I prefer to continue using Bedrock API with Claude Code for most cases, but experiment with local models from time to time, so I created an alias for myself.

```bash
# Add to ~/.zshrc

alias claude-local='ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY=ollama CLAUDE_CODE_USE_BEDROCK=0 claude --model <model-name>'
```

## Model Selection: Finding the Sweet Spot

With hundreds of models on Ollama, how do you pick the right ones? Here's my selection process:

### Hardware Constraints Define the Ceiling

On my 48GB M4 Pro, the math is straightforward:

- **Model weights** must fit in RAM
- **Context window overhead**: large context windows can require significant additional memory
- **OS and Ollama overhead** takes ~4-8GB
- **Practical ceiling**: ~35GB for model weights

This immediately ruled out flagship models (devstral-2:123b, qwen3-coder:480b) and pushed me toward the 20-32B parameter range.

### Selection Criteria

I filtered for models that met these requirements:

1. **Coding-specialized**: General-purpose models underperform on agentic coding tasks
2. **(Working) Tool calling support**: Required for Claude Code integration - eliminates [deepseek-r1](https://github.com/ollama/ollama/issues/10935), deepseek-coder-v2
3. **Large context advertised**: Models benefit from at least 128K to handle Claude Code's system prompts + codebase context
4. **Recent release**: Newer models benefit from advances in instruction following and tool use
5. **Agentic training**: Bonus points for SWE-Bench or agent-specific fine-tuning

### Critical Caveat: Context Window Configuration

**Ollama's advertised context window ≠ default context window!**

This might be very well known to long-time Ollama users, but the default context length is set to 4096 tokens, regardless of what model cards advertise (128K, 256K or 1M). Claude Code's large system prompts overflow this, causing models to "forget" the task or hallucinate.

**Fix:** Create custom Modelfiles with explicit `num_ctx`:

```bash
# Create Modelfile
echo 'FROM devstral-small-2
PARAMETER num_ctx 131072' > Modelfile.devstral-128k

# Build custom model
ollama create devstral-128k -f Modelfile.devstral-128k
```

### The Sweet Spot: 15-20GB Models

After testing, a clear pattern emerged:

| Model Size | Typical Params | Fits 48GB? | Performance |
|------------|---------------|------------|-------------|
| <10GB | 7-14B | ✅ Easily | Often too weak for complex tasks |
| **15-20GB** | **24-32B** | **✅ Comfortable** | **Best reliability/quality tradeoff** |
| 25-40GB | 40-70B | ⚠️ Tight | Context limited, swapping risk |
| >40GB | 70B+ | ❌ No | Requires 64GB+ or enterprise hardware |

The 15-20GB sweet spot leaves enough headroom for:

- 128K context window
- System stability without memory pressure
- Background processes and IDE

**devstral-small-2 (15GB)** hits this sweet spot perfectly - it's the largest model I tested that ran comfortably while still delivering excellent results.

### Models That Didn't Work

| Model | Issue |
|-------|-------|
| qwen2.5-coder:32b | Stuck on Explore subagent, can't adapt |
| deepseek-r1:32b | No tool support in Ollama Anthropic API |
| deepseek-coder-v2:16b | No tool support in Ollama Anthropic API |

## Models Tested

| Model | Size | Context | Notes |
|-------|------|---------|-------|
| **devstral-small-2:24b** | 15GB | 384K | Built for agentic coding, 65.8% SWE-Bench |
| **qwen3-coder:30b** | 18GB | 256K | SWE-Bench RL trained |
| **nemotron-3-nano:30b** | 24GB | 1M | MoE, 3.5B active params |
| **gpt-oss:20b** | 14GB | 128K | Needs larger context config |

## Test Methodology

I came up with a very simple task: create CLAUDE.md instructions using the `/init` command, which is usually the first thing I do in a new repo. This tests:

- Tool discovery and selection
- Multi-file codebase exploration
- Pattern recognition (build systems, frameworks)
- Documentation synthesis
- Hallucination resistance

The particular repo that I used was `jupyterlab-latex` which was already cloned to my machine.

This post is intentionally anecdotal: I only did a single-digit number of runs per model and didn't try to control for prompt wording, run-to-run variance, or toolchain versions. I'm planning to publish this as a very dumb benchmark later, but for now treat the timings and rankings as "field notes", not a rigorous eval.

## Experiments

The first two models I tested (nemotron, gpt-oss) used Ollama's default context window - which is how I discovered the critical 4K limit issue. For subsequent models, I created custom Modelfiles with 128K context from the start.

### `nemotron-3-nano:30b`

My first attempt revealed a critical failure mode. With the default context window, the model's thinking block explicitly shows it decided to skip reading files entirely:

> *"We don't have details of repo... There haven't been any reads yet... Let's assume typical repo structure"*

Instead of using tools to explore, it **fabricated an entire codebase structure**. The output described a React/Node.js monorepo with `/frontend` and `/backend` directories - neither of which exist in jupyterlab-latex (a Python/TypeScript JupyterLab extension). It invented commands like `npm run dev` and referenced non-existent config files.

This failure led me to discover Ollama's default 4K context limit. After configuring a 128K context window, subsequent attempts worked much better:
```
Read → Glob → Read → Read → Read → Read → Glob → Read → Write
```

The model properly explored the codebase, but still stopped mid-task and required a follow-up prompt ("Continue") to finish. Final output was accurate and high quality - proving the model *can* work, but context configuration is critical.

### `gpt-oss:20b`

Also tested early with the default context window. Fast but unreliable:
- Direct prompt: Finished quickly but low quality output
- `/init` skill: Tool parameter errors, empty results, needed intervention

```
Sautéed for 2m 37s  (Claude Code's task timer)
```

### `devstral-small-2:24b` ⭐ Winner

With 128K context configured from the start, this was a **perfect run**. The model immediately understood the task:

> "I'll analyze this codebase and create a CLAUDE.md file with the essential information for future instances."

Tool call sequence shows direct, confident tool usage:
```
Bash → Bash → Bash → Read → Bash → Bash → Bash → Read → Read → Read → Bash → Write
```

No confusion about subagents or tool parameters - it went straight for `Bash` and `Read` to explore the codebase, then used `Write` to create the output.

Output quality was excellent:
- 180 lines of well-structured documentation
- Detailed architecture breakdown with specific function names
- Configuration examples with Python code snippets
- Communication flow diagram (5-step process)
- No hallucinations - every file reference was accurate

Why did devstral outperform? Likely its purpose-built agentic training - Mistral specifically optimized it for SWE-Bench (65.8% score) and tool-use scenarios, rather than general coding assistance. This shows in its confident, direct tool usage without the subagent confusion that plagued other models.

```
Sautéed for 17m 12s
```

### `qwen3-coder:30b`

Also configured with 128K context. The model's first instinct was to delegate to a subagent. From the session trace, it tried to spawn an Explore agent twice:

```json
{
  "description": "Explore codebase structure",
  "prompt": "Explore the structure of this JupyterLab LaTeX extension repository...",
  "subagent_type": "Explore"
}
```

This isn't an Ollama bug, but a mismatch between **what Claude Code can do in a given environment** and **what the model decides to attempt**. Claude Code has a notion of subagents (like an "Explore" helper), but in my setup those weren't available/configured, so that tool call fails. Ollama's docs do advertise Claude Code usage, though, so it's worth calling out explicitly: with third-party models, you should expect occasional "tooling weirdness" like this even if the transport API is compatible.

When the Task tool failed (subagents weren't configured), qwen3-coder adapted gracefully. Tool sequence shows the recovery:
```
Task → Task → Bash → Read → Read → Read → Read → Read → Read → Read → Read → Write
```

After two failed Explore attempts, it switched to direct `Bash` and `Read` tools and completed the task without further intervention. Output quality was good - accurate, no hallucinations, but less detailed than devstral (86 lines vs 180).

```
Sautéed for 23m 48s
```

### `qwen2.5-coder:32b`

**Failed.** Despite having 128K context configured, through multiple attempts it kept reaching for the `Explore` subagent tool and then abruptly stopping without completing any work. Unlike qwen3-coder which recovered when Explore failed, qwen2.5-coder couldn't adapt. This contrast highlights a meaningful difference in instruction-following robustness between the two model generations.

## Results Summary

| Model | Completed | Quality | Hallucinations | Time | Interventions |
|-------|-----------|---------|----------------|------|---------------|
| **devstral-small-2** | ✅ Yes | Excellent | None | 17 min | 0 |
| qwen3-coder | ✅ Yes | Good | None | 24 min | 0 |
| nemotron-3-nano | ⚠️ Partial | Mixed | Yes (attempt 1) | - | 1+ |
| gpt-oss:20b | ✅ Yes | Low | No | ~3 min | 1 |
| qwen2.5-coder:32b | ❌ No | - | - | - | Stuck on Explore |

**Winner: devstral-small-2** - Fastest, highest quality output, zero interventions, and smallest memory footprint among successful models.

### devstral-small-2 vs qwen3-coder

| Aspect | devstral-small-2 | qwen3-coder |
|--------|------------------|-------------|
| **Output Lines** | 180 | 86 |
| **Time** | 17 min | 24 min |
| **RAM Usage** | 15GB | 18GB |
| **Architecture depth** | Detailed (functions, handlers) | High-level |
| **Config examples** | Python code snippets | File references only |
| **Tool confusion** | None | Tried Explore first |

### Model Outputs

Compare the actual CLAUDE.md files generated by each model. Use the tabs to switch between models, or click the side-by-side button to compare them directly:

{{< text-compare files="devstral-small-2,qwen3-coder,nemotron-30b" height="600px" >}}

## Conclusions

We are getting the first glimpse of what local models can achieve in agentic tools on local machines. The promise of privacy, low cost and freedom of choice is very compelling. **devstral-small-2 proves that local models can now complete agentic coding tasks reliably** - though still orders of magnitude slower than frontier cloud models.

### Key Takeaways

1. **devstral-small-2 is the current best choice** - Purpose-built for agentic coding, smallest footprint, best results
2. **Context window is critical** - Must create custom Modelfiles with large `num_ctx` or models fail silently
3. **Tool confusion is common** - Many models try to use subagents (Explore) instead of direct tools
4. **Speed is painful** - 17-24 minutes for a simple task vs seconds with Claude
5. **Check tool support first** - Not all models support function calling in Ollama's Anthropic API

### What Works

- **devstral-small-2**: fastest, best quality, zero interventions
- **qwen3-coder**: reliable backup option
- Tool calling infrastructure works when model supports it
- Ollama 0.14.0's Anthropic API compatibility makes setup easy

### What Doesn't Work (Yet)

- Models hallucinate when context overflows (fabricated URLs, wrong repo names)
- Many models fail to complete multi-step agentic tasks without intervention
- Performance is 100x+ slower than cloud models

### Recommendation

If you want to try local models with Claude Code today:

```bash
# 1. Install Ollama 0.14.0+

# 2. Pull and configure devstral-small-2
ollama pull devstral-small-2
echo 'FROM devstral-small-2
PARAMETER num_ctx 131072' | ollama create devstral-128k -f -

# 3. Add alias
echo "alias claude-local='ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY=ollama CLAUDE_CODE_USE_BEDROCK=0 claude --model devstral-128k'" >> ~/.zshrc

# 4. Use it
source ~/.zshrc
claude-local
```

I'm curious about hybrid approaches - could local and cloud models work together? Imagine local models handling file exploration and codebase indexing, while cloud models tackle complex reasoning and synthesis. The speed gap might close faster than we think.

### A Concrete Hybrid Workflow

One workflow I'd like to try:

- Local model: do the "mechanical" work (enumerate repo, run ripgrep searches, open relevant files, summarize each file/function into short notes, capture build/test commands)
- Local model: produce a compact "context pack" (file tree + key excerpts + a dependency/config summary + open questions)
- Cloud model: use the context pack to do the expensive thinking (design decisions, refactors, writing patches, producing polished docs)
- Cloud model: hand back a minimal file list / patch plan
- Local model: execute the plan with tools and iterate, only escalating back to cloud when reasoning gets stuck