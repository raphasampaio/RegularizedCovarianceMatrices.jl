import Pkg
Pkg.activate(dirname(@__DIR__))
Pkg.instantiate()
using RegularizedCovariances

Pkg.activate(@__DIR__)
Pkg.instantiate()
using Documenter

makedocs(;
    modules = [RegularizedCovariances],
    doctest = true,
    clean = true,
    format = Documenter.HTML(mathengine = Documenter.MathJax2()),
    sitename = "RegularizedCovariances.jl",
    pages = ["Home" => "index.md"],
)
