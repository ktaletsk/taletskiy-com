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

```
from multiprocessing import Pool, Queue, Process, Manager
import random
import signal
import time

num_writers = 10
num_readers = 3

def writer(i,q):
    # Imitate some work happening in writer
    delay = random.randint(1,10)
    time.sleep(delay)

    # Put the result into the queue for workers to read
    t = time.time()
    print(f'Write to queue from writer {i}: {t}')
    q.put(t)

def init_worker():
    """
    Pool worker initialization, required for keyboard interrupt on Windows
    """
    signal.signal(signal.SIGINT, signal.SIG_IGN)

def worker(i, q):
    """
    Queue read worker
    """

    # Read the first element of the queue
    incoming = q.get()

    # Sleep to imitate work
    time.sleep(3)
    print(f'Read from queue from reader {i}: {incoming}')

if __name__ ==  '__main__':
    # Create manager (required for Windows)
    m = Manager()
    
    # Create multiprocessing queue
    q = m.Queue()
    # Create a group of parallel writers and start them
    for i in range(num_writers):
        Process(target=writer, args=(i,q,)).start()

    # Create multiprocessing pool
    p = Pool(num_readers, init_worker)

    # Create a group of parallel readers and start them
    # Number of readers is matching the number of writers
    # However, the number of simultaneously running
    #   readers is constrained to the pool size
    res = []
    for i in range(num_writers):
        res.append(p.apply_async(worker, (i,q,)))
    
    # Wait for the asynchrounous reader threads to finish
    try:
        [r.get() for r in res]
    except:
        print('Interrupted')
        p.terminate()
        p.join()
```

If you run it, you will get something like this:
```
> python manager.py
Write to queue from writer 5: 1580594068.821965
Write to queue from writer 7: 1580594068.8229723
Write to queue from writer 6: 1580594069.8156118
Write to queue from writer 2: 1580594069.8246157
Read from queue from reader 0: 1580594068.821965
Read from queue from reader 1: 1580594068.8229723
Write to queue from writer 3: 1580594071.830222
Write to queue from writer 0: 1580594072.8017073
Write to queue from writer 9: 1580594072.8187084
Read from queue from reader 2: 1580594069.8156118
Write to queue from writer 1: 1580594073.8059778
Write to queue from writer 4: 1580594073.8359802
Read from queue from reader 3: 1580594069.8246157
Read from queue from reader 4: 1580594071.830222
Read from queue from reader 5: 1580594072.8017073
Write to queue from writer 8: 1580594077.834787
Read from queue from reader 6: 1580594072.8187084
Read from queue from reader 7: 1580594073.8059778
Read from queue from reader 8: 1580594073.8359802
Read from queue from reader 9: 1580594077.834787
```