var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": "(Image: Build Status)(Image: Coverage Status)(Image: )(Image: )(Image: Issues)Truss implementation for JuliaFEM."
},

{
    "location": "api.html#",
    "page": "API documentation",
    "title": "API documentation",
    "category": "page",
    "text": ""
},

{
    "location": "api.html#API-documentation-1",
    "page": "API documentation",
    "title": "API documentation",
    "category": "section",
    "text": ""
},

{
    "location": "api.html#FEMTruss",
    "page": "API documentation",
    "title": "FEMTruss",
    "category": "module",
    "text": "Truss implementation for JuliaFEM. \n\n\n\n"
},

{
    "location": "api.html#FEMTruss.Truss",
    "page": "API documentation",
    "title": "FEMTruss.Truss",
    "category": "type",
    "text": "This truss fromulation is from Concepts and applications of finite element analysis, forth edition Chapter 2.4 Cook, Malkus, Plesha, Witt\n\nFeatures\n\nNodal forces can be set using element Poi1 with field nodal force i, where i is dof number.\nDisplacements can be fixed using element Poi1 with field fixed displacement i, where i is dof number.\nTemperature loads can be set by setting field thermal expansion coefficient and field temperature difference\n\n\n\n"
},

{
    "location": "api.html#FEMTruss.get_Kg_and_Tg-Tuple{FEMBase.Element{FEMBasis.Seg2},Any,Any,Any}",
    "page": "API documentation",
    "title": "FEMTruss.get_Kg_and_Tg",
    "category": "method",
    "text": "get_Kg_and_Tg(element::Element{Seg2}, nnodes, ndim, time)    This function assembles the local stiffness uses global transformation matrix    to make the global version of the local stiffnes matrix    Will need to change allocation strategy to pre-allocation later    Can discuss if we really need nnodes, since that is always 2 for trusses\n\n\n\n"
},

{
    "location": "api.html#FEMBase.assemble!-Tuple{FEMBase.Assembly,FEMBase.Problem{FEMTruss.Truss},FEMBase.Element{FEMBasis.Seg2},Any}",
    "page": "API documentation",
    "title": "FEMBase.assemble!",
    "category": "method",
    "text": "assemble!(assembly:Assembly, problem::Problem{Elasticity}, elements, time)\n\nStart finite element assembly procedure for Elasticity problem. Function groups elements to arrays by their type and assembles one element type at time. This makes it possible to pre-allocate matrices common to same type of elements.\n\n\n\n"
},

{
    "location": "api.html#FEMTruss.get_truss_1d_K-Tuple{FEMBase.Element{FEMBasis.Seg2},Any,Any}",
    "page": "API documentation",
    "title": "FEMTruss.get_truss_1d_K",
    "category": "method",
    "text": "get_truss_1d_K(element::Element{Seg2}, nnodes, time)    This function assembles the 1d truss stiffness matrix    Will need to change allocation strategy to pre-allocation later    Can discuss if we really need nnodes, since that is always 2 for trusses\n\n\n\n"
},

{
    "location": "api.html#FEMTruss.get_truss_1d_and_Tg-Tuple{FEMBase.Element{FEMBasis.Seg2},Any}",
    "page": "API documentation",
    "title": "FEMTruss.get_truss_1d_and_Tg",
    "category": "method",
    "text": "get_truss_1d_and_Tg(element::Element{Seg2}) This function sets up the local truss 1d element needed for the integration points to be used for the stiffness and forces It also sets up the coordinate transformation matrix Will need to change allocation strategy to pre-allocation later\n\n\n\n"
},

{
    "location": "api.html#FEMTruss.get_truss_1d_f-Tuple{FEMBase.Element{FEMBasis.Seg2},Any,Any}",
    "page": "API documentation",
    "title": "FEMTruss.get_truss_1d_f",
    "category": "method",
    "text": "get_truss_1d_f(element::Element{Seg2}, nnodes, time)    This function assembles the 1d truss force vector    Will need to change allocation strategy to pre-allocation later    Can discuss if we really need nnodes, since that is always 2 for trusses\n\n\n\n"
},

{
    "location": "api.html#FEMTruss.has_temperature_load-Tuple{FEMBase.Element{FEMBasis.Seg2}}",
    "page": "API documentation",
    "title": "FEMTruss.has_temperature_load",
    "category": "method",
    "text": "has_temperature_load(elem_1d::Element{Seg2})\nchecks if we have a temperature load on the truss element\n\n\n\n"
},

{
    "location": "api.html#Index-1",
    "page": "API documentation",
    "title": "Index",
    "category": "section",
    "text": "DocTestSetup = quote\n    using FEMTruss\nendModules = [FEMTruss]"
},

]}
