xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace rxq="﻿http://exquery.org/ns/restxq" at "/example/lib/restxq.xqy";
import module namespace ex1="﻿http://example.org/mine/" at "/example/external.xqy";
import module namespace other="﻿http://example.org/other/" at "/example/other.xqy";

import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

declare option xdmp:mapping "false";

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


declare function test-default-endpoint()
{
  let $foo := "foo"
  let $bar := "bar"
  return (
    assert:not-empty($rxq:endpoint),
    assert:equal($rxq:endpoint, "/rewrite.xqy?mode=mux")
  )
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
  let $result := xdmp:eval('
import module namespace ex1="﻿http://example.org/mine/" at "/example/external.xqy";
import module namespace other="﻿http://example.org/other/" at "/example/other.xqy";

    import module namespace rxq="﻿http://exquery.org/ns/restxq" at "/example/lib/restxq.xqy";

    rxq:resource-functions()

    ')
    return
    assert:equal($result/*,<rxq:resource-functions xmlns:rxq="﻿http://exquery.org/ns/restxq">
	<rxq:resource-function xquery-uri="xs:anyURI">
	  <rxq:identity namespace="xs:anyURI" local-name="xs:NCName" arity="xs:int"></rxq:identity>
	</rxq:resource-function>
      </rxq:resource-functions>)
};


declare function test-rewrite-options()
{
  let $result := rxq:rewrite-options(("ex1"))
    return
    assert:equal($result,<options xmlns="http://marklogic.com/appservices/rest">
	<request uri="*" endpoint="/rewrite.xqy?mode=mux">
	  <uri-param name="f">dummy to catch non existent pages</uri-param>
	</request>
      </options>)
};


declare function test-rewrite-options2()
{
    assert:equal(rxq:rewrite-options(("ex1","other")),<options xmlns="http://marklogic.com/appservices/rest">
	<request uri="*" endpoint="/rewrite.xqy?mode=mux">
	  <uri-param name="f">dummy to catch non existent pages</uri-param>
	</request>
      </options>)
};


declare function test-default-content-type()
{
    assert:equal($rxq:default-content-type,"text/html")
};
