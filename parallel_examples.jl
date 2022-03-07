using BenchmarkTools
using Plots
using Statistics

# Example 1 - Arbitrary function

f(x) = 2x*sin(10x)*exp(-x)+10

function example_for_loop(arr)
    results = similar(arr)
    @inbounds for i in eachindex(arr)
        results[i] = f(arr[i])
    end
    return results
end
function example_broadcast(arr)
    results = f.(arr)
    return results
end
function example_inline_broadcast(x)
    return 2 .* x .* sin.(10 .* x).*exp.(-x) .+ 10
end

function example_for_loop_simd(arr)
    results = similar(arr)
    @inbounds @simd for i in eachindex(arr)
        results[i] = f(arr[i])
    end
    return results
end

function example_for_loop_threaded(arr)
    results = similar(arr)
    @inbounds Threads.@threads for i in eachindex(arr)
        results[i] = f(arr[i])
    end
    return results
end

using Distributed
@everywhere f(x) = 2x*sin(10x)*exp(-x)+10
function example_mapping_distributed(arr)
    results = pmap(f, arr)
    return results
end

using CUDA

function example_cuda_implementation(arr)
    arr_gpu = cu(arr) # copy array to the GPU
    res_gpu = f.(arr_gpu)
    res_cpu = Array(res_gpu)
    return res_cpu
end

function example_cuda_kernel!(y, x)
    i = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if i <= length(x)
        @inbounds y[i] = f(x[i])
    end
    nothing
end

function run_example_kernel()
    x = cu(rand(2^26))
    y = similar(x)
    kernel = @cuda launch=false example_cuda_kernel!(y, x)
    config = launch_configuration(kernel.fun)
    threads = min(length(x), config.threads)
    blocks = cld(length(x), threads)
    
    time_taken = @elapsed CUDA.@sync kernel(y, x; threads, blocks)
    
    x_cpu = Array(x)
    y_cpu = f.(x_cpu)

    correctness = Array(y) .≈ y_cpu
    return time_taken, correctness
end

const non_distributed_funcs = [example_for_loop, example_broadcast, example_inline_broadcast, example_for_loop_simd, example_for_loop_threaded]
const distributed_funcs = [example_mapping_distributed]
const cuda_funcs = [example_broadcast]

function benchmark_funcs(funcs; use_gpu=false)
    ns = 2 .^ (2:2:12)
    result_times = Dict{String, Any}()
    
    labels = (x->"$(string(Symbol(x)))").(funcs)
    arrays = [rand(n) for n in ns]
    if use_gpu
        arrays .= cu.(arrays) # copy the array to the GPU
    end
    for (label, fn) in zip(labels, funcs)
        r = Dict{Symbol, Any}()
        min_times = []
        std_times = []
        for (n, arr) in zip(ns, arrays)
            if use_gpu
                benchmark_results = @benchmark CUDA.@sync $fn($arr)
            else
                benchmark_results = @benchmark $fn($arr)
            end

            min_time = minimum(benchmark_results.times)
            std_time = std(benchmark_results.times)
            push!(min_times, min_time)
            push!(std_times, std_time)
        end
        result_times[label] = Dict(:min_times => min_times, :std_times=>std_times)
    end
    return ns, result_times
end

function plot_results(ns, result_times; new_plot=true)
    initial_plot_fn = new_plot ? plot : plot!
    plt = initial_plot_fn(size=(500,400), dpi=600)
    for (label, res) in result_times
        plot!(ns, res[:min_times]; label=label, markershape=:auto)
    end
    plot!(;legend=:bottomright,xscale=:log10, yscale=:log10, lw=4)
    xlabel!("n")
    ylabel!("Time (ns)")
    return plt
end