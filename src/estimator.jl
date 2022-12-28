abstract type CovarianceMatrixEstimator end

function empirical(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X)
)
    n, d = size(X)
    translated = (X .- mu')
    covariance = (translated' * translated) ./ n
    return covariance, mu
end

function empirical(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X, weights)
)
    translated = X .- mu'
    covariance = (translated' * (weights .* translated)) ./ sum(weights)
    return covariance, mu
end

function empirical!(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real}
)
    n, d = size(X)

    update_mu!(X, mu)

    estimator.cache1 .= X .- mu'
    mul!(covariance, estimator.cache1', estimator.cache1)
    covariance ./= n

    return
end

function empirical!(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real}
)
    update_mu!(X, weights, mu)

    estimator.cache1 .= X .- mu'
    estimator.cache2 .= weights .* estimator.cache1

    mul!(covariance, estimator.cache1', estimator.cache2)
    covariance ./= sum(weights)

    return
end

function shrunk(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X),
    shrinkage::Float64 = 0.1
)
    covariance, mu = empirical(estimator, X, mu = mu)
    shrunk = shrunk_matrix(covariance, shrinkage)
    return Symmetric(shrunk), mu
end

function shrunk(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real};
    mu::AbstractVector{<:Real} = get_mu(X, weights),
    shrinkage::Float64 = 0.1
)
    covariance, mu = empirical(estimator, X, weights, mu = mu)
    shrunk = shrunk_matrix(covariance, shrinkage)
    return Symmetric(shrunk), mu
end

function shrunk!(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real};
    shrinkage::Float64 = 0.1
)
    empirical!(estimator, X, covariance, mu)
    shrunk_matrix!(covariance, shrinkage)
    return
end

function shrunk!(
    estimator::CovarianceMatrixEstimator,
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    covariance::AbstractMatrix{<:Real},
    mu::AbstractVector{<:Real};
    shrinkage::Float64 = 0.1
)
    empirical!(estimator, X, weights, covariance, mu)
    shrunk_matrix!(covariance, shrinkage)
    return
end

function get_mu(X::AbstractMatrix{<:Real})
    return dropdims(sum(X, dims = 1) / size(X, 1), dims = 1)
end

function get_mu(X::AbstractMatrix{<:Real}, weights::AbstractVector{<:Real})
    return dropdims(sum(X .* weights, dims = 1) / sum(weights), dims = 1)
end

function update_mu!(X::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    n, d = size(X)

    for i in 1:d
        mu[i] = 0
        for j in 1:n
            mu[i] += X[j, i]
        end
        mu[i] /= n
    end
end

function update_mu!(
    X::AbstractMatrix{<:Real},
    weights::AbstractVector{<:Real},
    mu::AbstractVector{<:Real}
)
    n, d = size(X)

    sum_weights = sum(weights)

    for i in 1:d
        mu[i] = 0
        for j in 1:n
            mu[i] += weights[j] * X[j, i]
        end
        mu[i] /= sum_weights
    end
end

function shrunk_matrix(covariance::AbstractMatrix{<:Real}, shrinkage::Float64)
    d = size(covariance, 2)

    trace_mean = tr(covariance) / d
    shrunk = (1.0 - shrinkage) * covariance
    for i in 1:d
        shrunk[i, i] += shrinkage * trace_mean
    end
    return shrunk
end

function shrunk_matrix!(covariance::AbstractMatrix{<:Real}, λ::Float64)
    d = size(covariance, 2)

    trace_shrinkage = λ * (tr(covariance) / d)
    covariance .= (1.0 - λ) .* covariance
    for i in 1:d
        covariance[i, i] += trace_shrinkage
    end
    return
end

function translate_to_zero!(X::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    n, d = size(X)

    for j in 1:d, i in 1:n
        X[i, j] = X[i, j] - mu[j]
    end
end

function translate_to_mu!(X::AbstractMatrix{<:Real}, mu::AbstractVector{<:Real})
    n, d = size(X)

    for j in 1:d, i in 1:n
        X[i, j] = X[i, j] + mu[j]
    end
end
