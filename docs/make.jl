using Documenter, HaltonSequences

makedocs(sitename="HaltonSequences",
    pages = [
        "Index" => "index.md",
        "Functions and types" => "funcs.md"
        ],
    doctest = true
    )
