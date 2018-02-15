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
    "category": "Module",
    "text": "Truss implementation for JuliaFEM. \n\n\n\n"
},

{
    "location": "api.html#FEMTruss.Truss",
    "page": "API documentation",
    "title": "FEMTruss.Truss",
    "category": "Type",
    "text": "This truss fromulation is from Concepts and applications of finite element analysis, forth edition Chapter 2.4 Cook, Malkus, Plesha, Witt\n\nFeatures\n\nNodal forces can be set using element Poi1 with field nodal force i, where i is dof number.\nDisplacements can be fixed using element Poi1 with field fixed displacement i, where i is dof number.\n\n\n\n"
},

{
    "location": "api.html#FEMBase.assemble!-Tuple{FEMBase.Assembly,FEMBase.Problem{FEMTruss.Truss},FEMBase.Element{FEMBasis.Seg2},Any}",
    "page": "API documentation",
    "title": "FEMBase.assemble!",
    "category": "Method",
    "text": "assemble!(assembly:Assembly, problem::Problem{Elasticity}, elements, time)\n\nStart finite element assembly procedure for Elasticity problem. Function groups elements to arrays by their type and assembles one element type at time. This makes it possible to pre-allocate matrices common to same type of elements.\n\n\n\n"
},

{
    "location": "api.html#FEMTruss.get_K_and_T-Tuple{FEMBase.Element{FEMBasis.Seg2},Any,Any,Any}",
    "page": "API documentation",
    "title": "FEMTruss.get_K_and_T",
    "category": "Method",
    "text": "get_K_and_T(element::Element{Seg2}, nnodes, ndim, time)    This function assembles the local stiffness and transformation matrix    Need this to find element forces later on    Will need to change allocation strategy to pre-allocation later    Can discuss if we really need nnodes, since that is always 2 for trusses\n\n\n\n"
},

{
    "location": "api.html#Index-1",
    "page": "API documentation",
    "title": "Index",
    "category": "section",
    "text": "DocTestSetup = quote\n    using FEMTruss\nendModules = [FEMTruss]"
},

]}
