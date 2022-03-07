# Multithreading

Multithreading allows multiple streams of execution occur concurrently. If modern systems have multiple cores in their processors, they have the ability to execute these threads in parallel. In general, you want to use as many threads as you have logical cores on your system. 

A multithreaded programming model allows for the threads to share and access the same data and code, which makes it very simple to process a large piece of data across multiple threads.

## Multithreading vs Multiprocessing

A multiprocessing approach, however, spins up multiple copies of the runtime itself. These copies do not share a code base or have any shared memory. In order to communicate, these processes must send data to one another, this communication is often quite in comparison to threading. However, since the execution is split into different processes, it becomes very difficult run into race conditions. Multiprocessing is also required when splitting up a computation across multiple computers, as these computers cannot share memory and have to communicate through message passing. 

Generally, threading requires a lot less overhead than multiprocessing, but for long-running code that requires little communication between processes, the execution time is very comparable.

What is very different is the memory footprint, this is because each process has to keep a copy of the runtime in memory, including any loaded files. The more cores your computer has, the larger this footprint becomes. Additionally, it takes a lot longer to start multiple processes.