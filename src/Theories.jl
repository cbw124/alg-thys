module Theories
export Context, UnlabeledContext, LabeledContext,
  Term, Var, Appl,
  Operation, Equation, LabeledEquation, UnlabeledEquation,
  Presentation, UnlabeledPresentation, LabeledPresentation,
  sort_check, check_presentation

using MLStyle
using ..LabeledVectors
import ..LabeledVectors: label, unlabel

# Ideally we would have
#
# struct Context{V}
#   vartypes::V{Int}
# end
#
# const UnlabeledContext = Context{Vector}
# const LabeledContext{S} = Context{LabeledVector{S}}
#
# However Julia does not have support for higher-kinded types

abstract type Context end

struct UnlabeledContext <: Context
  vartypes::Vector{Int}
end

struct LabeledContext{S} <: Context
  vartypes::LabeledVector{S,Int}
end

unlabel(c::LabeledContext) = UnlabeledContext(unlabel(c.vartypes))

label(c::UnlabeledContext, labels::Vector{S}) where {S} = LabeledContext{S}(label(c.vartypes, labels))

@data Term begin
  Var(index::Int)
  Appl(op::Int, args::Vector{Term})
end

struct Operation
  arity::Vector{Int}
  ret::Int
end

abstract type Equation end

struct LabeledEquation{S} <: Equation
  context::LabeledContext{S}
  lhs::Term
  rhs::Term
end

struct UnlabeledEquation <: Equation
  context::UnlabeledContext
  lhs::Term
  rhs::Term
end

unlabel(eq::LabeledEquation) = UnlabeledEquation(unlabel(eq.context), eq.lhs, eq.rhs)

label(eq::UnlabeledEquation, labels::Vector{S}) where {S} =
  LabeledEquation{S}(label(eq.context, labels), eq.lhs, eq.rhs)

abstract type Presentation end

struct UnlabeledPresentation <: Presentation
  sorts::Vector{Tuple{}}
  operations::Vector{Operation}
  equations::Vector{UnlabeledEquation}
end

struct LabeledPresentation{S} <: Presentation
  sorts::LabeledVector{S, Tuple{}}
  operations::LabeledVector{S, Operation}
  equations::LabeledVector{S, LabeledEquation{S}}
end

unlabel(p::LabeledPresentation) =
  UnlabeledPresentation(unlabel(p.sorts), unlabel(p.operations), unlabel.(unlabel(p.equations)))

function label(p::UnlabeledPresentation; sorts::Vector{S}, operations::Vector{S},
               equations::Vector{Tuple{S, Vector{S}}}) where {S}
  LabeledPresentation{S}(
    label(p.sorts, sorts),
    label(p.operations, operations),
    label(map(
      ((eq, ctxlabels)) -> label(eq, ctxlabels),
      zip(p.equations, last.(equations))
    ), first.(equations))
  )
end

function sort_check(p::Presentation, c::Context, t::Term)
  @match t begin
    Var(index) => begin
      @assert 1 <= index <= length(c.vartypes)
      c.vartypes[index]
    end
    Appl(op,args) => begin
      @assert 1 <= op <= length(p.operations)
      @assert p.operations[op].arity == map(arg -> sort_check(p,c,arg), args)
      p.operations[op].ret
    end
  end
end

function check_presentation(p::Presentation)
  for o in p.operations
    @assert 1 <= o.ret <= length(p.sorts)
    for i in o.arity
      @assert 1 <= i <= length(p.sorts)
    end
  end
  for e in p.equations
    @assert sort_check(p, e.context, e.lhs) == sort_check(p, e.context, e.lhs)
  end
  true
end

end
