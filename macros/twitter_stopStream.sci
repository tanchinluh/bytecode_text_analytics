function twitter_stopStream(twitterstream)
// Stops the twitter stream
//
// Syntax
//     twitter_stopStream(twitterstream)
//
// Parameters
//     twitterstream : Java object. Created using twitterStream_init
//
// Description
//     Stops the twitter stream.
//
//
// See also
//    twitter_stream
//
// Authors
//     Joshua T.   
 
    twitterstream.stopStream();
    
endfunction
