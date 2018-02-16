# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMTruss.jl/blob/master/LICENSE

using FEMBase
using FEMBase.Test
using FEMTruss

@testset "FEMTrussProblems.jl" begin
    E = 400.0*sqrt(5)
    A = 0.1
    Fx = 6.4*sqrt(2)
    Fy = 1.6*sqrt(2)
    X = Dict(1 => [0.0, 0.0],
             2 => [0.0, 1.0],
             3 => [1.0, 0.5])
    el1 = Element(Seg2, [1, 3])
    el2 = Element(Seg2, [2, 3])
    bel1 = Element(Poi1, [1])
    bel2 = Element(Poi1, [2])
    bel3 = Element(Poi1, [3])
    elements = [el1, el2, bel1, bel2, bel3]
    update!(elements, "geometry", X)

    update!([bel1, bel2], "fixed displacement 1", 0.0)
    update!([bel1, bel2], "fixed displacement 2", 0.0)
    update!(bel3, "nodal force 1", Fx)
    update!(bel3, "nodal force 2", Fy)
    update!(elements, "youngs modulus", E)
    update!(elements, "cross section area", A)

    problem = Problem(Truss, "test problem", 2)
    add_elements!(problem, elements)

    # solution
    step = Analysis(Static)
    add_problems!(step, [problem])
    ls, normu, normla = run!(step)
    # Lets verify the system
    #Stiffness Matrix assemble by hand
    l = sqrt(0.5^2+1^2)
    K_loc = E*A/l*[1 -1; -1 1]
    l1 = 1/l
    m1 = 0.5/l
    T1 = [l1 m1 0 0; 0 0 l1 m1]
    K1 = T1'*K_loc*T1
    T2 = [l1 -m1 0 0; 0 0 l1 -m1]
    K2 = T2'*K_loc*T2
    K_glob = zeros(6,6)
    K_glob[3:6,3:6]+=K2
    K_glob[1:2, 1:2] += K1[1:2,1:2]
    K_glob[5:6, 1:2] += K1[3:4, 1:2]
    K_glob[1:2, 5:6] += K1[1:2, 3:4]
    K_glob[5:6, 5:6] += K1[3:4, 3:4]

    @test isapprox(full(ls.K), K_glob)

    # Forces are ok
    f_glob = zeros(6);
    f_glob[5:6]=[Fx,Fy]
    @test isapprox(full(ls.f), f_glob)

    # deflections
    u_glob = zeros(6)
    u_glob[5:6] = K_glob[5:6,5:6]\f_glob[5:6]
    @test isapprox(full(ls.u), u_glob)

    # support forces
    support_forces = full(ls.K*ls.u)[1:4]
    # This is the same as ls.la negated
    # println("la = ", full(ls.la))
    # The support forces from Sofistik
    Rf = [-6.78823, -3.39411, -2.26274, 1.13137]
    @test isapprox(support_forces, Rf, rtol=1e-5)
    #find local truss Forces
    K1,T1 = get_Kg_and_Tg(el1, 2,2, 0.0)
    f_loc1 = T1*K1*ls.u[[1,2,5,6]] # No local forces her to add_elements
    # both element forces should be stretch, item1 is negative
    @test isapprox(-f_loc1[1], f_loc1[2])
    @test isapprox(f_loc1[2], 7.58947, rtol=1e-5)
    K2,T2 = get_Kg_and_Tg(el2, 2,2, 0.0)
    f_loc2 = T2*K2*ls.u[3:6]
    @test isapprox(-f_loc2[1], f_loc2[2])
    @test isapprox(f_loc2[2], 2.52982,rtol=1e-5)
end
