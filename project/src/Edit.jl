function patch_species_reaction(model::Dict{Symbol,Any}, pair::Pair)

    try

        # process the reaction table -
        reaction_table = model[:reactions]
        (number_of_reactions, number_of_fields) = size(reaction_table)
        for reaction_index = 1:number_of_reactions

            # get reaction_markup -
            reaction_markup = reaction_table[reaction_index, :reaction_markup]

            # get st dict -
            std = reaction_table[reaction_index, :stoichiometric_dictionary]

            # update -
            replace!(reaction_markup, pair.first => pair.second)
        end

    catch error

        # what is our error policy? => for now, just print the message
        error_message = sprint(showerror, error, catch_backtrace())
        println(error_message)

    end
end