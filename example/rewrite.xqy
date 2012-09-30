xquery version "1.0-ml";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "lib/restxq.xqy";

(:~ include your modules imports here :)
import module namespace ex1="﻿http://example.org/mine/" at "external.xqy";
import module namespace other="﻿http://example.org/other/" at "other.xqy";
import module namespace ex2="﻿http://example.org/mine/test" at "test-import.xqy";

(:~ list your module prefixes :)
declare variable $app-prefixes := ("ex1","ex2","other");

(:~ :)
let $mode := xdmp:get-request-field("mode","rewrite")
return
 if ($mode eq "rewrite") then
   rxq:rewrite($app-prefixes)
 else if($mode eq "mux") then
   rxq:mux(xdmp:get-request-field("content-type",$rxq:default-content-type),
           fn:function-lookup(xs:QName(xdmp:get-request-field("f")),xs:integer(xdmp:get-request-field("arity","0"))),
           xs:integer(xdmp:get-request-field("arity","0"))
   )
 else
  rxq:handle-error()
     


  

