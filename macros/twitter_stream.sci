function twitter_stream(twitterstream,varargin)
// Begins the twitter streaming api
//
// Syntax
//     twitter_displayStream(twitterstream)
//     twitter_displayStream(twitterstream,options)
//
// Parameters
//     twitterstream : Java object. Created using twitterStream_init
//     options : Optional parameters (in key-value pairs) to refine the search. The optional parameters are the following:
//      "query" : String. Query used to filter the tweets. Default query is "coffee". There is a 60 character limit for the query.
//      "lang" : String. Tweet language. Default is "en"
//      "box" : Double matrix. Matrix containing the coordinates of a bounding box. The coordinates should be stored as [SWlong SWlat; NElong NElat].
//     "limit" : Double. The number of tweets to obtain from stream before stopping.
//     "csv" : String. Automatically save tweets into a CSV using the given file name. 
//
// Description
//     Starts the twitter streaming based on the parameters set by user. For more info on how the stream is filtered, refer to https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/basic-stream-parameters .
//
// Examples
//    twitterS = twitterStream_init()
//    consolebox on
//    twitter_displayStream(twitterS)
//    twitter_stream(twitterS,"query","ice cream","limit",30)
//
// See also
//    twitter_getStreamTweets
//
// Authors
//     Joshua T.

    autoT = jautoTranspose();
    jautoTranspose(%t)
    
    twitterstream.resetUserParameters(); 

    var_size = size(varargin)
    if modulo(var_size,2) == 0 then

        for i = 1:2:var_size
            temp = varargin(i)
            switch temp
            //case "ntweets" // for future
                //n = varargin(i+1)
            case "query"
                query = varargin(i+1)
                twitterstream.setQuery(query)
            case "lang"
                lang = varargin(i+1)
                twitterstream.setLang(lang);
            case "box"
                box = varargin(i+1)
                twitterstream.setLocation(box)
            case "limit"
                limit = varargin(i+1)
                twitterstream.setTweetLimit(limit)
            case "csv"
                csvpath = varargin(i+1)
                twitterstream.setCSVPath(csvpath)
            else
                error("Unknown option.")
            end
        end

    else
        error("Optional inputs should be in key-value pairs")
    end
    
    twitterstream.generalStream()
    jautoTranspose(autoT)
endfunction
