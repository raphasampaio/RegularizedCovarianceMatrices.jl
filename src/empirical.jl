mutable struct EmpiricalCovariance <: CovarianceEstimator
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}

    function EmpiricalCovariance()
        return new(zeros(0, 0), zeros(0, 0))
    end

    function EmpiricalCovariance(n::Int, d::Int)
        return new(zeros(n, d), zeros(n, d))
    end
end

function update_cache!(estimator::EmpiricalCovariance, n::Int, d::Int)
    if n != size(estimator.cache1, 1) || d != size(estimator.cache1, 2)
        estimator.cache1 = zeros(n, d)
        estimator.cache2 = zeros(n, d)
    end
end

function fit(estimator::EmpiricalCovariance, X::AbstractMatrix{<:Real}; mu::AbstractVector{<:Real} = get_mu(X))
    return empirical(estimator, X, mu = mu)
end

function fit(estimator::EmpiricalCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real}; mu::AbstractVector{<:Real} = get_mu(X, weights))
    return empirical(estimator, X, weights, mu = mu)
end

function fit!(estimator::EmpiricalCovariance, X::AbstractMatrix{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})::Nothing
    empirical!(estimator, X, covariance, mu)
    return nothing
end

function fit!(estimator::EmpiricalCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    empirical!(estimator, X, weights, covariance, mu)
    return nothing
end


# # function old_empirical_covariance(X::Matrix{T}; weights = ones(size(X, 1)), mu = get_mu(X, weights)) where {T}
# #     translate_to_zero!(X, mu)
# #     covariance = (X' * (weights .* X)) ./ sum(weights)
# #     translate_to_mu!(X, mu)
# #     return Symmetric(covariance), mu
# # end


