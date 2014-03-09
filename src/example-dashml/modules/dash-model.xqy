xquery version "1.0-ml";

module namespace model = "https://github.com/dashML/model/dash";

(:~ module: dash-model - responsible for rendering views using RXQ
:
: model:all()
: model:get($id)
: model:create($title,$xml)
: model:create($title,$xml,$validate)
: model:update($id,$xml)
: model:update($id,$xml,$validate)
: model:remove($id)
: model:add-widget-to-dash($id,$xml)
: model:remove-widget-to-dash($id,$widget-id)
:
:)

import module namespace meter="http://marklogic.com/manage/meters"
    at "/MarkLogic/manage/meter/meter.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
    
declare default element namespace "https://github.com/dashML/model/dash";

declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare option xdmp:mapping "false";

declare variable $model:_DASHML_ERR_CREATE := "DASHML_ERR_CREATE";
declare variable $model:_DASHML_ERR_UPDATE := "DASHML_ERR_UPDATE";

declare variable $model:_COLLECTION := "dashml";

declare variable $model:_VALIDATE := fn:false();

(:~ model:all() - return all dash
:
: @param
:
: @return dashes
:)
declare function model:all() as element(model:dashes)
{
  element model:dashes {
    collection($model:_COLLECTION)
  }
};


(:~ model:get() - get dash by id
:
: @param id
:
: @return dash
:)
declare function model:get(
$id
) as element(model:dash)?
{
  collection($model:_COLLECTION)/model:dash[@id eq $id]
};


(:~ model:create() - create dash
:
: @param title
: @param xml
:
: @return id
:)
declare function model:create(
    $title as xs:string,
    $xml as element(model:dash)
) as element(model:id)
{
    model:create($title,$xml,$model:_VALIDATE)
};    


(:~ model:create() - validating create dash
:
: @param title
: @param xml
: @param validate
:
: @return id
:)
declare function model:create(
    $title as xs:string,
    $xml as element(model:dash),
    $validate as xs:boolean
) as element(model:id)
{
  let $id := xdmp:random(100000000000000)

  let $_ := if($validate) then
      try {
          validate strict {$xml}
      }catch($e){
          error((),$model:_DASHML_ERR_CREATE,"Cannot validate payload")
      }
  else ()

  let $dash := element model:dash {
    attribute id {$id},
    if($xml/model:title)
        then $xml/*
        else
            (
                element title {$title},
                $xml/(* except model:title)
             )
  }
  
  return
  (xdmp:document-insert(
     $id || ".xml",
     $dash,
     xdmp:default-permissions(),
     ($model:_COLLECTION),
     10),
     element id { $id })
};


(:~ model:update() - update dash
:
: @param id
: @param xml
:
: @return id
:)
declare function model:update(
    $id as xs:unsignedLong,
    $xml as element(model:dash)
) as element(model:id)
{
    model:update($id,$xml,$model:_VALIDATE)
};


(:~ model:update() - validating update dash
:
: @param id
: @param xml
: @param validate
:
: @return id
:)
declare function model:update(
    $id as xs:unsignedLong,
    $xml as element(model:dash),
    $validate as xs:boolean
) as element(model:id)
{

  let $_ := if($validate) then
      try {
          validate strict {$xml}
      }catch($e){
          error((),$model:_DASHML_ERR_UPDATE,"Cannot validate payload on update")
      }
  else ()
  
  let $dash := element model:dash {
      attribute id {$id},
      $xml/*
  }
  
  return
  (xdmp:document-insert(
     $id || ".xml",
     $dash,
     xdmp:default-permissions(),
     ($model:_COLLECTION),
     10),
     element id { $id })
};


(:~ model:remove() - remove dash by id(s)
:
: @param id
:
: @return nothing
:)
declare function model:remove(
    $ids as xs:unsignedLong*
) as empty-sequence()
{
    for $id in $ids
    let $base-uri := base-uri( model:get($id) )
    return xdmp:document-delete($base-uri)
};


(:~ model:add-widget-to-dash() -
:
: @param id
: @param xml
:
: @return id
:)
declare function model:add-widget-to-dash(
    $id as xs:unsignedLong,
    $xml as element(model:widget)
) as element(model:id)
{
  let $existing := model:get($id)
  let $dash := element model:dash {
      attribute id {$id},
      $existing/model:*,
      $xml
    }
 return model:update($id,$dash)
};


(:~ model:remove-widget-to-dash() -
:
: @param id
: @param widget-id
:
: @return id
:)
declare function model:remove-widget-to-dash(
    $id as xs:unsignedLong,
    $widget-id as xs:unsignedLong
)
{
  let $existing := model:get($id)
  let $dash := element model:dash {
      attribute id {$id},
      $existing/model:title,
      $existing/model:widget[@id ne $widget-id]
    }
 return model:update($id,$dash)
};