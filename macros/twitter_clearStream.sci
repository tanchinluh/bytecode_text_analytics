function twitter_clearStream(twitterstream)
// Remove tweets from stream
//
// Syntax
//     twitter_clearStream(twitterstream)
//
// Parameters
//     twitterstream : Java object. Created using twitterStream_init
//
// Description
//     Remove the tweets from stream
//
//
// See also
//    twitterStream_init
//
// Authors
//     Joshua T.
    
    // Remove tweets from stream
    twitterstream.clearTweets()
    
endfunction
