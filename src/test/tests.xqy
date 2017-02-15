
xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace rxq = "http://exquery.org/ns/restxq" at "/example-simple/lib/rxq.xqy";
declare namespace http = "xdmp:http";

(: IMPORTANT- need to setup example-simple application with httpserver on port 9012 :)
declare variable $base-url as xs:string := "http://node1:8003";

declare variable $admin-auth :=
  <authentication method="digest" xmlns="xdmp:http">
    <username>admin</username>
    <password>admin</password>
  </authentication>;


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
  let $body := if (fn:exists($request/http:body/node())) then xdmp:quote($request/http:body/node()) else ()
  let $options := <options xmlns="xdmp:http">{$auth}{$headers}</options>
  return
    if (fn:empty($body))
    then xdmp:apply($method, $endpoint, $options)
    else xdmp:apply($method, $endpoint, $options, text { $body })
};


declare %test:case function test-default-vars()
{
  assert:equal($rxq:default-endpoint, "/rxq-rewriter.xqy?mode=mux"),
  assert:equal($rxq:exclude-prefixes, ("xdmp", "hof", "impl", "plugin", "amped-info", "debug", "cts", "json", "amped-common", "rest", "rest-impl", "fn", "math", "xs", "prof", "sc", "dbg", "xml", "magick", "map", "xp", "rxq", "idecl", "xsi")),
  assert:equal($rxq:cache-flag, fn:false()),
  assert:equal($rxq:default-content-type,"*/*")
};

