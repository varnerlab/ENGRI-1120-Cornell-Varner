function load_bson_model_file(path_to_model_file::String)

    try
        return BSON.load(path_to_model_file);
    catch error
        
        # what is our error policy?
        # ...
    end
end