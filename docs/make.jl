import Pkg
Pkg.instantiate()

using Documenter
using RegularizedCovarianceMatrices

DocMeta.setdocmeta!(
    RegularizedCovarianceMatrices, 
    :DocTestSetup, 
    :(using RegularizedCovarianceMatrices);
    recursive=true
)

makedocs(;
    modules=[RegularizedCovarianceMatrices],
    doctest=true,
    clean=true,
    authors="Raphael Araujo Sampaio and Joaquim Dias Garcia and Marcus Poggi and Thibaut Vidal",
    repo="https://github.com/raphasampaio/RegularizedCovarianceMatrices.jl/blob/{commit}{path}#{line}",
    sitename="RegularizedCovarianceMatrices.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://raphasampaio.github.io/RegularizedCovarianceMatrices.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/raphasampaio/RegularizedCovarianceMatrices.jl.git",
    devbranch="main",
    push_preview = true,
)
