---
title: "JupyterCon 2025 Reflections"
date: 2025-11-10
description: "JupyterCon reflections [+other fall 2025 Jupyter events]"
---

Another JupyterCon is in the books!

{{< youtube eZtGKLKr0u0 >}}

I have been a part of this community for the last 7 years, starting as a user, then building on top of Jupyter OSS projects and API and finally starting to contribute back to the core projects. I am really grateful for all the people I met along the way 🙏 
This post is a reflection on my experience.

![Me at JupyterCon 2025](/static/img/jupytercon/me-at-jupytercon2025.jpeg)

## Extension Development Tutorial

One of the main ways I participated in the community always were JupyterLab extensions. This is what makes JupyterLab a next step after Notebook -- extensible architecture starting in the core itself (JupyterLab itself is built as a collection of extensions) and extending outward to allow exploring new ideas (collaboration, AI) and enhancing UX millions of user can rely upon (git, LaTeX, ipywidgets). As an extension author, contributor and maintainer, I've seen an explosion of AI-related ideas in Jupyter space. To better highlight the changes happening in the ecosystem, I built a community extension marketplace [labextensions.dev](https://labextensions.dev), which surfaces the most importants signals (categories, downloads, GitHub stars).

So, naturally, when JupyterCon CFP has opened, I submitted a workshop proposal combining the things I am most interested in: mentoring new generation of contributors and exploring AI coding tools in the ways they can be helpful (or not). Turns out, there were 3 more very similar workshops, so we combined forces with Rosio Reyes, Jason Grout and Matt Fisher and put together a full day tutorial! It was my first ever workshop I organized and I dove head first. It was no small feat, but our amazing team made it possible. I would also like to thank Lahari Chowtoori for providing AWS Bedrock credits for the participants, so they can use Claude Code; and Zach Sailer for agreeing to do a demo of Jupyter AI in action.

But when conference day rolled around, we were ready with a repo and a website complete with all the steps. It is fully open source (MIT license) and will be available to the community for the time being. You can find the tutorial materials here: [jupytercon.github.io/jupytercon2025-developingextensions](https://jupytercon.github.io/jupytercon2025-developingextensions/).

And I also happy to report that the entire session was recorded and uploaded to YouTube

![JupyterCon 2025 Workshop](/static/img/jupytercon/IMG_1489.jpeg)
*Wrap up of the tutorial*

The day went in a flash, but when it was all said and done we were able to see the impact clearly:
1. Participants were able to follow our instructions: we've seen [30 repos](https://github.com/topics/jupytercon2025) created during the tutorial 
2. Participants enjoyed their experience and it felt empowering: in our DMs and public [posts](https://medium.com/womenintechnology/reflections-from-jupytercon-2025-8ace9e6b27ab)
3. Some participants (especially on Windows) struggled with the environment installation steps. Extensions are using somewhat complex stack (Python, nodejs) and tools like `git` or `gh-cli` were hard to get working.
4. Despite the difficulties, one of the attendees (Lingtao Xie @ Esri) have since created a brand new JupyterLab extension, [jupyterlab-todo-list](https://labextensions.dev/extensions/jupyterlab-todo-list)!
5. We might have made the wrong assumptions about the number of participants and their interests. This is because we had a very limited data on the workshop participants from the conference organizers. Turns out, pre-registration for a particular workshop was not required, only for the workshop day. Additionally, badges were not scanned at the entrance to the room, so we have a limited ways of knowing who attended the session. I hope this will be addressed by the Jupyter Foundation when planning the next JupyterCon!

## JupyterHub satellites

{{< youtube MvZ-UUpqYMw >}}

This is a talk I wanted to present for quite some years. 
I had a chance to do a brief intro to Notebooks Hub approach to running non-notebook applications at the previous JupyterCon ([see blog post here](/blogs/jupytercon-23)),
but the opportunity to present this came only after I left the company. I am grateful to Axle for the opportunity to still present this material.
Especially, because the topic find such a big interest in a community. Initially, I was planning to organize BoF session with all JupyterHub deployers,
but it ended up being a talk. It so happened that Yuvi @ 2i2c was giving his own perspective on 

- Reflections on Notebooks Hub experience
- Transition to Jupyter Server proxy (standalone)
- Desire to contribute back the solution for wrapping all the dashboards, etc. 
- Hub Dash on Dec 2-3, collaborator willing to help in a free time
- Thanks for Chris Holdgraph, Yuvi Panda and 2i2c


## First conference as Anacondiac

![Me at JupyterCon 2025, wearing Anaconda jacket and showing my badge](/static/img/jupytercon/IMG_1427.jpeg)

- Lessons presented from internal data by Jack Evans, 79% still prefer Notebook over Lab
- Conversations at the booth
- Students at the conference, seeking advice

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:share:7392660528554225664" height="1107" width="504" frameborder="0" allowfullscreen="" title="Embedded post"></iframe>

## Venue
Set in a beatiful San Diego, this was a great place to be in the beginning of the November. Paradise Point resort

![San Diego Gaslamp District](/static/img/jupytercon/san-diego-gaslamp.jpeg)



## Sprint Day
- Entire class of improvements I would like to make to JupyterLab file browser
- Jupyter-AI v3, personas

## Community
- Community engagement group, having ice cream together

![Triage Call Crew at JupyterCon 2025](/static/img/jupytercon/triage-call-crew.jpeg)


## Jupyter Open Studio Day
The fun did not stop after JupyterCon. Next Monday after the conference, Bloomberg [invited](https://go.bloomberg.com/attend/invite/jupyter-open-studio-day-november-10-2025/) everyone to their office to collaborate on Jupyter projects. There were many of the friendly faces who decided to make a trek from Southern California to the Bay while there were here for JupyterCon.

![Jupyter Open Studio Day venue](/static/img/jupytercon/jupyter-open-studio-day.jpeg)


Building on the momentum from the [Sprint Day](#sprint-day), I continued to explore those topics during the event.

- I exported all GitHub PRs and issues related to the filebrowser package ([`label:pkg:filebrowser`](https://github.com/jupyterlab/jupyterlab/issues?q=label%3Apkg%3Afilebrowser)) and ran analysis with Claude to find which of 800+ items might relevant to upload/copy/move UX. As a good first issue to solve (I've never contributed to the JupyterLab core!) I prototyped the button to cancel the file upload in JupyterLab. Below is my feature in action, but the full presentation is available [here](https://hackmd.io/@eqt0f1ICTrun-afIFzMReA/H1A0n1ggZg).

<div style="position: relative; padding-bottom: 62.42774566473989%; height: 0;"><iframe src="https://www.loom.com/embed/3d0b8b1adcb744a19634e82d898691ee" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

- I had a chat with participants about how my Jupyter Marketplace can be useful for developers, what additional signals to include. I appreciated a suggestion from Ely @ Bloomberg to include a contribution activity indicator (number of commits/issues/PRs over some period of time).
- I had an opportunity to help Hannah Chen @ Bloomberg to try and set up my [Auto Dashboards](https://github.com/orbrx/auto-dashboards) extension for generating Streamlit dashboards from Jupyter notebooks with live preview inside JupyterLab. She is `uv` user, so I learned how to do a development install using `uv` for JupyterLab extensions and updated my instructions.

![View from Bloomberg office during Jupyter Open Studio Day](/static/img/jupytercon/bloomberg-office-view.jpeg)

Huge thanks to Ely and Bloomberg for the invite and organizing the event for us!

![San Francisco Ferry Building and a skyline](/static/img/jupytercon/sf-ferry-skyline.jpeg)
