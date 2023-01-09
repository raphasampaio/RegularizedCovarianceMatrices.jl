struct EmpiricalCovarianceMatrix <: CovarianceMatrixEstimator
    n::Int
    d::Int
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}
end

function EmpiricalCovarianceMatrix(n::Integer = 0, d::Integer = 0)
    return EmpiricalCovarianceMatrix(n, d, zeros(n, d), zeros(n, d))
end

function fit(
    estimator::EmpiricalCovarianceMatrix,
    X::AbstractMatrix{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X)
)
    return empirical(estimator, X, mu = mu)
end

function fit(
    estimator::EmpiricalCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X, weights)
)
    return empirical(estimator, X, weights, mu = mu)
end

function fit!(
    estimator::EmpiricalCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real}
)
    empirical!(estimator, X, covariance, mu)
    return
end

function fit!(
    estimator::EmpiricalCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real}
)
    empirical!(estimator, X, weights, covariance, mu)
    return
end
