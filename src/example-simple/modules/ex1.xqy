xquery version "1.0-ml";

module namespace ex1="http://example.org/ex1";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "../lib/rxq.xqy";

(:~ example of using 2 regex capture groups :)
declare
 %rxq:produces('text/html')
 %rxq:GET
 %rxq:path('/ex1/c/(.*)/(.*)/')
 function ex1:regex-example(
   $var1,
   $var2
)
{
<html>
<body>
{ex1:header()}
<h1>RXQ: Demonstrates 2 regex matching groups</h1>
method:HTTP GET <br/>
path: /ex1/c/(.*)/(.*) <br/>
produces: text/html <br/>
$var1: {$var1}<br/>
$var2: {$var2}<br/>
{ex1:footer()}
</body>
</html>
};


(:~ example of using regex to constrain input e.g. http://localhost:{xdmp:get-request-port()}/ex1/c/b/c/999
:   but
:   http://localhost:{xdmp:get-request-port()}/ex1/c/b/c/9999 does not work as d{1,3} states maximum length of 3 numbers
:)
declare
 %rxq:produces('text/html')
 %rxq:GET
 %rxq:path('/ex1/c/(.*)/(.*)/(\d1)')
 function ex1:regex-example2(
   $var1,
   $var2,
   $var3
)
{
<html>
<body>
{ex1:header()}
<h1>RXQ: Demonstrates 2 regex matching groups</h1>
method:HTTP GET <br/>
path: /ex1/c/(.*)/(.*) <br/>
produces: text/html <br/>
$var1: {$var1}<br/>
$var2: {$var2}<br/>
$var3: {$var3}<br/>
{ex1:footer()}
</body>
</html>
};


declare
 %rxq:produces('text/html')
 %rxq:GET
 %rxq:path('/ex1/a/')
 function ex1:b(
   $var1
)
{
<html>
<body>
{ex1:header()}
<h1>Function ex1:b from modules/ex1.xqy</h1>
method:HTTP GET <br/>
path: /ex1/a/ <br/>
produces: text/html <br/>
$var1 value: {$var1} <br/>
{ex1:footer()}
</body>
</html>
};


(:~ example of using regex capture group to supply variable $var1 value :)
declare
 %rxq:produces('text/html')
 %rxq:GET
 %rxq:path('/ex1/a/(.*)')
 function ex1:a(
   $var1
)
{
<html>
<body>
{ex1:header()}
<h1>RXQ: Function ex1:a in modules/ex1.xqy</h1>
method:HTTP GET <br/>
path: /ex1/a/(.*) <br/>
produces: text/html <br/>
$var1 value: {$var1} <br/>
{ex1:footer()}
</body>
</html>
};


(:~ lists out all endpoints :)
declare
 %rxq:produces('text/html')
 %rxq:GET
 %rxq:path('/')
 function ex1:entry-point() {
<html>
<body>
{ex1:header()}
<h1> RXQ v0.1 - RESTful MVC with XQuery 3.0 annotations</h1>
<p> Its easy to create RESTful apis and applications with RXQ. To demonstrate, we have annotated all functions within the lib/address.xqy XQuery module library, which you can run curl against to test.
<ul>
<li>HTTP GET - All Addresses:  curl --digest -u user:pass http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}/address/all</li>
<li>HTTP GET - Get single address with id=3:  curl --digest -u user:pass "http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}/address/3"</li>
<li>HTTP GET - Get single address with id=22 (failure because it does not exist):  curl --digest -u user:pass "http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}/address/22"</li>
<li>HTTP PUT - Insert document with id=9:  curl --digest -u user:pass -i -H "Accept: application/xml" -X PUT -d "&lt;address&gt;&lt;name&gt;New&lt;/name&gt;&lt;email&gt;new@example.org&lt;/email&gt;&lt;/address&gt;" "http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}/address/9"</li>
<li>HTTP POST - Insert document with id=9:   curl --digest -u user:pass -i -X POST -d "name=new&amp;email=new@example.org" "http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}/address/9"</li>
<li>HTTP DELETE - Remove document with id=9:  curl --digest -u user:pass -i -X DELETE "http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}/address/1"</li>
</ul>
MarkLogic appservers have digest authentication as default so make sure you instruct curl to use digest and replace user:admin with your own username and password details.
Note - The HTTP PUT, POST, and DELETE examples demonstrate only the HTTP plumbing ... this example makes no modifications to the database attached to the appserver.
</p>

<h3>Other Functions</h3>
<h4>rxq:resource-functions()</h4>
<p>returns all functions that have RESTXQ annotation</p>
<p>list of all active endpoints, which are defined by RESTXQ annotations</p>
<ul>
{for $f in rxq:resource-functions()//rxq:identity
return
  <li> <a href="{fn:string($f/@uri)}">http://{xdmp:host-name(xdmp:host())}:{xdmp:get-request-port()}{fn:string($f/@uri)}</a> - {fn:string($f/@local-name)}#{fn:string($f/@arity)}</li>
}
</ul>
<h4>rxq:raw-params() as map:map</h4>
<p>returns all params as a map</p>
<textarea rows="10" cols="80">
{rxq:raw-params()}
</textarea>
{ex1:footer()}
</body>
</html>
};


(:~ example of a function without annotation :)
declare function ex1:header(){
  (
  <a href="/">home</a>,
  <hr/>
  )
};

(:~ example of a function without annotation :)
declare function ex1:footer(){
  (
  <br/>,<br/>,
  <hr/>,
  <div style="font-size:85%;float:right;">{fn:current-dateTime()} | <a href="https://github.com/xquery/rxq">RXQ github</a></div>
  )
};


(:~ example of a function declared without the namespace prefix :)
declare
  %rxq:produces('text/plain')
  %rxq:GET
  %rxq:path('/without-ns-prefix')
function without-ns-prefix(){
  "foo"
};
