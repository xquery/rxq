xquery version "1.0-ml";

module namespace rxq="﻿http://exquery.org/ns/restxq";

(:~ Implement of restxq as defined
 :
 :   http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html
 :
 :)
 
import module namespace rest = "http://marklogic.com/appservices/rest" 
    at "/MarkLogic/appservices/utils/rest.xqy";

declare namespace rxq-output = "http://www.w3.org/2010/xslt-xquery-serialization";    
declare namespace rxq-error = "http://exquery.org/ns/restxq/error";
  
(:~ :)
declare variable $rxq:endpoint as xs:string := "/rewrite.xqy?mode=mux";
(:~ :)
declare variable $rxq:default-content-type as xs:string := "text/html";

declare option xdmp:mapping "false";

(:~
 :
 :  /rewrite.xqy?mode=rewrite
 :  /rewrite.xqy?mode=mux
 :  /rewrite.xqy?mode=error
 :
 : @param $prfixes
 :)    
declare function rxq:rewrite-options($prefixes as xs:string*) as element(rest:options){
 <options xmlns="http://marklogic.com/appservices/rest">
  {
  for $prefix in $prefixes
    return
  for $f in xdmp:functions()[fn:prefix-from-QName(fn:function-name(.)) = $prefix]
  let $name as xs:string := fn:string(fn:function-name($f))
  let $arity as xs:integer := (fn:function-arity($f),0)[1]
  return
    if(xdmp:annotation($f,xs:QName('rxq:path'))) then
    <request uri="^{xdmp:annotation($f,xs:QName('rxq:path'))}$" endpoint="{$rxq:endpoint}">
      <uri-param name="f">{$name}</uri-param>
      <uri-param name="output">{xdmp:annotation($f,xs:QName('rxq:method'))}</uri-param>
      <uri-param name="arity">{$arity}</uri-param>
      {if($arity eq 0) then
        ()
      else
        for $var in 1 to $arity
          return
          <uri-param name="var{$var}">${$var}</uri-param>
      }
      <uri-param name="content-type">{xdmp:annotation($f,xs:QName('rxq:content-type'))}</uri-param>  
      {if (xdmp:annotation($f,xs:QName('rxq:GET')))    then <http method="GET"/>    else ()}
      {if (xdmp:annotation($f,xs:QName('rxq:POST')))   then <http method="POST"/>   else ()}
      {if (xdmp:annotation($f,xs:QName('rxq:PUT')))    then <http method="PUT"/>    else ()}
      {if (xdmp:annotation($f,xs:QName('rxq:DELETE'))) then <http method="DELETE"/> else ()}
    </request>
  else
    ()
   }
       <request uri="*" endpoint="{$rxq:endpoint}">
             <uri-param name="f">dummy to catch non existent pages</uri-param>
       </request>
  </options>
 };
  

(:~
 :
 : @param $prfixes
 :)    
declare function rxq:rewrite($prefixes as xs:string*) {
  try{
    rest:rewrite(
      rxq:rewrite-options($prefixes)
    )}
  catch($e){
       rest:report-error($e)
    }
};


(:~
 :
 : @param $prfixes
 :)    
declare function rxq:rewrite1($prefixes as xs:string*) {
      rxq:rewrite-options($prefixes)
};


(:~
 :
 : @param $mode
 :)    
declare function rxq:handle-error($mode){
  ()
};


(:~
 :
 : 
 :)    
declare function rxq:handle-error(){
<html>
<body>
<h1>error</h1>
</body>
</html>
};


(:~
 :
 : 
 :)    
declare function rxq:uri() as xs:anyURI{
  xs:anyURI('http://www.example.org')
};


(:~
 :
 : 
 :)    
declare function rxq:base-uri() as xs:anyURI{
  xs:anyURI('http://www.example.org')
};


(:~
 :
 : 
 :)    
declare function rxq:resource-functions() as document-node(element(rxq:resource-functions)){
document{<rxq:resource-functions>
<rxq:resource-function
  xquery-uri = "xs:anyURI">
  <rxq:identity
    namespace = "xs:anyURI"
    local-name = "xs:NCName"
    arity = "xs:int"/>
</rxq:resource-function>
</rxq:resource-functions>}
};


(:~
 :
 : 
 :)    
declare function rxq:mux($content-type, $function as xdmp:function, $arity as xs:integer){
    try{
     let $_  := xdmp:set-response-content-type($content-type)
     let $fn := $function
     return
       if($arity eq 0) then
         $fn()
       else if ($arity eq 1) then
         $fn(xdmp:get-request-field("var1","null"))
       else if ($arity eq 2) then
         $fn(xdmp:get-request-field("var1","null"),xdmp:get-request-field("var2","null"))
       else if ($arity eq 3) then
         $fn(xdmp:get-request-field("var1","null"),xdmp:get-request-field("var2","null"),xdmp:get-request-field("var3","null"))
       else if ($arity eq 4) then
         $fn(xdmp:get-request-field("var1","null"),
                        xdmp:get-request-field("var2","null"),
                        xdmp:get-request-field("var3","null"),
                        xdmp:get-request-field("var4","null")
              )
       else if ($arity eq 5) then
         $fn(xdmp:get-request-field("var1","null"),
                        xdmp:get-request-field("var2","null"),
                        xdmp:get-request-field("var3","null"),
                        xdmp:get-request-field("var4","null"),
                        xdmp:get-request-field("var5","null")
              )
       else if ($arity eq 6) then
         $fn(xdmp:get-request-field("var1","null"),
                        xdmp:get-request-field("var2","null"),
                        xdmp:get-request-field("var3","null"),
                        xdmp:get-request-field("var4","null"),
                        xdmp:get-request-field("var5","null"),
                        xdmp:get-request-field("var6","null")
              )
       else if ($arity eq 7) then
         $fn(xdmp:get-request-field("var1","null"),
                        xdmp:get-request-field("var2","null"),
                        xdmp:get-request-field("var3","null"),
                        xdmp:get-request-field("var4","null"),
                        xdmp:get-request-field("var5","null"),
                        xdmp:get-request-field("var6","null"),
                        xdmp:get-request-field("var7","null")
              )
       else if ($arity eq 8) then
         $fn(xdmp:get-request-field("var1","null"),
                        xdmp:get-request-field("var2","null"),
                        xdmp:get-request-field("var3","null"),
                        xdmp:get-request-field("var4","null"),
                        xdmp:get-request-field("var5","null"),
                        xdmp:get-request-field("var6","null"),
                        xdmp:get-request-field("var7","null"),
                        xdmp:get-request-field("var8","null")              )
       else if ($arity eq 9) then
         $fn(xdmp:get-request-field("var1","null"),
                        xdmp:get-request-field("var2","null"),
                        xdmp:get-request-field("var3","null"),
                        xdmp:get-request-field("var4","null"),
                        xdmp:get-request-field("var5","null"),
                        xdmp:get-request-field("var6","null"),
                        xdmp:get-request-field("var7","null"),
                        xdmp:get-request-field("var8","null"),
                        xdmp:get-request-field("var9","null")        
              )              
      else
         ()
     }catch($e){
         rxq:handle-error()
     }     
};
  
