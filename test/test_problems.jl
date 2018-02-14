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
    println("K = ", full(ls.K))
    println("f = ", full(ls.f))
    println("u = ", full(ls.u))
    println("la = ", full(ls.la))
end
