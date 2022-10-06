module RegularizedCovariances

using LinearAlgebra
using Statistics

export 
    fit,
    fit!,
    EmpiricalCovariance,
    ShrunkCovariance,
    OASCovariance,
    LedoitWolfCovariance
    
include("estimator.jl")
include("empirical.jl")
include("shrunk.jl")
include("oas.jl")
include("ledoitwolf.jl")

end
