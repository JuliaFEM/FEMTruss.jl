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
Concepts and applications of finite element analysis, forth edition
Chapter 2.4
Cook, Malkus, Plesha, Witt

# Features
- Nodal forces can be set using element `Poi1` with field
  `nodal force i`, where `i` is dof number.
- Displacements can be fixed using element `Poi1` with field
  `fixed displacement i`, where `i` is dof number.
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
   get_Kg_and_Tg(element::Element{Seg2}, nnodes, ndim, time)
   This function assembles the local stiffness uses global transformation matrix
   to make the global version of the local stiffnes matrix
   Need these to find element forces later
   Will need to change allocation strategy to pre-allocation later
   Can discuss if we really need nnodes, since that is always 2 for trusses
"""
function get_Kg_and_Tg(element::Element{Seg2}, nnodes, ndim, time)
    ndofs = nnodes*ndim
    K = zeros(ndofs,ndofs)
    T = zeros(2, ndofs*2)
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

    if ndim == 1
        K = K_loc
    elseif ndim == 2
        l_theta = dl[1]/l
        m_theta = dl[2]/l
        T = [l_theta m_theta 0 0; 0 0 l_theta m_theta]
        K = T'*K_loc*T
    else # All three dimensions
        l_theta = dl[1]/l
        m_theta = dl[2]/l
        n_theta = dl[3]/l
        T = [l_theta m_theta n_theta 0 0 0; 0 0 0 l_theta m_theta n_theta]
        K = T'*K_loc*T
    end
    return (K,T)
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
    K,T = get_Kg_and_Tg(element, nnodes, ndim, time)
    gdofs = get_gdofs(problem, element)
    add!(assembly.K, gdofs, gdofs, K)
    #add!(assembly.f, gdofs, f)
end

import FEMBase: assemble_elements!

function assemble_elements!(problem::Problem, assembly::Assembly,
                            elements::Vector{Element{Poi1}}, time::Float64)
    dim = ndofs = get_unknown_field_dimension(problem)
    Ce = zeros(ndofs,ndofs)
    ge = zeros(ndofs)
    fe = zeros(ndofs)
    for element in elements
        fill!(Ce, 0.0)
        fill!(ge, 0.0)
        fill!(fe, 0.0)
        ip = (0.0,)
        for i=1:dim
            if haskey(element, "fixed displacement $i")
                Ce[i,i] = 1.0
                ge[i] = element("fixed displacement $i", ip, time)
            end
            if haskey(element, "nodal force $i")
                fe[i] = element("nodal force $i", ip, time)
            end
        end
        gdofs = get_gdofs(problem, element)
        add!(assembly.C1, gdofs, gdofs, Ce)
        add!(assembly.C2, gdofs, gdofs, Ce)
        add!(assembly.g, gdofs, ge)
        add!(assembly.f, gdofs, fe)
    end
end

export Truss, get_Kg_and_Tg

end
