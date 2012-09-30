xquery version "1.0-ml";

module namespace ex1="﻿http://example.org/mine/";

declare namespace restxq="﻿http://exquery.org/ns/rest/annotation/";



declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/test/a') function ex1:b($test) {
<html>
<body>
<h1>Function b</h1>
test: {$test}
</body>
</html>
};


declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/test/(.+)') function ex1:a($test) {
<html>
<body>
<h1>Function a</h1>
test: {$test}
</body>
</html>
};

declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/home/(.*)/(.*)/') function ex1:homepage($test1, $test2) {
<html>
<body>
<h1>homepage</h1>
test1: {$test1}<br/>
test2: {$test2}<br/>
</body>
</html>
};
