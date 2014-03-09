xquery version "1.0-ml";

module namespace history = "https://github.com/dashML/model/history";

(:~ module: history - custom entry points to unofficial MarkLogic meters API
:
:)

import module namespace meter="http://marklogic.com/manage/meters"
  at "/MarkLogic/manage/meter/meter.xqy";

import module namespace mdecl="http://marklogic.com/manage/meters/decl"
  at "/MarkLogic/manage/meter/meter-decl.xqy";

import module namespace sem="http://marklogic.com/semantics"
  at "/MarkLogic/semantics.xqy";

import module namespace tr-model = "http://marklogic.com/manage/meters/transient-resource/model"
  at "/MarkLogic/manage/meter/models/transient-resource-model.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
  
declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare option xdmp:mapping "false";

(:~ history:get-metric-names - generate list of metric names for drop down selection
:
: @returns
:)
declare function history:get-metric-names(){
element optgroup {
    element optgroup {
        attribute label {"databases"},
        for $s in $mdecl:database-status-names
        order by $s
        return element option{
            attribute value {"databases:" || $s},
            "databases: " || $s }
    },
    element optgroup {
        attribute label {"hosts"},
        for $s in $mdecl:host-status-names
        order by $s
        return element option{
            attribute value {"hosts:" || $s},
            "hosts: " || $s }
    },
    element optgroup {
        attribute label {"servers"},
        for $s in $mdecl:server-status-names
        order by $s
        return element option{
            attribute value {"servers:" || $s},
            "servers: " || $s }
    },
    element optgroup {
        attribute label {"forests"},
        for $s in ( $mdecl:forest-status-names,$mdecl:forest-counts-names)
        order by $s
        return element option{
            attribute value {"forests:" || $s},
            "forests: " || $s }
    }
  }
};


(:~ history:get-database - get database metrics, as alternate to using Manage API
:
: @param meter
: @param period
: @param start
: @param end
: @param aggregation
: @param format
: @param summary
: @param detail
: @param databases
:
: @returns
:)
declare function history:get-database(
  $meter as xs:string,
  $period as xs:string,
  $start,
  $end,
  $aggregation as xs:string,
  $format as xs:string,
  $summary as xs:boolean,
  $detail as xs:boolean,
  $databases as xs:unsignedLong*
)
{
  let $params := map:map()
  let $_ := map:put($params,"summary",$summary)
  let $_ := map:put($params,"detail",$detail)
  let $_ := map:put($params,"summary-aggregation",$aggregation)
  let $_ := map:put($params,"format",$format)
  let $_ := map:put($params,"database",$databases)
  return meter:time-series(
      xs:QName("meter:database-status"),
      (),
      $meter,$period,$start,$end,$params)
};



(:~ history:get-forest - get forest metrics, as alternate to using Manage API
:
: @param meter
: @param period
: @param start
: @param end
: @param aggregation
: @param format
: @param summary
: @param detail
: @param databases
:
: @returns
:)
declare function history:get-forest(
  $meter as xs:string,
  $period as xs:string,
  $start,
  $end,
  $aggregation as xs:string,
  $format as xs:string,
  $summary as xs:boolean,
  $detail as xs:boolean,
  $forests as xs:unsignedLong*
)
{
  let $params := map:map()
  let $_ := map:put($params,"summary",$summary)
  let $_ := map:put($params,"detail",$detail)
  let $_ := map:put($params,"summary-aggregation",$aggregation)
  let $_ := map:put($params,"format",$format)
  let $_ := map:put($params,"forest",$forests)
  return meter:time-series(
      xs:QName("meter:forest-status"),
      (),
      $meter,$period,$start,$end,$params)
};



(:~ history:get-host - get host metrics, as alternate to using Manage API
:
: @param meter
: @param period
: @param start
: @param end
: @param aggregation
: @param format
: @param summary
: @param detail
: @param hosts
:
: @returns
:)

