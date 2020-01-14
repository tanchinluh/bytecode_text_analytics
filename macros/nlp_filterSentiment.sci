function [filtered_str,ind] = nlp_filterSentiment(senti_vec,str_vec,senti,n)
// Filter a string array based on a given sentiment
//
// Syntax
//     [filtered_str,ind] = nlp_filterSentiment(senti_vec,str_vec,senti,n)
//
// Parameters
//     senti_vec : String array. The sentiments
//     str_vec : String array. Text corresponding to the sentiments
//     senti : String. The specified sentiment
//     n : Double. Maximum number of texts to return 
//     filtered_str : The filtered text
//     ind : Double matrix. Index of the filtered text 
// 
// Description
//     Extracts strings from a string array based on a given sentiment. 
//
// Examples
//     sentiments = ["Neutral";"Neutral";"Positive"]
//     text = ["This is a text example.";"Mic test";"I am happy."]
//     [filtered_str,ind] = nlp_filterSentiment(sentiments,text,"Positive",5)
//
// See also
//      nlp_tabulSentiment
//
// Authors
//     Joshua T. - Bytecode Malaysia.



    
    rhs = argn(2)
    
    low_senti = convstr(senti,"l");
    switch low_senti
    case "very negative"
        senti_str = "Very negative"
    case "negative"
        senti_str = "Negative"
    case "neutral"
        senti_str = "Neutral"
    case "positive"
        senti_str = "Positive"
    case "very positive"
        senti_str = "Very positive"
    else
        error("Sentiment should be Very negative, Negative, Neutral, Positive or Very positive")
    end
    
    sentiment_ind = find(senti_vec == senti_str);
    
    if rhs == 4 then
        if n > length(sentiment_ind)
            n = length(sentiment_ind)
        end
        ind = sentiment_ind(1:n)
        filtered_str = str_vec(ind)
        
    elseif rhs == 3 // return all of them
        
        ind = sentiment_ind
        filtered_str = str_vec(ind)
    end
    
    
endfunction
