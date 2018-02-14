# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMTruss.jl/blob/master/LICENSE

using FEMBase
using FEMTruss
using FEMBase: get_formulation_type

using Base.Test
# thsi is the same for all tests testing K and orientation
function make_test_problem(coords::Vector{Tuple{Int64, Vector{Float64}}}, dim::Int64, t::Float64=0.0)
    elem_id = map(x->x[1], coords)
    coord_dict=Dict(coords)
    elem1 = Element(Seg2, elem_id) # connects to nodes 1, 2
    elem1.id = 1
    update!(elem1, "geometry", coord_dict)
    update!(elem1, "youngs modulus", 288.0)
    update!(elem1, "cross section area", 0.1)
    p1 = Problem(Truss, "my truss problem", dim) # 1 dofs/node for now;
    empty!(p1.assembly)
    assemble!(p1.assembly, p1, elem1, t)
    return p1
end

@testset "FEMTrussElements.jl" begin

zeros_2d = zeros(1,2)
zeros_3d = zeros(1,3)
K_oracle_base =  [2.88 -2.88;-2.88 2.88]
#truss test
X = [(1 , [0.0]),(2, [10.0])]
ndofs = length(X[1][2])
p1 = make_test_problem(X, ndofs)

@test get_unknown_field_name(p1)=="displacement"

#This one fails
#Test threw an exception of type UndefVarError
#  Expression: get_formulation_type(p1)
#  UndefVarError: get_formulation_type not defined
@test get_formulation_type(p1) == :total

K_truss = full(p1.assembly.K)
K_oracle =  K_oracle_base
@test isapprox(K_truss, K_oracle)

# now for the 2d x case
X = [(1 , [0.0,0.0]),(2, [10.0,0.0])]
ndofs = length(X[1][2])
p1 = make_test_problem(X, ndofs)
K_truss = full(p1.assembly.K)
trans_2d = [1 0]
trans = [trans_2d zeros_2d;zeros_2d trans_2d]
K_oracle = trans'*K_oracle_base*trans
@test isapprox(K_truss, K_oracle)

# lets do y as well
X = [(1 , [0.0,0.0]),(2, [0.0,10.0])]
ndofs = length(X[1][2])
p1 = make_test_problem(X, ndofs)
K_truss = full(p1.assembly.K)
trans_2d = [0 1]
trans = [trans_2d zeros_2d;zeros_2d trans_2d]
K_oracle = trans'*K_oracle_base*trans
@test isapprox(K_truss, K_oracle)

# now for the 2d x case reverted
X = [(2 , [0.0,0.0]),(1, [10.0,0.0])]
ndofs = length(X[1][2])
p1 = make_test_problem(X, ndofs)
K_truss = full(p1.assembly.K)
trans_2d = [-1 0]
trans = [trans_2d zeros_2d;zeros_2d trans_2d]
K_oracle = trans'*K_oracle_base*trans
@test isapprox(K_truss, K_oracle)

# lets do y as well reverted
X = [(2 , [0.0,0.0]),(1, [0.0,10.0])]
ndofs = length(X[1][2])
p1 = make_test_problem(X, ndofs)
K_truss = full(p1.assembly.K)
trans_2d = [0 -1]
trans = [trans_2d zeros_2d;zeros_2d trans_2d]
K_oracle = trans'*K_oracle_base*trans
@test isapprox(K_truss, K_oracle)

# now for the 3d case
X = [(1 , [0.0,0.0,0.0]),(2, [10.0,0.0,0.0])]
ndofs = length(X[1][2])
p1 = make_test_problem(X, ndofs)
K_truss = full(p1.assembly.K)
trans_3d = [1 0 0]
trans = [trans_3d zeros_3d;zeros_3d trans_3d]
K_oracle = trans'*K_oracle_base*trans
@test isapprox(K_truss, K_oracle)

end
