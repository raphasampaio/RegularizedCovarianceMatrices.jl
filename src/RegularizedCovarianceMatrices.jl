module RegularizedCovarianceMatrices

using LinearAlgebra
using Statistics

export
    CovarianceMatrixEstimator,
    EmpiricalCovarianceMatrix,
    ShrunkCovarianceMatrix,
    OASCovarianceMatrix,
    LedoitWolfCovarianceMatrix

include("estimator.jl")
include("empirical.jl")
include("shrunk.jl")
include("oas.jl")
include("ledoitwolf.jl")

end
