xquery version "1.0-ml";

module namespace other="﻿http://example.org/other/";

declare namespace restxq="﻿http://exquery.org/ns/rest/annotation/";


declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/test1/') function other:test() {
<html>
<body>
<h1>test1</h1>
</body>
</html>
};


declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/home1/(.*)') function other:homepage($test) {
<html>
<body>
<h1>homepage1</h1>
test: {$test}
</body>
</html>
};
