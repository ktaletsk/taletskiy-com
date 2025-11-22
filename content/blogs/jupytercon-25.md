---
title: "JupyterCon 2025 Reflections"
date: 2025-11-06
description: "Reflections on JupyterCon 2025"
---

Another JupyterCon is in the books!

{{< youtube eZtGKLKr0u0 >}}

I have been a part of this community for the last 7 years, starting as a user, then building on top of Jupyter OSS projects and API and finally starting to contribute back to the core projects. I am really grateful for all the people I met along the way 🙏 
This post is a reflection on my experience.

![Me at JupyterCon 2025](/img/jupytercon/me-at-jupytercon2025.jpeg)

## Extension Development Tutorial

One of the main ways I have always participated in the community is through JupyterLab extensions. This is what makes JupyterLab a next step after Notebook -- an extensible architecture starting in the core itself (JupyterLab is built as a collection of extensions) and extending outward to allow exploring new ideas (collaboration, AI) and enhancing UX millions of user can rely on (git, LaTeX, ipywidgets). As an extension author, contributor and maintainer, I've seen an explosion of AI-related ideas in Jupyter space. To better highlight the changes happening in the ecosystem, I built a community extension marketplace [labextensions.dev](https://labextensions.dev), which surfaces the most importants signals (categories, downloads, GitHub stars) to both users and developers.

So, naturally, when JupyterCon CFP has opened, I submitted a workshop proposal combining the things I am most interested in: mentoring new generation of contributors and exploring AI coding tools in the ways they can be helpful (or not). Turns out, there were 3 more very similar workshops, so we combined forces with Rosio Reyes, Jason Grout and Matt Fisher and put together a full day tutorial! It was my first ever workshop I organized and I dove head first. It was no small feat, but our amazing team made it possible. I would also like to thank Lahari Chowtoori for providing AWS Bedrock credits for the participants, so they can use Claude Code; and Zach Sailer for agreeing to do a demo of Jupyter AI in action.

