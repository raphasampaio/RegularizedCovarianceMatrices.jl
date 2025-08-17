using Documenter
using RegularizedCovarianceMatrices

DocMeta.setdocmeta!(
    RegularizedCovarianceMatrices,
    :DocTestSetup,
    :(using RegularizedCovarianceMatrices);
    recursive = true,
)

makedocs(
    sitename = "RegularizedCovarianceMatrices",
    modules = [RegularizedCovarianceMatrices],
    authors = "Raphael Araujo Sampaio and Joaquim Dias Garcia and Marcus Poggi and Thibaut Vidal",
    repo = "https://github.com/raphasampaio/RegularizedCovarianceMatrices.jl/blob/{commit}{path}#{line}",
    doctest = true,
    clean = true,
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://raphasampaio.github.io/RegularizedCovarianceMatrices.jl",
        edit_link = "main",
        assets = [
            "assets/favicon.ico",
        ],
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/raphasampaio/RegularizedCovarianceMatrices.jl.git",
    devbranch = "main",
    push_preview = true,
)
