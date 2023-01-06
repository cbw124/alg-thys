module Equations

using ..Theories
using ..Contexts

@data Equation begin
  GeneratorEq(i::Int)
  WhiskerL(f::ContextMorphism, e::Equation)
  WhiskerR(e::Equation, f::ContextMorphism)
  Refl(f::ContextMorphism)
  Sym(e::Equation)
  Compose(e1::Equation, e2::Equation)
end

flip(x::Tuple{S,T}) where {S,T} = (x[2],x[1])

function check_equation(p::Presentation, dom::Context, codom::Context, e::Equation)
  @match e begin
    GeneratorEq(i) => begin
      prim_eq = p.equations[i]
      @assert unlabel(prim_eq.context) == unlabel(dom)
      @assert only(unlabel(codom.vartypes)) == sort_check(p, dom, prim_eq.lhs)
      (from_term(prim_eq.lhs), from_term(prim_eq.rhs))
    end

    WhiskerL(f, e′) => begin
      check_morphism(p, f)
      @assert unlabel(f.codom) == unlabel(dom)
      (lhs, rhs) = check_equation(p, f.dom, dom, e′)
      (compose(f,lhs), compose(f,rhs))
    end

    WhiskerR(e′, f) => begin
      check_morphism(p, f)
      @assert unlabel(f.dom) == unlabel(codom)
      (lhs, rhs) = check_equation(p, codom, f.codom, e′)
      (compose(lhs, f), compose(rhs, f))
    end

    Refl(f) => begin
      check_morphism(p,f)
      @assert unlabel(f.dom) == unlabel(dom)
      @assert unlabel(f.codom) == unlabel(codom)
      (f,f)
    end

    Sym(e′) => flip(check_equation(p, dom, codom, e′))

    Compose(e1, e2) => begin
      (lhs1, rhs1) = check_equation(p, dom, codom, e1)
      (lhs2, rhs2) = check_equation(p, dom, codom, e2)
      @assert rhs1 == lhs2
      (lhs1, rhs2)
    end
  end
end

end
