# RXQ - MarkLogic RESTXQ implementation (v.1)

The recent release of [MarkLogic 6](http://www.marklogic.com) includes support for many cool [XQuery 3.0](http://www.w3.org/TR/xquery-30) features. 
One such feature, [annotations](http://www.w3.org/TR/xquery-30/#id-annotations), provides us with the opportunity to implement Adam Retter's [RESTXQ](http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html#method-annotation) draft (introduced at [XML Prague 2012](http://archive.xmlprague.cz/2012/sessions.html#RESTful-XQuery---Standardised-XQuery-3.0-Annotations-for-REST)).

RESTXQ proposes an elegant approach for building web applications using XQuery with consistent MVC architectures. A priori art JSR-311: Java Annotations for REST is the foundation of RESTXQ and RXQ.

To understand what RESTXQ is and how it works with XQuery 3.0 annotations please [download](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf) Adam Retters excellent overview.

# For the Impatient

1. download RXQ [dist](https://github.com/xquery/rxq/zipball/master) and unzip
2. copy [src/xquery/rxq-rewriter.xqy](https://github.com/xquery/rxq/blob/master/src/xquery/rxq-rewriter.xqy) and [src/xquery/lib/rxq.xqy](https://github.com/xquery/rxq/blob/master/src/xquery/lib/rxq.xqy) to your project
3. setup MarkLogic 6 appserver with url rewriter set to /rxq-rewriter.xqy?mode=rewrite and error handler to /rxq-rewriter.xqy?mode=error
4. edit rxq-rewriter.xqy, import your xquery modules which have RESTXQ annotations 

To learn more [install](https://github.com/xquery/rxq#setting-up-the-example-site-on-marklogic-6) and review [src/example-site](https://github.com/xquery/rxq/tree/master/src/example-site).

# Distribution

* README.md - this document
* [api](https://github.com/xquery/rxq/tree/master/api) - contains api level docs of RXQ rewriter and module library
* [src/example-site](https://github.com/xquery/rxq/tree/master/src/example-site) - contains example site which demonstrates how to use RXQ
* [src/xquery](https://github.com/xquery/rxq/tree/master/src/xquery) - contains clean rxq-rewriter.xqy and lib/rxq.xqy you can use in your own projects
* src/xray - RXQ uses Rob Whitby excellent [XRAY](https://github.com/robwhitby/xray) for xquery unit testing 
* [src/tests](https://github.com/xquery/rxq/tree/master/src/test) - used for testing

# How RXQ works

The following xquery module illustrates how to annotate your modules functions, so they can be accessible via HTTP Requests.

```
module namespace ex1="﻿http://example.org/ex1";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare 
   %rxq:GET 
   %rxq:path('/address/id/(.*)') 
function ex1:get-address($id){ 
   .... 
};
```
The above ex1:get-address() function is invoked when there is an HTTP GET Request on URL /address/id/(.*). The routing 'magic' is taken care of by the rxq-rewriter.xqy (which you attach to MarkLogic appserver). The %rxq:GET annotation specifies the HTTP method and the %rxq:path annotation value specifies the concrete URL.

The value for the ex1:get-address function's $id variable is taken from the first regex capture group in the url as specified by %rxq:path. This $id value can then be used by some search to lookup the address.

RXQ supports 3 annotations at this time;

* HTTP method annotation - %rxq:GET | %rxq:PUT | %rxq:DELETE | %rxq:POST
* Path annotation (maping url path) - %rxq:path('/some/path/(.*)')
* Produces annotation (output content-type) - %rxq:produces('text/html')

When you deploy these modules in a MarkLogic appserver you must then import those modules into the controller.

Please review the src/example-site/rxq-rewriter.xqy to see how to setup your own.

# Setting up the example-site on MarkLogic 6

The easist way to see RXQ in action is to setup the example application under src/example-site.

First, you *need* to download and install [MarkLogic 6](https://developer.marklogic.com/products). Second, create an appserver, providing the following details;

* root: provide example-site directory
* error handler: /rxq-rewriter.xqy?mode=error
* rewrite handler: /rxq-rewriter.xqy?mode=rewrite

With everything setup, you can now point your web browser to the created app (e.g. http://<host>:<port>/) and you should see html page.

# Limitations

The RESTXQ spec is still in draft form; where things were unclear I made my own impl decisions for the time being;
 
 * allow for full regex expressions within rxq:path, instead of binding by variable names
 * rxq:produces provides return content-type
 * its the responsibility of underlying function to grab hold of a PUT or POST content body
 * added some more metadata to the output of rxq:resource-function() 
 * RXQ works only for ML-1.0 at the moment (due to deps on some xdmp:features)
 * 2 separate files e.g. at some point would like to merge rxq-rewriter.xqy into the rxq library module itself

# License

RXQ is released under Apache License v2.0

Copyright 2012 Jim Fuller

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions.

# More Info

* RXQ github [repository](https://github.com/xquery/rxq)
* [EXQuery RESTXQ Draft Specification](http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html#method-annotation)
* Adam Retters [RESTXQ](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf).
* MarkLogic doc on [xdmp:annotation()](https://docs.marklogic.com/xdmp:annotation).
* [JSR-311](http://download.oracle.com/otndocs/jcp/jaxrs-1.0-fr-eval-oth-JSpec/).
