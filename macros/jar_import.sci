function [jars] = jar_import(folderpath)
// Add jar libraries to the Scilab Java classpath
//
// Syntax
//     jars = nlp_init()
//     jars = nlp_init(folderpath)
//
// Parameters
//     folderpath : String. Folder path containing the jar libraries
//     jars : String array. Jar files added to the classpath.
//
// Description
//     Adds jar files to the Scilab Java classpath. The Stanford CoreNLP jar libraries are needed for the NLP functions. This functions provide a convenient way of doing so.
//
//
// See also
//    nlp_simple
//
// Authors
//     Joshua T. 

    path = "";
    import_bool = %f
    rhs = argn(2)
    if rhs == 0 then
        // launch a file browser is no path is specified
        path = uigetdir("","Please select a directory with JAR files")
        if path ~= "" // if user press ok
            import_bool = %t
        end
    elseif rhs == 1 
         path = folderpath
         import_bool = %t
     else
         error("Wrong number of inputs.")
    end
    
    if import_bool then
        // Get all jar files
        jarfiles = findfiles(path,"*.jar")
    
    
        // Exclude source files and javadoc files
        re = "/^((?!sources.jar|src.jar|javadoc.jar).)*$/"
        ind = grep(jarfiles,re,"r")
        jar_filter = jarfiles(ind)
    
        // If no jar found
        if jar_filter == [] then
            jars = [];
            mprintf("No jar files found.\n")
        else
            // Add to Java classpath in Scilab
            if part(path,$) ~= "\" then
                path = path+"\"
            end
            jar_path = path+jar_filter
            javaclasspath(jar_path)
            jars = jar_filter
            res = %t
            mprintf("%i jars files added.\n",size(jar_filter,1))
        end
    else
        jars = "";
    end
    

endfunction
