function out_str = text_striphtml(in_str, rep_str)
    // Strip all HTML and replace with the given rep_str.
    //
    //    Copyright 2019 Bytecode.
    //    
    //    This program is free software: you can redistribute it and/or modify
    //    it under the terms of the GNU General Public License as published by
    //    the Free Software Foundation, either version 2 of the License, or
    //    (at your option) any later version.
    //    
    //    This program is distributed in the hope that it will be useful,
    //    but WITHOUT ANY WARRANTY; without even the implied warranty of
    //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    //    GNU General Public License for more details.
    //    
    //    You should have received a copy of the GNU General Public License
    //    along with this program.  If not, see <http://www.gnu.org/licenses/
    //
    // Syntax
    //    out_str = text_striphtml(in_str [,rep_str]);
    //
    // Parameters
    //    in_str : Input string
    //    rep_str : Replacement string
    //    out_str : Output string
    //
    // Description
    //    Looks for any expression that starts with < and ends with > and replace and does not have any < or > in the tag it with a given string, by default is space.
    //
    // Examples
    //    in_str = '<html><head><title>Page Title</title></head><body><h1>This is a Heading</h1><p>This is a paragraph.</p></body></html>';
    //    out_str = text_striphtml(in_str);
    //    disp(out_str);
    //
    // See also
    //    nlp_sentiment
    //    text_gencloud
    //    text_porterstemmer
    //    text_stripdollar
    //    text_stripemail
    //    text_striphtml
    //    text_stripnumber
    //    text_stripurl
    //    text_tokenize
    //
    // Authors
    //    C.L. Tan - Bytecode Malaysia.
    //
    // Bibliography
    //    Andrew Ng, Machine Learning Online Course, Week 6 notes and assignment: https://www.coursera.org/learn/machine-learning
    //    

    rhs=argn(2);
    // Error Checking
    if rhs < 1 ; error("Expect at least 1 argument, in_str"); end    
    if rhs < 2; rep_str = ' '; end
    //Initializing Weight and Bias
    if rep_str == []; rep_str = ' '; end

    out_str = strsubst(in_str ,'/<[^<>]+>/' ,rep_str,'r');

endfunction
