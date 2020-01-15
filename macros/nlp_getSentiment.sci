function senti = nlp_getSentiment(str)
// Obtains the sentiment of a given string
//
// Syntax
//     senti = nlp_getSentiment(str)
//
// Parameters
//     str : String. The text to be analysed
//     senti : String. The sentiment of the text
// 
// Description
//     Determines the sentiment of a given text. The sentiment is set by the longest sentence in the text. This function requires the Stanford CoreNLP libraries to be added to the Scilab classpath. For a more comprehensive sentiment analysis (or for an online version), please use nlp_sentiment.  
//
// Examples
//     str = "I am happy. This is a long, sad and heart breaking sentence. You are happy."
//    sentiment = nlp_getSentiment(str) 
//
// See also
//      nlp_sentiment
//
// Authors
//     Joshua T. - Bytecode Malaysia.

    jimport java.util.Properties
    jimport edu.stanford.nlp.pipeline.StanfordCoreNLP;
    jimport edu.stanford.nlp.ling.CoreAnnotations$SentencesAnnotation
    jimport edu.stanford.nlp.sentiment.SentimentCoreAnnotations$SentimentClass
    
    bool = jautoUnwrap()
    jautoUnwrap(%t)
    
    props = Properties.new()
    props.setProperty("annotators", "tokenize,ssplit,parse,sentiment")
    pipeline = StanfordCoreNLP.new(props)
    
    str_cnt = size(str,'*');
    
    for i = 1:str_cnt
    
        ann = pipeline.process(str(i))
        sentence = ann.get(CoreAnnotations$SentencesAnnotation);
        
        cnt = sentence.size();
        
        longest = 0
        for j = 0:cnt-1
            sentence2 = sentence.get(j)
            sentiment = sentence2.get(SentimentCoreAnnotations$SentimentClass)
            partText = sentence2.toString()
            if (length(partText) > longest)
                mainSentiment = sentiment;
                longest = length(partText);
            end // end if
        
        end // end inner loop
    
        senti(i) = mainSentiment
    
   end
    
    jautoUnwrap(bool)
endfunction
