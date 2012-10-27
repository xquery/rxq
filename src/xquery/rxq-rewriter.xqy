xquery version "1.0-ml";
(:~ rewrite.xqy - this is the rewriter for rxq.
 :
 :  There are 2 steps for configuring a restxq application.
 :
 :  STEP1 - define xquery modules using restxq annotations, then import them here
 :
 :  STEP2 - enumerate module prefixes (TRY TO REFACTOR OUT)
 :
 :)
import module namespace rxq="﻿http://exquery.org/ns/restxq" at "lib/rxq.xqy";

(:~ STEP1 - import modules that you would like to include :)

(:
   import module namespace ex1="﻿http://example.org/ex1" at "modules/ex1.xqy";
:)

(:~ STEP2 - list your module prefixes that contain rxq annotations :)
declare variable $app-prefixes := ("ex1");


(:~ Rewriter handles the following three conditions;
 : 
 :     rewrite - rewrites url using rxq:rewrite
 :
 :     mux - evaluates function for rewritten url using rxq:mux
 :
 :     error - provides http level error using rxq:handle-error
 :
 :)
let $mode := xdmp:get-request-field("mode")
return
 if ($mode eq "rewrite") then
   rxq:rewrite($app-prefixes,fn:false())
 else if($mode eq "mux") then
   rxq:mux(xdmp:get-request-field("content-type",$rxq:default-content-type),
           fn:function-lookup(xs:QName(xdmp:get-request-field("f")),xs:integer(xdmp:get-request-field("arity","0"))),
           xs:integer(xdmp:get-request-field("arity","0")) )
 else
   rxq:handle-error()
     

  

