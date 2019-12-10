function [rep,stat,stderr] = nlp_url(in_str,ann,url,json)
// Sends an annotation request to a NLP server.
//
// Calling Sequence
//     [rep,stat,stderr] = nlp_url(in_str,ann,url)
//
// Parameters
//     in_str : Input string
//     ann : Specified annotators
//     url : A valid URL with port number which point to the NLP server
//     json : Boolean. Converts response to struct if %t(default %f). Requires JSON Toolbox to be installed.
//     rep : String array or struct. Response from NLP server. 
//     stat : an integer, the error status. status=0 if no error occurred
//     stderr : Column of text: error message.
// 
// Description
//    This is a function to send an annotation request to a server hosting Stanford NLP engine and return the annotation results. This function requires the connection to the Standford NLP server. Some annotators require other annotators to be performed first (for example ssplit requires tokenize). The results from the required annotators are included as well. 
// 
// Examples
//   str = "I just had coffee. It was delicious."
//   url = "http://127.0.0.1:9000" // if you setup a local host Stanford CoreNLP server
//   [rep1,stat1,stderr1] = nlp_url(str1,"ssplit",url)
//   [rep2,stat2,stderr2] = nlp_url(str1,"ssplit",url,%t) 
//      
//
// See also
//    nlp_simple
//
// Authors
//    C.L. Tan - Bytecode Malaysia.
//    Joshua Teoh - Bytecode Malaysia

rhs=argn(2);
// Error Checking
if rhs < 3 ; error("Expect 3~4 arguments, in_str, ann, url and json"); end    

json_bool = %f
if rhs == 4 then
    json_bool = json
end

// Defind special chars
dc = char(34);

[OS,Version]=getos();
if OS == 'Windows' then
    curl_loc = SCI + '\tools\curl\curl';
else
    curl_loc = 'curl';
end

cmd = curl_loc;
msg = dc + in_str + dc;
prop = strsubst(ann,",","%2C")

url = dc + url;
cmd2 = cmd + " --data " + msg + " " + url + "/?properties={%22annotators%22%3A%22" + prop + "%22%2C%22outputFormat%22%3A%22json%22}" + dc +  " -o -"

[rep,stat,stderr] = unix_g(cmd2);

if stat == 0 then
    
    if json_bool
        if isdef("JSONlib")
            rep = JSONParse(rep);
        end
    end
    
else
    
    err = "This function requires internet connection and a valid Stanford NLP server address.";
    disp(err);
    if size(stderr,1) > 1
        new_err = strsplit(stderr($),'curl');
        disp('curl'+new_err($));
    else
        disp(stderr);
    end
end


endfunction

