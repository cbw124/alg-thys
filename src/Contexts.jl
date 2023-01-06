module Contexts
export check_morphism, apply, compose, from_term

using ..Theories

struct ContextMorphism
  dom::Context
  codom::Context
  terms::Vector{Term}
end

function check_morphism(p::Presentation, f::ContextMorphism)
  @assert length(terms) == length(f.codom.vartypes)
  for (t,T) in zip(f.terms, unlabel(f.codom.vartypes))
    @assert sort_check(p, f.dom, t) == T
  end
end

function apply(f::ContextMorphism, t::Term)
  @match t begin
    Var(i) => f.terms[i]
    Appl(op, args) = Appl(op, map(arg -> apply(f,arg), args))
  end
end

function compose(f::ContextMorphism, g::ContextMorphism)
  @assert unlabel(f.codom) == unlabel(g.dom)
  ContextMorphism(f.dom, g.codom, map(t -> apply(f, t), g.terms))
end

function from_term(p::Presentation, c::Context, t::Term)
  ContextMorphism(c, UnlabeledContext([sort_check(p,c,t)], [t]))
end

end
