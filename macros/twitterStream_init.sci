function twitterstream = twitterStream_init(con_key,con_sec,acc_tok,acc_sec)
// Creates a Twitter object to connect to Twitter Stream API
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
//    twitterS = twitterStream_init()
//    consolebox on
//    twitter_displayStream(twitterS,%t)
//    twitter_stream(twitterS,"limit",15)
//
// See also
//    twitter_init
//
// Authors
//     Joshua T. - Bytecode Malaysia.
    
    jimport com.bytecode_asia.ScilabTwitterStream
    
    rhs = argn(2)
    init_bool = %f
    
    if rhs == 0 then
        // Launch gui to request parameters
        txt = ['Consumer Key';'Consumer Secret';'Access Token';'Access Secret'];
        val = x_mdialog('Please enter the following:',txt,["";"";"";""])
        if val == [] then
            // If user cancelled
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
        
        twitterstream = ScilabTwitterStream.new(consumer_key,consumer_secret,access_token,access_secret)
        
    else
        twitterstream = [];
    end
    
    
endfunction
