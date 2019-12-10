function [sentiment_vec,tweet_vec] = twitter_processTweets(tweetslist,prog)
// Perform some text processing on tweets
//
// Syntax
    //     [senti,tweets] = twitter_processTweets(rawtweets)
    //     [senti,tweets] = twitter_processTweets(rawtweets,prog)
    //
    // Parameters
    //     rawtweets : String array. Retrieved tweets
    //     prog : String. Optional input to display progress. The options are "on","off","gui".
    //     senti: String array. Sentiment of tweets
    //     tweets : String array. Processed tweets
    //
    // Description
    //     A very simple text processing of tweets for sentiment analysis. It removes all non-unicode symbols, new lines and excess space. The sentiment is then determined using nlp_getSentiment. This function requires the Stanford CoreNLP libraries to be added to the Scilab classpath.
    //
    // Examples
    //      twitter = twitter_init()
    //      str = "coffee"
    //      [id1,tweets1,info1] = twitter_getTweets(twitter,str)
    //      [senti,proctweets] = twitter_processTweets(list2vec(tweets1),"on")
    //
    // See also
    //    twitter_getTweets
    //
    // Authors
    //     Joshua T.
    

    
    
    bool = jautoUnwrap();
    jautoUnwrap(%t)
    
    rhs = argn(2)
    prog_bool = %f
    if rhs == 2 then
        switch prog
        case "gui"
            // Create the messagebox
            f1=figure('figure_position',[380,270],'figure_size',[300,80],'auto_resize','on','background',[33],'figure_name','Analyser','dockable','off','infobar_visible','off','toolbar_visible','off','menubar_visible','off','default_axes','on','visible','off');
    
            t1=uicontrol(f1,"style","text","string","","Position",[0 0 300 40],"BackgroundColor",[-1 -1 -1],"FontSize",16,"HorizontalAlignment","left");

            f1.visible = 'on';
            prog_bool = %t
        case "on"
            // Do nothing
            prog_bool = %t
        case "off"
            // Do nothing
        else
            error("Unknown option.")
        end
    elseif rhs > 2
        error("Too many inputs.")
    end
    
    tweet_cnt = size(tweetslist,1);
    
    sentiment_list = list();
    tweet_list = list()
    
    re1 = "/[^\w\s\d[:punct:]]/"
    re2 = "/[\r\n]/"
    re3 = "/\s+/" 
    
    for i = 1:tweet_cnt
        
        str = tweetslist(i)
        str1 = strsubst(str,re1,"","r")
        str2 = strsubst(str1,re2," ","r")
        str3 = strsubst(str2,re3," ","r")
        
        tweet_list(i) = str3
        
        sentiment_list(i) = nlp_getSentiment(str3)
        
        if prog_bool then
            switch prog
            case "gui"
                txt = "Processing tweet: "+string(i)+"/"+string(tweet_cnt)
                t1.string = txt
            case "on"
                mprintf("Processing tweet: %i/%i\n",i,tweet_cnt)
            end
        end
        
    end
    
    sentiment_vec = list2vec(sentiment_list)
    tweet_vec = list2vec(tweet_list)
    
    jautoUnwrap(bool)
    
endfunction
