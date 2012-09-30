xquery version "1.0-ml";

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "lib/restxq.xqy";

(:~ include your modules imports here :)
import module namespace ex1="﻿http://example.org/mine/" at "external.xqy";
import module namespace other="﻿http://example.org/other/" at "other.xqy";

(:~ list your module prefixes :)
declare variable $app-prefixes := ("ex1","other");

(:~ :)
let $mode := xdmp:get-request-field("mode","rewrite")
return
 if ($mode eq "rewrite") then
   rxq:rewrite($app-prefixes)
 else if($mode eq "mux") then   
    try{
     let $_  := xdmp:set-response-content-type(xdmp:get-request-field("content-type"))
     let $fn := xdmp:function(xs:QName(xdmp:get-request-field("f")))
     let $arity := fn:function-arity($fn)  
     return
       if($arity eq 0) then
         xdmp:apply($fn)
       else if ($arity eq 1) then
         xdmp:apply($fn,xdmp:get-request-field("var1","null"))
       else if ($arity eq 2) then
         xdmp:apply($fn,xdmp:get-request-field("var1","null"),xdmp:get-request-field("var2","null"))
       else if ($arity eq 3) then
         xdmp:apply($fn,xdmp:get-request-field("var1","null"),xdmp:get-request-field("var2","null"),xdmp:get-request-field("var3","null"))
       else
         xdmp:apply($fn)
     }catch($e){
         rxq:handle-error($mode)
     }     
else
  rxq:handle-error()
     


  

