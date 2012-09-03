xquery version "1.0-ml";

module namespace ex1="﻿http://example.org/mine/";

declare namespace restxq="﻿http://exquery.org/ns/rest/annotation/";

declare %restxq:content-type('text/plain') %restxq:GET %restxq:path('/test') function ex1:test($name) as element(html){
<html>
<body>
<h1>test</h1>
</body>
</html>
};

declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/') function ex1:home-page() as element(html){
<html>
<body>
<h1>Home Page 1</h1>

</body>
</html>
};

declare %restxq:content-type('text/html') %restxq:GET %restxq:path('/homepage/(.+)') function ex1:home-page($name) as element(html){
<html>
<body>
<h1>Home Page</h1>
{$name}
</body>
</html>
};

declare %restxq:content-type('text/plain') %restxq:GET %restxq:path('^/(v1|LATEST)/documents/?$') function ex1:docs($name) as xs:string {
'<html>
<body>
<h1>Docs</h1>
</body>
</html>
'};



