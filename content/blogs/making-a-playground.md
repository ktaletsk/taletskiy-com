---
title: "Wanderland in marimo"
date: 2026-06-29
draft: false
summary: "Vincent from marimo posted a couple of Shorts that show Wanderland as a notebook-native playground, down to the tiny dark mode details."
tags: ["marimo", "Wanderland", "Python", "notebooks", "anywidget"]
image: /img/wanderland-in-marimo-vincent-short.jpg
---

A few weeks ago I wrote about [Wanderland]({{< ref "wanderland.md" >}}), my attempt to bring the Swift Playgrounds feeling into Python notebooks. The goal was pretty simple: code on one side, an immediate little world on the other, and enough delight that a beginner wants to keep poking at it.

Vincent from marimo posted a Short about it, which was a fun full-circle moment because Mo the Mossball started with him in the first place. In the video, he shows the exact thing I hoped would come through: Wanderland is not a separate app pretending to be a notebook. It is a notebook-native playground.

There is Mo, there is code next to him, and there is a button that runs the code so you can watch him move through the world. The small technical detail I really like is that the 3D scene is a custom `anywidget`, while the controls around it are ordinary marimo UI components. Even the editor is marimo's own code editor.

{{< youtube OF9c6u3PbDE >}}

That is the connection to the original Wanderland post for me. The interesting part is not just that Python can render a cute 3D puzzle. It is that the notebook can become the whole learning environment: instructions, editable code, UI controls, visual feedback, and the result, all in one reactive document.

Vincent posted another Short about a detail I was especially happy with: dark mode. When marimo switches themes, Wanderland does not just invert a few UI colors. The world itself turns to nighttime.

{{< youtube rJtcySrn8vM >}}

It is a small touch, but it is exactly the kind of thing that makes a notebook feel less like a form with outputs and more like a place you can build in. For teaching, that matters. The environment should invite curiosity before the first line of code even runs.

Also, subscribe to [Vincent's marimo posts](https://www.youtube.com/@marimo-team). He has been sharing lovely short demos and longer deep dives of what modern notebooks can do.