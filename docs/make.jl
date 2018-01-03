# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMBase.jl/blob/master/LICENSE

using Documenter, FEMTruss

# copy README.md to index.md to avoid DRY
cp("../README.md", "src/index.md"; remove_destination=true)

makedocs(modules=[FEMTruss],
         format = :html,
         checkdocs = :all,
         sitename = "FEMTruss.jl",
         pages = [
                  "Introduction" => "index.md",
                 ])
