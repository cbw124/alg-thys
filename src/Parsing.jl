module Parsing
export @present

using ..Theories
using ..LabeledVectors
using MLStyle

function strip_lines(expr::Expr; recurse::Bool=false)::Expr
  args = [ x for x in expr.args if !isa(x, LineNumberNode) ]
  if recurse
    args = [ isa(x, Expr) ? strip_lines(x; recurse=true) : x for x in args ]
  end
  Expr(expr.head, args...)
end

function parse_term(context::LabeledContext{Symbol}, ops::LabeledVector{Symbol, Operation}, t::Union{Expr, Symbol})
  @match t begin
    x::Symbol =>
      if x ∈ labels(ops)
        Appl(indexof(ops, x), Term[])
      elseif x ∈ labels(context.vartypes)
        Var(indexof(context.vartypes,x))
      else
        error("unrecognized symbol $x")
      end
    Expr(:call, op, args...) => Appl(indexof(ops, op), map(arg -> parse_term(context, ops, arg), args))
    _ => error("unrecognized syntax for term: $t")
  end
end

function parse_context(sorts::LabeledVector{Symbol, Tuple{}}, ctx::Expr)
  parse_binding(e::Expr) = @match e begin
    Expr(:(::), v::Symbol, s::Symbol) => v => indexof(sorts, s)
    _ => error("invalid syntax for binding")
  end

  bindings = @match ctx begin
    Expr(:(::), v::Symbol, s::Symbol) => [ctx]
    Expr(:tuple, args...) => [args...]
    _ => error("invalid syntax for context")
  end

  LabeledContext{Symbol}(LabeledVector(parse_binding.(bindings)))
end

function parse_pres(body::Expr)
  body = strip_lines(body; recurse=true)
  @assert body.head == :block
  sorts = LabeledVector{Symbol,Tuple{}}()
  operations = LabeledVector{Symbol,Operation}()
  equations = LabeledVector{Symbol,LabeledEquation{Symbol}}()
  for line in body.args
    @match line begin
      Expr(:(::), sort, :SORT) => push!(sorts, sort, ())
      Expr(:(::), op, Expr(:(->), dom, Expr(:block, cod))) => begin
        arity = @match dom begin
          x::Symbol => [indexof(sorts, x)]
          Expr(:tuple, xs...) => map(x -> indexof(sorts, x), xs)
        end
        ret = indexof(sorts, cod)
        push!(operations, op, Operation(arity, ret))
      end
      Expr(:(::), eq, Expr(:comparison, lhs_expr, :(==), rhs_expr, :(⊣), ctx_expr)) => begin
        ctx = parse_context(sorts, ctx_expr)
        lhs = parse_term(ctx, operations, lhs_expr)
        rhs = parse_term(ctx, operations, rhs_expr)
        push!(equations, eq, LabeledEquation{Symbol}(ctx, lhs, rhs))
      end
      _ => error("invalid syntax in line $line")
    end
  end

  p = LabeledPresentation{Symbol}(sorts, operations, equations)
  check_presentation(p)
  p
end

macro present(head::Symbol, body::Expr)
  :($(esc(head)) = $(GlobalRef(Parsing, :parse_pres))($(Expr(:quote, body))))
end

end
