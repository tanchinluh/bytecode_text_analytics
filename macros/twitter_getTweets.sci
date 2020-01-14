function [id,tweets,info] = twitter_getTweets(twitter,str,varargin)
// Retrieve tweets from Twitter
//
// Syntax
    //     [id,tweets,info] = twitter_getTweets(twitter,str)
    //     [id,tweets,info] = twitter_getTweets(twitter,str,options)
    //
    // Parameters
    //     twitter : Twitter object. Obtained from twitter_init function
    //     str : String. Search query.
    //     options: Optional parameters (in key-value pairs) to refine the search. The optional parameters are the following:
    //     "ntweets" : Max number of tweets to return (default:15)
    //     "lang" : Tweet language code (default:en)
    //     "latlon" : location coordinates [lat,lon] (none by default)
    //     "rad" : Radius of location parameter in km (default:10)
    //      id : Integer 64. Tweet ID.
    //      tweets : List. The tweet text.
    //      info :  Struct. Additional infomation.
    //
    // Description
    //     Retrieve tweets from Twitter that match the search query. Limitations from Twitter API apply. When querying with a location parameter, search results will include both geotagged and non-geotagged tweets. The non-geotagged are based on the location in the user's profile.
    //
    // Examples
    //      twitter = twitter_init()
    //      str = "coffee"
    //      [id1,tweets1,info1] = twitter_getTweets(twitter,str)
    //      // San Fransisco 37.7749° N, 122.4194° W
    //      [id2,tweets2,info2] = twitter_getTweets(twitter,str,"latlon",[37.7749,-122.4194])
    //
    // See also
    //     twitter_init
    //
    // Authors
    //     Joshua T. - Bytecode Malaysia. 

    jimport twitter4j.Query
    jimport twitter4j.GeoLocation

    bool = jautoUnwrap();
    jautoUnwrap(%t);

    rhs = argn(2)

    if rhs < 2 then
        error("At least 2 inputs are needed")
    end

    // Default values
    n = 15
    lang = "en"
    latlon = []
    rad = 10

    var_size = size(varargin)
    if modulo(var_size,2) == 0 then

        for i = 1:2:var_size
            temp = varargin(i)
            switch temp
            case "ntweets"
                n = varargin(i+1)
            case "lang"
                lang = varargin(i+1)
            case "latlon"
                latlon = varargin(i+1)
            case "rad"
                rad = varargin(i+1)
            else
                error("Unknown option.")
            end
        end

    else
        error("Optional inputs should be in key-value pairs")
    end

    query = Query.new(str+" -filter:retweets -filter:links -filter:replies -filter:images")

    query.setCount(n)
    query.setLang(lang)

    if latlon ~= [] then
        loc_coord = GeoLocation.new(latlon(1),latlon(2))
        query.setGeoCode(loc_coord,rad,Query.KILOMETERS)
    end

    results = jinvoke(twitter,"search",query) 

    tweetslist = results.getTweets() 

    if tweetslist.size() == 0 then
        id = []
        tweets = []
        info = []
        mprintf("No tweets found.\n")
    else
        info = struct();
        tweets = list();

        for i = 1:tweetslist.size()
            temp = tweetslist(i);

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
