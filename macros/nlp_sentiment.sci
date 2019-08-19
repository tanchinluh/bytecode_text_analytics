function [sentiment, rep,stat,stderr] = nlp_sentiment(in_str,url)
    // Sentiment analysis of a sentence using Stanford NLP
    //
    //    Copyright 2019 Bytecode.
    //    
    //    This program is free software: you can redistribute it and/or modify
    //    it under the terms of the GNU General Public License as published by
    //    the Free Software Foundation, either version 2 of the License, or
    //    (at your option) any later version.
    //    
    //    This program is distributed in the hope that it will be useful,
    //    but WITHOUT ANY WARRANTY; without even the implied warranty of
    //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    //    GNU General Public License for more details.
    //    
    //    You should have received a copy of the GNU General Public License
    //    along with this program.  If not, see <http://www.gnu.org/licenses/
    //
    // Calling Sequence
    //     [rep,stat,stderr] = nlp_sentiment(in_str,url)
    //
    // Parameters
    //     in_str : Input string
    //     url : A valid URL with port number which point to the NLP server
    //     sentiment : Sentiment of a sentence
    //     rep : Response from NLP server
    //     stat : an integer, the error status. status=0 if no error occurred
    //     stderr : Column of text: error message.
    // 
    // Description
    //    This is a function to call a server hosting Stanford NLP engine and return the sentiment of the input string. This unction require the connection to the Standford NLP server.
    //    
    // Examples
    //
    // See also
    //    nlp_sentiment
    //    text_gencloud
    //    text_porterstemmer
    //    text_stripdollar
    //    text_stripemail
    //    text_striphtml
    //    text_stripnumber
    //    text_stripurl
    //    text_tokenize
    //
    // Authors
    //    C.L. Tan - Bytecode Malaysia.
    // 

rhs=argn(2);
// Error Checking
if rhs < 2 ; error("Expect 2 arguments, in_str and url"); end    

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

url = dc + url;
 
cmd = cmd + " --data " + msg + " " + url + "/?properties={%22annotators%22%3A%22tokenize%2Cssplit%2Cpos%2Cparse%2Csentiment%22%2C%22outputFormat%22%3A%22json%22}" + dc +  " -o -";

[rep,stat,stderr] = unix_g(cmd);

if stat == 0 then
    if isdef("JSONlib")
        rep_json = JSONParse(rep);
        sentiment = rep_json.sentences.sentiment;
        
    else
        ind = grep(rep,'sentiment');
        sentiment_raw = rep(ind(2));
        sentiment_raw2 = strsplit(sentiment_raw,[":",""""]);
        sentiment = sentiment_raw2($-1);
    end
else
    sentiment = " ";
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



