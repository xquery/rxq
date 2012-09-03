xquery version "1.0-ml";

import module namespace restxq="﻿http://exquery.org/ns/rest/annotation/" at "lib/restxq.xqy";

(:~ include your modules here :)
import module namespace ex1="﻿http://example.org/mine/" at "external.xqy";

(:~ include your modules here :)
declare variable $app-prefixes := ("ex1");

(:~ :)
let $mode := xdmp:get-request-field("mode","rewrite")
let $debug := xdmp:get-request-field("debug")
return
  if($mode eq "rewrite") then
    restxq:rewrite($app-prefixes)
 else if($debug eq "true") then
  <div>
    <ul>
      <li>module/function: { xdmp:get-request-field("f")}</li>
      <li>method: { xdmp:get-request-field("method")}</li>
      <li>output: {xdmp:get-request-field("output")}</li>
      <li>var1: {xdmp:get-request-field("var1")}</li>
    </ul>
  </div>
 else if($mode eq "route") then
     let $_  := xdmp:set-response-content-type(xdmp:get-request-field("content-type"))
     let $fn := xdmp:function(xs:QName(xdmp:get-request-field("f")))
     return
       if(xdmp:get-request-field("var1")) then
         xdmp:apply($fn,xdmp:get-request-field("var1"))
       else
         xdmp:apply($fn)
else if($mode eq "error") then
 <error/>
else
 <div>Not Handled</div>
  

