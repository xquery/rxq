# RXQ v0.1 - RESTful MVC with XQuery 3.0 annotations for MarkLogic

The release of [MarkLogic 6](http://www.marklogic.com) includes support for many cool [XQuery 3.0](http://www.w3.org/TR/xquery-30) features. 
One such feature, [annotations](http://www.w3.org/TR/xquery-30/#id-annotations), provides an opportunity to implement Adam Retter's [RESTXQ](http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html#method-annotation) draft (introduced at [XML Prague 2012](http://archive.xmlprague.cz/2012/sessions.html#RESTful-XQuery---Standardised-XQuery-3.0-Annotations-for-REST)).

RESTXQ proposes an elegant approach for building RESTFul interfaces, in addition to full blown web applications using XQuery within a consistent MVC architecture.

RESTXQ is based on the annotations defined within [JSR-311](http://download.oracle.com/otndocs/jcp/jaxrs-1.0-fr-eval-oth-JSpec).

To understand what RESTXQ is and how it works with XQuery 3.0 annotations please [download](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf) Adam Retters excellent overview.

Important Note - for those using OSX Mountain Lion you might find some issues, give me a shout if you are getting a 'no content' message.

# For the Impatient

To learn just [install](https://github.com/xquery/rxq#setting-up-the-example-site-on-marklogic-6) and review [src/example-site](https://github.com/xquery/rxq/tree/master/src/example-site), otherwise to use in your own project, follow these steps (you _need_ MarkLogic 6 or later);

1. download RXQ [dist](https://github.com/xquery/rxq/zipball/master) and unzip
2. copy [src/xquery/rxq-rewriter.xqy](https://github.com/xquery/rxq/blob/master/src/xquery/rxq-rewriter.xqy) and [src/xquery/lib/rxq.xqy](https://github.com/xquery/rxq/blob/master/src/xquery/lib/rxq.xqy) to your project
3. setup MarkLogic 6 appserver with url rewriter set to _/rxq-rewriter.xqy?mode=rewrite_ and error handler to _/rxq-rewriter.xqy?mode=error_
4. edit _rxq-rewriter.xqy_, by importing those (your application) xquery modules which have RESTXQ annotations embedded in function declarations
5. test by using a browser (or [curl](http://curl.haxx.se/docs/manpage.html))  to navigate to your controller paths as defined by your functions %rxq:path annotation


# Distribution

* [README.md](https://github.com/xquery/rxq) - This document
* [api](https://github.com/xquery/rxq/tree/master/api) - contains api level docs of RXQ rewriter and module library
* [src/example-site](https://github.com/xquery/rxq/tree/master/src/example-site) - contains example site which demonstrates how to use RXQ
* [src/xquery](https://github.com/xquery/rxq/tree/master/src/xquery) - contains clean rxq-rewriter.xqy and lib/rxq.xqy you can use in your own projects
* src/xray - RXQ uses Rob Whitby excellent [XRAY](https://github.com/robwhitby/xray) for xquery unit testing 
* [src/tests](https://github.com/xquery/rxq/tree/master/src/test) - used for testing

# RXQ in action

The following xquery module illustrates how to annotate your modules functions using RESTXQ, which in turn will map them to a URL so they can be invoked via an HTTP Request.

```
xquery version "1.0-ml";
module namespace addr="﻿http://example.org/address";
declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare 
   %rxq:GET
   %rxq:path('/address/id/(.*)')
   %rxq:produces('text/html')
function addr:get-address($id){ 
   .... 
};
```

The `addr:get-address($id)` function has defined 3 RESTXQ annotations;

* _%rxq:GET_: indicates to select when HTTP REQUEST uses GET method
* _%rxq:path('/address/id/(.*)')_: maps the url /address/id/(.*) to this function, note the usage of regex matching group to capture `$id`
* _%rxq:produces('text/html')_: the output of this function, when returned by HTTP RESPONSE will have a content type of 'text/html'.

The `addr:get-address()` function is invoked when there is an HTTP GET Request on URL /address/id/(.*). 

The routing 'magic' is taken care of by [src/xquery/rxq-rewriter.xqy](https://github.com/xquery/rxq/blob/master/src/xquery/rxq-rewriter.xqy) (which you attach to MarkLogic appserver). The `%rxq:GET` annotation specifies the HTTP method and the `%rxq:path` annotation value specifies the concrete URL.

The value for the `addr:get-address` function's `$id` variable is taken from the first regex capture group in the url as specified by %rxq:path. This $id value can then be used by some search to lookup the address.

RXQ supports four RESTXQ annotations at this time;

* HTTP method annotation - `%rxq:GET` | `%rxq:PUT` | `%rxq:DELET`E | `%rxq:POST`
* Path annotation (maping url path) - `%rxq:path('/some/path/(.*)')`
* Produces annotation (output content-type) - `%rxq:produces('text/html')`
* Consumes annotation (ACCEPT) -

When you deploy these modules in a MarkLogic appserver you must then import those modules into the rxq-rewriter.xqy. for example if you wanted to use the addr:get-address() function, you would import the module in the rxq-rewriter.xqy 

```
(:~ STEP1 - import modules that contain annotation (controllers) here :)
import module namespace addr="﻿http://example.org/addr at "modules/addr.xqy";
```

This allows the RXQ implementation to scan for annotated functions and generate the neccessary url rewriting and evaluation.

Please review the [src/example-site/rxq-rewriter.xqy](https://github.com/xquery/rxq/blob/master/src/example-site/rxq-rewriter.xqy) to see how to setup your own. Note that the example-site also has a facility for profiling (enable $perf to fn:true).

To continue with our address example, lets add a function which inserts an address.

```
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

```
declare 
   %rxq:DELETE
   %rxq:path('/address/id/(.*)')
   %rxq:produces('text/html')
function addr:remove-address($id){ 
   .... 
};
```
This function could return some kind of success or failure text/html.

This usage of annotations turns out to be a very concise way of building up flexible RESTFul interfaces, as well as providing the basis from which to create MVC architectures for our XQuery web applications.


# Setting up the example-site on MarkLogic 6

The quickest way to see RXQ in action is to setup the example application under [src/example-site](https://github.com/xquery/rxq/tree/master/src/example-site).

First, you *need* to download and install [MarkLogic 6](https://developer.marklogic.com/products). Second, create an appserver, providing the following details;

* _root_: provide directory where example-site resides on your filesystem
* _error handler_: `/rxq-rewriter.xqy?mode=error`
* _rewrite handler_: `/rxq-rewriter.xqy?mode=rewrite`

With everything setup, you can now point your web browser to the created app (e.g. http://<host>:<port>/) and you should see html page.

# Points of interest & Limitations

The RESTXQ spec is still in draft form; where things are currently unclear or in flux I made my own implementation decisions for the time being;

 * no `xdmp:eval` were hurt (or used) in the creation of RXQ ... all execution is done by first class function invokation available using XQuery 3.0
 * annotations are effectively mapping onto existing MarkLogic REST library functionality ( [rest functions](https://docs.marklogic.com/rest-lib))
 * RXQ is not pure XQuery 3.0 due to usage of xdmp: functions, such as [xdmp:annotation()](https://docs.marklogic.com/xdmp:annotation).
 * allow for full regex expressions within `%rxq:path`, instead of binding by variable names
 * its the responsibility of underlying function to grab hold of a PUT or POST content body
 * added some more metadata to the output of `rxq:resource-function()` 
 * 2 separate files e.g. at some point would like to merge rxq-rewriter.xqy into the rxq library module itself

# License

RXQ is released under Apache License v2.0

Copyright 2012,2013 Jim Fuller

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions.

# More Info

* RXQ github [repository](https://github.com/xquery/rxq).
* [EXQuery RESTXQ Draft Specification](http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html#method-annotation).
* Adam Retters [RESTXQ](http://archive.xmlprague.cz/2012/presentations/RESTful_XQuery.pdf).
* [JSR-311](http://download.oracle.com/otndocs/jcp/jaxrs-1.0-fr-eval-oth-JSpec/).
