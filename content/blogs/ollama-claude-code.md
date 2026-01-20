---
title: Which local models actually work with Claude Code on a 48GB MacBook Pro?
date: 2026-01-15
draft: false
summary: "A little experiment evaluating local models for agentic tasks in Claude Code"
tags: ["Claude Code", "Ollama", "Local models", "qwen", "devstral"]
image: /img/ollama-claude-code-hero.png
---

![Claude Code running with devstral-128k via Ollama](/img/ollama-claude-code-hero.png)

## I Tested 18 Local Models So You Don't Have To

Ollama [released](https://github.com/ollama/ollama/releases/tag/v0.14.0) Anthropic API compatibility in January 2026, so I tested **18 local models** with Claude Code to find out which ones actually work for agentic coding tasks.

> **TL;DR**
> 1. [`devstral-small-2:24b`](https://ollama.com/library/devstral-small-2) is the winner - best quality, fastest, zero interventions
> 2. **You MUST configure context window** - Ollama defaults to 4K; use 64K minimum
> 3. **Expect 12-24 min for tasks that take ~2 min with Opus 4.5** - but it works!

- Ollama docs: https://docs.ollama.com/integrations/claude-code
- Anthropic API compatibility: https://docs.ollama.com/api/anthropic-compatibility

## My Setup

| Spec | Value |
| ------- | -------------------- |
| Machine | MacBook Pro |
| Chip | Apple M4 Pro |
| RAM | 48 GB unified memory |
| Ollama | v0.14.2 |

## Models

Here's everything I tested, sorted by size:

| Model | Size | Release | SWE-bench | Type |
|-------|------|---------|-----------|------|
| nemotron-3-nano:30b | 24GB | Dec 2025 | - | MoE |
| cogito:32b | 20GB | Jul 2025 | - | Hybrid reasoning |
| granite4:32b-a9b-h | ~20GB | Oct 2025 | - | General-purpose |
| command-r:35b | 19GB | Mar 2024 | - | RAG-optimized |
| qwen2.5-coder:32b | 19GB | Nov 2024 | 9.0% | Coding |
| deepseek-r1:32b | 19GB | Jan 2025 | 41.4% | Reasoning |
| qwen3-coder:30b | 18GB | Jul 2025 | 51.6% | Coding |
| qwen3:30b | 18GB | Apr 2025 | - | General-purpose |
| devstral-small-2:24b | 15GB | Dec 2025 | 68.0% | Agentic coding |
| mistral-small3.2:24b | 15GB | Jun 2025 | - | General-purpose |
| magistral:24b | 14GB | Jun 2025 | - | Reasoning |
| gpt-oss:20b | 14GB | Aug 2025 | - | General-purpose |
| cogito:14b | 9GB | Jul 2025 | - | Hybrid reasoning |
| deepseek-coder-v2:16b | 8.9GB | Jun 2024 | - | Coding (no tools) |
| rnj-1:8b | 5.1GB | Dec 2025 | 20.8% | General-purpose |
| phi4-mini:3.8b | 2.5GB | Feb 2025 | - | General-purpose |
| granite4:3b | 2.1GB | Oct 2025 | - | General-purpose |
| functiongemma:270m | 301MB | Dec 2025 | - | Function calling |

## Experiments

I chose a very simple task: run `/init` on a repo (`jupyterlab-latex`) to generate CLAUDE.md, which is normally the first thing I do in a new repo. It's deceptively hard though - the model has to discover tools, explore multiple files, and synthesize documentation without hallucinating. One or two runs per model; treat results as field notes.

My first two models (nemotron, gpt-oss) used Ollama's default context window - which is how I discovered the 4K limit issue. After that, I set context to 64K+ in Ollama's settings.

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

The output was 180 lines of documentation with actual function names, Python config examples, and a 5-step communication flow diagram. Every file reference checked out - no hallucinations.

Why did devstral outperform? Mistral trained it specifically for SWE-Bench (68.0% score) and tool-use scenarios. You can see it in the tool calls - direct and confident, no subagent confusion.

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

### `granite4:32b-a9b-h`

An interesting comparison point - this is IBM's general-purpose 32B model, not a coding specialist. With 128K context configured, it completed the task in **under 7 minutes** - the fastest successful run.

The trade-off: minimal exploration. Tool sequence:
```
Read → Write
```

Just two tool calls - read the README, write CLAUDE.md. No codebase exploration, no package.json check, no architecture analysis. The output was decent:
- ✅ Correct project type (JupyterLab LaTeX extension)
- ✅ Correct commands (`jlpm run build`, `jlpm run watch`)
- ✅ Mermaid architecture diagram
- ⚠️ Some hallucinated details (referenced `src/components/Toolbar.tsx` without verifying it exists)

At 32K context, it stalled - started correctly (Glob → Read), but got stuck after reading files and never produced output. A different failure mode than devstral's 32K hallucination.

**Verdict:** Works, but lazy. General-purpose models can complete agentic tasks but tend to "wing it" with minimal tool use, while coding specialists explore more thoroughly.

```
Sautéed for ~7m
```

### `qwen3:30b`

The general-purpose Qwen3 (not the coder variant). This was the worst performer - **pure hallucination with zero exploration**.

Tool sequence:
```
Write
```

Just one tool call. The thinking block is revealing - it explicitly acknowledged it couldn't see files but proceeded anyway:

> *"Since I can't actually see the files, I'll have to rely on the context provided."*

It inferred file structure from git status in the system prompt, then fabricated everything:
- ❌ `python jupyterlab_latex/build.py` - wrong command (should be `jlpm run build`)
- ❌ `latex_cleanup.py` - fabricated filename
- ❌ `flake8` - assumed linter without checking

At 128K context, it consumed **31GB RAM** (vs 18GB on disk) - pushing my 48GB system into swap. The memory pressure may have contributed to its laziness, but the thinking block shows it consciously chose to guess rather than explore.

**Key finding:** The coder fine-tuning isn't just about coding knowledge - it teaches the model to actually use tools instead of guessing. qwen3-coder explored properly; qwen3 base hallucinated everything.

```
Sautéed for ~5m
```

### `qwen2.5-coder:32b`

**Failed.** Despite having 128K context configured, through multiple attempts it kept reaching for the `Explore` subagent tool and then abruptly stopping without completing any work. Unlike qwen3-coder which recovered when Explore failed, qwen2.5-coder couldn't adapt. Same model family, different generation, completely different behavior when things go wrong.

### `mistral-small3.2:24b`

**Failed - hallucinated tool parameters.** This model understands it should use tools but invents wrong parameter schemas. From the session trace, it tried to call the Task tool with made-up parameters:

```json
// Attempt 1:
{"instruction": "...", "max_depth": 100}

// Attempt 2:
{"subagent_name": "Explore", "subagent_type": "Explore", "subagent_prompt": "..."}
```

The actual required parameters are `description` and `prompt`. When it received clear error messages explaining this, it simply repeated "I'm going to use the Task tool..." and stopped - unable to self-correct.

This is a different failure mode than hallucinating content (qwen3) or refusing (functiongemma). The model has learned *about* tools but not the actual invocation format. Worth noting: devstral-small-2 is also a Mistral model and works perfectly - the difference is devstral's agentic specialization.

**Memory:** 37GB loaded at 128K context (vs 15GB on disk).

### `magistral:24b`

**Failed - narrated tools instead of invoking them.** This new Mistral reasoning model understood the task and knew which tools to use, but wrote out tool calls as text instead of actually executing them:

~~~
"Let me use the Glob tool to find these patterns:

```bash
Glob pattern: **/README.md
Glob pattern: .github/readme*
...
```

Now that I have the relevant files, let's analyze..."
~~~

Zero actual tool calls were made. The model described what it *would* do, assumed the tools had run, and proceeded to the next step. This suggests training on tool documentation without actual tool-use interactions.

**Memory:** 23GB loaded at 128K context (vs 14GB on disk).

**Native context limitation:** magistral's native context is only 39K. Even with Ollama allocating 128K, the model may not effectively use context beyond its training limit - which could explain why it never received the tool invocation format.

### `cogito:32b`

**Failed - memory issues and context-limited stall.** This hybrid reasoning model has different failure modes depending on context configuration:

**At 128K context:** Loaded 64GB into memory (41% CPU / 59% GPU split). On my 48GB system, this caused severe memory thrashing - spiky memory pressure, swap usage, and zero tokens produced after 5+ minutes.

**At 64K context:** Loaded 42GB (8% CPU / 92% GPU). Still tight but runnable. Same stalling behavior.

**At 32K context:** Loaded 30GB (100% GPU). Actually started working! Made correct Glob and Read calls, explored the codebase properly:

```
Glob → Read README.md → "Let me create a todo list..."
```

But then it just... stopped. Said "Let me start with writing the overview section first" and ended without writing anything. Even nudging with "continue" prompt didn't help - completely stuck.

This is the same pattern as granite4:32b at 32K context: can explore but can't complete. **32K context is insufficient for task completion** - the model loses track of the goal mid-execution.

### `cogito:14b`

**Failed - multiple tool issues.** Testing the smaller cogito variant to see if the 7-15B range had any surprises. It did, but not good ones.

**Memory:** Even at 9GB on disk, loaded 45GB at 128K context with 15% CPU offload. At 64K context it was more manageable.

Tool sequence shows multiple failure modes:
```
Read README.md ✅ → Read copilot-instructions.md ✅ (not found) →
WebSearch ❌ (hallucinated) → TodoWrite ❌ (wrong params, twice) →
Printed CLAUDE.md as text ⚠️
```

1. **Hallucinated `WebSearch`** - tool doesn't exist in Claude Code, got empty results
2. **Wrong TodoWrite params** - missing required `activeForm` field, tried twice without learning
3. **Never used Write tool** - just printed the CLAUDE.md content as markdown text instead of writing to file

The generated content was actually reasonable - correct commands, accurate architecture. But the model "completed" the task by printing output rather than writing the file. It understood the goal but couldn't execute properly.

**Time:** ~7.7 minutes

The cogito family (both 32b and 14b) consistently fails with Claude Code's tool schemas - different sizes, different failure modes, same outcome.

### `command-r:35b`

**Failed - nested tool parameter schema.** The last untested model in the viable 15-35B range. At 128K context it didn't fit on my GPU. At 64K and 32K it loaded but failed with the same tool schema issue.

From the trace, the model wrapped all tool parameters in a nested structure:

```json
{
  "tool_name": "Task",
  "parameters": {
    "description": "...",
    "prompt": "...",
    "subagent_type": "general-purpose"
  }
}
```

The correct format is flat parameters at the top level. It made 4 tool calls (3 Task, 1 TodoWrite) - all failed with validation errors like "required parameter `description` is missing" because the nesting caused parameters to be undefined at the expected level.

Unlike mistral-small3.2 which invented wrong parameter *names*, command-r uses the correct parameter names but wraps them incorrectly. When it received validation errors, it didn't retry - just output a text-based "Action Plan" and stopped.

This suggests Cohere's tool-calling format differs from the Anthropic API schema. The model was trained on a different tool invocation structure.

**Context comparison:**
- **32K**: 4 tool calls, all failed, gave up quickly (~7 min)
- **64K**: 29 tool calls, all failed, kept retrying same broken schema (~9.5 min)

More context didn't help - it just gave the model more runway to keep failing the same way. It never learned from the error messages.

## Results

### ✅ Worked

| Model | Quality | Time | Notes |
|-------|---------|------|-------|
| **devstral-small-2** ⭐ | Excellent | 17 min | No hallucinations, no interventions |
| qwen3-coder | Good | 24 min | Recovered after Explore failed |
| granite4:32b | Good | ~7 min | Fast but lazy, minor hallucinations* |

### ⚠️ Completed With Issues

| Model | Quality | Time | Issue |
|-------|---------|------|-------|
| gpt-oss:20b | Low | ~3 min | Needed intervention |
| nemotron-3-nano | Mixed | - | Hallucinated on first attempt |
| qwen3:30b | Poor | ~5 min | Zero tool calls, fabricated everything |

### ❌ Failed

| Model | Time | Failure Mode |
|-------|------|--------------|
| qwen2.5-coder:32b | - | Stuck on Explore subagent |
| mistral-small3.2:24b | - | Wrong tool parameter schema |
| magistral:24b | - | Narrated tools instead of invoking |
| cogito:32b | - | Memory thrashing, context stall |
| cogito:14b | ~8 min | Hallucinated WebSearch tool |
| command-r:35b | 7-10 min | Nested tool parameters |
| deepseek-r1:32b | - | No tool support in Ollama |
| deepseek-coder-v2:16b | - | No tool support in Ollama |
| functiongemma:270m | - | Refuses everything |
| granite4:3b | - | Hallucinates without tools |
| phi4-mini:3.8b | - | Invents fake tool names |
| rnj-1:8b | - | Silent, zero output |

*granite4:32b referenced files it never verified existed. It "works" in the sense that it completes the task and produces usable output, but you'd want to review it before trusting it. devstral and qwen3-coder are trustworthy out of the box.

**Winner: devstral-small-2** - best quality, smallest footprint, zero interventions.

### Model Outputs

Compare the actual CLAUDE.md files generated by each model. Use the tabs to switch between models, or click the side-by-side button to compare them directly:

{{< text-compare files="devstral-small-2,qwen3-coder,granite4-32b,nemotron-30b" height="600px" >}}

### Failure Modes

Testing revealed distinct ways models fail at agentic tasks:

| Failure Mode | Example | Probable Cause |
|--------------|---------|-------|
| **Refuses** | functiongemma | Too conservative, confused by system prompts |
| **Hallucinates content** | qwen3:30b, granite4:3b | Skips tools, fabricates output |
| **Hallucinates tools** | phi4-mini | Invents non-existent tool names |
| **Hallucinates params** | mistral-small3.2 | Knows tools exist, wrong schema |
| **Narrates tools** | magistral | Describes tools in text, never invokes |
| **Stuck on subagent** | qwen2.5-coder | Can't adapt when Explore fails |
| **Context stall** | cogito:32b, granite4@32K | Explores correctly, stops mid-task |
| **Nested params** | command-r | Wraps params in {"tool_name":X,"parameters":{...}} |
| **Silent** | rnj-1:8b | Zero output, can't process system prompts |

The more sophisticated failures (wrong params, narration, nested params) suggest models trained on different tool-calling formats or documentation rather than actual Anthropic API interactions. Native context window also matters - magistral (39K native) failed even with 128K allocated.

### How Local Models Compare to Cloud

SWE-bench Verified is what everyone uses to evaluate agentic coding - 500 real GitHub issues that models must solve. Here's how local models compare to cloud:

**Frontier Cloud Models (Proprietary)**

| Model | SWE-bench |
|-------|-----------|
| Gemini 3 Flash | 75-76% |
| Claude Opus 4.5 | 74-81% |
| GPT-5.2 | 72-75% |
| Claude Sonnet 4.5 | 70.6% |
| Claude Haiku 4.5 | 68.8% |

**Large Open Weights (Won't fit 48GB)**

| Model | SWE-bench | Size |
|-------|-----------|------|
| Devstral 2 | 72.2% | 123B |
| Qwen3-Coder-480B | 67% | 480B |
| DeepSeek-V3.1 | 66% | 671B |

**Local Models (Fits 48GB)**

| Model | SWE-bench | Result |
|-------|-----------|--------|
| **devstral-small-2** | **68.0%** | ⭐ Winner |
| qwen3-coder:30b | 51.6% | ✅ Good |
| deepseek-r1:32b | 41.4% | ❌ No tools |
| qwen2.5-coder:32b | 9.0% | ❌ Stuck |

**The gap is surprisingly small.** devstral-small-2 at 68% matches Claude Haiku 4.5 and trails Opus by only 6-8 points. A 24B model running locally keeps up with 100B+ models - turns out agentic training matters more than size.

SWE-bench score also predicts Claude Code success: models without published scores aren't coding-focused and failed my tests.

## Conclusions

Local models can do real agentic work now. devstral-small-2 completed the task reliably, with no hand-holding. It's slower than cloud (17 min vs 2 min), but it runs on my laptop completely offline.

### Key Takeaways

1. **devstral-small-2 wins** - best results, smallest footprint, built for this
2. **The gap is smaller than I expected** - 68% SWE-bench matches Haiku, trails Opus by 8 points
3. **Context window matters** - Ollama defaults to 4K; bump it to 64K or watch models hallucinate
4. **SWE-bench predicts success** - no published score usually means it won't work
5. **Speed hurts** - 17-24 minutes vs 2 minutes on cloud
6. **Check tool support first** - not all models work with Ollama's Anthropic API

### What Works

devstral-small-2 and qwen3-coder both work reliably. The tool calling infrastructure is solid when the model supports it. Ollama 0.14.0 makes setup easy - no more LiteLLM translation layer.

### What Doesn't Work (Yet)

Most models can't finish multi-step agentic tasks without help. Context overflow causes hallucinations (fabricated URLs, wrong repo names). And 8-12x slower than cloud is hard to ignore.

### Critical: Set Context to 64K+

Ollama defaults to 4K context regardless of what model cards advertise. Claude Code's system prompts overflow this, causing silent failures or hallucinations.

![Ollama settings showing context length slider](/img/ollama-context-setting.png)

| Context | Result |
|---------|--------|
| 4-16K | ❌ Zero tool calls |
| 32K | ⚠️ Starts fine, then hallucinates |
| 64K+ | ✅ Works |

### Quick Start

```bash
# 1. Install Ollama 0.14.0+ and pull devstral
ollama pull devstral-small-2

# 2. Set context to 64K in Ollama settings (GUI slider)

# 3. Add alias to ~/.zshrc
alias claude-local='ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY=ollama CLAUDE_CODE_USE_BEDROCK=0 claude --model devstral-small-2'

# 4. Run it
source ~/.zshrc
claude-local
```