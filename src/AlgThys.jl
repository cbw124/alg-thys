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

using Reexport

include("LabeledVectors.jl")
include("Theories.jl")
include("Parsing.jl")
include("Examples.jl")

@reexport using .LabeledVectors
@reexport using .Theories
@reexport using .Parsing

end
