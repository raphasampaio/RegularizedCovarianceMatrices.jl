<div align="center"><img src="/docs/src/assets/logo.svg" width=250px alt="RegularizedCovarianceMatrices.jl"></img></div>

# RegularizedCovarianceMatrices.jl

[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://raphasampaio.github.io/RegularizedCovarianceMatrices.jl/stable)
[![CI](https://github.com/raphasampaio/RegularizedCovarianceMatrices.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/raphasampaio/RegularizedCovarianceMatrices.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/raphasampaio/RegularizedCovarianceMatrices.jl/graph/badge.svg?token=VVRUZRIAYQ)](https://codecov.io/gh/raphasampaio/RegularizedCovarianceMatrices.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

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

estimator = ShrunkCovarianceMatrix(n, d, 0.1)
covariance_matrix = RegularizedCovarianceMatrices.fit(estimator, data)

```

### Cite

```bibtex
@article{sampaio2024regularization,
  title={Regularization and optimization in model-based clustering},
  author={Sampaio, Raphael Araujo and Garcia, Joaquim Dias and Poggi, Marcus and Vidal, Thibaut},
  journal={Pattern Recognition},
  pages={110310},
  year={2024},
  publisher={Elsevier}
}
```
