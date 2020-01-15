This is a Text Analytics toolbox.

Currently, the module provides few functions for text processing. Two main features of this module is the Stemmer Porter which currently call the Java library from https://tartarus.org/martin/PorterStemmer/ and the sentiment analysis from the standford nlp library

The NLP functions require the Stanford CoreNLP libraries.
You can download the libraries from https://stanfordnlp.github.io/CoreNLP/download.html.

To load them into Scilab, do the following:
1. Extract the downloaded Stanford CoreNLP zip file.
2. Use the function jar_import to add the jar files to Scilab.
   jar_import('path to folder containing jar files')

Some functions allow you to send request fo a Stanford server.
The same downloaded files can be used to run a local server.

1. In Windows, launch command prompt.
2. Change directory to folder.
cd folder_path
3. Type the following to start the server.
   java -mx6g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer

You can access the local server using the url 127.0.0.1:9000.
