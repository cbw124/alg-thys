module AlgThys

# Algebraic Theories
# Owen & Christian [Fall 2021]

# TODO
# DATA
# data structure that contains names for operations
# easy way of parsing a presentation

# CATEGORY
# generate the theory from the presentation
#       [obj: contexts, mor: terms, comp: substitution, 2mor: equations]

# MORPHISMS
# morphisms of presentations
#       [send op to op]
# morphisms of theories
# functorial: sends an equation to a composite equation
#       [send op to composite term]
#       [push forward a term]
# pushouts of morphisms

# REWRITING
# contexts with equations?

using MLStyle

struct Context
    context::Vector{Int}
end

@data Term begin
    Var(index::Int)
    Appl(op::Int, args::Vector{Term})
end

struct Presentation
    sorts::Int
    operations::Vector{Tuple{Vector{Int}, Int}}
    equations::Vector{Tuple{Context, Tuple{Term, Term}}}
end

function sort_check(p::Presentation, c::Context, t::Term)
    @match t begin
        Var(index) => begin
            @assert 1 <= index <= length(c.context)
            return c.context[index]
        end
        Appl(op,args) => begin
            @assert 1 <= op <= length(p.operations)
            @assert p.operations[op][1] == map(arg -> sort_check(p,c,arg), args)
            return p.operations[op][2]
        end
    end
end

function check_presentation(p::Presentation)
    for o in p.operations
        @assert 1 <= o[2] <= p.sorts
        for i in o[1]
            @assert 1 <= i <= p.sorts
        end
    end
    for e in p.equations
        @assert sort_check(p, e[1], e[2][1]) == sort_check(p, e[1], e[2][2])
    end
end

end
