module Syntax

using ..Theories

struct Naming
  sort_names::Vector{Symbol}
  operator_names::Vector{Symbol}
end

function syntax_valid_for(s::Syntax, p::Presentation)
  (length(s.sort_names) == length(p.sorts)) &&
    (length(s.operator_names) == length(p.operators)) &&
    (unique(s.sort_names) == s.sort_names) &&
    (unique(s.operator_names) == s.operator_names)
end

struct Context
  ctx::Context
  var_names::Vector{Symbol}
end

struct Decorated

function pprint(nc::NamedContext, )

end
