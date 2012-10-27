# RXQ - MarkLogic restxq implementation (v.1)

The recent release of [MarkLogic 6](http://www.marklogic.com) included support for several [XQuery 3.0](http://www.w3.org/TR/xquery-30) features. 
One such feature, [annotations](http://www.w3.org/TR/xquery-30/#id-annotations), provides us with the opportunity to implement Adam Retter's RESTXQ draft (introduced at [XML Prague 2012](http://archive.xmlprague.cz/2012/sessions.html#RESTful-XQuery---Standardised-XQuery-3.0-Annotations-for-REST)).

RESTXQ proposes an elegant approach for building web applications using XQuery with consistent MVC architectures. 

This approach has a priori art e.g. JSR-311: Java Annotations for REST


# How RESTXQ works

```
declare 
   %rxq:GET 
   rxq:path('/address/id/(.*)') 
function local:get-address($id){ 
   .... 
};
```

ml-RESTXQ only supports 3 annotations at this time;

* http method - %rxq:GET | %rxq:PUT | %rxq:DELETE | %rxq:POST
* map url path - %rxq:path('/some/path/(.*)')
* output content-type - %rxq:content-type('text/html')

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

 
