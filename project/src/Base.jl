function build_stoichiometric_matrix_from_reaction_id_array(model::Dict{Symbol,Any}, reaction_id_array::Array{String,1})

    try

        # get the reaction table -
        reaction_table = model[:kegg_reactions]

        # initialize -
        compound_symbol_array = Array{String,1}()

        # create the list compounds from the reaction id in the model -
        for reaction_id in reaction_id_array

            # get the row -
            df_reaction = filter(:reaction_number => x -> (x == reaction_id), reaction_table)

            # grab the keys for the st dict -
            compound_keys = keys(df_reaction[1, :stoichiometric_dictionary])
            for compound_key in compound_keys
                push!(compound_symbol_array, compound_key)
            end
        end

        # we will have duplicates in the compound array, remove those -
        unique!(compound_symbol_array)

        # now - let's build the stm -
        number_of_species = length(compound_symbol_array)
        number_of_reactions = length(reaction_id_array)
        stoichiometric_matrix = zeros(number_of_species, number_of_reactions)

        # build the array -
        for reaction_index = 1:number_of_reactions

            # what is my reaction id?
            reaction_id = reaction_id_array[reaction_index]

            # get row from the reaction table -
            df_reaction = filter(:reaction_number => x -> (x == reaction_id), reaction_table)

            # grab the stm dictionary -
            stm_dictionary = df_reaction[1, :stoichiometric_dictionary]

            # ok, lets see if we have these species -
            for species_index = 1:number_of_species

                # species code -
                species_symbol = compound_symbol_array[species_index]
                if (haskey(stm_dictionary, species_symbol) == true)
                    stm_coeff_value = stm_dictionary[species_symbol]
                    stoichiometric_matrix[species_index, reaction_index] = stm_coeff_value
                end
            end
        end

        # return -
        return (compound_symbol_array, reaction_id_array, stoichiometric_matrix)
    catch error

        # what is our error policy? => for now, just print the message
        error_message = sprint(showerror, error, catch_backtrace())
        println(error_message)

    end
end