struct OASCovariance <: CovarianceEstimator
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}
    cache3::Matrix{Float64}

    function OASCovariance()
        return new(zeros(0, 0), zeros(0, 0), zeros(0, 0))
    end

    function OASCovariance(n::Int, d::Int)
        return new(zeros(n, d), zeros(n, d), zeros(d, d))
    end
end

function update_cache!(estimator::OASCovariance, n::Int, d::Int)
    if n != size(estimator.cache1, 1) || d != size(estimator.cache1, 2)
        estimator.cache1 = zeros(n, d)
        estimator.cache2 = zeros(n, d)
        estimator.cache3 = zeros(d, d)
    end
end

function get_shrinkage(estimator::OASCovariance, X::AbstractMatrix{<:Real}, covariance::AbstractMatrix{<:Real})
    n, d = size(X)
    update_cache!(estimator, n, d)

    trace_mean = tr(covariance) / d
    estimator.cache3 .= covariance .^ 2
    alpha = mean(estimator.cache3)
    num = alpha + trace_mean^2
    den = (n + 1.0) * (alpha - (trace_mean^2) / d)

    return (den == 0) ? 1.0 : min(num / den, 1.0)
end

function fit(estimator::OASCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real} = ones(size(X, 1)), mu::AbstractVector{<:Real} = get_mu(X, weights))
    n, d = size(X)

    translate_to_zero!(X, mu)
    covariance, _ = empirical(estimator, X, weights, mu = zeros(d))
    trace_mean = tr(covariance) / d

    # formula from Chen et al.'s **implementation**
    alpha = mean(covariance .^ 2)
    num = alpha + trace_mean^2
    den = (n + 1.0) * (alpha - (trace_mean^2) / d)
    shrinkage = (den == 0) ? 1.0 : min(num / den, 1.0)
    shrunk = shrunk_matrix(covariance, shrinkage)

    translate_to_mu!(X, mu)

    return Symmetric(shrunk), mu
end

function fit!(estimator::OASCovariance, X::AbstractMatrix{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})::Nothing
    empirical!(estimator, X, covariance, mu)
    shrinkage = get_shrinkage(estimator, X, covariance)
    shrunk_matrix!(covariance, shrinkage)
    return nothing
end

function fit!(estimator::OASCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})::Nothing
    empirical!(estimator, X, weights, covariance, mu)
    shrinkage = get_shrinkage(estimator, X, covariance)
    shrunk_matrix!(covariance, shrinkage)
    return nothing
end
