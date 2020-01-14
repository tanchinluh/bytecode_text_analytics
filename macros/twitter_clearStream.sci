function twitter_clearStream(twitterstream)
// Remove tweets retrieved from streaming 
//
// Syntax
//     twitter_clearStream(twitterstream)
//
// Parameters
//     twitterstream : Java object. Created using twitterStream_init
//
// Description
//     Tweets retrieved from stream will be stored temporarily inside the twitterstream object. Subsequent streaming will append the new tweets. This function removes all stored tweets.
//
//
// See also
//    twitterStream_init
//
// Authors
//     Joshua T.
    
    twitterstream.clearTweets()
    
endfunction