declare function history:get-host(
  $meter as xs:string,
  $period as xs:string,
  $start,
  $end,
  $aggregation as xs:string,
  $format as xs:string,
  $summary as xs:boolean,
  $detail as xs:boolean,
  $hosts as xs:unsignedLong*
)
{
  let $params := map:map()
  let $_ := map:put($params,"summary",$summary)
  let $_ := map:put($params,"detail",$detail)
  let $_ := map:put($params,"summary-aggregation",$aggregation)
  let $_ := map:put($params,"format",$format)
  let $_ := map:put($params,"host",$hosts)
  return meter:time-series(
      xs:QName("meter:host-status"),
      (),
      $meter,$period,$start,$end,$params)
};



(:~ history:get-server - get server metrics, as alternate to using Manage API
:
: @param meter
: @param period
: @param start
: @param end
: @param aggregation
: @param format
: @param summary
: @param detail
: @param servers
:
: @returns
:)
declare function history:get-server(
  $meter as xs:string,
  $period as xs:string,
  $start,
  $end,
  $aggregation as xs:string,
  $format as xs:string,
  $summary as xs:boolean,
  $detail as xs:boolean,
  $servers as xs:unsignedLong*
)
{
  let $params := map:map()
  let $_ := map:put($params,"summary",$summary)
  let $_ := map:put($params,"detail",$detail)
  let $_ := map:put($params,"summary-aggregation",$aggregation)
  let $_ := map:put($params,"format",$format)
  let $_ := map:put($params,"server",$servers)
  return meter:time-series(
      xs:QName("meter:server-status"),
      (),
      $meter,$period,$start,$end,$params)
};


