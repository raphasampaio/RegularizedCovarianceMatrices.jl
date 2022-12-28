struct ShrunkCovarianceMatrix <: CovarianceMatrixEstimator
    shrinkage::Float64
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}

    function ShrunkCovarianceMatrix(n::Int, d::Int, shrinkage::Float64 = 0.1)
        return new(shrinkage, zeros(n, d), zeros(n, d))
    end
end

function fit(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X)
)
    return shrunk(estimator, X, mu = mu, shrinkage = estimator.shrinkage)
end

function fit(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X, weights)
)
    return shrunk(estimator, X, weights, mu = mu, shrinkage = estimator.shrinkage)
end

function fit!(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real}
)
    shrunk!(estimator, X, covariance, mu, shrinkage = estimator.shrinkage)
    return
end

function fit!(
    estimator::ShrunkCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real}
)
    shrunk!(estimator, X, weights, covariance, mu, shrinkage = estimator.shrinkage)
    return
end
