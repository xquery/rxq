xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace restxq="﻿http://exquery.org/ns/rest/annotation/" at "../example/lib/restxq.xqy";

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
    assert:not-empty($restxq:endpoint),
    assert:equal($restxq:endpoint, "/rewrite.xqy?mode=mux")
  )
};


declare function test-uri()
{
    assert:equal(restxq:uri(), xs:anyURI("http://www.example.org"))
};

declare function test-base-uri()
{
    assert:equal(restxq:base-uri(), xs:anyURI("http://www.example.org"))
};

declare function test-resource-functions()
{
    assert:equal(restxq:resource-functions(),
    document{<restxq:resource-functions>
<restxq:resource-function
  xquery-uri = "xs:anyURI">
  <restxq:identity
    namespace = "xs:anyURI"
    local-name = "xs:NCName"
    arity = "xs:int"/>
</restxq:resource-function>
</restxq:resource-functions>})

};
