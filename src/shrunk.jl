struct ShrunkCovarianceMatrix <: CovarianceMatrixEstimator
    n::Int
    d::Int
    λ::Float64
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}

    function ShrunkCovarianceMatrix(n::Integer = 0, d::Integer = 0; λ::Float64 = 0.1)
        return new(n, d, λ, zeros(n, d), zeros(n, d))
    end
end

function fit(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X),
)
    return shrunk(estimator, X, mu = mu, λ = estimator.λ)
end

function fit(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X, weights),
)
    return shrunk(estimator, X, weights, mu = mu, λ = estimator.λ)
end

function fit!(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real},
)
    shrunk!(estimator, X, covariance, mu, λ = estimator.λ)
    return
end

function fit!(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real},
)
    shrunk!(estimator, X, weights, covariance, mu, λ = estimator.λ)
    return
end
