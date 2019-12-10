function tab = nlp_tabulSentiment(sentiment_vec)
// Tabulate the sentiments
//
// Syntax
//     tab = nlp_tabulSentiment(senti)
//
// Parameters
//     senti : String array. An array of sentiments
//     tab : String array. An array of the tabulated sentiments
// 
// Description
//     Tabulates the sentiment array.  
//
// Examples
//    str = ["I am happy."; "I am sad."; "You are happy."]
//    sentiment = nlp_getSentiment(str)
//    tab = nlp_tabulSentiment(sentiment) 
//
// See also
//    nlp_filterSentiment
//
// Authors
//     Joshua T. - Bytecode Malaysia.
    
    m = tabul(sentiment_vec)
    tab_val = [0;0;0;0;0]
    tab_key = ["Very negative" "Negative" "Neutral" "Positive" "Very positive"]
    i = 1
    for keyname = tab_key
        //disp(keyname)
        ind = find(m(1) == keyname)
        if ind ~= [] then
            tab_val(i) = m(2)(ind)
        end
        i = i+1
    end
    
    tab = [tab_key' string(tab_val)]
    
    
endfunction
