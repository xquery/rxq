# Overview

The recent release of MarkLogic 6 included support for several XQuery 3.0 features. One such feature, annotations, provided the opportunity at attempting to implement Adam Retter's RESTXQ draft (introduced at XML Prague 2012). RESTXQ proposes a consistent and elegant approach for building web applications using XQuery.


# How RESTXQ works

declare %rxq:GET rxq:path('/address/id/(.*)') function local:get-address($id){ .... }

# Setting up the example-site

Create an appserver, provide the followig details;

* root: provide example-site directory
* error handler: /rxq-rewriter.xqy?mode=error
* rewrite handler: /rxq-rewriter.xqy?mode=rewrite

Navigate to the created app (e.g. http://<host>:<port>/) and you should see the following;

 test by reviewing module lib rxq:paths in browser

 

 
