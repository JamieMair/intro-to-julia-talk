function create_random_walk!(positions, T)
    for i in 1:length(positions)
        x = 0
        for _ in 1:T
            if rand() < 0.5
                x += 1
            else
                x -= 1
            end
        end
        positions[i] = x
    end
end

function create_random_walk_with_arrays!(positions, T)
    positions .= 0 # Reset to zero
    for _ in 1:T
        positions .+= rand([-1, 1],
         size(positions)...)
    end
end

function walk1D(T)
    x = 0
    for _ in 1:T
        x += rand() < 0.5 ? 1 : -1
    end
    return x
end

function run_walk_in_parallel(N, T)
    positions = zeros(Int, N)
    Threads.@threads for i in 1:N
        positions[i] = walk1D(T)
    end
    nothing
end