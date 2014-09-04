xquery version "1.0-ml";
(:
 : rxq.xqy
 :
 : Copyright (c) 2012,2013 James Fuller - jim.fuller@webcomposite.com . All Rights Reserved.
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

module namespace rxq="http://exquery.org/ns/restxq";

(:~ RXQ- MarkLogic RESTXQ implementation
 :
 : @spec http://exquery.github.com/exquery/exquery-restxq-specification/restxq-1.0-specification.html
 :
 :)

import module namespace rest = "http://marklogic.com/appservices/rest"
    at "/MarkLogic/appservices/utils/rest.xqy";

declare namespace rxq-output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace rxq-error="http://exquery.org/ns/restxq/error";

(:~ declare constants:)
declare variable $rxq:_REWRITE_MODE := "rewrite";
declare variable $rxq:_MUX_MODE := "mux";

(:~ defines default evaluation endpoint :)
declare variable $rxq:default-endpoint as xs:string := "/rxq-rewriter.xqy?mode=" ||  $rxq:_MUX_MODE;

(:~ cache REST mapping to server-field :)
declare variable $rxq:cache-flag as xs:boolean := fn:false();

(:~ defines server field used by cache :)
declare variable $rxq:server-field as xs:string := "rxq-server-field";

(:~ defines default content type :)
declare variable $rxq:default-content-type as xs:string := "*/*";

(:~ define list of prefixes for exclusion :)
declare variable $rxq:exclude-prefixes as xs:string* := ("xdmp", "hof", "impl",
     "plugin", "amped-info", "debug", "cts", "json",
     "amped-common", "rest", "rest-impl", "fn", "math",
     "xs", "prof", "sc", "dbg", "xml", "magick", "map",
     "xp", "rxq", "idecl", "xsi");

(:~ XSLT and XQuery Serialization 3.0 parameter names :)
declare variable $rxq:output-parameters as xs:string+ := (
  "method", "version", "html-version", "encoding", "indent",
  "suppress-indentation", "cdata-section-elements", "omit-xml-declaration",
  "standalone", "doctype-system", "doctype-public", "undeclare-prefixes",
  "normalization-form", "media-type", "use-character-maps", "byte-order-mark",
  "escape-uri-attributes", "include-content-type", "item-separator");

(:~ define options :)
declare option xdmp:mapping "false";

declare option xdmp:update "true";

declare function rxq:process-request(
  $cache as xs:boolean
)
{
  let $mode := xdmp:get-request-field("mode", $rxq:_REWRITE_MODE)
  let $arity := xs:integer(xdmp:get-request-field("arity", "0"))
  let $use-custom-serializer := xdmp:get-request-field("use-rxq-serializer")
  let $filter :=
    if($use-custom-serializer) then
      fn:function-lookup(xs:QName("rxq:serialize"), 1)
    else
      function($item) { $item } (: filter that does nothing :)

  return
    if ($mode eq $rxq:_REWRITE_MODE)
    then (rxq:rewrite($cache), xdmp:get-request-url())[1]
    else if($mode eq $rxq:_MUX_MODE) then
      $filter(rxq:mux(
        xdmp:get-request-field("produces", $rxq:default-content-type),
        xdmp:get-request-field("consumes", $rxq:default-content-type),
        fn:function-lookup(fn:QName(xdmp:get-request-field("f-ns"), xdmp:get-request-field("f-name")), $arity),
        $arity
      ))
    else
      rxq:handle-error()
};

(:~ rxq:rewrite-options - generate <rest:request/> based on restxq annotations
 :
 : @param $exclude-prefixes
 :
 : @return element(rest:options)
 :)
declare function rxq:rewrite-options(
  $exclude-prefixes as xs:string*
) as element(rest:options)
{
  <options xmlns="http://marklogic.com/appservices/rest">
  {
  for $f in xdmp:functions()[fn:not(fn:prefix-from-QName(fn:function-name(.)) = $exclude-prefixes)]
  order by xdmp:annotation($f,xs:QName('rxq:path')) descending
  return
    let $qname := fn:function-name($f)
    let $ns := fn:namespace-uri-from-QName($qname)
    let $local-name := fn:local-name-from-QName($qname)
    let $arity as xs:integer := (fn:function-arity($f),0)[1]
    return
      if(xdmp:annotation($f,xs:QName('rxq:path'))) then
        <request uri="^{xdmp:annotation($f,xs:QName('rxq:path'))}$"
          endpoint="{$rxq:default-endpoint}">
          <uri-param name="f-ns">{$ns}</uri-param>
          <uri-param name="f-name">{$local-name}</uri-param>
          <uri-param name="produces">{xdmp:annotation($f,xs:QName('rxq:produces'))}</uri-param>
          <uri-param name="consumes">{xdmp:annotation($f,xs:QName('rxq:consumes'))}</uri-param>
          <uri-param name="arity">{$arity}</uri-param>
          { for $var in 1 to $arity return <uri-param name="var{$var}">${$var}</uri-param> }
          <uri-param name="content-type">{xdmp:annotation($f,xs:QName('rxq:produces'))}</uri-param>
          {
            if (xdmp:annotation($f,xs:QName('rxq:GET'))) then <http method="GET"  user-params="allow"/> else (),
            if (xdmp:annotation($f,xs:QName('rxq:POST'))) then
              <http method="POST" user-params="allow">
                { xdmp:get-request-field-names() ! <param name="{.}" as="string" required="false"/> }
              </http>
            else (),
            if (xdmp:annotation($f,xs:QName('rxq:PUT'))) then <http method="PUT" user-params="allow"/> else (),
            if (xdmp:annotation($f,xs:QName('rxq:DELETE'))) then <http method="DELETE"/> else (),

            let $serialization-uri-params as element(uri-param)* :=
              fn:map(
                function($parameter) {
                  let $value :=
                    xdmp:annotation($f,
                    fn:QName("http://www.w3.org/2010/xslt-xquery-serialization",
                      $parameter))
                    return if($value) then
                      <uri-param name="{$parameter}">{$value}</uri-param>
                  else ()
                }, $rxq:output-parameters
              )

            return (
              $serialization-uri-params,
              <uri-param name="use-rxq-serializer">{
                fn:exists($serialization-uri-params)
              }</uri-param>
            )
          }

        </request>
      else ()
  }
  </options>
 };


(:~ rxq:rewrite - creates rewritten URL string
 :
 : @cache $cache - if set to true will cache rest:options in server field
 :
 : @returns rewrite url
 :)
declare function rxq:rewrite(
  $cache as xs:boolean
)
{
  try {
    if ($cache) then
      if (xdmp:get-server-field($rxq:server-field))
      then rest:rewrite(xdmp:get-server-field($rxq:server-field))
      else
	     let $options as element(rest:options) := rxq:rewrite-options($rxq:exclude-prefixes)
	     let $_ := xdmp:set-server-field($rxq:server-field, $options)
	     return rest:rewrite($options)
    else
	   let $options as element(rest:options) := rxq:rewrite-options($rxq:exclude-prefixes)
	   return rest:rewrite($options)
  }
  catch($e) {
    rest:report-error($e)
  }
};

(:~ rxq:serialize - custom serializer for functions with %output:* annotations
 :
 : @output   the output of the user's target function which will be serialized
 : @returns  a reserialized output according to the %output:* annotations
 : @author Charles Foster
 :)
declare function rxq:serialize(
  $output
) as item()*
{
  let $quote-options :=
    <options xmlns="xdmp:quote"> {
      for $parameter in $rxq:output-parameters
      let $value := xdmp:get-request-field($parameter)
      where $value
      return
        element { fn:QName("xdmp:quote", $parameter) } {
        $value
      }
    }</options>

  return xdmp:quote($output, $quote-options)
};

  

(:~ rxq:mux - function invoke
 :
 : @param $produces
 : @param $consumes
 : @param $function
 : @param $arity
 :
 : @returns result of function invokation
 :)
declare function rxq:mux(
  $produces as xs:string,
  $consumes as xs:string,
  $function as function(*),
  $arity as xs:integer
) as item()*
{
    try{
     let $_  := xdmp:set-response-content-type($produces)
     let $fn := $function
     return
       if($arity eq 0) then
         $fn()
       else if ($arity eq 1) then
         $fn(xdmp:get-request-field("var1","null"))
       else if ($arity eq 2) then
         $fn(xdmp:get-request-field("var1","null"),
	     xdmp:get-request-field("var2","null")
	 )
       else if ($arity eq 3) then
         $fn(xdmp:get-request-field("var1","null"),
	     xdmp:get-request-field("var2","null"),
	     xdmp:get-request-field("var3","null")
	 )
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
         rxq:handle-error($e)
     }
};


(:~ rxq:base-uri - returns base uri
 :
 : @returns URI
 :)
declare function rxq:raw-params() as map:map{
  rest:get-raw-query-params()
};


(:~ rxq:resource-functions - returns all functions
 :
 : @returns element(rxq:resource-functions)
 :)
declare function rxq:resource-functions() as element(rxq:resource-functions){
  element rxq:resource-functions{
    for $f in xdmp:functions()
      order by xdmp:annotation($f,xs:QName('rxq:path'))
      return
	if(xdmp:annotation($f,xs:QName('rxq:path'))) then
	<rxq:resource-function xquery-uri="">
	  <rxq:identity
	  namespace = ""
	  local-name = "{fn:function-name($f)}"
	  arity = "{fn:function-arity($f)}"
	  uri="{xdmp:annotation($f,xs:QName('rxq:path'))}"
	  />
    </rxq:resource-function>
    else ()}
};


(:~ rxq:handle-error
 :
 : @returns html error response
 :)
declare function rxq:handle-error()
{
  rxq:handle-error(<error:error xmlns:error="http://marklogic.com/xdmp/error"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <error:format-string>Incorrect RXQ mode</error:format-string>
  <error:retryable>false</error:retryable>
  <error:stack>
  </error:stack>
  </error:error>)
};


(:~ rxq:handle-error
 :
 : @returns html error response
 :)
declare function rxq:handle-error(
  $e
)
{
  xdmp:set-response-code(500, $e/error:format-string),
  rest:report-error($e)
};
