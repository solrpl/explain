1. Supported versions of Apache Solr
Explain.solr.pl supports the following versions of Apache Solr search server:
 * 3.x
 * 4.0 (beta)
 
We plan to support Apache Solr 3.6 and newer, but support for versions older
than 3.0 is not planned.

2. Adding a new query - 10 seconds tutorial
In order to add Your query explain information and visualise it, please add the
following to your query debugQuery=true and paste the raw Solr response. So if
your query looks like q=hd&bf=pow(sold,1.5)&qf=name,description,attributes you
should re-run a query which looks like the following:
q=hd&bf=pow(sold,1.5)&qf=name,description,attributes&debugQuery=true.

3. Adding a new query - detailed tutorial
In order to add Your query explain information and visualise it, please add the
following parameters to your query:
 * debugQuery=true (required)
 * indent=true (optional)
 * explainOther=... (optional)
After adding those parameters please re-run the query. After that paste raw Solr
response and click "Create Explain" button.
In order for explain.solr.pl to work the best way, please ensure that one of the
fields you return in the documents is your unique identifier (You can add this
by modifying with the fl parameter).

The meaning of the additional parameters is:
 * debugQuery=true - when debugQuery parameter is present the debuging
   information will be added to the response. Please remember that the debuging
   can affect performance, so don't use this parameter with your every query.
 * indent=true - when this parameter is added to the query, the raw Solr
   response is indented with whitespaces.
 * explainOther=... - if you want explain.solr.pl to visualise explain for some
   additional documents that are not in the result list you should add the
   unique identifiers of those documents as the value of the explainOther
   parameter. This will make Solr return explain for those documents and let
   explain.solr.pl visualise it.

4. Hidding your explain visualisation
If you want to make your explain information visualisation private please
uncheck the "I want this explain to be visible on history page." checkbox on the
"New explain" page. In order to get back to your explain information you will
need to remember its identifier and visit the following URL:
http://explain.solr.pl/explains/[ID]. For example, if explain.solr.pl generated
53827fty identifier for Your explain, You should visit
http://explain.solr.pl/explains/53827fty.

5. Available information
Explain.solr.pl application can show you the following information regarding your
query results:
a) RETURNED TAB
 * Unique identifier
   On the top of the explain visualisation page, you can see the unique
   identifier of Your explain visualisation. You will need that identifier to
   get back to the explain visualisation later.
 * Public availability
   This sections of explain visualisation page tells you about the public
   availability of your query explain. If you see a sentence like "This explain
   is available to public." your explain is visible by other users. In other
   case, to see your explain visualisation, you will need to know its unique
   identifier.
 * Fields returned
   This section contain information about the value of the fields that were
   returned by Solr (this are usually the fields defined in the fl parameter).
 * Score decomposition
   One of the main sections of explain visualisation which shows which elements
   of the scoring influenced the score and how. This section shows percentages
   of each debug query information.
 * Explain components
   This is the visualisation of the data that is presented in the "Score
   decomposition" section of the explain visualisation. You can see the same
   numbers that are presented in the mentioned section, but visualised in a form
   of pie chart.
b) PERFORMANCE tab
This tab presents the simple performance information about query components of
the query connected to the explain information you've sent to explain.solr.pl.

6. Common errors
Here are some common error that You can see while using explain.solr.pl:
 * "XML parse error. Check the XML document you've pasted and the quality of
   your copy & paste engine ;) Make sure you pasted the COMPLETE xml document
   returned from Solr." - There was an error during XML file parsing, please
   ensure that you've pasted the correct XML file, that You are using supported
   Solr version and the You have pasted raw Solr response (ie. page source is
   You are using web browser).
 * "Cannot determine unique key field. Connection doc/explain may be inaccurate.
   Check the existence of the unique key field in the 'fl' parameter." - Could
   not determine unique identifier of the result documents. Please ensure that
   you fetch the unique identifier in Your query - check the fl parameter
 * "No debug section in the data. Make sure that you use debugQuery option." -
   Debug section was not found in the XML file. Please check if the
   debugQuery=true parameter was added to the query.
 * "No debugOther section in the data." - Debug other section was not found in
   the XML file. Please check if the explainOther parameter was added to the
   query.
 * "XML parse error. 'numFound' attribute not found" - There was an error
   parsing XML file - numFound attribute was not found.
 * "Empty result list. Your explainOther parameter didn't match doocuments
   either." - There are no results in the response you submited.
 * "Empty result list. Use explainOther to check why concrete document wasn't
   found." - There are no results in the response you submited. Please look at
   the explainOther parameter to submit documents that are not a part of the
   result list.

7. Handling issues
If You find error in Solr Explain tool please send us a mail to explain@solr.pl
or create an issue on Github (https://github.com/solrpl/explain/issues).

                                                     Solr.pl team (2012)
                                                     Rafał Kuć
                                                     Marek Rogoziński
