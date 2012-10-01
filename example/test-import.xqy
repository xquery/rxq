xquery version "1.0-ml";

module namespace ex2="﻿http://example.org/mine/test";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare function ex2:raw1(){
()
};
  
declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test5/a/') function ex2:b($test) {
<html>
<body>
<h1>Function b from test import</h1>
test: {$test}
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test5/(.+)/') function ex2:a($test) {
<html>
<body>
<h1>Function a</h1>
test: {$test}
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/home5/(.*)/(\d{4,7})/') function ex2:homepage($test1, $test2) {
<html>
<body>
<h1>homepage</h1>
test1: {$test1}<br/>
test2: {$test2}<br/>
</body>
</html>
};

