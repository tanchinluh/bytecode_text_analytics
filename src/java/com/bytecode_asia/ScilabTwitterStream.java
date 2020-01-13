/*
ScilabTwitterStreaming.java
This Java file allows Twitter Streaming API to be run in Scilab.
*/

package com.bytecode_asia;

import twitter4j.*;
import twitter4j.conf.ConfigurationBuilder;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

import java.io.BufferedWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;



public class ScilabTwitterStream{

    private ConfigurationBuilder configurationBuilder = new ConfigurationBuilder();
    private TwitterStream twitterStream;
    private volatile Boolean stopstream = false;
    List<Status> statuses = new ArrayList<Status>();
    
    FilterQuery tweetFilterQuery;
    private String[] default_query = {"coffee"};
    private String[] user_query;
    private Boolean use_user_query = false;
    private String default_lang = "en";
    private String user_lang;
    private Boolean use_user_lang = false;
    private Boolean use_user_location = false;
    private double[][] user_location;
    private int tweet_limit;
    private Boolean use_tweet_limit = false;
    private volatile int tweet_cnt = 0; 
    private Boolean csv_enabled = false;
    private String csv_path;

    private volatile Boolean display_enabled = false;

    private BufferedWriter writer;
    private CSVPrinter csvPrinter;


    public ScilabTwitterStream(String consumer_key, String consumer_secret,String access_token, String access_secret){
        configurationBuilder.setOAuthConsumerKey(consumer_key)
                .setOAuthConsumerSecret(consumer_secret)
                .setOAuthAccessToken(access_token)
                .setOAuthAccessTokenSecret(access_secret)
                .setTweetModeExtended(true);

        // Creating the stream object
        twitterStream = new TwitterStreamFactory(configurationBuilder.build()).getInstance();

        // Creating the listener
        StatusListener listener = new StatusListener(){
            @Override
            public void onStatus(Status status) {
                
                statuses.add(status);

                if(display_enabled){
                    System.out.println(statuses.size() + ":" + status.getId() + "   " + status.getUser().getScreenName() + "   " + status.getCreatedAt());
                    System.out.println(status.getText());
                    System.out.println("--------------------------------------------------------");
                }
                

                if(csv_enabled){
                    try{

                        if(status.getPlace() != null){
                            csvPrinter.printRecord(Long.toString(status.getId()),
                                                                 status.getText(),
                                                                 status.getCreatedAt().toString(),
                                                                 status.getLang(),
                                                                 status.getUser().getName(),
                                                                 status.getUser().getScreenName(),
                                                                 status.getUser().getId(),
                                                                 status.getUser().getLocation(),
                                                                 status.getPlace().getName(),
                                                                 status.getPlace().getId(),
                                                                 status.getPlace().getCountry(),
                                                                 status.getPlace().getCountryCode()
                                                                 );
                        }else{
                            csvPrinter.printRecord(Long.toString(status.getId()),
                                                                 status.getText(),
                                                                 status.getCreatedAt().toString(),
                                                                 status.getLang(),
                                                                 status.getUser().getName(),
                                                                 status.getUser().getScreenName(),
                                                                 status.getUser().getId(),
                                                                 status.getUser().getLocation(),
                                                                 null,
                                                                 null,
                                                                 null,
                                                                 null
                                                                 );
                        }
                        
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                }

                if(use_tweet_limit){
                    tweet_cnt = tweet_cnt + 1;
                    if(tweet_cnt >= tweet_limit){
                        stopstream = true;
                    }
                }
   
            }

            @Override
            public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
                System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
            }

            @Override
            public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
                System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
            }

            @Override
            public void onScrubGeo(long userId, long upToStatusId) {
                System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
            }

            @Override
            public void onStallWarning(StallWarning warning) {
                System.out.println("Got stall warning:" + warning);
            }

            @Override
            public void onException(Exception ex) {
                ex.printStackTrace();
            }

        };  // End of StatusListener


        // Adding the streamer
        twitterStream.addListener(listener);


    } // End of Constructor


    public void stopStream(){
        stopstream = true;
    }

    public List<Status> getAllStatus(){
        return statuses;
    }


    public List<Status> getFirstStatus(int n){

        int cnt;

        if(n >= statuses.size()){
            cnt = statuses.size();
        }else{
            cnt = n;
        }

        List<Status> firststatus = statuses.subList(0,n);

        return firststatus;
    }

    public List<Status> getLastStatus(int n){

        int cnt;

        if(n >= statuses.size()){
            cnt = statuses.size();
        }else{
            cnt = n;
        }

        List<Status> laststatus = statuses.subList(statuses.size()-cnt,statuses.size());
        
        return laststatus;
    }

    public void generalStream(){
        // stream using the variable values
        stopstream = false;
        tweet_cnt = 0;
        tweetFilterQuery = new FilterQuery();

        if(use_user_query){
            tweetFilterQuery.track(user_query);
        }else{
            tweetFilterQuery.track(default_query);
        }
        
        if(use_user_lang){
            tweetFilterQuery.language(user_lang);
        }else{
            tweetFilterQuery.language(default_lang);
        }
        
        if (use_user_location){
            tweetFilterQuery.locations(user_location);
        }
        Thread myThread = new Thread(new StreamThread());
        myThread.start();

    }

    public void setQuery(String[] query){
        use_user_query = true;
        user_query = query;
    }

    public void setLang(String lang){
        user_lang = lang;
    }

    public void setLocation(double[][] locations){
        use_user_location = true;
        user_location = locations;
    }

    public void setTweetLimit(int n){
        tweet_limit = n;
        use_tweet_limit = true;

    }

    public void resetUserParameters(){
        use_user_query = false;
        use_user_lang = false;
        use_user_location = false;
        use_tweet_limit = false;
        

    }

    public void clearTweets(){
        statuses.clear();
    }

    public void setCSVPath(String path){
        csv_enabled = true;
        csv_path = path;
    }

    public void setDisplay(Boolean display){
        display_enabled = display;
    }

    public List<Status> execute() throws TwitterException {
        
        twitterStream.filter(tweetFilterQuery);
        System.out.println("Twitter Streaming started.");

        while (!stopstream){
            // Continue streaming
        }

        twitterStream.cleanUp();
        twitterStream.shutdown();
        System.out.println("Twitter Streaming has stopped.");

        return statuses;

    }


    class StreamThread extends Thread  {
        

        public void run() {

            if(csv_enabled){
                try{
                    writer = Files.newBufferedWriter(Paths.get(csv_path),StandardOpenOption.APPEND, StandardOpenOption.CREATE);
                    csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }

            try{
                execute();
            }catch(TwitterException e){
                System.out.println(e);
            }

            if(csv_enabled){
                csv_enabled = false;
                try{
                    csvPrinter.flush();
                    csvPrinter.close();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
            
        }// end run

    }


}




