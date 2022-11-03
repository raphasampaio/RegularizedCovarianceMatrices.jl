using Random
using RegularizedCovarianceMatrices
using ScikitLearn: @sk_import, fit!, fit_transform!, predict, score
using Test
using TimerOutputs

@sk_import covariance:(EmpiricalCovariance, ShrunkCovariance, OAS, LedoitWolf)

include("empirical.jl")
include("shrunk.jl")
include("oas.jl")
include("ledoitwolf.jl")

function test_all()
    Random.seed!(1)
    size = 10
    ns = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]

    @testset "covariance tests" begin
        for i in 1:size, n in ns, d in ns
            if n > d
                matrix = rand(n, d)
                weights = rand(n)

                @timeit "empirical" test_empirical(matrix, weights)
                @timeit "shrunk" test_shrunk(matrix, weights)
                @timeit "oas" test_oas(matrix, weights)
                @timeit "ledoitwolf" test_ledoitwolf(matrix, weights)
            end
        end
    end
end

reset_timer!()
test_all()
print_timer(sortby = :firstexec)
