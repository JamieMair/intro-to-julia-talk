import random
import time
import numpy as np


def create_random_walk(positions, T):
    for i in range(len(positions)):
        x = 0
        for _ in range(T):
            if random.random() < 0.5:
                x += 1
            else:
                x -= 1
        positions[i] = x
        
def create_random_walk_with_numpy_array(positions, T):
    positions[:] = 0
    for _ in range(T):
        positions += (
            np.random.randint(0,2,size=np.size(positions)) * 2 - 1
            )

def benchmark_create_random_walk(n, T, repeats=100):
    times = []
    for _ in range(repeats):
        positions = [0 for _ in range(n)]
        start_time = time.perf_counter_ns()
        create_random_walk(positions, T)
        end_time = time.perf_counter_ns()
        times.append(end_time - start_time)
    return times

def benchmark_create_random_walk_with_numpy(n, T, repeats=100):
    times = []
    for _ in range(repeats):
        positions = np.zeros(n)
        start_time = time.perf_counter_ns()
        create_random_walk_with_numpy_array(positions, T)
        end_time = time.perf_counter_ns()
        times.append(end_time - start_time)
    return times


from multiprocessing import Pool
def walk1D(T):
    x = 0
    for _ in range(T):
        x += 1 if random.random() < 0.5 else -1
    return x

def run_walk_in_parallel(N, T, num_processes):
    positions = [0 for _ in range(N)]
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
    N = 1024
    T = 100
    
    # Raw Python
    times = benchmark_create_random_walk(N, T, repeats=15)
    min_time = min(times)
    print(f"The minimum time (raw python) for N={N}, T={T} is {min_time/1000} micro seconds.")
    
    # Numpy arrays
    times = benchmark_create_random_walk_with_numpy(N, T, repeats=15)
    min_time = min(times)
    print(f"The minimum time (numpy) for N={N}, T={T} is {min_time/1000} micro seconds.")
    
    # Raw python in parallel
    N=1024*1024
    times = benchmark_1D_walk_in_parallel(N, T, repeats=15)
    min_time = min(times)
    print(f"The minimum time (1D parallel) for N={N}, T={T} is {min_time/1000} micro seconds.")