using Random
using CUDA
using Plots

function generate_random_walks!(positions, cache, T)
    positions .= zero(eltype(positions))

    # Make the code typesafe!
    limit = convert(eltype(cache), 0.5);
    el_two = convert(eltype(positions), 2);
    el_one = one(eltype(positions))

    for _ in 1:T
        rand!(cache) # Put random numbers in the cache
        positions .+= el_two .* (cache .< limit) .- el_one
    end
    nothing
end

# positions = zeros(10^6);
# cache = similar(positions);
# generate_random_walks!(positions, cache, 20)
# histogram(positions)


# positions_gpu = cu(zeros(10^6));
# cache_gpu = similar(positions_gpu);
# generate_random_walks!(positions_gpu, cache_gpu, 20)
# histogram(Array(positions_gpu))

function time_function(fn, params...; repeats = 5)
    min_time = Inf64
    for _ in 1:repeats
        new_time = @elapsed fn(params...)
        min_time = min(new_time, min_time)
    end
    return min_time
end

function measure_array_times(samples, T)
    function measure_cpu(n)
        dist = zeros(Int32, n)
        cache = zeros(Float32, n)
        return time_function(generate_random_walks!, dist, cache, T)
    end
    function measure_gpu(n)
        dist = cu(zeros(Int32, n))
        cache = cu(zeros(Float32, n))
        return time_function(generate_random_walks!, dist, cache, T)
    end
    cpu_times = zeros(Float64, length(samples))
    gpu_times = zeros(Float64, length(samples))
    for (i, n) in enumerate(samples)
        cpu_times[i] = measure_cpu(n)
        gpu_times[i] = measure_gpu(n)
        # Save memory
        GC.gc()
        CUDA.reclaim()
    end
    return cpu_times, gpu_times
end

function plot_threaded_gpu(T, samples, cpu_threaded_times, gpu_times)
    plt = plot(samples, cpu_threaded_times, label="Threaded"; markershape=:utriangle)
    plot!(samples, gpu_times, label="GPU"; markershape=:square, xscale=:log10, yscale=:log10)
    xlabel!("n")
    ylabel!("Time (s) for T=$T")
    return plt
end

samples = 10 .^ collect(0: 9);
cpu_times_array, gpu_times_array = measure_array_times(samples, 20);

plt_threaded_vs_gpu_array = plot_threaded_gpu(20, samples, cpu_times_array, gpu_times_array);
display(plt_threaded_vs_gpu_array)

