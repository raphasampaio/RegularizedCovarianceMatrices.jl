struct ShrunkCovariance <: CovarianceEstimator
    shrinkage::Float64
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}

    function ShrunkCovariance(shrinkage::Float64 = 0.1)
        return new(shrinkage, zeros(0, 0), zeros(0, 0))
    end

    function ShrunkCovariance(n::Int, d::Int, shrinkage::Float64 = 0.1)
        return new(shrinkage, zeros(n, d), zeros(n, d))
    end
end

function update_cache!(estimator::ShrunkCovariance, n::Int, d::Int)
    if n != size(estimator.cache1, 1) || d != size(estimator.cache1, 2)
        estimator.cache1 = zeros(n, d)
        estimator.cache2 = zeros(n, d)
    end
end

function fit(estimator::ShrunkCovariance, X::AbstractMatrix{<:Real}; mu::AbstractVector{<:Real} = get_mu(X))
    return shrunk(estimator, X, mu = mu, shrinkage = estimator.shrinkage)
end

function fit(estimator::ShrunkCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real}; mu::AbstractVector{<:Real} = get_mu(X, weights))
    return shrunk(estimator, X, weights, mu = mu, shrinkage = estimator.shrinkage)
end

function fit!(estimator::ShrunkCovariance, X::AbstractMatrix{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})::Nothing
    shrunk!(estimator, X, covariance, mu, shrinkage = estimator.shrinkage)
    return nothing
end

function fit!(estimator::ShrunkCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    shrunk!(estimator, X, weights, covariance, mu, shrinkage = estimator.shrinkage)
    return nothing
end