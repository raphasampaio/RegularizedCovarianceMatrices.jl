struct LedoitWolfCovarianceMatrix <: CovarianceMatrixEstimator
    n::Int
    d::Int
    cache1::Matrix{Float64}
    cache2::Matrix{Float64}
    cache3::Matrix{Float64}

    function LedoitWolfCovarianceMatrix(n::Integer = 0, d::Integer = 0)
        return new(n, d, zeros(n, d), zeros(n, d), zeros(d, d))
    end
end

function get_shrinkage(
    estimator::LedoitWolfCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real},
)
    n, d = size(X)

    @assert n == estimator.n
    @assert d == estimator.d

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
    beta_coefficients = sum(estimator.cache3)

    mul!(estimator.cache3, estimator.cache1', estimator.cache1)
    estimator.cache3 .= estimator.cache3 .^ 2
    delta_coefficients = sum(estimator.cache3) / (n^2)

    beta = 1.0 / (n * d) * (beta_coefficients / n - delta_coefficients)
    delta = (delta_coefficients - 2.0 * trace_mean * trace_sum + d * trace_mean .^ 2) / d

    beta = min(beta, delta)
    return (beta <= 0) ? 0.0 : beta / delta
end

function fit(
    estimator::LedoitWolfCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights = ones(size(X, 1)),
    mu = dropdims(sum(X .* weights, dims = 1) / sum(weights), dims = 1),
)
    n = size(X, 1)
    d = size(X, 2)

    translate_to_zero!(X, mu)

    X2 = X .^ 2
    trace = sum(X2, dims = 1) / n
    trace_mean = sum(trace) / d
    beta_coefficients = 0.0
    delta_coefficients = 0.0

    delta_coefficients += sum((X' * X) .^ 2)
    delta_coefficients /= (n^2)

    beta_coefficients += sum(X2' * X2)

    beta = 1.0 / (n * d) * (beta_coefficients / n - delta_coefficients)
    delta = delta_coefficients - 2.0 * trace_mean * sum(trace) + d * trace_mean .^ 2

    delta /= d
    beta = min(beta, delta)
    λ = (beta == 0) ? 0.0 : beta / delta

    translate_to_mu!(X, mu)

    return shrunk(estimator, X, weights, mu = mu, λ = λ)
end

function fit!(
    estimator::LedoitWolfCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real},
)
    update_mu!(X, mu)
    λ = get_shrinkage(estimator, X, mu)
    return shrunk!(estimator, X, covariance, mu, λ = λ)
end

function fit!(
    estimator::LedoitWolfCovarianceMatrix,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real},
)
    update_mu!(X, weights, mu)
    λ = get_shrinkage(estimator, X, mu)
    shrunk!(estimator, X, weights, covariance, mu, λ = λ)
    return
end
