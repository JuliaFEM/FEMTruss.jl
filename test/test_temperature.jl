# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMTruss.jl/blob/master/LICENSE

using FEMBase
using FEMBase.Test
using FEMTruss

@testset "FEMTrussTemperature.jl" begin
    E = 2e11
    A1 = 20e-4
    A2 = 15e-4
    X = Dict(1 => [3.0, 3.0],
             2 => [3.0, 0.0],
             3 => [0.0, 0.0],
             4 => [0.0, 3.0])
    el1 = Element(Seg2, [4,1])
    el2 = Element(Seg2, [3,1])
    el3 = Element(Seg2, [2,1])
    bel1 = Element(Poi1, [3])
    bel2 = Element(Poi1, [2])
    bel3 = Element(Poi1, [4])
    #bel4 = Element(Poi1, [1])
    elements = [el1, el2, el3, bel1, bel2, bel3]
    update!(elements, "geometry", X)

    update!([bel1, bel2, bel3], "fixed displacement 1", 0.0)
    update!([bel1, bel2, bel3], "fixed displacement 2", 0.0)
    #update!(bel4, "nodal force 2", 10)
    update!(elements, "youngs modulus", E)
    update!([el1,el3], "cross section area", A2)
    update!([el2], "cross section area", A1)

    lambda = 1/ 75000
    dt = 40
    update!([el2], "thermal expansion coefficient", lambda)
    update!([el2], "temperature difference", dt)

    problem = Problem(Truss, "test problem", 2)
    add_elements!(problem, elements)

    step = Analysis(Static)
    add_problems!(step, [problem])
    ls, normu, normla = run!(step)
    # Check deflections in top
    u_oracle = [0.00077645, 0.00077645]
    r_oracle = [0.0, -77645.0, +77645.0, +77645.0, -77645.0, 0.0]
    @test isapprox(ls.u[collect(1:2)], u_oracle,rtol=1e-5)
    @test isapprox(ls.la[collect(3:8)], r_oracle*-1.0, rtol=1e-5)

# Find element forces, these
    f1_oracle = [-77645.0, 77645.0]
    f2_oracle = [1.09807e5, -1.09807e5]
    K1,T1 = get_Kg_and_Tg(el1, 2,2, 0.0)
    f1 = get_F_local(el1,2,2, 0.0)
    f_loc1 = T1*K1*ls.u[[3,4, 1,2]]  +f1
    K2,T2 = get_Kg_and_Tg(el2, 2,2, 0.0)
    f2 = get_F_local(el2,2,2, 0.0)
    f_loc2 = T2*K2*ls.u[[5,6,1,2]] + f2
    @test isapprox(f_loc1, f1_oracle,rtol=1e-5)
    @test isapprox(f_loc2, f2_oracle,rtol=1e-5)

    # Lets verify the system
    #Stiffness Matrix assemble by hand
end
