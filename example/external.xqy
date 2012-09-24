xquery version "1.0-ml";

module namespace ex1="﻿http://example.org/mine/";

declare namespace restxq="﻿http://exquery.org/ns/rest/annotation/";


declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/test/') function ex1:test() {
<html>
<body>
<h1>test</h1>
</body>
</html>
};


declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/home/') function ex1:homepage() {
<html>
<body>
<h1>homepage</h1>
</body>
</html>
};
