function load_bson_model_file(path_to_model_file::String, module_name::Module)

    try
        return BSON.load(path_to_model_file, module_name)

    catch error

        # what is our error policy? => for now, just print the message
        error_message = sprint(showerror, error, catch_backtrace())
        println(error_message)

    end
end