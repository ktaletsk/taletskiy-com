---
date: 2022-05-05
title: Play MIDI tones on Adafruit Clue
summary: "Learn how to play MIDI tones on the Adafruit Clue microcontroller using CircuitPython. This tutorial explores converting MIDI files into playable sounds using the device's built-in speaker, creating a foundation for game development."
categories: [ "Microcontrollers" ]
tags: ["CircuitPython", "Adafruit Clue"]
---

I've recently got an Adafruit Clue microcontroller (shout out to Chipy and JFrog for the prize!). It is packed with sensors and a color LCD screen, but the best thing - it is programmable with Circuit Python. With the small screen and couple of buttons to the side, it reminded me of some sort of old pocket gaming console. I decided to build a little game that would run on Clue. When I started, there were no gaming engines written to run on Clue or CircuitPython, so I decided to build my own. 

What good game is without a soundtrack? The first thing I got interested in when creating a game was playing a sounds with a tiny speaker found on Clue. It only has a basic API allowing to play a tone with given frequency for a given period of time. 

The Adafruit Clue has a built-in tiny speaker that can be controlled using CircuitPython's `audioio` module. Here's the basic API for playing tones:

```python
from adafruit_clue import clue

# Play a tone at 440 Hz (A4 note) for 1 second
clue.play_tone(440, 1.0)

# Play a higher note (C5 at 523 Hz) for 0.5 seconds
clue.play_tone(523, 0.5)
```

The `play_tone` function takes two parameters:
- `frequency`: The frequency of the tone in Hz (higher values create higher-pitched sounds)
- `duration`: How long to play the tone in seconds

This simple API makes it easy to play individual tones, but it blocks program execution while the tone plays. For more complex sounds or background music, you would need to implement timing mechanisms around this basic functionality.

There is an excellent post explaining the connection between musical notes and frequencies and a CircuitPython code for playing Jingle Bells and Hanukkah tune: https://blog.wokwi.com/play-musical-notes-on-circuitpython/


But what if we don't have the notes written down for us? I thought about finding the soundtrack I like in MIDI format on the Internet and dropping that on my Clue drive folder, so that Python script can read the file and convert to a sequence of notes. What I didn't know is the internals of the MIDI file. It is more complicated than just a sequence of notes, but we can still extract that information.

## Extracting notes

https://github.com/mido/mido