xquery version "1.0-ml";

module namespace ex1="﻿http://example.org/ex1";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "../lib/rxq.xqy";


declare %rxq:content-type('application/json') %rxq:PUT %rxq:path('/json/(.*)') function ex1:insert-json($id) {
<html>
<body>
{ex1:header()}
<h1>RXQ: PUT example - save document as json {$id}</h1>
<textarea rows="10" cols="40">
{xdmp:get-request-body()}
</textarea>
</body>
{ex1:footer()}
</html>
};


declare %rxq:produces('application/x-www-form-urlencoded') %rxq:POST %rxq:path('/post/(.*)') function ex1:post-xml($id) {
<html>
<body>
{ex1:header()}
<h1>RXQ: POST example - post params to {$id}</h1>
<textarea rows="10" cols="40">
{xdmp:get-request-field-names()}
</textarea>
{ex1:footer()}
</body>
</html>
};


declare %rxq:produces('text/xml') %rxq:DELETE %rxq:path('/xml/(.*)') function ex1:delete-xml($id) {
<html>
<body>
{ex1:header()}
<h1>RXQ: DELETE example - remove  document at {$id}</h1>
{ex1:footer()}
</body>
</html>
};


declare %rxq:produces('text/xml') %rxq:PUT %rxq:path('/xml/(.*)') function ex1:insert-xml($id) {
<html>
<body>
{ex1:header()}
<h1>RXQ: PUT example - save document as xml {$id}</h1>
<textarea rows="10" cols="40">
{xdmp:get-request-body()}
</textarea>
{ex1:footer()}
</body>
</html>
};


declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex1/c/(.*)/(.*)/') function ex1:regex-example($var1, $var2) {
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


declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex1/a/') function ex1:b($var1) {
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


declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex1/a/(.*)') function ex1:a($var1) {
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


declare %rxq:produces('text/html') %rxq:GET %rxq:path('/') function ex1:entry-point() {
<html>
<body>
{ex1:header()}
<h1> RXQ v0.1 - RESTful MVC with XQuery 3.0 annotations</h1>
<p> Its easy to create RESTful apis and applications with RXQ.
<ul>
<li>HTTP GET - /ex2/ maps onto modules/ex1.xqy function ex1:b#1</li>
<li>HTTP PUT - /ex2/ maps onto modules/ex1.xqy function ex1:b#1</li>
<li>HTTP POST - /ex2/ maps onto modules/ex1.xqy function ex1:b#1</li>
<li>HTTP DELETE - /ex2/ maps onto modules/ex1.xqy function ex1:b#1</li>

</ul>
</p>

<h3>Current endpoints</h3>
<ul>
{for $f in rxq:resource-functions()//rxq:identity
return
  <li> <a href="{string($f/@uri)}">{string($f/@uri)}</a> - {string($f/@local-name)}#{string($f/@arity)}</li>
}
</ul>
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
