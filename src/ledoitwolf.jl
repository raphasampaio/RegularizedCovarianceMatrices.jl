struct LedoitWolfCovariance <: CovarianceEstimator
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}
    cache3::Matrix{Float64}

    function LedoitWolfCovariance()
        return new(zeros(0, 0), zeros(0, 0), zeros(0, 0))
    end

    function LedoitWolfCovariance(n::Int, d::Int)
        return new(zeros(n, d), zeros(n, d), zeros(d, d))
    end
end

function update_cache!(estimator::LedoitWolfCovariance, n::Int, d::Int)
    if n != size(estimator.cache1, 1) || d != size(estimator.cache1, 2)
        estimator.cache1 = zeros(n, d)
        estimator.cache2 = zeros(n, d)
        estimator.cache3 = zeros(d, d)
    end
end

function get_shrinkage(estimator::LedoitWolfCovariance, X::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    n, d = size(X)
    update_cache!(estimator, n, d)

    block_size = 1000
    n_splits = round(n / block_size)

    estimator.cache1 .= X .- mu'
    estimator.cache2 .= estimator.cache1 .^ 2

    trace_mean = 0
    trace_sum = 0
    for i in 1:d
        s = 0
        for j in 1:n
            s += estimator.cache2[j, i]
        end
        trace_sum += s / n
    end
    trace_mean = trace_sum / d

    mul!(estimator.cache3, estimator.cache2', estimator.cache2)
    beta_ = sum(estimator.cache3)

    mul!(estimator.cache3, estimator.cache1', estimator.cache1)
    estimator.cache3 .= estimator.cache3 .^ 2
    delta_ = sum(estimator.cache3) / (n^2)

    beta = 1.0 / (n * d) * (beta_ / n - delta_)
    delta = (delta_ - 2.0 * trace_mean * trace_sum + d * trace_mean .^ 2) / d

    beta = min(beta, delta)
    return (beta <= 0) ? 0.0 : beta / delta
end

function fit(estimator::LedoitWolfCovariance, X::AbstractMatrix{<:Real}, weights = ones(size(X, 1)), mu = dropdims(sum(X .* weights, dims = 1) / sum(weights), dims = 1))
    n = size(X, 1)
    d = size(X, 2)
    block_size = 1000

    translate_to_zero!(X, mu)

    n_splits = round(n / block_size)

    X2 = X .^ 2
    emp_cov_trace = sum(X2, dims = 1) / n
    trace_mean = sum(emp_cov_trace) / d
    beta_ = 0.0  # sum of the coefficients of <X2.T, X2>
    delta_ = 0.0  # sum of the *squared* coefficients of <X.T, X>
    # starting block computation

    delta_ += sum((X' * X) .^ 2)
    delta_ /= (n^2)

    beta_ += sum(X2' * X2)

    beta = 1.0 / (n * d) * (beta_ / n - delta_)
    delta = delta_ - 2.0 * trace_mean * sum(emp_cov_trace) + d * trace_mean .^ 2

    delta /= d
    beta = min(beta, delta)
    shrinkage = (beta == 0) ? 0.0 : beta / delta

    translate_to_mu!(X, mu)

    return shrunk(estimator, X, weights, mu = mu, shrinkage = shrinkage)
end

function fit!(estimator::LedoitWolfCovariance, X::AbstractMatrix{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    update_mu!(X, mu)
    shrinkage = get_shrinkage(estimator, X, mu)
    return shrunk!(estimator, X, covariance, mu, shrinkage = shrinkage)
end

function fit!(estimator::LedoitWolfCovariance, X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real}, covariance::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    update_mu!(X, weights, mu)
    shrinkage = get_shrinkage(estimator, X, mu)
    return shrunk!(estimator, X, weights, covariance, mu, shrinkage = shrinkage)
end