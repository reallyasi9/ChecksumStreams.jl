using ChecksumStreams
using Documenter

DocMeta.setdocmeta!(ChecksumStreams, :DocTestSetup, :(using ChecksumStreams); recursive=true)

makedocs(;
    modules=[ChecksumStreams],
    authors="Phil Killewald <reallyasi9@users.noreply.github.com> and contributors",
    sitename="ChecksumStreams.jl",
    format=Documenter.HTML(;
        canonical="https://reallyasi9.github.io/ChecksumStreams.jl",
        edit_link="dev",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/reallyasi9/ChecksumStreams.jl",
    devbranch="dev",
)
