function str = text_porterstemmer(filepath)
    // Apply stemming on the input text
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
    //    str = text_porterstemmer(filepath);
    //
    // Parameters
    //    filepath : String of path to file, or Scilab string array
    //    str : The result of stemming
    //
    // Description
    //    A simple function using the Stemmer2 class
    //
    // Examples
    //    input_str = 'Scilab is a free and open source software for engineers & scientists';
    //    out_str = text_porterstemmer(input_str);
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
    //    Joshua - Bytecode Malaysia.
    //
    // Bibliography
    //    Martin Porter, The Porter Stemming Algorithm: https://tartarus.org/martin/PorterStemmer/
    //    
    
    jimport Stemmer2

    if size(filepath,1) > 1 then
        mputl(filepath,TMPDIR+'/temp.txt');
        temp = Stemmer2.main(TMPDIR+'/temp.txt');
        str = strsubst(temp,ascii(10)," ")
        str = text_tokenize(str);

    else
        temp = Stemmer2.main(filepath);

        if temp == '' then
            mputl(filepath,TMPDIR+'/temp.txt');
            temp = Stemmer2.main(TMPDIR+'/temp.txt');
        end
        str = strsubst(temp,ascii(10)," ")
    end
    
    str = stripblanks(str);
    
endfunction
