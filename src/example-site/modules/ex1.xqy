xquery version "1.0-ml";

module namespace ex1="﻿http://example.org/ex1";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "../lib/rxq.xqy";


declare %rxq:content-type('application/json') %rxq:PUT %rxq:path('/json/(.*)') function ex1:insert-json($id) {
<html>
<body>
<h1>PUT example - save document as json {$id}</h1>
<textarea rows="10" cols="40">
{xdmp:get-request-body()}
</textarea>
</body>
</html>
};


declare %rxq:content-type('application/x-www-form-urlencoded') %rxq:POST %rxq:path('/post/(.*)') function ex1:post-xml($id) {
<html>
<body>
<h1>POST example - post params to {$id}</h1>
<textarea rows="10" cols="40">
{xdmp:get-request-field-names()}
</textarea>
</body>
</html>
};


declare %rxq:content-type('text/xml') %rxq:DELETE %rxq:path('/xml/(.*)') function ex1:delete-xml($id) {
<html>
<body>
<h1>DELETE example - remove  document at {$id}</h1>
</body>
</html>
};


declare %rxq:content-type('text/xml') %rxq:PUT %rxq:path('/xml/(.*)') function ex1:insert-xml($id) {
<html>
<body>
<h1>PUT example - save document as xml {$id}</h1>
<textarea rows="10" cols="40">
{xdmp:get-request-body()}
</textarea>
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/ex1/c/(.*)/(\d{4,7})/') function ex1:homepage($test1, $test2) {
<html>
<body>
<h1>homepage</h1>
test1: {$test1}<br/>
test2: {$test2}<br/>
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/ex1/a/') function ex1:b($test) {
<html>
<body>
<h1>Function b</h1>
test: {$test}
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/ex1/a/(.*)') function ex1:a($test) {
<html>
<body>
<h1>Function a</h1>
test: {$test}
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/') function ex1:allwebpages() {
<html>
<body>
<h1>RESTXQ app</h1>
<p> Its easy to test the example app using curl
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
</body>
</html>
};


(:~ example of a function without annotation, hence it does not participate :)
declare function ex1:does-nothing(){
  ()
};
