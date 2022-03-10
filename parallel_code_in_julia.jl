function walk1D(T)
    x = 0
    for _ in 1:T
        x += rand() < 0.5 ? 1 : -1
    end
    return x
end

function create_random_walk!(positions, T)
    for i in 1:length(positions)
        positions[i] = walk1D(T)
    end
end

# using BenchmarkTools;
# positions = zeros(Int, 64);
# T = 10^7;
# @btime create_random_walk!(positions, T);
# @benchmark create_random_walk!(positions, T)
# Threads.nthreads()