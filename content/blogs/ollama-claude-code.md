---
title: Ollama Models in Claude Code
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
> 1. **[devstral-small-2](https://ollama.com/library/devstral-small-2) is the winner** - best quality, fastest, zero interventions
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
| Ollama | v0.14.0 |

### Configuration

Ollama docs outline how to set the endpoint, the key and a model. I prefer to continue using Bedrock API with Claude Code for most cases, but experiment with local models from time to time, so I created an alias for myself.

```bash
# Add to ~/.zshrc

alias claude-local='ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY=ollama CLAUDE_CODE_USE_BEDROCK=0 claude --model <model-name>'
```

## The 18 Models

Here's everything I tested, grouped by outcome:

### Winners (3)

| Model | Size | Result | Why |
|-------|------|--------|-----|
| **devstral-small-2:24b** ⭐ | 15GB | ✅ Best | Fastest, highest quality, zero interventions |
| **qwen3-coder:30b** | 18GB | ✅ Good | Reliable, adapted when tools failed |
| **granite4:32b-a9b-h** | ~20GB | ✅ OK | Fast but lazy - minimal exploration |

### Completed But Problematic (3)

| Model | Size | Result | Issue |
|-------|------|--------|-------|
| **qwen3:30b** | 18GB | ⚠️ Hallucinated | Zero tool calls, fabricated everything |
| **nemotron-3-nano:30b** | 24GB | ⚠️ Partial | Needed intervention to finish |
| **gpt-oss:20b** | 14GB | ⚠️ Low quality | Fast but unreliable output |

### Failed - Tool Issues (6)

| Model | Size | Failure Mode |
|-------|------|--------------|
| **mistral-small3.2:24b** | 15GB | Hallucinated wrong parameter names |
| **magistral:24b** | 14GB | Narrated tools in text, never invoked |
| **cogito:32b** | 20GB | Memory thrashing, context stall |
| **cogito:14b** | 9GB | Hallucinated non-existent tools |
| **command-r:35b** | 19GB | Nested parameters in wrong schema |
| **qwen2.5-coder:32b** | - | Stuck on Explore subagent |

### Failed - No Tool Support (2)

| Model | Issue |
|-------|-------|
| **deepseek-r1:32b** | [No tools in Ollama Anthropic API](https://github.com/ollama/ollama/issues/10935) |
| **deepseek-coder-v2:16b** | No tools in Ollama Anthropic API |

### Failed - Too Small (4)

| Model | Size | Behavior |
|-------|------|----------|
| **functiongemma:270m** | 301MB | Refuses everything |
| **granite4:3b** | 2.3GB | Hallucinates without tools |
| **phi4-mini:3.8b** | 2.5GB | Invents fake tool names |
| **rnj-1:8b** | 5.1GB | Silent - zero output |

## Test Methodology

I came up with a simple task: create CLAUDE.md instructions using the `/init` command, which is usually the first thing I do in a new repo. It's a good test because the model has to figure out what tools exist, explore multiple files, recognize patterns like build systems and frameworks, and synthesize it all into documentation without making things up.

The repo I used was `jupyterlab-latex`, already cloned to my machine.

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

The output was 180 lines of documentation with actual function names, Python config examples, and a 5-step communication flow diagram. Every file reference checked out - no hallucinations.

Why did devstral outperform? Mistral trained it specifically for SWE-Bench (65.8% score) and tool-use scenarios. You can see it in the tool calls - direct and confident, no subagent confusion.

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

```
"Let me use the Glob tool to find these patterns:

```bash
Glob pattern: **/README.md
Glob pattern: .github/readme*
...
```

Now that I have the relevant files, let's analyze..."
```

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

But then it just... stopped. Said "Let me start with writing the overview section first" and ended without writing anything. Even nudging with "continue" didn't help - completely stuck.

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

## Results Summary

| Model | Completed | Quality | Hallucinations | Time | Interventions |
|-------|-----------|---------|----------------|------|---------------|
| **devstral-small-2** | ✅ Yes | Excellent | None | 17 min | 0 |
| qwen3-coder | ✅ Yes | Good | None | 24 min | 0 |
| granite4:32b | ✅ Yes | Good | Minor* | ~7 min | 0 |
| qwen3:30b | ⚠️ Technically | Poor | **Everything** | ~5 min | 0 |
| nemotron-3-nano | ⚠️ Partial | Mixed | Yes (attempt 1) | - | 1+ |
| gpt-oss:20b | ✅ Yes | Low | No | ~3 min | 1 |
| qwen2.5-coder:32b | ❌ No | - | - | - | Stuck on Explore |
| mistral-small3.2:24b | ❌ No | - | Tool params | - | Wrong tool schema |
| magistral:24b | ❌ No | - | - | - | Narrated tools |
| cogito:32b | ❌ No | - | - | - | Memory/context issues |
| cogito:14b | ❌ No | - | Tools | ~8 min | Hallucinated WebSearch |
| command-r:35b | ❌ No | - | - | 7-10 min | Nested tool params |

*granite4:32b referenced files it never verified existed

**Winner: devstral-small-2** - Fastest, highest quality output, zero interventions, and smallest memory footprint among successful models.

### Failure Mode Taxonomy

Testing revealed distinct ways models fail at agentic tasks:

| Failure Mode | Example | Cause |
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

## What I Discovered Along the Way

These are things I didn't know going in - I figured them out by watching models fail.

### Context Window: The Silent Killer

**Ollama defaults to 4K context, regardless of what model cards advertise (128K, 256K, 1M).**

My first two models (nemotron, gpt-oss) failed mysteriously until I discovered this. Claude Code's system prompts are large - they overflow 4K and cause models to "forget" the task or hallucinate.

**Fix:** Drag Ollama's "Context length" slider to 64K or higher (Settings panel).

![Ollama settings showing context length slider](/img/ollama-context-setting.png)

I tested devstral-small-2 at different context sizes to find the minimum:

| Context | Result | What Happened |
|---------|--------|---------------|
| 4-16K | ❌ Failed | Zero tool calls - context overflow |
| 32K | ⚠️ Hallucinated | Started correctly, then invented a bug to fix |
| 64K | ✅ Works | Completed task (tried extra work after) |
| 128K | ✅ Works | Clean completion |

**64K is the minimum.** The 32K failure is insidious - the model has *just enough* context to start acting, but loses track mid-execution and hallucinates.

### The 15-20GB Sweet Spot

After all the testing, a pattern emerged for my 48GB machine:

| Model Size | Fits? | Reality |
|------------|-------|---------|
| <10GB (7-14B) | ✅ | Too weak for complex tasks |
| **15-20GB (24-32B)** | ✅ | **Best tradeoff** |
| 25-40GB (40-70B) | ⚠️ | Context limited, swapping risk |
| >40GB (70B+) | ❌ | Need 64GB+ RAM |

devstral-small-2 at 15GB hits this perfectly - leaves room for 128K context + OS + IDE without memory pressure.

### Small Models Just Can't

Models under ~15B parameters lack the reasoning to drive agentic tools. They either:
- **Refuse** (functiongemma) - too conservative, confused by prompts
- **Hallucinate content** (granite4:3b) - skip tools, fabricate everything
- **Hallucinate tools** (phi4-mini) - invent non-existent tool names
- **Go silent** (rnj-1:8b) - zero output

Function calling skill without general reasoning is useless for agentic work.

## Conclusions

Local models can do real agentic work now. devstral-small-2 completed the task reliably, with no hand-holding. It's slower than cloud (17 min vs 2 min), but it runs on my laptop with no API calls.

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

### Recommendation

If you want to try local models with Claude Code today:

**Quick setup (GUI method):**
1. Install Ollama 0.14.0+
2. Open Ollama settings → drag "Context length" slider to 64K
3. `ollama pull devstral-small-2`
4. Add alias to `~/.zshrc`:
```bash
alias claude-local='ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY=ollama CLAUDE_CODE_USE_BEDROCK=0 claude --model devstral-small-2'
```
5. `source ~/.zshrc && claude-local`

**Alternative (Modelfile method)** - for per-model control:
```bash
# 1. Install Ollama 0.14.0+

# 2. Pull and configure devstral-small-2
ollama pull devstral-small-2
echo 'FROM devstral-small-2
PARAMETER num_ctx 65536' | ollama create devstral-64k -f -

# 3. Add alias
echo "alias claude-local='ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY=ollama CLAUDE_CODE_USE_BEDROCK=0 claude --model devstral-64k'" >> ~/.zshrc

# 4. Use it
source ~/.zshrc
claude-local
```