mutable struct KEGGReaction

    ec_number::String
    reaction_number::String
    enzyme_name::String
    reaction_markup::String
    reaction_forward::Union{Missing,String}
    reaction_reverse::Union{Missing,String}
    stoichiometric_dictionary::Union{Missing,Dict{String,Number}}

    KEGGReaction() = new()
end


mutable struct Problem
end

mutable struct Solution
end