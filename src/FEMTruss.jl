# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/FEMTruss.jl/blob/master/LICENSE

""" Truss implementation for JuliaFEM. """
module FEMTruss

using FEMBase

import FEMBase: get_unknown_field_name,
                get_formulation_type,
                assemble!

"""
This truss fromulation is from
"""
type Truss <: FieldProblem
end

function get_unknown_field_name(::Problem{Truss})
    return "displacement"
end

function get_formulation_type(::Problem{Truss})
    return :total
end

"""
    assemble!(assembly:Assembly, problem::Problem{Elasticity}, elements, time)
Start finite element assembly procedure for Elasticity problem.
Function groups elements to arrays by their type and assembles one element type
at time. This makes it possible to pre-allocate matrices common to same type
of elements.
"""
function assemble!(assembly::Assembly, problem::Problem{Truss},
                   element::Element{Seg2}, time)
    #Require that the number of nodes = 2 ?
    nnodes = length(element)
    ndim = get_unknown_field_dimension(problem)
    ndofs = nnodes*ndim
    K = zeros(ndofs,ndofs)
    node_id1 = element.connectivity[1] #First node in element
    node_id2 = element.connectivity[2] #second node in elements
    pos = element("geometry")
    dl = pos[node_id2]-pos[node_id1];
    l = sqrt(dot(dl,dl));
    # Do the local element for calculations
    loc_elem = Element(Seg2, [1,2])
    loc_elem.id=-1 # To signal it is local
    X = Dict{Int64, Vector{Float64}}(
        1 => [0.0],
        2 => [l])
    update!(loc_elem, "geometry", X)
    update!(loc_elem, "youngs modulus", element("youngs modulus"))
    update!(loc_elem, "cross section area", element("cross section area"))
    K_loc = zeros(nnodes, nnodes)
    for ip in get_integration_points(loc_elem)
        dN = loc_elem(ip, time, Val{:Grad})
        detJ = loc_elem(ip, time, Val{:detJ})
        A = loc_elem("cross section area", ip, time)
        E = loc_elem("youngs modulus", ip, time)
        K_loc += ip.weight*E*A*dN'*dN*detJ
    end
    # Should we keep the local transform
    if ndim == 1
        K = K_loc
    elseif ndim == 2
        l_theta = dl[1]/l
        m_theta = dl[2]/l
        L = [l_theta m_theta 0 0; 0 0 l_theta m_theta]
        K = L'*K_loc*L
    else # All three dimensions
        l_theta = dl[1]/l
        m_theta = dl[2]/l
        n_theta = dl[3]/l
        L = [l_theta m_theta n_theta 0 0 0; 0 0 0 l_theta m_theta n_theta]
        K = L'*K_loc*L
    end

    gdofs = get_gdofs(problem, element)
    add!(assembly.K, gdofs, gdofs, K)
    #add!(assembly.f, gdofs, f)
end

export Truss

end
