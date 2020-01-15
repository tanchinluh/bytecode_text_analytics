function [id,tweets,info] = twitter_getStreamTweets(twitterstream,n,tweetind)
// Import tweets from Twitter stream into Scilab
//
// Syntax
//     [id,tweets,info] = twitter_getStreamTweets(twitterstream)
//     [id,tweets,info] = twitter_getStreamTweets(twitterstream,n)
//     [id,tweets,info] = twitter_getStreamTweets(twitterstream,n,tweetind)
//
// Parameters
//     twitterstream : Java object. Created using twitterStream_init
//     n : Double. Number of tweets to be retrived. Default is all are retrieved.
//     tweetind : String. Option to retrieve either the latest n tweets ("last") or the earliest n tweets ("first")
//     id : Integer64. Tweet ID.
//     tweets : List. Tweet text.
//     info : Struct. Contains information regarding the tweet.
//
// Description
//     Retrieve the tweets from the stream stored inside the twitterstream object.
//
// Examples
//    // After streaming has started for a while
//    [id1,tweets1,info1] = twitter_getStreamTweets(twitterS)
//    [id2,tweets2,info2] = twitter_getStreamTweets(twitterS,10,"first")
//    [id3,tweets3,info3] = twitter_getStreamTweets(twitterS,10,"last")
//    
//
// See also
//    twitter_stream
//
// Authors
//     Joshua T.
    
    bool = jautoUnwrap();
    jautoUnwrap(%t);
    
    rhs = argn(2);
    
    if rhs == 1 then
        results = twitterstream.getAllStatus();
    elseif rhs == 2 then
        results = twitterstream.getLastStatus(n);
    elseif rhs == 3 then
        switch tweetind
        case "first"
            results = twitterstream.getFirstStatus(n)
        case "last"
            results = twitterstream.getLastStatus(n);
        else
            error("Unknown option.") 
        end
    end
    
    if results.size() == 0 then
        id = []
        tweets = []
        info = []
        mprintf("No tweets found.\n")
    else
        info = struct();
        tweets = list();

        for i = 1:results.size()
            temp = results(i);

            // Get Tweet ID
            id(i,:) = [int64(i) temp.getId()];
            info(i).tweetid = temp.getId()

            // Get Tweet Text and Time
            createdAt = temp.getCreatedAt().toString(); 
            tweets(i) = temp.getText();
            info(i).tweet = temp.getText();
            info(i).tweetdate = createdAt;
            info(i).tweetlang = temp.getLang();

            // Get User Information 
            utemp = temp.getUser();
            info(i).username = utemp.getName();
            info(i).userscreenname = utemp.getScreenName();
            info(i).userid = utemp.getId();
            uloc = utemp.getLocation();
            if uloc == [] then
                uloc = "N/A"
            end
            info(i).userlocation = uloc;

            // Get Tweet Location
            loc = temp.getPlace()
            if isempty(loc) then
                info(i).tweetgeotag = %f
                info(i).tweetplacename = "N/A"
                info(i).tweetplaceid = "N/A"
                info(i).tweetcountry = "N/A"
                info(i).tweetcountrycode = "N/A"
            else
                info(i).tweetgeotag = %t
                info(i).tweetplacename = loc.getName()
                info(i).tweetplaceid = loc.getId()
                info(i).tweetcountry = loc.getCountry()
                info(i).tweetcountrycode = loc.getCountryCode()
            end 
        end
    end
    
    jautoUnwrap(bool);
    
endfunction
