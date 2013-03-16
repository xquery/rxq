xquery version "1.0-ml";
(:
 : rxq-rewriter.xqy
 :
 : Copyright (c) 2012,2013 James Fuller. All Rights Reserved.
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


(:~ STEP1 - import modules that contain annotation (controllers) here :)

(:------------------------------------------------------------------- :)




(:------------------------------------------------------------------- :)
(:~ Rewriter routes between the following three conditions based on 
 :  value of mode url param.
 :
 :     rewrite - rewrites url using rxq:rewrite
 :
 :     mux - evaluates function for rewritten url using rxq:mux
 :
 :     error - provides http level error using rxq:handle-error
 :
 :)
let $mode := xdmp:get-request-field("mode", $rxq:_REWRITE_MODE)
return
 if ($mode eq $rxq:_REWRITE_MODE) then rxq:rewrite($rxq:cache-flag)
 else if($mode eq $rxq:_MUX_MODE) then
   rxq:mux(xdmp:get-request-field("produces",$rxq:default-content-type),
   xdmp:get-request-field("consumes",$rxq:default-content-type),
   fn:function-lookup(xs:QName(xdmp:get-request-field("f")),xs:integer(xdmp:get-request-field("arity","0"))),
   xs:integer(xdmp:get-request-field("arity","0")) )
 else rxq:handle-error()
