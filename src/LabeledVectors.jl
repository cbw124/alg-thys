module LabeledVectors
export LabeledVector, indexof, labelof, unlabel, label, labels

struct LabeledVector{S,T} <: AbstractVector{T}
  elts::Vector{T}
  labels::Vector{S}
  indexes::Dict{S,Int}
end

flip(t::Tuple{S,T}) where {S,T} = (t[2],t[1])

function LabeledVector(labels::Vector{S}, elts::Vector{T}) where {S,T}
  @assert unique(labels) == labels
  @assert length(labels) == length(elts)
  label_to_idx = Dict{S,Int}(flip.(enumerate(labels)))
  LabeledVector{S,T}(elts, labels, label_to_idx)
end

function LabeledVector(vs::Vector{Pair{S,T}}) where {S,T}
  LabeledVector(first.(vs), last.(vs))
end

function LabeledVector{S,T}() where {S,T}
  LabeledVector(S[], T[])
end

labelof(lv::LabeledVector, i::Int) = lv.labels[i]

indexof(lv::LabeledVector{S}, l::S) where {S} = lv.indexes[l]

labels(lv::LabeledVector) = lv.labels

unlabel(lv::LabeledVector) = lv.elts
unlabel(v::Vector) = v

label(v::Vector{T}, labels::Vector{S}) where {S,T} = LabeledVector(labels, v)
label(lv::LabeledVector{S,T}, labels::Vector{S}) where {S,T} = LabeledVector(labels, lv.elts)

Base.getindex(lv::LabeledVector, i::Int) = lv.elts[i]
Base.getindex(lv::LabeledVector{S}, l::S) where {S} = lv.elts[indexof(lv,l)]

Base.length(lv::LabeledVector) = length(lv.elts)
Base.size(lv::LabeledVector) = (length(lv),)

function Base.push!(lv::LabeledVector{S,T}, k::S, v::T) where {S,T}
  @assert k ∉ lv.labels
  push!(lv.elts, v)
  push!(lv.labels, k)
  lv.indexes[k] = length(lv.elts)
end

end
