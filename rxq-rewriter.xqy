xquery version "1.0-ml";
(:
 : rxq-rewriter.xqy
 :
 : Copyright (c) 2012-2014 James Fuller. All Rights Reserved.
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

(:~ RXQ MarkLogic RESTXQ implementation :)
import module namespace rxq="http://exquery.org/ns/restxq" at "/lib/rxq.xqy";

(:~ rewriter for RXQ.
 :
 :  Import modules that contain REST XQ annotations below
 :)

(: example

import module namespace view = "https://github.com/dashML/view" at "/modules/view.xqy";

:)

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare variable $ENABLE-CACHE as xs:boolean := fn:false();

rxq:process-request($ENABLE-CACHE)