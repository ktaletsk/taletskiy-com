---
date: 2020-02-01
linktitle: spectrum
title: Pool Limited Queue Processing in Python
weight: 10
categories: [ "algorithms" ]
tags: ["Python", "Multiprocessing", "Queue", "Pool"]
---

While solving a problem I was confronted with a problem: I needed to build a large number (order of 100) of Docker containers and then push them to the registry. Docker SDK for Python provided an excellent handle on that, and together with `multiprocessing` library allowed to parallelize the task very effectively. However, after testing the library I noticed that pushing multiple images to registry got stalled likely due to an overload of simultaneous uploads. In the empirical testing, I was only able to run 2-3 `docker push ...` commands before the process get stalled. At that point I decided to limit the simultaneous uploads to the small number of parallel threads, while still utilizing large number of threads to facilitate image builds. Combination of queue (`multiprocessing.Queue`) for passing down the work from builder threads to pusher threads and thread pool (`multiprocessing.Pool`) looked like a best candidate. Yet, there are small nuances and gaps in documentation which took me some time to understand (especially when using `multiprocessing` on Windows). Below, I provide a small tutorial on how to use these data structures and objects.

## Problem formulation

![Problem formulation](/img/multiprocessing.png)

In this toy problem we have a large array of parallel Processes writing results into the Queue. Alongside them, there is a single-threaded reader Process checking for new items in the Queue and assigning them to new Processes in the Pool, such that only a small fixed number of these Processes are running at the same time. Let's go through all the elements below.

## `Process`

## `Queue`

## `Pool`

## Windows-related quirks

## Final solution