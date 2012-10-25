xquery version "1.0-ml";

module namespace ex2="﻿http://example.org/ex2";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare function ex2:raw1(){
  ()
};

declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test/a/') function ex2:b($test) {
<html>
<body>
<h1>Function b</h1>
test: {$test}
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test/(.+)/') function ex2:a($test) {
<html>
<body>
<h1>Function a</h1>
test: {$test}
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/home/(.*)/(\d{4,7})/') function ex2:homepage($test1, $test2) {
<html>
<body>
<h1>homepage</h1>
test1: {$test1}<br/>
test2: {$test2}<br/>
</body>
</html>
};

declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/') function ex2:allwebpages() {
<html>
<body>
<h1>Other web pages</h1>
<ul>
{
for $prefix in ("other", "ex2")
    return
  for $f in xdmp:functions()[fn:prefix-from-QName(fn:function-name(.)) = $prefix]
  let $name as xs:string := fn:string(fn:function-name($f))
  let $arity as xs:integer := (fn:function-arity($f),0)[1]
  return
    if(xdmp:annotation($f,xs:QName('rxq:path'))) then
     <li> <a href="{xdmp:annotation($f,xs:QName('rxq:path'))}">{xdmp:annotation($f,xs:QName('rxq:path'))}</a></li>
    else
      ()
}
</ul>
</body>
</html>
};
