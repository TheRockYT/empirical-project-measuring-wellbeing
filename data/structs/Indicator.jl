# This is the Struct for an Indicator of a Country
mutable struct Indicator
    name::String
    values::Dict{Int64,Float64}
end