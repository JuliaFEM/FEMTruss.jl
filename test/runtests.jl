# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMTruss.jl/blob/master/LICENSE

using FEMBase
using FEMTruss

using Base.Test

@testset "FEMTruss.jl" begin

  elem1 = Element(Seg2, [1, 2]) # connects to nodes 1, 2
  elem1.id = 1
  X = Dict{Int64, Vector{Float64}}(
      1 => [0.0],
      2 => [10.0])

  update!(elem1, "geometry", X)
  update!(elem1, "youngs modulus", 288.0)
  update!(elem1, "cross section area", 0.1)
  p1 = Problem(Truss, "my truss problem", 1) # 1 dofs/node for now;
  empty!(p1.assembly)
  assemble!(p1.assembly, p1, elem1, 0.0)
  K_truss = full(p1.assembly.K)
  @test isapprox(K_truss, [2.88 -2.88;-2.88 2.88])

# now for the 2d case
X = Dict{Int64, Vector{Float64}}(
    1 => [0.0, 0.0],
    2 => [10.0, 0.0])

update!(elem1, "geometry", X)
p1 = Problem(Truss, "my truss problem", 2) # 1 dofs/node for now;
empty!(p1.assembly)
assemble!(p1.assembly, p1, elem1, 0.0)
K_truss = full(p1.assembly.K)
@test isapprox(K_truss, [2.88 0.0 -2.88 0.0; 0.0 0.0 0.0 0.0; -2.88 0.0 2.88 0.0; 0.0 0.0 0.0 0.0])

# now for the 3d case
X = Dict{Int64, Vector{Float64}}(
    1 => [0.0, 0.0, 0.0],
    2 => [10.0, 0.0, 0.0])

update!(elem1, "geometry", X)
p1 = Problem(Truss, "my truss problem", 3) # 1 dofs/node for now;
empty!(p1.assembly)
assemble!(p1.assembly, p1, elem1, 0.0)
K_truss = full(p1.assembly.K)
@test isapprox(K_truss, [2.88 0.0 0.0 -2.88 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0; -2.88 0.0 0.0  2.88 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0])

  # Need some boundary conditions and forces
  # simple truss along x axis
  #b1 = Element(Poi1, [1])
  #update!(b1, "displacement 1", 0.0)
  #f1 = Element(Poi1, [2]) # Point load
  #update!(f1, "displacement traction force 1", 10.0)
  #solver = Solver(Linear, p1, f1, b1)
  #solver()
  # u = 10*10/(288*0.1)

end