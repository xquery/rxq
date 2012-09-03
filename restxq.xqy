xquery version "1.0-ml";

module namespace restxq="﻿http://exquery.org/ns/rest/annotation/";

import module namespace rest = "http://marklogic.com/appservices/rest" 
    at "/MarkLogic/appservices/utils/rest.xqy";


declare variable $restxq:endpoint as xs:string := "/rewrite.xqy?mode=route";

declare function  restxq:rewrite($prefix){
let $options :=  <options xmlns="http://marklogic.com/appservices/rest">
  {
  for $f in xdmp:functions()
  let $name as xs:string := fn:string(fn:function-name($f))
  return
    if(fn:starts-with($name,$prefix)) then
    <request uri="{xdmp:annotation($f,xs:QName('restxq:path'))}" endpoint="/rewrite.xqy?mode=route">
       <uri-param name="f">{$name}</uri-param>
      <uri-param name="output">{xdmp:annotation($f,xs:QName('restxq:method'))}</uri-param>
      <uri-param name="var1">$1</uri-param>
      <uri-param name="var2">$2</uri-param>
      <uri-param name="content-type">{xdmp:annotation($f,xs:QName('restxq:content-type'))}</uri-param>
       
      {if (xdmp:annotation($f,xs:QName('restxq:GET')))    then <http method="GET"/>    else ()}
      {if (xdmp:annotation($f,xs:QName('restxq:POST')))   then <http method="POST"/>   else ()}
      {if (xdmp:annotation($f,xs:QName('restxq:PUT')))    then <http method="PUT"/>    else ()}
      {if (xdmp:annotation($f,xs:QName('restxq:DELETE'))) then <http method="DELETE"/> else ()}
    </request>
    else
    ()
   }
  </options>
  return
    
    (xdmp:log($options),    rest:rewrite($options))
};


  
