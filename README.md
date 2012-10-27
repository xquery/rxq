# RXQ - MarkLogic restxq implementation (v.1)

The recent release of [MarkLogic 6](http://www.marklogic.com) included support for several [XQuery 3.0](http://www.w3.org/TR/xquery-30) features. 
One such feature, [annotations](http://www.w3.org/TR/xquery-30/#id-annotations), provides us with the opportunity to implement Adam Retter's RESTXQ draft (introduced at [XML Prague 2012](http://archive.xmlprague.cz/2012/sessions.html#RESTful-XQuery---Standardised-XQuery-3.0-Annotations-for-REST)).

RESTXQ proposes an elegant approach for building web applications using XQuery with consistent MVC architectures. 

This approach has a priori art e.g. JSR-311: Java Annotations for REST

To understand what RESTXQ is and how it works please [download](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf) Adam Retters excellent overview.

# How RXQ works
The following xquery module illustrates how to annotate your moudles. 

```
module namespace ex1="﻿http://example.org/ex1";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare 
   %rxq:GET 
   rxq:path('/address/id/(.*)') 
function ex1:get-address($id){ 
   .... 
};
```

RXQ supports 3 annotations at this time;

* HTTP method annotation - %rxq:GET | %rxq:PUT | %rxq:DELETE | %rxq:POST
* Path annotation (maping url path) - %rxq:path('/some/path/(.*)')
* Output content-type - %rxq:content-type('text/html')

When you deploy these modules in a MarkLogic appserver you must then import those modules into the controller.


# Setting up the example-site on MarkLogic 6

First, you *need* to download and install [MarkLogic 6](https://developer.marklogic.com/products). Second, create an appserver, providing the following details;

* root: provide example-site directory
* error handler: /rxq-rewriter.xqy?mode=error
* rewrite handler: /rxq-rewriter.xqy?mode=rewrite

Navigate to the created app (e.g. http://<host>:<port>/) and you should see the following;

 test by reviewing module lib rxq:paths in browser

# Limitations

The RESTXQ spec is still in draft form; where things were unclear I made my own impl decisions for the time being;
 
 * allow for full regex expressions within rxq:path, instead of binding by variable names
 * rxq:content-type provides return content-type
 * its the responsibility of underlying function to grab hold of a PUT or POST content body
 * added some more metadata to the output of rxq:resource-function() 
 * RXQ works only for ML-1.0 at the moment (due to deps on some xdmp:features)
 * 2 separate files e.g. at some point would like to merge rxq-rewriter.xqy into the rxq library module itself
