xquery version "1.0-ml";

module namespace ex2="﻿http://example.org/ex2";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex2/a') function ex2:b($var) {
<html>
<body>
{ex2:header()}
<h1>Function ex2:b from modules/ex2.xqy</h1>
method:HTTP GET <br/>
path: /ex2/a/ <br/>
produces: text/html <br/>
{ex2:footer()}
</body>
</html>
};


declare %rxq:produces('text/html') %rxq:GET %rxq:path('/ex2/a/(.*)') function ex2:a($var1) {
<html>
<body>
{ex2:header()}
<h1>Function ex2:a from modules/ex2.xqy</h1>
tmethod:HTTP GET <br/>
path: /ex2/a/ <br/>
produces: text/html <br/>
$var1 value: {$var1}
{ex2:footer()}
</body>
</html>
};


(:~ example of a function without annotation :)
declare function ex2:header(){
  (
  <a href="/">home</a>,
  <hr/>
  )
};

(:~ example of a function without annotation :)
declare function ex2:footer(){
  (
  <br/>,<br/>,
  <hr/>,
  <div style="font-size:85%;float:right;">{fn:current-dateTime()} | <a href="https://github.com/xquery/rxq">RXQ github</a></div>
  )
};
