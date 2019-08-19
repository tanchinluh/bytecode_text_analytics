function out_str = text_tokenize(in_str)
    // Tokenize and also get rid of any punctuation
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
    //    out_str = text_tokenize(in_str);
    //
    // Parameters
    //    in_str : Input string
    //    out_str : Output string
    //
    // Description
    //    Tokenize and also get rid of any punctuation
    //
    // Examples
    //    in_str = 'A line of text for tokenize test';
    //    out_str = text_tokenize(in_str);
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
    //if rhs < 2; rep_str = 'httpaddr'; end
    ////Initializing Weight and Bias
    //if rep_str == []; rep_str = 'httpaddr'; end

    out_str = strsplit(in_str,['@','$','/','#','.','-',':','&','*','+','=','[',']','?','!','(',')','{','}',',','''',"""",'>','_','<',';','%',' ',char(10),char(13)]);

    out_str = out_str(out_str~='');
    //out_str = stripblanks(out_str);
endfunction
