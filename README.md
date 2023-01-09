# RegularizedCovarianceMatrices.jl

<div align="center">
    <a href="/docs/src/assets/">
        <img src="/docs/src/assets/logo.svg" width=300px alt="RegularizedCovarianceMatrices.jl" />
    </a>
    <br>
    <br>
    <a href="https://raphasampaio.github.io/RegularizedCovarianceMatrices.jl/stable">
        <img src="https://img.shields.io/badge/docs-stable-blue.svg" alt="Stable">
    </a>
    <a href="https://raphasampaio.github.io/RegularizedCovarianceMatrices.jl/dev">
        <img src="https://img.shields.io/badge/docs-dev-blue.svg" alt="Dev">
    </a>
    <a href="https://pkgs.genieframework.com?packages=RegularizedCovarianceMatrices">
        <img src="https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/RegularizedCovarianceMatrices/label:-sep:">
    </a>
    <br>
    <a href="https://github.com/raphasampaio/RegularizedCovarianceMatrices.jl/actions/workflows/CI.yml">
        <img src="https://github.com/raphasampaio/RegularizedCovarianceMatrices.jl/actions/workflows/CI.yml/badge.svg" alt="CI"/>
    </a>
    <a href="https://codecov.io/gh/raphasampaio/RegularizedCovarianceMatrices.jl">
        <img src="https://codecov.io/gh/raphasampaio/RegularizedCovarianceMatrices.jl/branch/main/graph/badge.svg" alt="Coverage"/>
    </a>
    <a href="https://github.com/JuliaTesting/Aqua.jl">
        <img src="https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg" alt="Coverage"/>
    </a>
</div>

## Introduction
RegularizedCovarianceMatrices.jl is a Julia package that implements several regularized covariance matrices estimations.

## Getting Started

### Installation

```julia
julia> ] add RegularizedCovarianceMatrices
```

### Example
```julia
using RegularizedCovarianceMatrices

n = 100
d = 2

data = rand(n, d)

estimator = EmpiricalCovarianceMatrix(n, d)
covariance_matrix = RegularizedCovarianceMatrices.fit(estimator, data)

```