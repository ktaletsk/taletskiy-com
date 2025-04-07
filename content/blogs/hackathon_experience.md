---
date: 2025-02-08
title: Building Auto Dashboards - A Hackathon Journey
summary: Reflecting on my experience of creating the Auto Dashboards project during a hackathon.
categories: [ "Technology", "Hackathon" ]
tags: ["Auto Dashboards", "JupyterLab", "Streamlit", "Solara", "OpenAI"]
---

## How It All Started

The first Bay Area H4CK D4Y has wrapped up, and what an exhilarating experience it was! As we stepped into 2025, I was eager to capture the enthusiasm and hope for the new year. Most importantly, I wanted to embrace that uncomfortably exciting itch to build and make something happen—a sentiment shared by my fellow participants.

Ten passionate, friendly, and capable hackers gathered to build on the day. We explored every possible Gen AI technology under the sun and worked on real-world projects. The day was so productive that we didn't have enough time to finish the demos!


![Hackathon Group Photo](/img/hackathon_1.jpeg)
*The amazing team of hackers at the Bay Area H4CK D4Y.*

![Demo Time](/img/hackathon_2.jpeg)
*My demo session showcasing Auto-Dashboard POC.*

## The Hackathon Experience

I had a blast at H4CK D4Y Bay Area! We tested all the latest coding agents, and I was particularly impressed with Cline in combination with Gemini 2.0 Pro. Others experimented with Devin and Windsurf.

Here's a glimpse of the projects we worked on:

1. Automated university assignment grader
2. Tool to infer security breaches from logs
3. Book ranking tracker
4. Tool to convert Jupyter Notebooks to Streamlit apps
5. Voice transcription
6. Document classification and filing tool

## Auto-Dashboards

During the event, I built and demoed a tool for single-click notebook-to-dashboard conversion, with results rendered side-by-side in JupyterLab. The source will be published [here](https://github.com/orbrx/auto-dashboards).

I started with the existing Streamlit rendering extension from Elyra and added a new endpoint and UI to convert notebooks to Python script and send to LLM for code-to-code translation. The output is Streamlit dashboard with tables, headings and widget APIs from Jupyter replaced by the ones from Streamlit.

```bash
pip install auto-dashboards jupyterlab
```

## Conclusion

A big thank you to Jasmine Robinson, Luke Fernandez, Paul "π" Ivanov, Smit Lunagariya, CL Kao, Salman Munaf, and Scott Behrens for an incredibly fun day. Special thanks to Itay Dafna, the organizer, who brought together a diverse group of participants from companies like Netflix, Google, and TikTok from across Bay Area.