#include <iostream>
#include <stdlib.h>
#include <chrono>
#include <algorithm>
#include <climits>

void create_random_walk(int* positions, int N, int T)
{
    for (size_t n = 0; n < N; n++)
    {
        int x = 0;
        for (size_t i = 0; i < T; i++)
        {
            if (rand() % 2 == 0)
                x++;
            else
                x--;
        }
        positions[n] = x;
    }
}

int main()
{
    using std::chrono::duration_cast;
    using std::chrono::nanoseconds;
    typedef std::chrono::high_resolution_clock clock;


    const int n = 1024;
    const int T = 100;
    const int repeats = 15;
    int* positions = new int[n];
    long long times[repeats];
    long long min_time = LLONG_MAX;
    for (size_t i = 0; i < repeats; i++)
    {
        auto start = clock::now();
        create_random_walk(positions, n, T);
        auto end = clock::now();
        auto time_taken = duration_cast<nanoseconds>(end-start).count();
        times[i] = time_taken;
        if (time_taken < min_time)
        {
            min_time = time_taken;
        }
    }
    delete[] positions;
    std::cout << "Minimum time taken was: " << min_time / 1000 << " micro seconds" << std::endl;
}