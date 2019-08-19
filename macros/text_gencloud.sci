function text_gencloud(tag_text,tag_count,x_spacing,y_spacing,sz_inc,colormap,isbold)
    // Generate text cloud from a given text-count pairs
    //
    // Syntax
    //    text_gencloud(tag_text,tag_count)
    //    text_gencloud(tag_text,tag_count,x_spacing,y_spacing,sz_inc,colormap,isbold)
    //
    // Parameters
    //    tag_text : A (m x 1) string matrix of the text to generate text cloud
    //    tag_count : A (m x 1) double matrix correspond to the counts of the text appearance
    //    x_spacing : Spacing between words in a row, in the range of 0.01 - 0.2
    //    y_spacing : Spacing between words in col, in the range of 0.01 - 0.2
    //    sz_inc : Size to increase or decrese for all words, in the range of 1 - 10
    //    colormap : Colormap could be in 3 format, [r g b], color string such as "blue", and standard colormap such as hsvcolormap(64) etc.
    //    isbold : To plot the text in bold, %t or %f
    //
    // Description
    //    This function generate a text cloud base on given text and count. 
    //
    // Examples
    //    AtoZ = strsplit(ascii([65:90,97:122]));
    //    m = 100;
    //    for cnt = 1:m
    //        strlen = round(rand()*10+3);     
    //        randstr = round(rand(1,strlen)*51+1);
    //        tag_text(cnt) = strcat(AtoZ(randstr));
    //    end
    //    tag_count = round(rand(m,1).*4 + 1);
    //    text_gencloud(tag_text,tag_count,0.02,0.1,1,hsvcolormap(6),%t);
    //
    // See also
    //
    // Authors 
    //    C.L. Tan - Bytecode Malaysia.
    //
    rhs = argn(2);

    if rhs <=6 then, isbold = %f; end
    if rhs <=5 then, colormap = 'blue'; end
    if rhs <=4 then, sz_inc = 0; end
    if rhs <=3 then, y_spacing = 0.08; end
    if rhs <=2 then, x_spacing = 0.01; end
    if rhs ==0 then
        AtoZ = strsplit(ascii([65:90,97:122]));
        m = 60;
        for cnt = 1:m
            strlen = round(rand()*8+3);     
            randstr = round(rand(1,strlen)*51+1);
            tag_text(cnt) = strcat(AtoZ(randstr));
        end
        tag_count = round(rand(m,1).*4 + 1);
    end
    if x_spacing == [];x_spacing = 0.01;end
    if y_spacing == []; y_spacing = 0.08;end
    if sz_inc == []; sz_inc = 0;end
    if colormap == []; colormap = 'blue';end
    if isbold == []; isbold = %f;end

    num = size(tag_count,1);
    plot2d([0, 1], [0, 1], 0);
    f = gcf();
    f.figure_position=[0 0];
    h = getsystemmetrics('SM_CYSCREEN')
    w = getsystemmetrics('SM_CXFULLSCREEN')

    f.figure_size = [w h].*0.6;
    f.children.axes_visible = ['off' 'off' 'off'];

    if type(colormap) == 10
    elseif sum(size(colormap) == [1 3]) == 2
        f.color_map($+1,:) =  colormap;
        //txt.font_color = getColorIndex(colormap);
    else
        f.color_map = colormap;
    end



    sleep(1000)

    tag_count = tag_count;
    tag_count_sz = round((tag_count - min(tag_count))./(max(tag_count)-min(tag_count)).*4)+1+sz_inc;
    //tag_count = 
    
    x = 0.02;
    y = 0.9;

    if isbold == %t then
        font_type = 4;
    else
        font_type = 2; 
    end

    for cnt = 1:num
        r = xstringl(x, y, tag_text(cnt),font_type, tag_count_sz(cnt));

        if r(1)+r(3) > 1
            y = y - y_spacing;
            x = 0.02;
            r = xstringl(x, y, tag_text(cnt),font_type, tag_count_sz(cnt));
        end

        xstring(r(1), r(2)-1.2.*r(4), tag_text(cnt));

        txt = gce();
        txt.font_size = tag_count_sz(cnt);

        if type(colormap) == 10
            txt.font_color = color(colormap);
        elseif sum(size(colormap) == [1 3]) == 2;
            txt.font_color = size(f.color_map,1);
        else
            //txt.font_color = cnt;
            //txt.font_color =max(tag_count)+1-tag_count(cnt);
            txt.font_color =tag_count(cnt);
        end




        txt.font_style = font_type;

        x = r(1) + r(3) + x_spacing;
    end




endfunction
