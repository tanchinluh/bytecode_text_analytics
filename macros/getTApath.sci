function y = getTApath()
// Gets the full path of the toolbox
    if isdef('text_analyticslib') then
        [m, mp] = libraryinfo('text_analyticslib');
        mp = fullpath(mp);
        y = strncpy( mp, length(mp)-length("macros") );
    else
        y = "";
    end
endfunction
