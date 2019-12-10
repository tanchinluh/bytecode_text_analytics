function pbButton_callback(handles)
// This function is used by twitter_TweetSentimentDemo.
// Retrieves tweets from Twitter using the input from the GUI.

    lat = evstr(handles.editLat.String)
    lon = evstr(handles.editLong.String)
    rad = evstr(handles.editRad.String)
    temp = handles.editText.String 
    
    if rad == [] then
        rad = 10
    end
    
    if lat == [] | lon == [] then
        [myid,mytweets,myinfo] = twitter_getTweets(handles.twitter,temp,"ntweets",100)
    else
        [myid,mytweets,myinfo] = twitter_getTweets(handles.twitter,temp,"latlon",[lat,lon],"rad",rad,"ntweets",100)
    end
    
    my_cnt = size(mytweets)
    mytweets_vec = list2vec(mytweets)
    handles.txtResult.String = 'Total Tweets: '+string(my_cnt)
    handles.rawtweets = mytweets_vec;
    handles = resume(handles); 

endfunction
