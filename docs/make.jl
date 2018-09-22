using Documenter, HaltonSequences

makedocs(sitename="HaltonSequences",
    pages = [
        "Index" => "index.md",
        "Functions and types" => "funcs.md"
        ],
    doctest = true
    )

deploydocs(
    repo = "github.com/tobydriscoll/HaltonSequences.jl.git",
    julia = "0.7"
)
    