function res = nlp_simple(str,ann)
// Runs a specified annotator
//
// Syntax
//    res = nlp_simple(str,ann)   
//
// Parameters
//     str : String. The text to be analyzed
//     ann : String. The specified annotator. Available annotators are sentence splitting (ssplit), tokenization (tokenize), part of speech tagging (pos), lemmatization (lemma), named entity recognition (ner), constituency parsing (parse), dependency parsing (depparse), coreference resolution (dcoref), natural logic polarity, (natlog) and open information extraction (openie).
//     res : List. The result from the annotation.
//
// Description
//     Runs the specified annotator on the string. This uses annotators from Stanford Simple CoreNLP. Note: Certain annotators (ner, depparse, dcoref) requires a lot of memory. You will need to increase Scilab's Java heap memory to be several GB or more in order to work. The heap memory can be adjusted under Preferences.
//
// Examples
//    str1 = "The lion and the unicorn were fighting for the crown. The lion beat the unicorn all around the town." 
//   res1 = nlp_simple(str1,"ssplit")
//   res2 = nlp_simple(str1,"tokenize")
//   res3 = nlp_simple(str1,"pos")
//   res4 = nlp_simple(str1,"lemma")
//   str2 = "3 men lived in Gotham. They went on vacation to London."
//   res5 = nlp_simple(str2,"parse")
//   res6 = nlp_simple(str2,"depparse")
//   res7 = nlp_simple(str2,"natlog")
//   res8 = nlp_simple(str2,"openie")
//   res9 = nlp_simple(str2,"ner")
//   str3 = "Mary had a little lamb. Its fleece was white as snow. And everywhere that she went it was sure to go."
//   res10 = nlp_simple(str3,"dcoref")
//
// See also
//    nlp_url
//
// Authors
//     Joshua T. 
    
    jimport edu.stanford.nlp.simple.Document 
    
    bool = jautoUnwrap()
    jautoUnwrap(%t)
    
    doc = jnewInstance(Document,str)
    sentences = jinvoke(doc,"sentences")
    
    l = list();
    for i = 1:sentences.size()
        temp = sentences(i)
        select ann
        case "ssplit"
            l(i) = jinvoke(temp,"toString")
            
        case "tokenize"
            l(i) = jinvoke(temp,"words");
           
        case "pos"
            l(i) = jinvoke(temp,"posTags")
            
        case "lemma"
            l(i) = jinvoke(temp,"lemmas")
            
        case "ner"
            l(i) = jinvoke(temp,"nerTags")
            
        case "parse"
            parse = jinvoke(temp,"parse");
            l(i) = jinvoke(parse, "toString");
            
        case "depparse"
            graph = jinvoke(temp,"dependencyGraph")
            iter = jinvoke(jinvoke(graph,"edgeIterable"),"iterator")
            dep_arr = []
            cnt = 1
            while jinvoke(iter,"hasNext")
                edge = jinvoke(iter,"next")
                relation = edge.getRelation().toString()
                gov = edge.getGovernor().word()
                gov_ind = edge.getGovernor().index()
                dep = edge.getDependent().word()
                dep_ind = edge.getDependent().index()
                mystr = msprintf("%s(%s-%i, %s-%i)",relation,gov,gov_ind,dep,dep_ind)
                dep_arr(cnt,1) = mystr
                cnt = cnt+1
            end
            l(i) = dep_arr;
                    
        case "dcoref"
            core = jinvoke(doc,"coref")
            l = jinvoke(core,"toString")
            break
            
        case "natlog"
            nat = jinvoke(temp,"natlogPolarities")
            l(i) = jinvoke(nat,"toString")
            
        case "openie"
            openie = jinvoke(temp,"openie")
            openie_arr = [];
            for k = 1:openie.size()
                openie_arr(1,k) = jinvoke(openie(k),"toString")
            end
            l(i) = openie_arr
        else
            error("Annotators unknown.")
        end
    end
    
    res=l
    
    jautoUnwrap(bool)
endfunction
