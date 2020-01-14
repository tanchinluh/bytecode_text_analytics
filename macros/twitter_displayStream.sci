function twitter_displayStream(twitterstream,bool)
// Display streamed tweets on the Scilab Java Console
//
// Syntax
//     twitter_displayStream(twitterstream)
//     twitter_displayStream(twitterstream,bool)
//
// Parameters
//     twitterstream : Java object. Created using twitterStream_init
//     bool : Boolean. Indicate whether tweets should be displayed (%t) or not (%f).
//
// Description
//     Displays some infomation on the streamed tweets on the Scilab Java console. The information shown are the tweet ID, the user's screen name, the tweet time as well as the tweet itself.
//
// Examples
//    twitterS = twitterStream_init()
//    consolebox on
//    twitter_displayStream(twitterS)
//    twitter_stream(twitterS,"limit",15)
//
// See also
//    twitterStream_init
//
// Authors
//     Joshua T.
    
    rhs = argn(2);
    if rhs == 1 then
        twitterstream.setDisplay(%t)
    elseif rhs == 2
        if typeof(bool) == "boolean"
            twitterstream.setDisplay(bool)
        else
            error("2nd input must be a Boolean.")
        end
    else
        error("Too many inputs.")
    end
    
    
endfunction
