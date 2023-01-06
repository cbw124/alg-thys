module GATs

using MLStyle

using ..LabeledVectors

const Pres{L} = LabeledVector{L, PresEntry{L}}

@data PresEntry{L} begin
  # cc=canonical context. A type is contructed using a morphism
  # into the canonical context for that type constructor
  TyC(cc::Context{L})

  # cc=canonical context. A term is contructed using a morphism
  # into the canonical context for that type constructor
  # Then, to get the type of the constructed term, we pull
  # back ty along that morphism.
  TC(cc::Context{L}, ty::Type)
end

const Context{L} = LabeledVector{L,Type}

struct ContextMorphism{L}
  dom::Context{L}
  codom::Context{L}

  # A term in the domain context for each variable in the codom context
  terms::Vector{Term}
end

struct Type
  con::Int # the constructor

  # This is essentially just the "terms" part of a ContextMorphism,
  # the domain and codomain are inferred
  args::Vector{Term}
end

@data Term begin
  # This is an index into the context
  Var(index::Int)

  # Again, args is the "terms" part of a ContextMorphism, and
  # the domain and codomain are inferred
  Appl(con::Int, args::Vector{Term})
end

# All of these will signal badly-formed things by erroring

# Assumes that p and c are well-formed
# Returns type in context c if t is well-typed
function check(p::Pres, c::Context, t::Term)::Union{Term, Nothing}
end

# Assumes that p and c are well-formed
# Returns if ty is a well-formed type
function check(p::Pres, c::Context, ty::Type)
end

# Assumes that p is well-formed
# Returns if c is a well-formed context
function check(p::Pres, c::Context)
end

# Returns if p is a well-formed presentation
function check(p::Pres)
end

# Assumes that p is well-formed
# Returns if the type constructor is a valid entry to add to the presentation
function check(p::Pres, tyc::TyC)
end

# Assumes that p is well-formed
# Returns if the term constructor is a valid entry to add to the presentation
function check(p::Pres, tc::TC)
end

# Assumes that p is well-formed
# Returns true if f is a well-formed context morphism
function check(p::Pres, f::ContextMorphism)
end

end
