function pbSentiment_callback(handles)
// This function is used by twitter_TweetSentimentDemo.
// Analyse tweets using twitter_processTweets
// Tabulate the sentiment results and display them on the GUI

        [handles.sentiments,handles.proctweets] = twitter_processTweets(handles.rawtweets,"gui")
        table = nlp_tabulSentiment(handles.sentiments)
        
        handles.t1.string = table(1,2)
        handles.t2.string = table(2,2)
        handles.t3.string = table(3,2)
        handles.t4.string = table(4,2)
        handles.t5.string = table(5,2)
        handles = resume(handles);
        
endfunction