declare %test:case function test-site(){
let $request :=
  <request xmlns="xdmp:http" id="base1" description="base1 - simple get with auth">
    <method>GET</method>
    <url>{$base-url}</url>
    {$admin-auth}
  </request>

return
  assert:equal(submit-request($request)//http:code/fn:string(), "200")
};


declare %test:case function test-http-get(){
  let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
      <url>{$base-url}/address/1</url>
      {$admin-auth}
    </request>

  let $expected :=
    <success id="1" http-method="GET" xmlns="">
      <address id="1">
        <name>Gabriela</name>
        <email>Gabriela@example.og</email>
      </address>
    </success>

  return
    assert:equal(submit-request($request)//success, $expected)
};

declare %test:case function test-http-delete()
{
  let $request :=
    <request xmlns="xdmp:http" id="delete1" description="">
      <method>DELETE</method>
      <url>{$base-url}/address/1</url>
      {$admin-auth}
    </request>
  let $actual := submit-request($request)
  return
    assert:equal( $actual[1]/http:code/fn:string(), "200")
};

declare %test:case function test-http-post()
{
  let $request :=
    <request xmlns="xdmp:http" id="base1" description="base1 - simple get with authh">
      <method>POST</method>
      <url>{$base-url}/address/1</url>
      {$admin-auth}
    </request>
  let $actual := submit-request($request)
  return
    assert:equal($actual//http:code/fn:string(), "200")
};


declare %test:case function test-http-put()
{
  let $request :=
    <request xmlns="xdmp:http" id="base1" description="base1 - simple get with auth">
      <method>PUT</method>
      <url>{$base-url}/address/1</url>
      {$admin-auth}
    </request>

  return
    assert:equal(submit-request($request)//http:code/fn:string(), "201")
};


declare %test:case function test-resource-functions()
{
  let $result  := xdmp:eval('
    import module namespace rxq="http://exquery.org/ns/restxq" at "/example-simple/lib/rxq.xqy";
    import module namespace ex1="http://example.org/ex1" at "/example-simple/modules/ex1.xqy";
    import module namespace ex2="http://example.org/ex2" at "/example-simple/modules/ex2.xqy";
    import module namespace address="http://example.org/address" at "/example-simple/lib/address.xqy";
    declare option xdmp:output "method=xml";
    rxq:resource-functions()
  ')
  return
    assert:equal($result, $result)
};


declare %test:case function test-rewrite-options()
{
  let $result := rxq:rewrite-options($rxq:exclude-prefixes)
  return
    assert:equal($result, <options xmlns="http://marklogic.com/appservices/rest"></options>)
};


declare %test:case function test-rewriter()
{
  let $result := xdmp:eval('
    import module namespace rxq="http://exquery.org/ns/restxq" at "/example-simple/lib/rxq.xqy";
    import module namespace ex1="http://example.org/ex1" at "/example-simple/modules/ex1.xqy";
    import module namespace ex2="http://example.org/ex2" at "/example-simple/modules/ex2.xqy";
    import module namespace address="http://example.org/address" at "/example-simple/lib/address.xqy";

    rxq:rewrite-options($rxq:exclude-prefixes)
  ')

  let $expected :=
    <options xmlns="http://marklogic.com/appservices/rest">
      <request uri="^/xhtml-with-doctype$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">xhtml-with-doctype</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">0</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="method">xhtml</uri-param>
        <uri-param name="indent">no</uri-param>
        <uri-param name="omit-xml-declaration">no</uri-param>
        <uri-param name="standalone">no</uri-param>
        <uri-param name="doctype-system">http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd</uri-param>
        <uri-param name="doctype-public">-//W3C//DTD XHTML 1.0 Strict//EN</uri-param>
        <uri-param name="use-rxq-serializer">true</uri-param>
      </request>
      <request uri="^/without-ns-prefix$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">without-ns-prefix</uri-param>
        <uri-param name="produces">text/plain</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">0</uri-param>
        <uri-param name="content-type">text/plain</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/text-serialization-iso-8859-1$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">text-serialization-iso-8859-1</uri-param>
        <uri-param name="produces">text/plain</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">0</uri-param>
        <uri-param name="content-type">text/plain</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="method">text</uri-param>
        <uri-param name="encoding">iso-8859-1</uri-param>
        <uri-param name="indent">no</uri-param>
        <uri-param name="omit-xml-declaration">no</uri-param>
        <uri-param name="use-rxq-serializer">true</uri-param>
      </request>
      <request uri="^/text-content-gzipped$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">text-content-gzipped</uri-param>
        <uri-param name="produces">text/plain</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">0</uri-param>
        <uri-param name="content-type">text/plain</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="method">text</uri-param>
        <uri-param name="use-rxq-serializer">true</uri-param>
        <uri-param name="xdmp-gzip">true</uri-param>
      </request>
      <request uri="^/ex2/a/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex2</uri-param>
        <uri-param name="f-name">a</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/ex2/a$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex2</uri-param>
        <uri-param name="f-name">b</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/ex1/c/(.*)/(.*)/(\d1)$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">regex-example2</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">3</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="var2">$2</uri-param>
        <uri-param name="var3">$3</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/ex1/c/(.*)/(.*)/$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">regex-example</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">2</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="var2">$2</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/ex1/a/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">a</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/ex1/a/$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">b</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/basic-html-document$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">basic-html-document</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">0</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="method">html</uri-param>
        <uri-param name="indent">no</uri-param>
        <uri-param name="use-rxq-serializer">true</uri-param>
      </request>
      <request uri="^/address/all$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/address</uri-param>
        <uri-param name="f-name">all-addresses</uri-param>
        <uri-param name="produces">text/xml</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/xml</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/address/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/address</uri-param>
        <uri-param name="f-name">get-address</uri-param>
        <uri-param name="produces">text/xml</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/xml</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/address/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/address</uri-param>
        <uri-param name="f-name">remove-address</uri-param>
        <uri-param name="produces">text/xml</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/xml</uri-param>
        <http method="DELETE"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/address/(.*)$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/address</uri-param>
        <uri-param name="f-name">insert-address</uri-param>
        <uri-param name="produces">text/xml</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">1</uri-param>
        <uri-param name="var1">$1</uri-param>
        <uri-param name="content-type">text/xml</uri-param>
        <http method="PUT" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
      <request uri="^/$" endpoint="/rxq-rewriter.xqy?mode=mux" xmlns="http://marklogic.com/appservices/rest">
        <uri-param name="f-ns">http://example.org/ex1</uri-param>
        <uri-param name="f-name">entry-point</uri-param>
        <uri-param name="produces">text/html</uri-param>
        <uri-param name="consumes"></uri-param>
        <uri-param name="arity">0</uri-param>
        <uri-param name="content-type">text/html</uri-param>
        <http method="GET" user-params="allow"></http>
        <uri-param name="use-rxq-serializer">false</uri-param>
      </request>
    </options>

  (: nasty hack to ignore the POST as it includes the xray querystring params... :)
  let $actual := $result//*:request[*:http/@method != "POST"]
  let $expected := $expected//*:request[*:http/@method != "POST"]
  for $i in 1 to fn:count($actual)
  return assert:equal($actual[$i], $expected[$i], fn:string($i))
};


declare %test:case function url-not-matching-a-route-should-be-passed-through-to-main-module ()
{
  let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
       <url>{$base-url}/resources/test.txt</url>
       {$admin-auth}
    </request>

  let $actual := submit-request($request)

  return assert:equal($actual//http:code/fn:string(), "200", "http status code")
};


declare %test:case function url-not-matching-a-route-or-main-module-should-return-404 ()
{
  let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
       <url>{$base-url}/foo-bar.xqy</url>
       {$admin-auth}
    </request>

  let $actual := submit-request($request)

  return assert:equal($actual//http:code/fn:string(), "404", "http status code")
};


declare %test:case function should-handle-functions-declared-without-namespace-prefix ()
{
let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
       <url>{$base-url}/without-ns-prefix</url>
       {$admin-auth}
    </request>

  let $actual := submit-request($request)
  let $actual-status-code := $actual//http:code/fn:string()
  let $actual-body := $actual[2]/fn:string()

  let $expected-status-code := "200"
  let $expected-body := "foo"

  return (
    assert:equal($actual-body, $expected-body, "body"),
    assert:equal($actual-status-code, $expected-status-code, "http status code")
  )

};

(: -------------------------------------------------------------------------- :)
(: XSLT and XQuery Serialization 3.0                                          :)
(: -------------------------------------------------------------------------- :)
declare %test:case function basic-html-document()
{
let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
       <url>{$base-url}/basic-html-document</url>
       {$admin-auth}
    </request>

  let $actual := submit-request($request)
  let $actual-status-code := $actual//http:code/fn:string()
  let $actual-body := $actual[2]/fn:string()
  let $actual-content-type := $actual//http:content-type/fn:string()

  let $expected-status-code := "200"
  let $expected-content-type := "text/html; charset=UTF-8"
  let $expected-body := '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><link href="no-destination"><script src="no-script"></script></head><body></body></html>
'

  return (
    assert:equal($actual-content-type, $expected-content-type, "content-type"),
    assert:equal($actual-body, $expected-body, "body"),
    assert:equal($actual-status-code, $expected-status-code, "http status code")
  )

};

declare %test:case function test-text-serialization-iso-8859-1()
{
let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
       <url>{$base-url}/text-serialization-iso-8859-1</url>
       {$admin-auth}
    </request>

  let $actual := submit-request($request)
  let $actual-status-code := $actual//http:code/fn:string()
  let $actual-body := $actual[2]/fn:string()
  let $actual-content-type := $actual//http:content-type/fn:string()

  let $expected-content-type := "text/plain; charset=iso-8859-1"
  let $expected-status-code := "200"
  let $expected-body := 'Hello World
'

  return (
    assert:equal($actual-content-type, $expected-content-type, "content-type"),
    assert:equal($actual-body, $expected-body, "body"),
    assert:equal($actual-status-code, $expected-status-code, "http status code")
  )

};

declare %test:case function test-doctype()
{
let $request :=
    <request xmlns="xdmp:http" id="get1" description="">
      <method>GET</method>
       <url>{$base-url}/xhtml-with-doctype</url>
       {$admin-auth}
    </request>

  let $actual := submit-request($request)
  let $actual-status-code := $actual//http:code/fn:string()
  let $actual-body := $actual[2]/fn:string()
  let $actual-content-type := $actual//http:content-type/fn:string()

  let $expected-content-type := "text/html; charset=UTF-8"
  let $expected-status-code := "200"
  let $expected-body := '<?xml version="1.0" encoding="UTF-8" standalone="no"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><?xml version="1.0" encoding="UTF-8" standalone="no"?><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></head><body><p>Hello World</p></body></html>
'

  return (
    assert:equal($actual-content-type, $expected-content-type, "content-type"),
    assert:equal($actual-body, $expected-body, "body"),
    assert:equal($actual-status-code, $expected-status-code, "http status code")
  )

};

(: -------------------------------------------------------------------------- :)
(: xdmp annotations, e.g. xdmp:gzip, maybe multipart etc                      :)
(: -------------------------------------------------------------------------- :)

(:
  testing the %xdmp:gzip annotation

  unfortunately, the xdmp:http-get function does not support calling content
  where the response where both the following headers exist:

  Content-type: */*; charset=UTF-8
  Content-encoding: gzip

  xdmp:http-get throws:

    Invalid UTF-8 escape sequence at http://localhost:9012/text-content-gzipped
    line 1 -- document is not UTF-8 encoded
:)

(: -------------------------------------------------------------------------- :)
