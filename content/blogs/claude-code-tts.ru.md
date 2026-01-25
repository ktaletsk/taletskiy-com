---
title: Добавляем голос в Claude Code (с автоматическим приглушением музыки)
date: 2026-01-23
draft: false
summary: "Синтез речи для Claude Code с автоматическим приглушением музыки, когда он говорит — как Google Maps в CarPlay."
tags: ["Claude Code", "TTS", "macOS", "Kokoro"]
---

## Claude Code умеет говорить

Я провожу много времени в Claude Code. Читать ответы во время программирования — это нормально, но иногда хочется услышать, что говорит Claude, пока смотришь на что-то другое.

[claude-code-tts](https://git.sr.ht/~cg/claude-code-tts) от Криса Гоффа делает именно это. Он использует [Kokoro TTS](https://github.com/nazdridoy/kokoro-tts), быструю локальную модель синтеза речи, чтобы озвучивать ответы Claude. Подключается к системе событий Claude Code — когда Claude заканчивает отвечать, он извлекает текст и произносит его.

**Примечание:** Оригинальный проект использует `tac` (GNU coreutils), которого нет в macOS. Мой форк заменяет его на `tail -r`.

<video width="100%" controls>
  <source src="/videos/claude-code-tts.mp4" type="video/mp4">
  Ваш браузер не поддерживает тег video.
</video>

## Автоматическое приглушение звука (Audio Ducking)

Когда TTS заработал, появилась новая проблема: я люблю слушать музыку во время программирования. Когда Claude говорит поверх музыки, его плохо слышно.

CarPlay решил эту проблему с помощью audio ducking — когда говорит навигатор, громкость музыки снижается, а затем восстанавливается. Я добавил это для Claude Code TTS.

Реализация управляет Apple Music напрямую через AppleScript:

```bash
# Приглушаем до 5% перед началом TTS
osascript -e "tell application \"Music\" to set sound volume to 5"

# Восстанавливаем по завершении TTS
osascript -e "tell application \"Music\" to set sound volume to $original"
```

Меняется только внутренняя громкость Apple Music — системная громкость остаётся прежней, поэтому TTS воспроизводится на полной громкости, пока музыка приглушена. Фоновый процесс отслеживает завершение TTS и автоматически восстанавливает громкость.

## Настройка

Задаётся в `~/.claude/settings.json`:

| Переменная | По умолчанию | Описание |
|------------|--------------|----------|
| `KOKORO_VOICE` | `af_sky` | [Голос для использования](https://huggingface.co/hexgrad/Kokoro-82M/blob/main/VOICES.md) |
| `AUDIO_DUCK_ENABLED` | `true` | Установите `false` для отключения приглушения |
| `DUCK_LEVEL` | `5` | Процент от исходной громкости во время TTS |

## Попробуйте

Мой форк с audio ducking: [github.com/ktaletsk/claude-code-tts](https://github.com/ktaletsk/claude-code-tts)

Оригинал: [git.sr.ht/~cg/claude-code-tts](https://git.sr.ht/~cg/claude-code-tts)

```bash
git clone https://github.com/ktaletsk/claude-code-tts
cd claude-code-tts
./install.sh
```

Теперь я могу программировать, слушать музыку и слышать Claude — всё это без борьбы за звуковое пространство.
