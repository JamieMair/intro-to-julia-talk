import random
from multiprocessing import Pool
import time

def walk1D(T):
    x = 0
    for _ in range(T):
        x += 1 if random.random() < 0.5 else -1
    return x

def run_walk_in_parallel(N, T, num_processes):
    with Pool(num_processes) as pool:
        positions = pool.map(walk1D, [T for _ in range(N)])
    return None

def benchmark_1D_walk_in_parallel(n, T, repeats=30):
    times = []
    for _ in range(repeats):
        start_time = time.perf_counter_ns()
        run_walk_in_parallel(n, T, 32)
        end_time = time.perf_counter_ns()
        times.append(end_time - start_time)
    return times

if __name__=="__main__":
    times = benchmark_1D_walk_in_parallel(10**6, 100, repeats=30)
    print(min(times)) # 408ms