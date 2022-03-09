using Pkg
Pkg.activate(".")
using Distributed, ClusterManagers


# Start 15 workers on SLURM - uses the allocated ones
n_tasks = 15
ClusterManagers.addprocs_slurm(
    n_tasks;
    exeflags=["--project=."]
)


# Gives all workers access to the source code (walk1D function)
@everywhere include("parallel_code_in_julia.jl") 

N = 4096
T = 10^6
# Example of getting the array of positions:
@btime positions = pmap(walk1D, T for _ in 1:N);

# Example of a reduction
mean_position = @distributed (+) for _ = 1:N
    walk1D(T)
end
mean_position /= N
println("Mean Position is $mean_position")



