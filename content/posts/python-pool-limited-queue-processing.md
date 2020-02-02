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

For our large array of parallel threads on the left we are going to use `multithreading.Process()`. From official the [reference](https://docs.python.org/3.7/library/multiprocessing.html#multiprocessing.Process): "`Process` objects represent activity that is run in a separate process". Starting a process(es) requires 2 things: the target function called and the `Process` call itself. Let's take a look:
```
from multiprocessing import Process

def proc(i):
    print(f'I am Process {i}')

if __name__ ==  '__main__':
    for i in range(10):
        Process(target=proc, args=(i,)).start()
```

In the example above we created 10 `Process`es and launched them all at the same time. Each process is running an instance of `proc()` function with arguments taken from `arg`. Because the order of execution is not guaranteed, if we run it we get something like:
```
I am Process 6
I am Process 2
I am Process 0
I am Process 3
I am Process 7
I am Process 4
I am Process 8
I am Process 1
I am Process 5
I am Process 9
```

Notice also the interesting syntax of the `args=(i,)`. `Process` requires that `args` is iterable, so changing it to `args=(i)` or `args=i` will lead to a `TypeError`.

## `Queue`

Now, it is time to introduce a `multithreading.Queue()`. According to [reference](https://docs.python.org/3.7/library/multiprocessing.html#multiprocessing.Queue) it "returns a process shared queue implemented using a pipe and a few locks/semaphores". Queue will allow us to put objects into it and then process them elswhere asynchronously. Importantly, queues are thread and process safe. Let's modify our previous example to add the `Queue` object and pass it to our parallel `Process`es:

```
from multiprocessing import Process, Queue

def writer(i,q):
    message = f'I am Process {i}'
    q.put(message)

if __name__ ==  '__main__':    
    # Create multiprocessing queue
    q = Queue()
    # Create a group of parallel writers and start them
    for i in range(10):
        Process(target=writer, args=(i,q,)).start()

    # Read the queue sequentially
    for i in range(10):
        message = q.get()
        print(message)
```

Keep in mind that `Queue.get()` is a blocking method, so we are not going to miss any messages in that queue.

The next step in solving our problem is to switch to a parallel reads from the queue. We could just spawn the reader processes in the same way we spawned writers, but that will permit up 10 threads run in parallel. What should we do if we are limited by the smaller number of readers like in the original problem description?

## `Pool`

Enter [`multithreading.Pool()`](https://docs.python.org/3.7/library/multiprocessing.html#multiprocessing.pool.Pool): "A process pool object which controls a pool of worker processes to which jobs can be submitted. It supports asynchronous results with timeouts and callbacks and has a parallel map implementation". Using `Pool` we can assign as many parallel processes as we like, but only the `processes` number of threads will be active at any given moment.

Let's see how it will behave if we through all the readers to the `Pool`:

```
from multiprocessing import Process, Queue, Pool

def writer(i,q):
    message = f'I am Process {i}'
    q.put(message)

def reader(i,q):
    message = q.get()
    print(message)

if __name__ ==  '__main__':    
    # Create multiprocessing queue
    q = Queue()

    # Create a group of parallel writers and start them
    for i in range(10):
        Process(target=writer, args=(i,q,)).start()

    # Create multiprocessing pool
    p = Pool(10)

    # Create a group of parallel readers and start them
    # Number of readers is matching the number of writers
    # However, the number of simultaneously running
    #   readers is constrained to the pool size
    for i in range(10):
        p.apply_async(reader, (i,q,))
```

However, if we run the code above, we will get no output. What happened? When we called `apply_async`, the code execution immediately moved on and, since nothing else has left in the main function, exited. Thankfully, `multiprocessing` reference provides a way to wait for the execution results:

```
from multiprocessing import Process, Queue, Pool

def writer(i,q):
    message = f'I am Process {i}'
    q.put(message)

def reader(i,q):
    message = q.get()
    print(message)

if __name__ ==  '__main__':    
    # Create multiprocessing queue
    q = Queue()

    # Create a group of parallel writers and start them
    for i in range(10):
        Process(target=writer, args=(i,q,)).start()

    # Create multiprocessing pool
    p = Pool(10)

    # Create a group of parallel readers and start them
    # Number of readers is matching the number of writers
    # However, the number of simultaneously running
    #   readers is constrained to the pool size    
    readers = []
    for i in range(10):
        readers.append(p.apply_async(reader, (i,q,)))
    
    # Wait for the asynchrounous reader threads to finish
    [r.get() for r in readers]
```

This time, if we run the code we will get the following error: `RuntimeError: Queue objects should only be shared between processes through inheritance`. The `multiprocessing.Manager` will enable us to manage the queue and to also make it accessible to different workers:

```
from multiprocessing import Process, Queue, Pool, Manager

def writer(i,q):
    message = f'I am Process {i}'
    q.put(message)

def reader(i,q):
    message = q.get()
    print(message)

if __name__ ==  '__main__':    
    # Create manager
    m = Manager()
    
    # Create multiprocessing queue
    q = m.Queue()

    # Create a group of parallel writers and start them
    for i in range(10):
        Process(target=writer, args=(i,q,)).start()

    # Create multiprocessing pool
    p = Pool(10)

    # Create a group of parallel readers and start them
    # Number of readers is matching the number of writers
    # However, the number of simultaneously running
    #   readers is constrained to the pool size    
    readers = []
    for i in range(10):
        readers.append(p.apply_async(reader, (i,q,)))
    
    # Wait for the asynchrounous reader threads to finish
    [r.get() for r in readers]
```

Finally, we get the results we expect:
```
> python pl.py
I am Process 1
I am Process 4
I am Process 9
I am Process 8
I am Process 0
I am Process 5
I am Process 7
I am Process 2
I am Process 6
I am Process 3
```

## Windows-related quirks

I initially started working on this problem on Linux-based machine, but later continued on Windows. Unfortunately many of the things did not work immediately. Here are the things you need to know:

1. 

## Final Result

Finally, we throw in some delays to emulate CPU-bound work and the solution is ready:

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