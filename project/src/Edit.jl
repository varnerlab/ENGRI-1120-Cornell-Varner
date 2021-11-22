function +(reaction_table::DataFrame, reaction::KEGGReaction) 

    # create a tmp df from the reaction object -
    df_row = (reaction |> DataFrame)

    # return new df -
    return vcat(reaction_table, df_row)
end