But when conference day rolled around, we were ready with a repo and a website complete with all the steps. It is fully open source (MIT license) and will be available to the community for the time being. You can find the tutorial materials here: [jupytercon.github.io/jupytercon2025-developingextensions](https://jupytercon.github.io/jupytercon2025-developingextensions/).

And I also happy to report that the entire session was recorded and uploaded to YouTube

![JupyterCon Tutorial Room](/img/jupytercon/tutorial-room.jpeg)
*Anatomy of the extension* 

The day went in a flash, but when it was all said and done we were able to see the impact clearly:
1. Participants were able to follow our instructions: we've seen [30 repos](https://github.com/topics/jupytercon2025) created during the tutorial 
2. Participants enjoyed their experience and it felt empowering: in our DMs and public [posts](https://medium.com/womenintechnology/reflections-from-jupytercon-2025-8ace9e6b27ab)
3. Some participants (especially on Windows) struggled with the environment installation steps. Extensions are using somewhat complex stack (Python, nodejs) and tools like `git` or `gh-cli` were hard to get working. I would strongly consider creating a cloud-hosted backup option (i.e. GitHub Codespaces) to allow participants to have a ready-to-go environment if their local one is impossible to set up.
4. Despite the difficulties, at least one of the attendees (Lingtao Xie @ Esri) has since created a brand new JupyterLab extension, [jupyterlab-todo-list](https://labextensions.dev/extensions/jupyterlab-todo-list)! After the conference she mentioned that she enjoyed the workshop and invited feedback on the extension as she keeps learning React and TypeScript — exactly the kind of follow‑through and openness that makes this community so fun to work with.

![Screenshot of jupyterlab-todo-list extension in action](/img/jupytercon/todo-extension-screenshot.png)

5. We might also have made the wrong assumptions about the number of participants and their interests. This is because we had a very limited data on the workshop participants from the conference organizers. Turns out, pre-registration for a particular workshop was not required, only for the workshop day. Additionally, badges were not scanned at the entrance to the room, so we have a limited ways of knowing who attended the session. I hope this will be addressed by the Jupyter/Linux Foundation when planning the next JupyterCon!

![JupyterCon 2025 Workshop](/img/jupytercon/IMG_1489.jpeg)
*Wrap up of the tutorial*

Overall, I had a great time teaching people and troubleshooting them as a TA. Most importantly, we laid a strong foundation for the next tutorials as we created a strong written guide alongside the presentation.

## JupyterHub satellites

{{< youtube MvZ-UUpqYMw >}}

This is a talk I wanted to present for quite some time. 
I had a chance to do a brief intro to Notebooks Hub approach to running non-notebook applications at the previous JupyterCon ([see blog post here](/blogs/jupytercon-23)),
but the opportunity to present this in full detail came only after I left the company, 
especially, because the topic found such strong interest in the community. 
I am grateful to Axle for the opportunity to still present this material.

Initially, I was planning to organize a Birds-of-a-Feather (BoF) session with JupyterHub deployers,
but it ended up being a talk. It so happened that Yuvi @ 2i2c was giving his own perspective on 

"JupyterHub satellites" as I called them in this talk are really just applications other than Jupyter Notebook/Lab (RStudio, VSCode, Streamlit) orchestrated by JupyterHub. Even though, community had tools and recipes for a long time now, our approach was a little different, as we relied on standalone proxy (jhsingle_native_proxy). Both my and Yuvi's talk highlighted the need to update documentation and centralize the existing recipes (scripts, Docker images) to unlock even more satellites (i.e. [Marimo](https://marimo.io/), [Dyad](https://www.dyad.sh/), [Positron](https://github.com/posit-dev/positron), etc) by the community efforts.

Recent updates to Jupyter Server proxy adding standalone mode, finally allowed for both standalone and integrated experiences in JupyterHub with the unified codebase under an official Jupyter repo. Since jhsingle_native_proxy was not actively maintained, it provides an off-ramp for existing users to join the community effort.

I heard back after my talk that there are users of JupyterHub interested in collaborating on open-sourcing the recipes for wrapping dashboards in Docker containers, which I hope to meet at Hub Dash on Dec 2-3.

To wrap up, I would like to thank Chris Holdgraf and Yuvi Panda @ 2i2c for productive conversations on the topic before and after this talk!

## Favorite talks

Even though I spent a lot of time at the Anaconda booth and in hallway conversations, I still managed to sneak out for a few talks that really stuck with me.

## First conference as Anacondiac

This was my first conference as a OSS Jupyter developer working at Anaconda.

![Me at JupyterCon 2025, wearing Anaconda jacket and showing my badge](/img/jupytercon/IMG_1427.jpeg)

We had a strong showing this year with talks across multiple tracks, sponsored talk at the Demo Theater and a delightful booth where I got a chance to meet so many of our users!

### Demo: Usage Patterns in the Jupyter Ecosystem (Jack Evans, Anaconda)

One of the most thought‑provoking sessions for me was Jack’s demo based on internal telemetry about how people actually use Jupyter. One stat that really stuck with me: based on Anaconda’s data, **around 79% of users still prefer the classic Notebook interface over JupyterLab**, which is a humbling reminder to keep investing in Notebook UX even as we push the ecosystem forward.

You can dig into the full deck here:

<iframe src="https://static.sched.com/hosted_files/jupytercon2025/98/Usage%20patterns%20in%20the%20Jupyter%20Ecosystem%20-%20JupyterCon%202025.pdf" width="100%" height="600" style="border:none;"></iframe>

### Lightning Talk: What's New in Jupyter Frontends (Jeremy Tuloup, QuantStack & Rosio Reyes, Anaconda)

{{< youtube xiPJDIbUU0o >}}

This was a fast but very dense overview of what’s landing across JupyterLab and the classic Notebook experience. As someone who works on extensions, it was great to see how improvements in the Lab frontend keep flowing back into the “plain notebook” UX that so many users still rely on.

### The Lifecycle of a Jupyter Environment: From Exploration To Production‑Grade Pipelines (Dawn Wages, Anaconda)

{{< youtube G66iE89f450 >}}

Dawn’s talk did a great job walking through the journey from an exploratory notebook to a maintainable ETL pipeline, with practical tooling like Papermill, nbconvert and PyScript/Voila/Panel in the mix. I especially appreciated the emphasis on planning for production from the start instead of treating “pipeline-izing” as an afterthought.

### Runtime Agents: Unleashing Event Sourced Collaboration for Jupyter (Kyle Kelley, Anaconda)

{{< youtube PzvUPHeD7Hs >}}

Kyle made a strong case for “moving notebooks to the server side” so that state lives independently of the browser tab. I loved seeing concrete demos of long‑running, resilient sessions and collaborative editing that felt much closer to how people actually work with notebooks day‑to‑day.

### Conversations at the booth

![Anaconda crew at the booth](/img/jupytercon/at-anaconda-booth.jpeg)
*Anaconda crew at the booth. Left to right: myself, Peter Wang, Dan Yeaw, Daina Bouquin, Rosio Reyes*

Since conference was well attended by the local students (kudos to JupyterCon!), the topic of job searching advice came up a lot. As someone who mentored and interviewed engineers throughout my career, I highlighted the importance of pursuing personal projects and open source contributions. It really is such a powerful signal to hiring managers being able to see your ideas, contributions and code style in the open. I shared my favorite personal anecdote on how a very well crafted [Colab notebook](https://colab.research.google.com/github/ktaletsk/CPF/blob/master/1D_Example/CPF_1D_toy.ipynb) helped me get my first job after grad school. Below are some reflections of the students.

- [Fariha Sheikh](https://www.linkedin.com/in/fariha-sheikh-usc/)'s reflections 👉 [View this post on LinkedIn](https://www.linkedin.com/feed/update/urn:li:share:7392660528554225664)

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:share:7392660528554225664" height="1107" width="504" frameborder="0" allowfullscreen="" title="Embedded post"></iframe>

- [Gor Abaghyan](https://www.linkedin.com/in/abaghyangor/)'s experience. At the booth and later at Sprints, we talked through his [PokéAgent Challenge](https://pokeagent.github.io/) setup and I suggested Docker as a way to both debug and pick up a tool that would pay off later; after the conference he messaged that he’d built the `mgba` bindings from source, had the ReAct agent running, and completed about 30% of the run, describing it as a really great experience.

### Exploring the city and connecting to fellow Anacondiacs

As we wrapped each day, Anaconda team would pack into local restaraunt and invite fellow jovyans for a dinner and conversation about Jupyer, Python and Open Source

![Dinner at El Agave with Jupyter community](/img/jupytercon/el-agave-dinner.jpeg)
*El Agave dinner: A memorable night of with great food and amazing people from the Jupyter community.*

![Anaconda × Deepnote Dinner at JupyterCon 2025](/img/jupytercon/anaconda-x-deepnote-dinner.jpg)
*Dinner with the Deepnote team. Photo credit: Dawn Wages*

## Venue and city
Set in a beatiful San Diego, this was a great place to be in the beginning of the November. Paradise Point resort did a great job creating such a welcoming experience. Continuing on JupyterCon 2023 success, this year catering was a perfect. Not only they provided breakfast and lunch, but the variety of snacks and deserts like no other conference!

![Conference lunch at JupyterCon 2025](/img/jupytercon/jupytercon-lunch.jpg)
*Photo credit: Dawn Wages*

![Paradise Point Resort beach at night](/img/jupytercon/IMG_1419.jpeg)
*Paradise Point Resort beach at night – the end of a perfect JupyterCon day*

![Paradise Point Resort at sunset](/img/jupytercon/IMG_1402.jpeg)
*Ligths and decoration at Paradise Point Resort*

![Paradise Point Resort grounds with conference banners](/img/jupytercon/IMG_1426.jpeg)
*Flowers at Paradise Point Resort*

![San Diego Gaslamp District](/img/jupytercon/san-diego-gaslamp.jpeg)
*San Diego Gaslamp District*

![Ghirardeli store in Gaslamp district](/img/jupytercon/IMG_1530.jpeg)
*Ghirardeli store in Gaslamp district*

After wrapping up the conference, I spent some quality time exploring San Diego with my family. The San Diego Zoo was a favorite, with its lush landscapes, panda exhibit, and countless other animal encounters.

![San Diego Zoo Adventure](/img/jupytercon/san-diego-zoo.jpeg)
*San Diego Zoo was a big highlight for the family!*

![San Diego Zoo Panda Exhibit](/img/jupytercon/san-diego-zoo-panda.jpeg)
*The panda exhibit was my daughter's favorite*

We also managed to visit Legoland, making the trip a perfect mix of work and play!

![Legoland Adventure](/img/jupytercon/legoland.jpeg)
*We topped off the trip with a visit to Legoland!*

## Sprint Day
- Entire class of improvements I would like to make to JupyterLab file browser
- Jupyter-AI v3, personas

## Community

Throughout the conference, I had a great time talking with members of Jupyter community, in particular our tutorial working group and [Community Building Working Group Members](https://jupyter.org/about#community-building-working-group-members), which (not surprisingly!) have a big intersection.

![Presenting at JupyterCon 2025](/img/jupytercon/IMG_4026.jpeg)

![AN'S ELECTRONICS REPAIR ice cream shop](/img/jupytercon/ans-electronics-repair-shop.jpeg)
*Decompressing after our workshop with Rosio Reyes and Matt Fisher at An's Electornics Repair ice cream shop. Not a real repair shop, but features menu items on a CRTs!*

It was so awesome to meet the people who I regularly see on my screen, it GitHub issues, in Zoom calls!

![Triage Call Crew at JupyterCon 2025](/img/jupytercon/triage-call-crew.jpeg)

And of course, it was such a priviledge to shake hands and talk to the Project Jupyter leaders and creators:  Fernando Pérez, Brian Granger, Min Ragan-Kelley and many others.

![At JupyterCon with Brian Granger, Sylvain Corlay and Jason Weill in the back](/img/jupytercon/IMG_1525.jpeg)
*At JupyterCon with Brian Granger, Sylvain Corlay and Jason Weill in the back*
