module RegularizedCovariances

using LinearAlgebra
using Statistics

export 
    fit, 
    fit!, 
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
