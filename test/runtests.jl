using RegularizedCovarianceMatrices

using Aqua
using Random
using Statistics
using StatsBase
using Test
using TimerOutputs

include("empirical.jl")

function test_all()
    reset_timer!()

    @testset "Aqua.jl" begin
        @testset "Ambiguities" begin
            Aqua.test_ambiguities(RegularizedCovarianceMatrices, recursive = false)
        end
        Aqua.test_all(RegularizedCovarianceMatrices, ambiguities = false)
    end

    @timeit "empirical" test_empirical()

    print_timer(sortby = :firstexec)
end

test_all()
