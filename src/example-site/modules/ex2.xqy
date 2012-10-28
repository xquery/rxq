xquery version "1.0-ml";

module namespace ex2="﻿http://example.org/ex2";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "../lib/rxq.xqy";

declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex2/a/') function ex2:b($test) {
<html>
<body>
<h1>Function ex2:b from modules/ex2.xqy</h1>
test: {$test}
</body>
</html>
};


declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex2/a/(.*)') function ex2:a($test) {
<html>
<body>
<h1>Function ex2:a from modules/ex2.xqy</h1>
test: {$test}
</body>
</html>
};

