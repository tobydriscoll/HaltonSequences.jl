using Documenter, HaltonSequences

makedocs(sitename="HaltonSequences")

deploydocs(
    repo = "github.com/tobydriscoll/HaltonSequences.jl.git",
    deploy_config = Documenter.GitHubActions(),
)
    