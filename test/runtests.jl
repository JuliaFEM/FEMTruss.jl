# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMTruss.jl/blob/master/LICENSE

using Base.Test
using TimerOutputs
const to = TimerOutput()

test_files = String[]
push!(test_files, "test_elements.jl")
push!(test_files, "test_problems.jl")

@testset "FEMTruss.jl" begin
    for fn in test_files
        timeit(to, fn) do
            include(fn)
        end
    end
end
println()
println("Test statistics:")
println(to)

  # Need some boundary conditions and forces
  # simple truss along x axis
  #b1 = Element(Poi1, [1])
  #update!(b1, "displacement 1", 0.0)
  #f1 = Element(Poi1, [2]) # Point load
  #update!(f1, "displacement traction force 1", 10.0)
  #solver = Solver(Linear, p1, f1, b1)
  #solver()
  # u = 10*10/(288*0.1)