(:~ history:get-metrics - generic entry point
:
: @param resource
: @param meter
: @param period
:
: @returns
:)
declare function history:get-metrics(
    $resource as xs:string,
    $meter as xs:string,
    $period as xs:string
){
    switch($resource)
    case "databases" return
         history:get-database(
             $meter,$period,
             (),fn:current-dateTime(),
             'sum','xml',true(),false(),
             ())[1]/*
    case "hosts" return
      history:get-host(
          $meter,$period,
          (),fn:current-dateTime(),
          'sum','xml',true(),false(),
          ())
    case "servers" return
      history:get-server(
          $meter,$period,
          (),fn:current-dateTime(),
          'sum','xml',true(),false(),
          ())
    default return
      history:get-forest(
          $meter,$period,
          (),fn:current-dateTime(),
          'sum','xml',true(),false(),
          ())
};


(:~ history:generate-sparkle-data - helper function for massaging data
:                                   into format required for sparkline
:
: @param data
:
: @returns
:)
declare function history:generate-sparkle-data(
    $data
)
{
    fn:string-join( for $entry at $pos in $data/*:summary/*:data/*:entry
    return fn:concat($pos,':',$entry/*:value/string()),',' )
};


(:~ history:get-log - obtain error log from HTTP to avoid file path differences
:
: @param logfile
:
: @returns
:)
declare function history:get-log(
    $logfile as xs:string
)
{
 xdmp:http-get(
     "http://localhost:8001/get-error-log.xqy?filename=ErrorLog.txt",
     <options xmlns="xdmp:http">
       <authentication method="digest">
         <username>admin</username>
         <password>admin</password>
         <format xmlns="xdmp:document-get">text</format>
       </authentication>
     </options>
      )[2]
};



(:~ history:remove-error-log-triples - remove error_log triple graph
:
: @returns
:)
declare function history:remove-error-log-triples()
{
      xdmp:eval('
      import module namespace sem="http://marklogic.com/semantics"
      at "/MarkLogic/semantics.xqy";
      sem:graph-delete(sem:iri("error_log"))
      ',  (),
      <options xmlns="xdmp:eval">
        <isolation>different-transaction</isolation>
      </options>)
 };



(:~ history:generate-test-error - insert an error log trace into ErrorLog.txt
:
: @returns
:)
declare function history:generate-test-error(){
    xdmp:log("dashML errorlog test:" || current-dateTime(), "error")
};



(:~ history:load-error-triples - load ErrorLog.txt as triples into error_log graph
:
: @returns
:)
declare function history:load-error-triples(){

let $make := sem:rdf-builder(
sem:prefixes("ml:
http://marklogic.com/logging/request/"))

let $errorlogdata := history:get-log("ErrorLog.txt")

let $lines := fn:tokenize($errorlogdata, "&#10;")

let $triples := for $line in $lines
  let $pieces := fn:tokenize($line,' ')
  let $date := $pieces[1] || "T" || fn:replace(fn:substring-before($pieces[2],'.'),'([0-9][0-9])$','00') 
  let $info := substring-after($line,$pieces[2])
  let $subject := sem:iri("http://marklogic.com/logfile/request/" || xdmp:md5($line)) where fn:count($pieces) gt 0
    return
      if( fn:substring-before($info,":") eq 'Info')
        then ()
        else
        (
          $make($subject, "a", "ml:Request"),
          $make($subject, "ml:timestamp", if($date castable as xs:dateTime) then
            fn:adjust-dateTime-to-timezone(
                xs:dateTime($date), fn:implicit-timezone())
            else $date
          ),
          $make($subject, "ml:message", $info),
          $make($subject, "a", fn:substring-before($info,":"))
        )
return sem:graph-insert(sem:iri('error_log'), $triples)
};



(:~ history:get-error-log-data - return error log data for meter widget
:
: @param loglevel
: @param meter
: @param end
: @param resource
: @param period
:
: @returns
:)
declare function history:get-error-log-data(
    $loglevel as xs:string,
    $meter as xs:string,
    $end as xs:dateTime,
    $resource as xs:string,
    $period as xs:string
)
{
let $inc := if ($period eq "raw") then xs:dayTimeDuration("PT60M")
          else if ($period eq "hour") then xs:dayTimeDuration("PT24H")
          else xs:dayTimeDuration("P30D")
let $start :=  fn:format-dateTime( $end - $inc,
                                     "[Y0001]-[M01]-[D01]T[H01]:[m01]:00[Z]")

let $tr := switch($resource)
    case "databases" return tr-model:getDatabases(xs:dateTime($start),$end,$period)
    case "forests" return tr-model:getForests(xs:dateTime($start),$end,$period)
    case "hosts" return tr-model:getHosts(xs:dateTime($start),$end,$period)
    case "servers" return tr-model:getServers(xs:dateTime($start),$end,$period)
    default return ()

    let $_ := xdmp:log($tr)
let $check := fn:concat("PREFIX xs: <http://www.w3.org/2001/XMLSchema#>
ASK
FROM <error_log>
FROM <meters>
WHERE {
    ?s ?p '",$loglevel,"' ;
    <http://marklogic.com/logging/request/timestamp> ?ts .

FILTER ( ?ts >= '",$start,"'^^xs:dateTime )
}
LIMIT 100")


let $s := concat("PREFIX xs: <http://www.w3.org/2001/XMLSchema#>
SELECT DISTINCT *
FROM <error_log>
FROM <meters>
WHERE {
?s ?p 'Error' ;
<http://marklogic.com/logging/request/timestamp> ?ts .
?s <http://marklogic.com/logging/request/message> ?message .
?ts ?meters ?value .
FILTER (regex(?meters, '",$period, if ( $resource eq "databases") then "/master/" else "/",$meter,"','i'))
FILTER ( ?ts >= '",$start,"'^^xs:dateTime )
}
LIMIT 100")
    let $_:= xdmp:log($s)

let $objects:= if(sem:sparql($check))
    then sem:sparql($s)
    else ()

for $n in (1 to fn:count($objects))
let $object := $objects[$n]
let $ts := map:get($object,"ts")
let $info := map:get($object,"info")
let $message := map:get($object,"message")
let $value := map:get($object,"value")
let $r := fn:substring-before(map:get($object,"meters"),'/')
return
    element error {
        element loglevel {$loglevel},
        element ts {map:get($object,"ts") },
        element message {map:get($object,"message")},
        element name {$tr[@id = $r]/tr-model:name/string(.)},
        element value {map:get($object,"value")}
    }
};
