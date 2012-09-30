xquery version "1.0-ml";

module namespace other="﻿http://example.org/other/";

declare namespace rxq="﻿http://exquery.org/ns/restxq";


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/test1/') function other:test() {
<html>
<body>
<h1>test1</h1>
</body>
</html>
};


declare %rxq:content-type('text/html') %rxq:GET %rxq:path('/home1/(.*)') function other:homepage($test) {
<html>
<body>
<h1>homepage1</h1>
test: {$test}
</body>
</html>
};
