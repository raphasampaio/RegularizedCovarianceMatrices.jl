import Pkg
Pkg.activate(dirname(@__DIR__))
Pkg.instantiate()
using RegularizedCovarianceMatrices

Pkg.activate(@__DIR__)
Pkg.instantiate()
using Documenter

makedocs(;
    modules = [RegularizedCovarianceMatrices],
    doctest = true,
    clean = true,
    format = Documenter.HTML(mathengine = Documenter.MathJax2()),
    sitename = "RegularizedCovarianceMatrices.jl",
    pages = ["Home" => "index.md"],
)
