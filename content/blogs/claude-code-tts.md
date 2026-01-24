---
title: Adding Voice to Claude Code (with Audio Ducking)
date: 2026-01-23
draft: false
summary: "Text-to-speech for Claude Code that automatically lowers your music when it speaks - like Google Maps in CarPlay."
tags: ["Claude Code", "TTS", "macOS", "Kokoro"]
---

## Claude Code Can Talk

I spend a lot of time in Claude Code. Reading responses while coding is fine, but sometimes I want to hear what Claude is saying while I'm looking at something else.

[claude-code-tts](https://git.sr.ht/~cg/claude-code-tts) by Chris Goff does exactly this. It uses [Kokoro TTS](https://github.com/nazdridoy/kokoro-tts), a fast local text-to-speech model, to read Claude's responses aloud. Hooks into Claude Code's event system - when Claude finishes responding, it extracts the text and speaks it.

**Note:** The upstream project uses `tac` (GNU coreutils) which doesn't exist on macOS. My fork replaces it with `tail -r`.

<video width="100%" controls>
  <source src="/videos/claude-code-tts.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## Audio Ducking

With TTS working, I had a new problem: I like music while coding. Claude talking over music is hard to hear.

CarPlay solved this with audio ducking - when navigation speaks, music volume drops, then comes back. I added this for Claude Code TTS.

The implementation controls Apple Music directly via AppleScript:

```bash
# Duck to 5% before TTS starts
osascript -e "tell application \"Music\" to set sound volume to 5"

# Restore when TTS finishes
osascript -e "tell application \"Music\" to set sound volume to $original"
```

Only Apple Music's internal volume changes - system volume stays the same, so TTS plays at full volume while music is ducked. A background process monitors when TTS finishes and restores the volume automatically.

## Configuration

Set in `~/.claude/settings.json`:

| Variable | Default | Description |
|----------|---------|-------------|
| `KOKORO_VOICE` | `af_sky` | [Voice to use](https://huggingface.co/hexgrad/Kokoro-82M/blob/main/VOICES.md) |
| `AUDIO_DUCK_ENABLED` | `true` | Set to `false` to disable ducking |
| `DUCK_LEVEL` | `5` | Percentage of original volume during TTS |

## Try It

My fork with audio ducking: [github.com/ktaletsk/claude-code-tts](https://github.com/ktaletsk/claude-code-tts)

Original: [git.sr.ht/~cg/claude-code-tts](https://git.sr.ht/~cg/claude-code-tts)

```bash
git clone https://github.com/ktaletsk/claude-code-tts
cd claude-code-tts
./install.sh
```

Now I can code, listen to music, and hear Claude - all without fighting for audio space.
