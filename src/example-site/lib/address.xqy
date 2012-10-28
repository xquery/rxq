xquery version "1.0-ml";

module namespace address="﻿http://example.org/address";
       
declare namespace rxq="﻿http://exquery.org/ns/restxq";

declare variable $addresses := <addresses>
 <address id="1"><name>Gabriela</name><email>Gabriela@example.og</email></address>
 <address id="2"><name>Jim</name><email>jim@example.og</email></address>
 <address id="3"><name>Vojtech</name><email>jim@example.og</email></address>
 <address id="4"><name>Ladislav</name><email>ladi@example.og</email></address>
 <address id="5"><name>Kveta</name><email>kveta@example.og</email></address>
 <address id="6"><name>Suzi</name><email>suzi@example.og</email></address>
</addresses>;


(:~ path with variable and text/xml content type :)
declare %rxq:produces('text/xml') %rxq:GET %rxq:path('/address/all') function address:all-addresses($dummy) {
<success http-method="GET">{$addresses}</success>
};

declare %rxq:produces('text/xml') %rxq:GET %rxq:path('/address/(.*)') function address:get-address($id) {
 if($addresses/address[@id eq $id]) then
 <success id="{$id}" http-method="GET">{$addresses/address[@id eq $id]}</success>
 else
 <failure id="{$id}"  http-method="GET">problem accessing {$id}</failure>
};


declare %rxq:produces('text/xml') %rxq:PUT %rxq:path('/address/(.*)') function address:insert-address($id) {
<success id="{$id}" http-method="PUT">{element address {
                                           attribute id {$id},
                                           (xdmp:get-request-body("xml")/.)/*} }</success>
};


declare %rxq:produces('*/*') %rxq:POST %rxq:path('/address/(.*)') function address:change-address($id) {
<success id="{$id}" http-method="POST">{element address {
                                           attribute id {$id},
                                           (xdmp:get-request-body()/.)/*} }</success>
};

declare %rxq:produces('text/xml') %rxq:DELETE %rxq:path('/address/(.*)') function address:remove-address($id) {
   if($addresses/address[@id eq $id]) then
   <success id="{$id}" http-method="DELETE"></success>
   else
   <failure id="{$id}"  http-method="GET">problem accessing {$id}</failure>
};

