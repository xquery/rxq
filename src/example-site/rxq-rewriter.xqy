xquery version "1.0-ml";
(:
 : rxq-rewriter.xqy
 :
 : Copyright (c) 2012 James Fuller. All Rights Reserved.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :
 :)

(:~ RXQ MarkLogic RESTXQ implementation :)
import module namespace rxq="﻿http://exquery.org/ns/restxq" at "/lib/rxq.xqy";

(:~ cprof - Michael Blakely excellent profiling tool :)
import module namespace cprof="com.blakeley.cprof" at "/lib/cprof.xqy";

(:~ rewriter for RXQ.
 :
 : NOTE- This version of the rxq-rewriter is modified to take advantage of Michael Blakely excellent cprof profiling library
 :
 :)

(:~ STEP1 - import modules that contain annotation (controllers) here :)
import module namespace ex1="﻿http://example.org/ex1" at "/modules/ex1.xqy";
import module namespace ex2="﻿http://example.org/ex2" at "/modules/ex2.xqy";
import module namespace other="﻿http://example.org/other" at "/lib/other.xqy";

(:~ Rewriter routes between the following three conditions;
 : 
 :     rewrite - rewrites url using rxq:rewrite
 :
 :     mux - evaluates function for rewritten url using rxq:mux
 :
 :     error - provides http level error using rxq:handle-error
 :
 :)
let $perf := fn:false()
let $mode := xdmp:get-request-field("mode", $rxq:_REWRITE_MODE )
return
 if ($mode eq $rxq:_REWRITE_MODE ) then
   rxq:rewrite(())
 else if($mode eq $rxq:_MUX_MODE ) then
   (if($perf) then cprof:enable() else (),
   rxq:mux(xdmp:get-request-field("content-type",$rxq:default-content-type),
           fn:function-lookup(xs:QName(xdmp:get-request-field("f")),xs:integer(xdmp:get-request-field("arity","0"))),
           xs:integer(xdmp:get-request-field("arity","0")) ),
   if($perf) then xdmp:xslt-eval($cprof:report-xsl, cprof:report()) else ()	   
   )	   
 else
   rxq:handle-error()
     

  

