---
title: "Jupyter Open Studio Day SF 2025"
date: 2025-11-10
description: "Report on Jupyter event organized by Bloomberg"
---

The fun did not stop after JupyterCon. Next Monday after the conference, Bloomberg [invited](https://go.bloomberg.com/attend/invite/jupyter-open-studio-day-november-10-2025/) everyone to their office to collaborate on Jupyter projects. There were many of the friendly faces who decided to make a trek from Southern California to the Bay while there were here for JupyterCon.

![Jupyter Open Studio Day venue](/img/jupytercon/jupyter-open-studio-day.jpeg)

<!--more-->

Building on the momentum from the [Sprint Day](#sprint-day), I continued to explore those topics during the event.

- I exported all GitHub PRs and issues related to the filebrowser package ([`label:pkg:filebrowser`](https://github.com/jupyterlab/jupyterlab/issues?q=label%3Apkg%3Afilebrowser)) and ran analysis with Claude to find which of 800+ items might relevant to upload/copy/move UX. As a good first issue to solve (I've never contributed to the JupyterLab core!) I prototyped the button to cancel the file upload in JupyterLab. Below is my feature in action, but the full presentation is available [here](https://hackmd.io/@eqt0f1ICTrun-afIFzMReA/H1A0n1ggZg).

<div style="position: relative; padding-bottom: 62.42774566473989%; height: 0;"><iframe src="https://www.loom.com/embed/3d0b8b1adcb744a19634e82d898691ee" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

- I had a chat with participants about how my Jupyter Marketplace can be useful for developers, what additional signals to include. I appreciated a suggestion from Ely @ Bloomberg to include a contribution activity indicator (number of commits/issues/PRs over some period of time).
- I had an opportunity to help Hannah Chen @ Bloomberg to try and set up my [Auto Dashboards](https://github.com/orbrx/auto-dashboards) extension for generating Streamlit dashboards from Jupyter notebooks with live preview inside JupyterLab. She is `uv` user, so I learned how to do a development install using `uv` for JupyterLab extensions and updated my instructions.

![View from Bloomberg office during Jupyter Open Studio Day](/img/jupytercon/bloomberg-office-view.jpeg)

Huge thanks to Ely and Bloomberg for the invite and organizing the event for us!

![San Francisco Ferry Building and a skyline](/img/jupytercon/sf-ferry-skyline.jpeg)
