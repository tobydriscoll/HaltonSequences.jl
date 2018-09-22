using Documenter, HaltonSequences

makedocs(sitename="HaltonSequences",
    format = :html,
    authors = "Toby Driscoll",
    pages = [
        "Home" => "index.md",
        "Functions and types" => "funcs.md"
        ],
    doctest = true
    )

deploydocs(
    repo = "github.com/tobydriscoll/HaltonSequences.jl.git",
    julia = "0.7",
    deps = nothing,
    make = nothing
)
    