---
title: "Jupyter Open Studio Day SF 2025"
date: 2025-11-10
description: "Отчет о мероприятии Jupyter, организованном Bloomberg"
---

Веселье не остановилось после JupyterCon. В следующий понедельник после конференции Bloomberg [пригласил](https://go.bloomberg.com/attend/invite/jupyter-open-studio-day-november-10-2025/) всех в свой офис для совместной работы над проектами Jupyter. Было много знакомых лиц, которые решили совершить поездку из Южной Калифорнии в Bay Area, пока они были здесь на JupyterCon.

![Место проведения Jupyter Open Studio Day](/img/jupytercon/jupyter-open-studio-day.jpeg)

<!--more-->

Развивая импульс [Дня спринтов](#sprint-day), я продолжил исследовать эти темы во время мероприятия.

- Я экспортировал все GitHub PR и issues, связанные с пакетом filebrowser ([`label:pkg:filebrowser`](https://github.com/jupyterlab/jupyterlab/issues?q=label%3Apkg%3Afilebrowser)) и провел анализ с помощью Claude, чтобы найти, какие из 800+ элементов могут быть связаны с UX загрузки/копирования/перемещения. В качестве хорошего первого issue для решения (я никогда не вносил вклад в ядро JupyterLab!) я создал прототип кнопки для отмены загрузки файла в JupyterLab. Ниже моя функция в действии, но полная презентация доступна [здесь](https://hackmd.io/@eqt0f1ICTrun-afIFzMReA/H1A0n1ggZg).

<div style="position: relative; padding-bottom: 62.42774566473989%; height: 0;"><iframe src="https://www.loom.com/embed/3d0b8b1adcb744a19634e82d898691ee" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

- У меня был разговор с участниками о том, как мой Jupyter Marketplace может быть полезен для разработчиков, какие дополнительные сигналы стоит включить. Я оценил предложение от Ely @ Bloomberg включить индикатор активности вклада (количество коммитов/issues/PR за определенный период времени).
- У меня была возможность помочь Hannah Chen @ Bloomberg попробовать и настроить мое расширение [Auto Dashboards](https://github.com/orbrx/auto-dashboards) для генерации дашбордов Streamlit из Jupyter notebooks с живым предпросмотром внутри JupyterLab. Она пользователь `uv`, поэтому я узнал, как сделать development install с использованием `uv` для расширений JupyterLab и обновил свои инструкции.

![Вид из офиса Bloomberg во время Jupyter Open Studio Day](/img/jupytercon/bloomberg-office-view.jpeg)

Огромное спасибо Ely и Bloomberg за приглашение и организацию мероприятия для нас!

![Здание Ferry Building в Сан-Франциско и панорама города](/img/jupytercon/sf-ferry-skyline.jpeg)

