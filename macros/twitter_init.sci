function twitter = twitter_init(con_key,con_sec,acc_tok,acc_sec)
// Creates a Twitter object to connect to Twitter API
//
// Syntax
//     twitter = twitter_init()
//     twitter = twitter_init(con_key,con_sec,acc_tok,acc_sec)
//
// Parameters
//     con_key : String. Consumer key.
//     con_sec : String. Consumer secret.
//     acc_tok : String. Access token.
//     acc_sec : String. Access secret.
//     twitter : Java object. Connects to Twitter API.
//
// Description
//     Creates a Twitter object that allows you to access the Twitter API. You need a Twitter developer account  in order to obtain the 4 required parameters. This function uses the Twitter4J library.
//
// Examples
//    twitter = twitter_init()
//    [id,tweets,info] = twitter_getTweets(twitter,'cats')
//
// See also
//    twitter_getTweets
//
// Authors
//     Joshua T. - Bytecode Malaysia.
    
    bool = jautoUnwrap();
    jautoUnwrap(%f);
    
    jimport twitter4j.conf.ConfigurationBuilder
    jimport twitter4j.TwitterFactory
    jimport java.lang.Long;
    jimport twitter4j.TwitterObjectFactory;
    
    rhs = argn(2)
    init_bool = %f
    
    if rhs == 0 then
        txt = ['Consumer Key';'Consumer Secret';'Access Token';'Access Secret'];
        val = x_mdialog('Please enter the following:',txt,["";"";"";""])
        if val == [] then
            // Cancelled
            init_bool = %f
        else
            consumer_key = val(1);
            consumer_secret = val(2);
            access_token = val(3);
            access_secret = val(4);
            init_bool = %t
        end
        
    elseif rhs == 4
        consumer_key = con_key;
        consumer_secret = con_sec;
        access_token = acc_tok;
        access_secret = acc_sec;
        init_bool = %t
    else
        error("Wrong number of inputs.")
    end
    
    if init_bool then
        
        cb = ConfigurationBuilder.new();
        cb.setDebugEnabled(%t)
        cb.setOAuthConsumerKey(consumer_key)
        cb.setOAuthConsumerSecret(consumer_secret)
        cb.setOAuthAccessToken(access_token)
        jinvoke(cb,"setOAuthAccessTokenSecret",access_secret)
        cb.setJSONStoreEnabled(%t)
        cb.setTweetModeExtended(%t)
    
        cbbuild=cb.build()
    
        twitterfact = TwitterFactory.new(cbbuild)
        twitter=twitterfact.getInstance()
        
    else
        twitter = [];
    end
    
      
    jautoUnwrap(bool)
    
endfunction
