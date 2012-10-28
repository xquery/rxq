xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace rxq="﻿http://exquery.org/ns/restxq" at "/example-site/lib/rxq.xqy";

import module namespace ex1="﻿http://example.org/ex1" at "/example-site/modules/ex1.xqy";
import module namespace ex2="﻿http://example.org/ex2" at "/example-site/modules/ex2.xqy";
import module namespace other="﻿http://example.org/other" at "/example-site/lib/other.xqy";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

declare namespace http = "xdmp:http";

declare variable $admin-auth := 
    <authentication method="digest" xmlns="xdmp:http">
        <username>admin</username>
        <password>admin</password>
    </authentication>;

declare variable $base-url as xs:string := "http://localhost:9011";

declare variable $methods :=
    let $map := map:map()
    let $put := map:put($map, "GET", xdmp:function(xs:QName("xdmp:http-get")))
    let $put := map:put($map, "POST", xdmp:function(xs:QName("xdmp:http-post")))
    let $put := map:put($map, "PUT", xdmp:function(xs:QName("xdmp:http-put")))
    let $put := map:put($map, "DELETE", xdmp:function(xs:QName("xdmp:http-delete")))
    let $put := map:put($map, "HEAD", xdmp:function(xs:QName("xdmp:http-head")))
    return $map;

      
declare option xdmp:mapping "false";

declare private function submit-request(
$request as element(http:request)
) as item()*
{
    let $method := map:get($methods, $request/http:method/text())
    let $auth := $request/http:authentication
    let $endpoint := $request/http:url/fn:string()
    let $headers := $request/http:headers
    let $body := if (fn:exists($request/http:body/node()))
        then xdmp:quote($request/http:body/node())
         else ()
    let $options := <options xmlns="xdmp:http">{$auth}{$headers}</options>
    return 
    if (fn:empty($body))
    then xdmp:apply($method, $endpoint, $options)
    else xdmp:apply($method, $endpoint, $options, text { $body })
};

(: 
  optional setup function evaluated first
  add any test docs used by the tests in this module
:)
declare function setup()
{
  xdmp:document-insert("doc1.xml", <doc1>foo bar</doc1>, (), "test")
};

(: optional teardown function evaluated after all tests :)
declare function teardown()
{
  xdmp:document-delete("doc1.xml")
};


declare function test-default-vars()
{
   (
    assert:equal($rxq:default-endpoint, "/rxq-rewriter.xqy?mode=mux"),
    assert:equal($rxq:exclude-prefixes, ("xdmp", "hof", "impl", "plugin", "amped-info", "debug", "cts", "json", "amped-common", "rest", "rest-impl", "fn", "math", "xs", "prof", "sc", "dbg", "xml", "magick", "map", "xp", "rxq", "idecl", "xsi")),
    assert:equal($rxq:cache-flag, fn:false()),
    assert:equal($rxq:default-content-type,"*/*")
    
  )
};

declare function test-site(){
let $request := 
  <request xmlns="xdmp:http" id="base1" description="base1 - simple get with authh">
    <method>GET</method>
    <url>{$base-url}</url>
     <authentication method="digest">
        <username>admin</username>
        <password>admin</password>
    </authentication>
    <expected>
      <code>200</code>
    </expected>
  </request>

return
  assert:equal( submit-request($request)//http:code, <code xmlns="xdmp:http">200</code> )
};
  
declare function test-uri()
{
    assert:equal(rxq:uri(), xs:anyURI("http://www.example.org"))
};

declare function test-base-uri()
{
    assert:equal(rxq:base-uri(), xs:anyURI("http://www.example.org"))
};

declare function test-resource-functions()
{
  let $result  := xdmp:eval('
    import module namespace rxq="﻿http://exquery.org/ns/restxq" at "/example-site/lib/rxq.xqy";
    import module namespace ex1="﻿http://example.org/ex1" at "/example-site/modules/ex1.xqy";
    import module namespace ex2="﻿http://example.org/ex2" at "/example-site/modules/ex2.xqy";
    import module namespace other="﻿http://example.org/other" at "/example-site/lib/other.xqy";
    declare option xdmp:output "method=xml";
    rxq:resource-functions()
    ')
    return
    assert:equal( $result,$result)
};


declare function test-rewrite-options()
{
  let $result := rxq:rewrite-options(())
    return
    assert:equal($result,<options xmlns="http://marklogic.com/appservices/rest">
	<request uri="*" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">dummy to catch non existent pages</uri-param>
	</request>
      </options>)
};


declare function test-rewrite-options2()
{
    assert:equal(rxq:rewrite-options(()),<options xmlns="http://marklogic.com/appservices/rest">
	<request uri="*" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">dummy to catch non existent pages</uri-param>
	</request>
      </options>)
};


declare function test-rewriter()
{

  let $result  := xdmp:eval('
    import module namespace rxq="﻿http://exquery.org/ns/restxq" at "/example-site/lib/rxq.xqy";
    import module namespace ex1="﻿http://example.org/ex1" at "/example-site/modules/ex1.xqy";
    import module namespace ex2="﻿http://example.org/ex2" at "/example-site/modules/ex2.xqy";
    import module namespace other="﻿http://example.org/other" at "/example-site/lib/other.xqy";

    rxq:rewrite-options( $rxq:exclude-prefixes)
    
    ')
    return
    assert:equal($result, <options xmlns="http://marklogic.com/appservices/rest">
	<request uri="^/ex2/a/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex2:a</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/import/test/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">other:importtest</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/ex1/a/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:b</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/ex2/a/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex2:b</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/xml/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:delete-xml</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/xml</uri-param>
	  <http method="DELETE"></http>
	</request>
	<request uri="^/home1/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">other:homepage</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/json/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:insert-json</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type"></uri-param>
	  <http method="PUT" user-params="allow"></http>
	</request>
	<request uri="^/ex1/a/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:a</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/test1/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">other:test</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">0</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/xml/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:insert-xml</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/xml</uri-param>
	  <http method="PUT" user-params="allow"></http>
	</request>
	<request uri="^/a1/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">other:a</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">text/xml</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/ex1/c/(.*)/(\d{{4,7}})/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:homepage</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">2</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="var2">$2</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/ex2/c/(.*)/(\d{{4,7}})/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex2:homepage</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">2</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="var2">$2</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/ex2/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex2:allwebpages</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">0</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:allwebpages</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">0</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/test3$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">other:testa</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">0</uri-param>
	  <uri-param name="content-type">text/html</uri-param>
	  <http method="GET" user-params="allow"></http>
	</request>
	<request uri="^/post/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux">
	  <uri-param name="f">ex1:post-xml</uri-param>
	  <uri-param name="output"></uri-param>
	  <uri-param name="arity">1</uri-param>
	  <uri-param name="var1">$1</uri-param>
	  <uri-param name="content-type">application/x-www-form-urlencoded</uri-param>
	  <http method="POST" user-params="allow">
	    <param name="dir" as="string" required="false"/>
	    <param name="modules" as="string" required="false"/>
	    <param name="tests" as="string" required="false"/>
	    <param name="format" as="string" required="false"/>
	  </http>
	</request>
	<request uri="*" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns:rest="http://marklogic.com/appservices/rest">
	  <uri-param name="f">dummy to catch non existent pages</uri-param>
	</request>
      </options>)
};


