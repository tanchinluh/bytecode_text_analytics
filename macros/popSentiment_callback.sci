function popSentiment_callback(handles)
// This function is used by twitter_TweetSentimentDemo.
// Display the processed tweets on the GUI based on the sentiment selected

    tweet_vec = handles.proctweets
    sentiment_vec = handles.sentiments
    
    select handles.popSentiment.value
    case 1
        [filtered_str,myind] = nlp_filterSentiment(sentiment_vec,tweet_vec,"Very Negative")
        handles.lstFilteredTweets.String = filtered_str
    case 2 
        [filtered_str,myind] = nlp_filterSentiment(sentiment_vec,tweet_vec,"Negative")
        handles.lstFilteredTweets.String = filtered_str
    case 3
        [filtered_str,myind] = nlp_filterSentiment(sentiment_vec,tweet_vec,"Neutral")
        handles.lstFilteredTweets.String = filtered_str
    case 4
        [filtered_str,myind] = nlp_filterSentiment(sentiment_vec,tweet_vec,"Positive")
        handles.lstFilteredTweets.String = filtered_str
    case 5
        [filtered_str,myind] = nlp_filterSentiment(sentiment_vec,tweet_vec,"Very Positive")
        handles.lstFilteredTweets.String = filtered_str
    end

endfunction
