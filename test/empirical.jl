function test_empirical()
    size = 10
    dimensions = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]

    Random.seed!(1)
    for i in 1:size, n in dimensions, d in dimensions
        if n > d
            X = rand(n, d)
            X_copy = copy(X)

            weights = rand(n)
            weights_copy = copy(weights)

            estimator = EmpiricalCovarianceMatrix(n, d)
            @timeit "rcm" covariance, mu = RegularizedCovarianceMatrices.fit(estimator, X)
            @test X == X_copy

            @timeit "base" covariance_base = Statistics.cov(X, corrected = false)
            @test X == X_copy
            @test covariance ≈ covariance_base

            @timeit "statsbase" covariance_statsbase = StatsBase.cov(X, corrected = false)
            @test X == X_copy
            @test covariance ≈ covariance_statsbase

            mu_inplace = zeros(d)
            covariance_inplace = zeros(d, d)
            estimator = EmpiricalCovarianceMatrix(n, d)
            @timeit "rcm in-place" RegularizedCovarianceMatrices.fit!(estimator, X, covariance_inplace, mu_inplace)
            @test X == X_copy
            @test covariance ≈ covariance_inplace
            @test mu ≈ mu_inplace

            @timeit "rcm weighted" covariance, mu = RegularizedCovarianceMatrices.fit(estimator, X, weights)
            @test X == X_copy
            @test weights == weights_copy

            @timeit "statsbase weighted" covariance_statsbase = StatsBase.cov(X, Weights(weights), corrected = false)
            @test X == X_copy
            @test weights == weights_copy
            @test covariance ≈ covariance_statsbase

            mu_inplace = zeros(d)
            covariance_inplace = zeros(d, d)
            @timeit "rcm weighted in-place" RegularizedCovarianceMatrices.fit!(
                estimator,
                X,
                weights,
                covariance_inplace,
                mu_inplace,
            )
            @test X == X_copy
            @test weights == weights_copy
            @test covariance ≈ covariance_inplace
            @test mu ≈ mu_inplace
        end
    end
end
