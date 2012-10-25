xquery version "1.0-ml";

module namespace other="﻿http://example.org/other";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare function other:raw1(){
()
};

(:~ path without end slash :)
declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test3') function other:testa() {
<html>
<body>
<h1>testd</h1>
</body>
</html>
};


(:~ path with end slash :)
declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test1/') function other:test() {
<html>
<body>
<h1>test1</h1>
</body>
</html>
};


(:~ path with variable :)
declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/home1/(.*)') function other:homepage($test) {
<html>
<body>
<h1>homepage1</h1>
test: {$test}
</body>
</html>
};

(:~ path with variable and text/xml content type :)
declare %rxq:content-type('text/xml') %rxq:GET %rxq:path('/a1/(.*)') function other:a($test) {
<root>
<body>
<h1>other a</h1>
test: {$test}
</body>
</root>
};


(:~ import :)
declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/import/test/') function other:importtest($test) {
() (: ex2:b($test) :)
};
