xquery version "1.0-ml";

module namespace ex2="﻿http://example.org/ex2";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "../lib/restxq.xqy";

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


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/ex2/') function ex2:allwebpages() {
<html>
<body>
<h1>endpoints</h1>
<ul>
{for $f in rxq:resource-functions()/rxq:resource-functions/rxq:resource-function/rxq:identity
return
  <li> <a href="{xdmp:quote($f/@uri)}">{xdmp:quote($f/@uri)}</a> - {xdmp:quote($f/@local-name)}#{xdmp:quote($f/@arity)}</li>
}
</ul>
</body>
</html>
};

