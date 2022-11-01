function test_shrunk(original_X::Matrix{Float64}, original_weights::Vector{Float64})
    n, d = size(original_X)
    estimator = RegularizedCovariances.ShrunkCovarianceMatrix(n, d)

    X = copy(original_X)
    weights = copy(original_weights)

    @timeit "not-in-place - sklearn" begin
        sklearn_fitted = fit!(ShrunkCovariance(), X)
        sklearn_mu = sklearn_fitted.location_
        sklean_covariance = sklearn_fitted.covariance_
    end

    X = copy(original_X)
    weights = copy(original_weights)
    mu = zeros(d)
    covariance = zeros(d, d)

    @timeit "not-in-place" covariance, mu = fit(estimator, X)
    @test X ≈ original_X
    @test covariance ≈ sklean_covariance
    @test mu ≈ sklearn_mu

    X = copy(original_X)
    weights = copy(original_weights)
    mu = zeros(d)
    covariance = zeros(d, d)

    @timeit "in-place" RegularizedCovariances.fit!(estimator, X, covariance, mu)
    @test X ≈ original_X
    @test covariance ≈ sklean_covariance
    @test mu ≈ sklearn_mu

    X = copy(original_X)
    weights = copy(original_weights)
    mu = zeros(d)
    covariance = zeros(d, d)

    @timeit "weights - not-in-place" weights_covariance, weights_mu = RegularizedCovariances.fit(estimator, X, weights)
    @test X ≈ original_X

    X = copy(original_X)
    weights = copy(original_weights)
    mu = zeros(d)
    covariance = zeros(d, d)

    @timeit "weights - in-place" RegularizedCovariances.fit!(estimator, X, weights, covariance, mu)
    @test original_X ≈ X
    @test weights_covariance ≈ covariance
    @test weights_mu ≈ mu
end
