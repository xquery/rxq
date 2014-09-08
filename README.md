# RXQ v1.0 - RESTXQ for MarkLogic

Use RXQ to build MVC/RESTful apps with MarkLogic XQuery.

Until RXQ has a release version, we list significant changes [here](https://github.com/xquery/rxq/wiki/Changes)

[Applications built with RXQ](https://github.com/xquery/rxq/wiki/Applications-using-RXQ)

## What is RESTXQ/RXQ ?

[MarkLogic 6 and 7](http://www.marklogic.com) includes support for annotations [XQuery 3.0](http://www.w3.org/TR/xquery-30).

One such feature, [annotations](http://www.w3.org/TR/xquery-30/#id-annotations), provides the opportunity to implement Adam Retter's [RESTXQ](http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html#method-annotation) draft (introduced at [XML Prague 2012](http://archive.xmlprague.cz/2012/sessions.html#RESTful-XQuery---Standardised-XQuery-3.0-Annotations-for-REST)).

RESTXQ is an elegant approach for building RESTFul interfaces; full blown web applications using XQuery within a consistent MVC architecture.

RESTXQ is based on the annotations defined within [JSR-311](http://download.oracle.com/otndocs/jcp/jaxrs-1.0-fr-eval-oth-JSpec).

To understand what RESTXQ is and how it works with XQuery 3.0 annotations please [download](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf) Adam Retter's excellent overview.

RXQ is an implementation of RESTXQ for the MarkLogic server.

## For the Impatient (set up example application)

MarkLogic 6.0-3 and higher is required version for use with RXQ.

The quickest way to see RXQ in action is to setup the example application under [src/example-simple](https://github.com/xquery/rxq/tree/master/src/example-simple).

First, you *need* to download and install [MarkLogic](https://developer.marklogic.com/products). Second, create an appserver, providing the following details;

* _root_: provide directory where example-simple resides on your filesystem
* _error handler_: `/rxq-rewriter.xqy?mode=error`
* _rewrite handler_: `/rxq-rewriter.xqy?mode=rewrite`

You can now point your web browser to the created app (e.g. http://&lt;host&gt;:&lt;port&gt;/) and you should see an html page which is the example-simple application.

## Distribution

* [README.md](https://github.com/xquery/rxq) - This document
* [api](https://github.com/xquery/rxq/tree/master/api) - contains api level docs of RXQ rewriter and module library
* [src/example-simple](https://github.com/xquery/rxq/tree/master/src/example-simple) - contains example site which demonstrates how to use RXQ
*  [src/example-dashML](https://github.com/xquery/rxq/tree/master/src/example-dashml) - non trivial [dashML](https://github.com/xquery/dashML) application (dashboard metrics) using RXQ.
* [src/xquery](https://github.com/xquery/rxq/tree/master/src/xquery) - contains clean rxq-rewriter.xqy and lib/rxq.xqy you can use in your own projects
* src/xray - RXQ uses Rob Whitby's excellent [XRAY](https://github.com/robwhitby/xray) for xquery unit testing
* [src/tests](https://github.com/xquery/rxq/tree/master/src/test) - used for testing

## RXQ in action

To use RXQ in your own application emulate how the example-simple is structured.

Essentially, you need these files in your project.

* rxq-rewriter.xqy - simple rewriter and entry point where you import modules which include RESTXQ annotations
* lib/rxq.xqy - the RXQ library

Then you will need setup a MarkLogic appserver (follow example simple instructions), edit rxq-rewriter.xqy to import the library modules containing your RESTXQ annotations.

You can enable the following options via setting variable in rxq-rewriter.xqy
* enable-caching - performs simple caching of your annotated function outputs
* enable-gzip - will output gzip encoding as default

All the following code examples are included in the example application.

The following xquery module illustrates how to annotate your modules functions using RESTXQ, which in turn will map them to a URL so they can be invoked via an HTTP Request.

```xquery
xquery version "1.0-ml";
module namespace addr="﻿http://example.org/address";
declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare
   %rxq:GET
   %rxq:path('/address/id/(.*)')
   %rxq:produces('text/html')
   %output:method('html')
function addr:get-address($id){
   ....
};
```

The `addr:get-address($id)` function has defined 4 RESTXQ annotations;

* _%rxq:GET_: indicates to select when HTTP REQUEST uses GET method
* _%rxq:path('/address/id/(.*)')_: maps the url /address/id/(.*) to this function, note the usage of regex matching group to capture `$id`
* _%rxq:produces('text/html')_: the output of this function, when returned by HTTP RESPONSE will have a content type of 'text/html'.
* _%output:method('html')_: makes sure that MarkLogic serializes a HTML document and not an "HTML unaware" XML document.

The `addr:get-address()` function is invoked when there is an HTTP GET Request on URL /address/id/(.*).

The routing 'magic' is taken care of by [src/xquery/rxq-rewriter.xqy](https://github.com/xquery/rxq/blob/master/src/xquery/rxq-rewriter.xqy) (which you attach to MarkLogic appserver). The `%rxq:GET` annotation specifies the HTTP method and the `%rxq:path` annotation value specifies the concrete URL.

The value for the `addr:get-address` function's `$id` variable is taken from the first regex capture group in the url as specified by %rxq:path. This $id value can then be used by some search to lookup the address.

RXQ supports the following RESTXQ annotations at this time;

* HTTP method annotation - `%rxq:GET` | `%rxq:PUT` | `%rxq:DELETE` | `%rxq:POST`
* Path annotation (maping url path) - `%rxq:path('/some/path/(.*)')`
* Produces annotation (output content-type) - `%rxq:produces('text/html')`
* Consumes annotation (ACCEPT) -
* [XSLT and XQuery Serialization 3.0 annotations](http://www.w3.org/TR/xslt-xquery-serialization-30), e.g. `%output:method`, `%output:byte-order-mark`, `%output:indent` etc

When you deploy these modules in a MarkLogic appserver you must then import those modules into the rxq-rewriter.xqy. for example if you wanted to use the addr:get-address() function, you would import the module in the rxq-rewriter.xqy

```xquery
(:~ STEP1 - import modules that contain annotation (controllers) here :)
import module namespace addr="﻿http://example.org/addr at "modules/addr.xqy";
```

This allows the RXQ implementation to scan for annotated functions and generate the neccessary url rewriting and evaluation.

Please review the [src/example-simple/rxq-rewriter.xqy](https://github.com/xquery/rxq/blob/master/src/example-site/rxq-rewriter.xqy) to see how to setup your own.

To continue with our address example, lets add a function which inserts an address.

```xquery
declare
   %rxq:PUT
   %rxq:path('/address/id/(.*)')
   %rxq:produces('text/html')
   %rxq:consumes('application/xml')
function addr:insert-address($id){
   ....
};
```
we are not interested in the actual implementation details of inserting the address (which could even be delegated to another xquery module, reinforcing the M in MVC). The `addr:insert-address` function would be invoked when an HTTP PUT Request is received.

Lastly, if we wanted to remove an address we need to support the HTTP DELETE method.

```xquery
declare
   %rxq:DELETE
   %rxq:path('/address/id/(.*)')
   %rxq:produces('text/html')
function addr:remove-address($id){
   ....
};
```
This function could return some kind of success or failure text/html.

It is the responsibility of your modules to return the correct HTTP status codes and the address library module provides some guidance of how to do this.

## Other functions

These helper functions can be useful to introspect the current RXQ enviroment.

_rxq:resource-functions()_ - returns all functions with RESTXQ annotations and their endpoint

_rxq:raw-params() as map:map_ - returns all in scope url params.

## FAQ

https://github.com/xquery/rxq/wiki/FAQ

# Points of interest & Limitations

The RESTXQ spec is still in draft form; where things are currently unclear or in flux I made my own implementation decisions for the time being;

 * no `xdmp:eval` were hurt (or used) in the creation of RXQ ... all execution is done by first class function invokation available using XQuery 3.0
 * annotations are mapped onto MarkLogic existing REST library functionality ( [rest functions](https://docs.marklogic.com/rest-lib))
 * RXQ is not pure XQuery 3.0 due to usage of xdmp: functions, such as [xdmp:annotation()](https://docs.marklogic.com/xdmp:annotation).
 * allow for full regex expressions within `%rxq:path`, instead of binding by variable names
 * its the responsibility of underlying function to grab hold of a PUT or POST content body
 * added some more metadata to the output of `rxq:resource-function()`

## License

RXQ is released under Apache License v2.0

Copyright 2012-2014 Jim Fuller

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions.

## More Info

* RXQ github [repository](https://github.com/xquery/rxq).
* [EXQuery RESTXQ Draft Specification](http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html#method-annotation).
* Adam Retter's [RESTXQ](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf).
* [JSR-311](http://download.oracle.com/otndocs/jcp/jaxrs-1.0-fr-eval-oth-JSpec/).

The usage of RESTXQ annotations turns out to be a very concise way of building up flexible RESTFul interfaces, as well as providing the basis from which to create MVC architectures for our XQuery web applications.
