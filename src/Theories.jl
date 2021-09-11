module Theories
export Context, Term, Var, Appl, Presentation, sort_check, check_presentation

using MLStyle

struct Context
  vartypes::Vector{Int}
end

@data Term begin
  Var(index::Int)
  Appl(op::Int, args::Vector{Term})
end

struct Presentation
  sorts::Int
  operations::Vector{NamedTuple{(:arity, :ret), Tuple{Vector{Int}, Int}}}
  equations::Vector{NamedTuple{(:context, :lhs, :rhs), Tuple{Context, Term, Term}}}
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
    @assert 1 <= o.ret <= p.sorts
    for i in o.arity
      @assert 1 <= i <= p.sorts
    end
  end
  for e in p.equations
    @assert sort_check(p, e.context, e.lhs) == sort_check(p, e.context, e.lhs)
  end
  true
end

end
