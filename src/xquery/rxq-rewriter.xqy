xquery version "1.0-ml";
(:
 : restxq.xqy
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

import module namespace rxq="﻿http://exquery.org/ns/restxq" at "lib/rxq.xqy";

import module namespace cprof="com.blakeley.cprof" at "/lib/cprof.xqy";

(:~ rewrite.xqy - this is the rewriter for rxq.
 :
 : NOTE- This version of the rxq-rewriter is modified to take advantage of Michael Blakely excellent cprof profiling library
 :
 :)

(:~ STEP1 - import modules that contain annotation (controllers) :)
import module namespace ex1="﻿http://example.org/ex1" at "modules/ex1.xqy";
import module namespace ex2="﻿http://example.org/ex2" at "modules/ex2.xqy";
import module namespace other="﻿http://example.org/other" at "lib/other.xqy";

(:~ Rewriter handles the following three conditions;
 : 
 :     rewrite - rewrites url using rxq:rewrite
 :
 :     mux - evaluates function for rewritten url using rxq:mux
 :
 :     error - provides http level error using rxq:handle-error
 :
 :)
let $perf := fn:true()
let $mode := xdmp:get-request-field("mode", $rxq:_REWRITE_MODE )
return
 if ($mode eq $rxq:_REWRITE_MODE ) then
   rxq:rewrite(())
 else if($mode eq "mux") then
   (if($perf) then cprof:enable() else (),
   rxq:mux(xdmp:get-request-field("content-type",$rxq:default-content-type),
           fn:function-lookup(xs:QName(xdmp:get-request-field("f")),xs:integer(xdmp:get-request-field("arity","0"))),
           xs:integer(xdmp:get-request-field("arity","0")) ),
   if($perf) then xdmp:xslt-eval(<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:prof="http://marklogic.com/xdmp/profile"
                  version="2.0">
    <xsl:template match="prof:report">
    <hr/>
    <table border="1">
    <tr>
      <td>id</td>
      <td>expr-source</td>
      <td>uri</td>
      <td>line</td>
      <td>column</td>
      <td>count</td>
      <td>shallow-time</td>
      <td>deep-time</td>   
    </tr>
    <xsl:apply-templates/>
    </table>
    <hr/>
    </xsl:template>
    <xsl:template match="prof:metadata">
    elapsed: <xsl:value-of select="prof:overall-elapsed"/> |
    created: <xsl:value-of select="prof:created"/> |
    server-version: <xsl:value-of select="prof:server-version"/>
    <br/>
    </xsl:template>
    <xsl:template match="prof:expression">
      <tr>
           <td><xsl:value-of select="prof:expr-id"/></td>
	   <td><xsl:value-of select="prof:expr-source"/></td>
	   <td><xsl:value-of select="prof:uri"/></td>
	   <td><xsl:value-of select="prof:line"/></td>
	   <td><xsl:value-of select="prof:column"/></td>
	   <td><xsl:value-of select="prof:count"/></td>
	   <td><xsl:value-of select="prof:shallow-time"/></td>
	   <td><xsl:value-of select="prof:deep-time"/></td>
      </tr>
    </xsl:template>
  </xsl:stylesheet>,cprof:report()) else ()	   
   )	   
 else
   rxq:handle-error()
     

  

