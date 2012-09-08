xquery version "1.0-ml";

module namespace rxq="﻿http://exquery.org/ns/rest/annotation/";

(:~ Implement of restxq as defined
 :
 :   http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html
 :
 :   * consider changing   %rest:path("/stock/widget/{$id}") to be able to accept regex
 :)
 
import module namespace rest = "http://marklogic.com/appservices/rest" 
    at "/MarkLogic/appservices/utils/rest.xqy";

declare variable $rxq:endpoint as xs:string := "/rewrite.xqy?mode=mux";

(:~
 :
 :  /rewrite.xqy?mode=rewrite
 :  /rewrite.xqy?mode=mux
 :  /rewrite.xqy?mode=error
 :)    

declare function rxq:rewrite-options($prefix) as element(rest:options){
 <options xmlns="http://marklogic.com/appservices/rest">
  {
  for $f in xdmp:functions()
  let $name as xs:string := fn:string(fn:function-name($f))
  return
    if(fn:starts-with($name,$prefix)) then
    <request uri="{xdmp:annotation($f,xs:QName('rxq:path'))}" endpoint="{$rxq:endpoint}">
      <uri-param name="f">{$name}</uri-param>
      <uri-param name="output">{xdmp:annotation($f,xs:QName('rxq:method'))}</uri-param>
      <uri-param name="var1">$1</uri-param>
      <uri-param name="var2">$2</uri-param>
      <uri-param name="content-type">{xdmp:annotation($f,xs:QName('rxq:content-type'))}</uri-param>  
      {if (xdmp:annotation($f,xs:QName('rxq:GET')))    then <http method="GET"/>    else ()}
      {if (xdmp:annotation($f,xs:QName('rxq:POST')))   then <http method="POST"/>   else ()}
      {if (xdmp:annotation($f,xs:QName('rxq:PUT')))    then <http method="PUT"/>    else ()}
      {if (xdmp:annotation($f,xs:QName('rxq:DELETE'))) then <http method="DELETE"/> else ()}
    </request>
    else
    ()
   }
  </options>
 };
  

declare function rxq:rewrite($prefix) {
   rest:rewrite( rxq:rewrite-options($prefix) )
};

declare function rxq:handle-error(){
()
};

declare function rxq:uri() as xs:anyURI{
  xs:anyURI('http://www.example.org')
};

declare function rxq:base-uri() as xs:anyURI{
  xs:anyURI('http://www.example.org')
};
  
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


