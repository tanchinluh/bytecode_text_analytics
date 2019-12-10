function twitter_TweetSentimentDemo(twitter)
// Tweet sentiment analysis demo
//
// Syntax
    //     twitter_TweetSentimentDemo()
    //     twitter_TweetSentimentDemo(twitter)
    //
    // Parameters
    //     twitter : Twitter object. Obtained from twitter_init function
    //
    // Description
    //     Launches a GUI for tweet sentiment analysis. This demo uses the twitter_processTweets function to process the tweets. This demo requires the Stanford CoreNLP libraries to be added to the Scilab classpath.
    //
    // Examples
    //    twitter_TweetSentimentDemo()
    //
    // See also
    //    twitter_processTweets
    //
    // Authors
    //     Joshua T.

    rhs = argn(2);
    nlp_chk = %f // Check NLP libraries
    twitter_chk = %f // Check Twitter initalization
    demo_run = %f // Whether to run demo
    
    while ~nlp_chk
        try
            jimport edu.stanford.nlp.pipeline.StanfordCoreNLP;
            nlp_chk = %t
            twitter_chk = %t
        catch
            messagebox("You need to add Stanford CoreNLP jar files to run this demo!","Java Libraries Required","warning","modal")
            [jars] = jar_import();
            if jars == "" // user cancelled
                nlp_chk = %t // stop while loop
            end
        end
    end
    
    if twitter_chk then
        if rhs == 0 then
            twitter = twitter_init()
            if isempty(twitter) then
                // User Cancelled
                demo_run = %f
            else
                demo_run = %t
            end
        
        elseif rhs == 1
            // check if it is the correct input
            if type(twitter) == 17 then
                //disp("Type 17")
                if  twitter.class().toString() == "class twitter4j.TwitterImpl" then
                //disp("Correct class")
                    demo_run = %t
                else
                    error("Wrong input type.")
                end
            else
                error("Wrong input type.")
            end
        else
            error("Too many inputs.")
        end
    end
    
    if demo_run then
        //disp(typeof(twitter))
        
        // Initial values
        // San Fransisco 37.7749° N, 122.4194° W
        lat = "37.7749"
        lng = "-122.4194"
        rad = "10"
        query = "coffee"
        
        // Create the GUI
        f=figure('figure_position',[200,50],'figure_size',[640,640],'auto_resize','on','background',[33],'figure_name','Graphic window number %d','dockable','off','infobar_visible','off','toolbar_visible','off','menubar_visible','off','default_axes','on','visible','off');
        
        
        // GUI properties
        sz = 120;
        sz1 = 120;
        sz2 = 40;
        y1 = 250;
        y2 = 210;
        xstrt = 0.015625
        yhght = 0.05
        xwidth = 0.67
        ssz = 0.1875
        ssz1 = 0.1875
        ssz2 = 0.0625
        yy1 = 0.53-0.051
        yy2 = 0.4676-0.05
        xoff = 0.03125

        handles.dummy = 0;
        handles.rawtweets = [];
        handles.proctweets = [];
        handles.sentiments = [];
        handles.twitter = twitter;
        
        // GUI components
        // Demo Title
        handles.txtTitle=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[20],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.01,0.91,0.98,0.08],'Relief','default','SliderStep',[0.01,0.1],'String','Tweets Sentiment Analyser','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txtResult','Callback','')
        
        // Latitude Text
        handles.txtLat=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt,0.84,0.16,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',' Latitude:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txtResult','Callback','')

        // Latitude Input
        handles.editLat=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt+0.16,0.84,0.15,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',lat,'Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','editText','Callback','')

        // Longitude Text
        handles.txtLong=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt+0.33,0.84,0.15,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',' Longitude:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txtResult','Callback','')

        // Longitude Input
        handles.editLong=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt+0.48,0.84,0.15,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',lng,'Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','editText','Callback','')

        // Radius Text
        handles.txtRad=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt+0.65,0.84,0.16,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',' Radius(km):','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txtResult','Callback','')

        // Radius Input
        handles.editRad=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt+0.81,0.84,0.15,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',rad,'Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','editText','Callback','')

        // Twitter Search Box
        handles.editText=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt,0.77,xwidth,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',query,'Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','editText','Callback','')

        // Twitter Search Button
        handles.pbButton=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.7,0.76,0.28,0.07],'Relief','raised','SliderStep',[0.01,0.1],'String','Search Twitter','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','pbButton','Callback','pbButton_callback(handles)')

        // TextBox to display number of Tweets
        handles.txtResult=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt,0.69,xwidth,yhght],'Relief','default','SliderStep',[0.01,0.1],'String','Total Tweets:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txtResult','Callback','')

        // Sentiment Analyser Button
        handles.pbSentiment=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.7,0.68,0.28,0.07],'Relief','raised','SliderStep',[0.01,0.1],'String','Analyse Sentiment','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','pbSentiment','Callback','pbSentiment_callback(handles)')
        
        // Sentiment images
        tlbxpath = getTApath();
        imgpath = tlbxpath+"images\"
        h1=uicontrol(f,"style","image","string",imgpath+"1.png","Position",[ssz*0+xoff yy1 ssz ssz],"BackgroundColor",[-1 -1 -1],"HorizontalAlignment","center", "Units","normalized");
        h2=uicontrol(f,"style","image","string",imgpath+"2.png","Position",[ssz*1+xoff yy1 ssz ssz],"BackgroundColor",[-1 -1 -1],"HorizontalAlignment","center", "Units","normalized");
        h3=uicontrol(f,"style","image","string",imgpath+"3.png","Position",[ssz*2+xoff yy1 ssz ssz],"BackgroundColor",[-1 -1 -1],"HorizontalAlignment","center", "Units","normalized");
        h4=uicontrol(f,"style","image","string",imgpath+"4.png","Position",[ssz*3+xoff yy1 ssz ssz],"BackgroundColor",[-1 -1 -1],"HorizontalAlignment","center", "Units","normalized");
        h5=uicontrol(f,"style","image","string",imgpath+"5.png","Position",[ssz*4+xoff yy1 ssz ssz],"BackgroundColor",[-1 -1 -1],"HorizontalAlignment","center", "Units","normalized");
        
        // Sentiment Tabulated Values
        data = [0 0 0 0 0]
        handles.t1=uicontrol(f,"style","text","string",string(data(1)),"Position",[ssz*0+xoff yy2 ssz1 ssz2],"BackgroundColor",[-1 -1 -1],"FontSize",36,"HorizontalAlignment","center", "Units","normalized");
        handles.t2=uicontrol(f,"style","text","string",string(data(2)),"Position",[ssz*1+xoff yy2 ssz1 ssz2],"BackgroundColor",[-1 -1 -1],"FontSize",36,"HorizontalAlignment","center", "Units","normalized");
        handles.t3=uicontrol(f,"style","text","string",string(data(3)),"Position",[ssz*2+xoff yy2 ssz1 ssz2],"BackgroundColor",[-1 -1 -1],"FontSize",36,"HorizontalAlignment","center", "Units","normalized");
        handles.t4=uicontrol(f,"style","text","string",string(data(4)),"Position",[ssz*3+xoff yy2 ssz1 ssz2],"BackgroundColor",[-1 -1 -1],"FontSize",36,"HorizontalAlignment","center", "Units","normalized");
        handles.t5=uicontrol(f,"style","text","string",string(data(5)),"Position",[ssz*4+xoff yy2 ssz1 ssz2],"BackgroundColor",[-1 -1 -1],"FontSize",36,"HorizontalAlignment","center", "Units","normalized");
        
        // Sentiment Dropdown Menu
        popup_con = ["Very Negative" "Negative" "Neutral" "Positive" "Very Positive"]
        handles.popSentiment=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt,0.34,xwidth,yhght],'Relief','default','SliderStep',[0.01,0.1],'String',popup_con,'Style','popupmenu','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','popSentiment','Callback','popSentiment_callback(handles)')
        
        // Sentiment Selector Text
        handles.txtSentiment=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.7,0.33,0.28,0.07],'Relief','default','SliderStep',[0.01,0.1],'String','Sentiment Selector','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','pbSentiment','Callback','')

        // List box to list filtered tweets
        handles.lstFilteredTweets=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[xstrt,0.0127273,0.96875,0.3],'Relief','default','SliderStep',[0.01,0.1],'String','','Style','listbox','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txtFilteredTweets','Callback','')

        f.visible = "on";
        handles = resume(handles);

    end
    
endfunction

