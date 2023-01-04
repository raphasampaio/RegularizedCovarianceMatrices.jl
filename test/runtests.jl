using Random
using RegularizedCovarianceMatrices
using Statistics
using StatsBase
using Test
using TimerOutputs

include("empirical.jl")

function test_all()
    @timeit "empirical" test_empirical()
end

reset_timer!()
test_all()
print_timer(sortby = :firstexec)
