xquery version "1.0-ml";

module namespace address="http://example.org/address";
       
declare namespace rxq="http://exquery.org/ns/restxq";

declare variable $addresses := <addresses>
 <address id="1"><name>Gabriela</name><email>Gabriela@example.og</email></address>
 <address id="2"><name>Jim</name><email>jim@example.og</email></address>
 <address id="3"><name>Vojtech</name><email>jim@example.og</email></address>
 <address id="4"><name>Ladislav</name><email>ladi@example.og</email></address>
 <address id="5"><name>Kveta</name><email>kveta@example.og</email></address>
 <address id="6"><name>Suzi</name><email>suzi@example.og</email></address>
</addresses>;


(:~ demonstrates HTTP GET  :)
declare
 %rxq:produces('text/xml')
 %rxq:GET
 %rxq:path('/address/all')
 function address:all-addresses(
   $dummy
) as element(){
     ( xdmp:set-response-code(200, "Found"),
     <success http-method="GET">{$addresses}</success>
     )
};


(:~ demonstrates HTTP GET  :)
declare
 %rxq:produces('text/xml')
 %rxq:GET
 %rxq:path('/address/(.*)')
 function address:get-address(
   $id
) as element(){
 if($addresses/address[@id eq $id]) then
   ( xdmp:set-response-code(200, "Found"),
   <success id="{$id}" http-method="GET">{$addresses/address[@id eq $id]}</success>
   )
 else
   ( xdmp:set-response-code(404, "Not Found"),
   <failure id="{$id}"
   http-status="404"
   http-method="GET">{$id} does not exist</failure>
   )
};


(:~ demonstrates HTTP PUT  :)
declare
 %rxq:produces('text/xml')
 %rxq:PUT
 %rxq:path('/address/(.*)')
 function address:insert-address(
   $id
) as element(){
   ( xdmp:set-response-code(201, "Created"),
   <success id="{$id}" http-method="PUT">{
     element address {attribute id {$id},
     (xdmp:get-request-body("xml")/.)/*} }
   </success>
   )
};


(:~ demonstrates HTTP POST  :)
declare
 %rxq:produces('*/*')
 %rxq:POST
 %rxq:path('/address/(.*)')
 function address:change-address(
   $id
) as element(){
     ( xdmp:set-response-code(200, "OK"),
     <success id="{$id}" http-method="POST">{
       element address {attribute id {$id},
       (xdmp:get-request-body()/.)/*} }
     </success>
     )
};


(:~ demonstrates HTTP DELETE  :)
declare
 %rxq:produces('text/xml')
 %rxq:DELETE
 %rxq:path('/address/(.*)')
 function address:remove-address(
   $id
) as element(){
   if($addresses/address[@id eq $id]) then
    ( xdmp:set-response-code(200, "OK"),     
     <success id="{$id}" http-method="DELETE"></success>
     )
   else
     ( xdmp:set-response-code(404, "Not Found"),
     <failure id="{$id}"  http-method="GET">{$id} does not exist</failure>
     )
};
