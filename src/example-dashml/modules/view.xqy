xquery version "1.0-ml";

module namespace view = "https://github.com/dashML/view";

(:~ module: view - responsible for rendering views using RXQ
:
:)

import module namespace dash-model = "https://github.com/dashML/model/dash"
  at "dash-model.xqy";

  import module namespace history-model = "https://github.com/dashML/model/history"
  at "history-model.xqy";

declare namespace rxq="﻿http://exquery.org/ns/restxq";
declare namespace html="﻿http://www.w3.org/1999/xhtml";
declare namespace meter="http://marklogic.com/manage/meters";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare default element namespace "https://github.com/dashML/model/dash";

declare option xdmp:mapping "false";


(:~ view:spec() - about dashML page
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:path('/')
  %rxq:produces('text/html')
function view:spec() as element()
{
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>About - dashML</title>
<link rel="stylesheet" href="/resources/css/pure-min.css"></link>
<link rel="stylesheet" href="http://weloveiconfonts.com/api/?family=fontawesome"></link>
<link rel="stylesheet" href="/resources/css/main.css"></link>
<link rel="stylesheet" href="/resources/css/custom.css"></link>
<script src="/resources/js/vendor/modernizr-2.6.2.min.js">>&#160;</script>
</head>
<body>
  <div class="pure-menu pure-menu-open pure-menu-horizontal pure-menu-blackbg">
    <ul>
      <li class="pure-menu-selected"><a href="/">dashML</a></li>
      <li><a href="/instructions">instructions</a></li>
      <li><a href="/builder">build dashboards</a></li>
    </ul>
  </div>
  <div class="splash">
    <div class="pure-g-r">
            <div class="pure-u-1-3">
                <div class="l-box splash-image">
                    <img src="resources/history-screenshot.jpg"
                         height="270" width="450"
                         alt="Placeholder image for example."/>
                </div>
            </div>
            <div class="pure-u-2-3">
                <div class="l-box splash-text">
                    <h1 class="splash-head">
                        dashboards with MarkLogic 7.0.
                    </h1>
                    <h2 class="splash-subhead">
                        MarkLogic 7.0 introduces more tools for
                        <a href="http://{xdmp:host-name()}:8002/history"
                          target="_history">
                        monitoring performance</a> of your MarkLogic server.
                        dashML leverages these tools to make it easy to create
                        lightweight, responsive dashboards giving you up-to-date
                        information on the health and performance of your
                        applications.
                    </h2>
                    <p>
                        <a href="/builder" class="pure-button primary-button">
                          Start building dashboards</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
 <div class="content">
        <div class="pure-g-r content-ribbon">
            <div class="pure-u-2-3">
                <div class="l-box">
                    <h4 class="content-subhead">Features</h4>
                    <ul>
                       <li>create dashboards based on MarkLogic
                         history performance metrics</li>
                       <li>multiple dashboards, each with multiple metrics</li>
                       <li>responsive layout - works in most
                         mobile and tablet environments</li>
                    </ul>
                </div>
            </div>
            <div class="pure-u-2-3">
                <div class="l-box">
                    <h4 class="content-subhead">Technologies Used</h4>
                    <ul>
                      <li>marklogic 7.0 history performance meters</li>
                      <li><a href="http://github.com/xquery/rxq" target="_new">rxq</a>- app framework based on RESTXQ annotations for rapid development</li>
                      <li><a href="http://purecss.io/" target="_new">purecss</a>- easy to use css bootstrap, from Yahoo, to make my rubbish css/html look somewhat acceptable</li>
                      <li><a href="http://purecss.io/" target="_new">jquery</a>-</li>
                      <li><a href="http://purecss.io/" target="_new">spectrum</a>- easy to use jquery color picker</li>
                      <li><a href="http://purecss.io/" target="_new">sparkline</a>- generates mini graphs</li>
                    </ul>
                </div>
            </div>
            <div class="pure-u-2-3">
                <div class="l-box">
                    <h4 class="content-subhead">todo</h4>
                    <ul>
                      <li>make widgets and dash standalone (consume json endpoints)</li>
                      <li>add resource selection</li>
                      <li>different widget types</li>
                      <li>add replica to database</li>
                      <li>customise everything (colors, etc)</li>
                      <li>reordering</li>
                      <li>add thresholds for alerting</li>
                      <li>add start &amp; end selection</li>
                    </ul>
                </div>
            </div>
            <div class="pure-u-2-3">
                <div class="l-box">
                    <h4 class="content-subhead">Caveat Emptor</h4>
                    <ul>
                      <li>I made GET do bad things (as in not idempotent)</li>
                      <li>time constraints = quick code generate (though there are some xray unit tests)</li>
                      <li>no error checking (other then schema validation)</li>
                      <li>probably a long list of other things done poorly ...</li>
                    </ul>
                </div>
            </div>
        </div>
 </div>
<a href="https://github.com/xquery/dashML"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png" alt="Fork me on GitHub"/></a>
<footer>
  &copy; 2013 <a href="https://github.com/xquery/dashML">Jim Fuller</a> <span style="float:right;">last updated: {current-dateTime()}</span>
</footer>
</body>
</html>
};



(:~ view:setup() - about dashML page
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:path('/instructions')
  %rxq:produces('text/html')
function view:instructions()
{
('<!DOCTYPE html>',
<html>
<head>
  <title>Setup - dashML</title>
<link rel="stylesheet" href="/resources/css/pure-min.css"></link>
<link rel="stylesheet" href="http://weloveiconfonts.com/api/?family=fontawesome"></link>
<link rel="stylesheet" href="/resources/css/main.css"></link>
<link rel="stylesheet" href="/resources/css/custom.css"></link>
<script src="/resources/js/vendor/modernizr-2.6.2.min.js">>&#160;</script>
</head>
<body>
  <div class="pure-menu pure-menu-open pure-menu-horizontal pure-menu-blackbg">
    <ul>
      <li><a href="/">dashML</a></li>
      <li class="pure-menu-selected"><a href="/instructions">instructions</a></li>
      <li><a href="/builder">build dashboards</a></li>
    </ul>
  </div>
  <div class="splash">
    <div class="pure-g-r">
            <div class="pure-u-1-3">
                <div class="l-box splash-image">
                    <img src="/resources/history-screenshot.jpg"
                         height="270" width="450"
                         alt="Placeholder image for example."/>
                </div>
            </div>
            <div class="pure-u-2-3">
                <div class="l-box splash-text">
                    <h1 class="splash-head">
                        Instructions how to use dashML
                    </h1>
                    <p>
                        <a href="/builder" class="pure-button primary-button">
                          Start Building Dashboards</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
 <div class="content">
        <div class="pure-g-r content-ribbon">
            <div class="pure-g">
                <div class="pure-u-1-4">
                    <h4 class="content-subhead">Create a dashboard</h4>
                    <ul>
                       <li>goto 'Build Dashboards'</li>
                       <li>supply a dashboard name</li>
                       <li>click 'create dashboard'</li>
                    </ul>
                </div>
                <div class="pure-u-1-2">
                 <div class="l-box splash-image">
                    <img src="/resources/instructions1.png"
                         height="400" width="650"
                         alt="add dashboard."/>
                </div>
                </div>
            </div>
            <hr/>
            <div class="pure-g">
                <div class="pure-u-1-4">
                    <h4 class="content-subhead">Add widget</h4>
                    <ul>
                      <li>goto 'Build Dashboards'</li>
                      <li>create a new dashboard or edit an existing one</li>
                      <li>choose dashboard title color</li>
                      <li>select 'standard widget'</li>
                      <li>select metric of interest</li>
                      <li>view dashboard in viewer or click dashboard name to view in its own browser window</li>
                      <li>in dashboard, choose 'live' to enable auto page refresh</li>
                      <li>in dashboard, choose time period ex. 'last 60 minutes'</li>
                    </ul>
                </div>
                <div class="pure-u-1-2">
                 <div class="l-box splash-image">
                    <img src="/resources/instructions2.png"
                         height="400" width="650"
                         alt="add dashboard."/>
                </div>
                </div>
            </div>
            <br/>
            <div class="pure-g">
                <div class="pure-u-1-4">
                    <h4 class="content-subhead">Try out experimental widgets</h4>
                    <ul>
                      <li>goto 'Build Dashboards'</li>
                      <li>create a new dashboard or edit an existing one</li>
                      <li>choose dashboard title color</li>
                      <li>select 'ErrorLog widget'</li>
                      <li>view dashboard in viewer or click dashboard name to view in its own browser window</li>
                      <li>on the ErrorLog Widget, click '[ generate test errors &amp; reload ErrorLog triples ]' link to generate some test errors and load ErrorLog as triples</li>
                    </ul>
                </div>
                <div class="pure-u-1-2">
                 <div class="l-box splash-image">
                    <img src="/resources/instructions3.jpg"
                         height="400" width="650"
                         alt="add dashboard."/>
                </div>
                </div>
            </div>
        </div>
 </div>
<a href="https://github.com/xquery/dashML"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png" alt="Fork me on GitHub"/></a>
<footer>
  &copy; 2013 <a href="https://github.com/xquery/dashML">Jim Fuller</a> <span style="float:right;">last updated: {current-dateTime()}</span>
</footer>
</body>
</html>
)
};


(:~ view:builder() - dashML builder page
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:path('/builder')
  %rxq:produces('text/html')
function view:builder(
    $id
) as element()
{
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>dashML</title>
  <link rel="stylesheet" href="/resources/css/pure-min.css"></link>
  <link rel="stylesheet" href="http://weloveiconfonts.com/api/?family=fontawesome"></link>
  <link rel="stylesheet" href="/resources/css/main.css"></link>
  <link rel="stylesheet" href="/resources/css/custom.css"></link>
  <link rel='stylesheet' href='/resources/css/spectrum.css' ></link>
  <script src="/resources/js/vendor/jquery-1.9.1.min.js">&#160;</script>
  <script src="/resources/js/vendor/modernizr-2.6.2.min.js">>&#160;</script>
  <script src='/resources/js/spectrum.js'></script>

</head>
<body>
<div class="pure-menu pure-menu-open pure-menu-horizontal pure-menu-blackbg">
    <ul>
        <li><a href="/">dashML</a></li>
        <li><a href="/instructions">instructions</a></li>
        <li class="pure-menu-selected"><a href="/builder">build dashboards</a></li>
    </ul>
</div>
<div class="pure-g-r">
    <div class="pure-u-1-2 builder-div">
    <h2>dashML build</h2>
    <i>add, edit, view &amp; remove dashboard tab.
    </i>
    <form method="POST" action="/builder" class="pure-form">
      <fieldset>
        <table  class="pure-table dash-table">
         <thead>
        <tr>
            <th>dashboard name</th>
            <th colspan="3">actions</th>
        </tr>
    </thead>
    <tbody>
          {
              for $dash in dash-model:all()/dash-model:dash
              let $dash-id := $dash/@id/data(.)
              order by $dash/dash-model:title/data()
              return
              <tr>
              <td>
                <a href="/render/{$dash-id}" title="view dash" target="_dash">
                {$dash/dash-model:title/data()}
                </a>
              </td>
              <td>
                <a href="/render/{$dash-id}"
                  title="view dash" target="_dash{$dash-id}" class="pure-button">
                view
                </a>
              </td>
              <td>
                <a href="/builder/{$dash-id}"
                  title="edit dash" class="pure-button">
                edit
                </a>
              </td>
              <td>
                <a href="/builder/delete/{$dash-id}" id="delete"
                  title="delete dash" class="pure-button">remove</a>
              </td>
              </tr>
          }
    </tbody>
   </table>
   <input id="name" name="name" type="text"/>
     <button id="create" title="create new dash"
       class="pure-button pure-button-primary">create dash</button>
  </fieldset>
 </form>
{
 if($id) then
 (
 <h3>edit dashboard:
 <span style="color:#888">{dash-model:get($id)/dash-model:title/data()}</span>
 </h3>,
 <i>add and remove meter widgets from this dashboard</i>
 )
 else ()
}
 <form method="POST" action="/builder/{$id}" class="pure-form">
   <table  class="pure-table widget-table">
     <thead>
       <tr>
         <th>color</th>
         <th>type</th>
         <th>resource</th>
         <th>meter</th>
         <th>actions</th>
       </tr>
     </thead>
     <tbody>
     {for $widget in dash-model:get($id)/dash-model:widget
     order by $widget/dash-model:title/data()
     return
     <tr>
     <td>{$widget/dash-model:title/data()}</td>
     <td>{$widget/dash-model:type/data()}</td>
     <td>{$widget/dash-model:resource/data()}</td>
     <td>{$widget/dash-model:meter/data()}</td>
     <td><a href="/builder/widget/delete/{$id}/{$widget/@id/data()}"
       title="delete widget" class="pure-button">delete</a></td>
     </tr>
     }
     </tbody>
   </table><br/>
{
if($id) then
<div>
<input name="color" type="color" value='#FFF'/>
<select name="type">
  <option value="sparkline">standard widget</option>
  <option value="log">ErrorLog (experimental)</option>
  <!--option>timeseries</option-->
</select>
<select name="meter">
{history-model:get-metric-names()}
</select>
<button id="add-widget" class="pure-button pure-button-primary"
  style="float:right;margin-right:30px;"
  title="add new widget">add widget</button>
</div>
else ()
}
 </form>
<br/>
 </div>
 <div class="pure-u-1-2 render-div">
    <h2>dashML view</h2>
    {if($id)
    then 
    <iframe name="render-frame" src="/render/{$id}"/>
    else
    <iframe name="render-frame"/>
    }
 </div>
</div>
<a href="https://github.com/xquery/dashML">
<img style="position: absolute; top: 0; right: 0; border: 0;"
 src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png"
 alt="Fork me on GitHub"/></a>
<footer>
  &copy; 2013 <a href="https://github.com/xquery/dashML">Jim Fuller</a>
  <span style="float:right;">last updated: {current-dateTime()}</span>
</footer>
</body>
</html>
};



(:~ view:handle-dash-post() - create dash from HTTP POST
:
: @param id
:
: @return html
:)
declare
  %rxq:POST
  %rxq:path('/builder')
  %rxq:produces('text/html')
function view:handle-dash-post(
  $id
  )
{
    let $id :=
        dash-model:create( xdmp:get-request-field("name"),
        <dash xmlns="https://github.com/dashML/model/dash">
          <title>{xdmp:get-request-field("name")}</title>
        </dash>)
    return xdmp:redirect-response("/builder/" || $id)
};



(:~ view:handle-widget-post() - add dash widget from HTTP POST
:
: @param id
:
: @return html
:)
declare
  %rxq:POST
  %rxq:path('/builder/(.*)?')
  %rxq:produces('text/html')
function view:handle-widget-post(
  $id
  )
{
    let $m := fn:tokenize(xdmp:get-request-field("meter"),":")
    let $_ := dash-model:add-widget-to-dash(xs:unsignedLong($id),
        element widget {
            attribute id {xdmp:random(100000000000000)},
            element title { xdmp:get-request-field("color")},
            element type {xdmp:get-request-field("type")},
            element resource {$m[1]},
            element meter {$m[2]}
        }
     )
     return xdmp:redirect-response("/builder/" || $id  )
};



(:~ view:handle-configure() - sets current dash to edit
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:produces('text/html')
  %rxq:path('/builder/(.*)$')
function view:handle-configure(
  $id
)
{
    view:builder(xs:unsignedLong($id))
};



(:~ view:handle-widget-delete() - remove widget from dash
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:produces('text/html')
  %rxq:path('/builder/widget/delete/(.*)/(.*)')
function view:handle-widget-delete(
  $id,
  $widget-id
)
{
    let $_ := dash-model:remove-widget-to-dash(xs:unsignedLong($id),
        xs:unsignedLong($widget-id))
    return xdmp:redirect-response("/builder/" || $id)
};


(:~ view:handle-delete() - remove dash
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:produces('text/html')
  %rxq:path('/builder/delete/(.*)$')
function view:handle-delete(
  $id
)
{
    let $_ := dash-model:remove(xs:unsignedLong($id))
    return xdmp:redirect-response("/builder")
};


(:~ view:handle-render() - render dashboard
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:produces('text/html')
  %rxq:path('/render/(.*)?')
function view:handle-render(
  $id
)
{
let $xslt := <xsl:transform
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:meter="http://marklogic.com/manage/meters"
    xmlns:model="https://github.com/dashML/model/dash"
    xmlns:xdmp="http://marklogic.com/xdmp"
    xmlns:math="http://marklogic.com/xdmp/math"
    xmlns:history-model ="https://github.com/dashML/model/history"
    exclude-result-prefixes="math xdmp xs meter"
    extension-element-prefixes="math xdmp history-model"
    version="2.0">
    <xsl:variable name="period"
      select="xdmp:get-request-field('period','raw')"/>
    <xdmp:import-module namespace="https://github.com/dashML/model/history"
    href="modules/history-model.xqy"/>
   <xsl:template match="model:dash">
     <div class="pure-g-r">
       <xsl:apply-templates select="model:widget"/>
     </div>
   </xsl:template>
   <xsl:template match="model:widget[model:type eq 'sparkline']">
     <xsl:variable name="data"
       select="history-model:get-metrics(model:resource/string(),
         model:meter/string(),$period)"/>
     <div title="{{$data//*:desc}}"
       class="pure-u-1-3 dashboard-piece dashboard-piece-{{
         if(model:resource eq 'servers') then 'gray'
         else if(model:resource eq 'hosts') then 'purple'
         else if(model:resource eq 'forests') then 'orange'
         else 'blue'}}bg" >
       <div class="dashboard-content" style="color:{{model:title/string(.)}}">
       <span class="resource"><a href="http://{{xdmp:host-name()}}:8002/manage/v2/{{model:resource}}"
         target="_resources" title="view {{model:resource}}"><xsl:value-of select="model:resource"/></a>[<xsl:value-of select="$data/*:summary/*:count/data(.)"/>]</span><br/>
       <span style="font-size: 2.0em;line-height: 1;"><xsl:value-of select="model:meter"/></span>
       <h2>
         <span class="inlinesparkline">
           <xsl:value-of select=" history-model:generate-sparkle-data($data)"/>
         </span>
       </h2>
       <p class="dashboard-metric">
           <xsl:value-of select="$data/*:summary/*:data/*:entry[last()]/*:value"/>
       <span class="units"><xsl:value-of select="$data/*:units"/></span>
       </p>
       <p class="maxminavg small">
       min: <xsl:value-of select="min($data/*:summary/*:data/*:entry/*:value)"/> |
       max: <xsl:value-of select="max($data/*:summary/*:data/*:entry/*:value)"/> <br/>
       avg: <xsl:value-of select="round-half-to-even(avg($data/*:summary/*:data/*:entry/*:value),2)"/> |
       mean: <xsl:value-of select="round-half-to-even(math:median($data/*:summary/*:data/*:entry/*:value),2)"/> <br/>
       stdev:  <xsl:value-of select="round-half-to-even(math:stddev($data/*:summary/*:data/*:entry/*:value),2)"/>
       </p>
      <span class="xml">[
       <a href="http://{{xdmp:host-name()}}:8002/manage/v2/{{model:resource}}?view=metrics&amp;{{replace(model:resource,'s$','')}}-metrics={{model:meter}}&amp;period={{$period}}&amp;format=xml" target="_xml">xml</a> |
       <a href="http://{{xdmp:host-name()}}:8002/manage/v2/{{model:resource}}?view=metrics&amp;{{replace(model:resource,'s$','')}}-metrics={{model:meter}}&amp;period={{$period}}&amp;format=html" target="_html">html</a> |
       <a href="http://{{xdmp:host-name()}}:8002/manage/v2/{{model:resource}}?view=metrics&amp;{{replace(model:resource,'s$','')}}-metrics={{model:meter}}&amp;period={{$period}}&amp;format=json" target="_json">json</a>
      ]</span>
       </div>
     </div>
   </xsl:template>
   <xsl:template match="model:widget[model:type eq 'log']">
     <xsl:variable name="data"
       select="history-model:get-metrics(model:resource/string(),
         model:meter/string(),$period)"/>
     <xsl:variable name="errors" select='history-model:get-error-log-data(
           "Error",
           model:meter,
           current-dateTime(),
           model:resource,$period)'/>
           
     <div title="{{$data//*:desc}}"
       class="pure-u-1-3 dashboard-piece dashboard-piece-{{
         if(model:resource eq 'servers') then 'gray'
         else if(model:resource eq 'hosts') then 'purple'
         else if(model:resource eq 'forests') then 'orange'
         else 'blue'}}bg">
       <div class="dashboard-content">
       <span class="resource"><a href="http://{{xdmp:host-name()}}:8002/manage/v2/{{model:resources}}"
         target="_resources"><xsl:value-of select="model:resource"/></a>[<xsl:value-of select="$data/*:summary/*:count/data(.)"/>]</span><br/>
       <span class="{{if($errors) then 'red' else ()}}" style="font-size: 2.0em;line-height: 1;"><xsl:value-of select="model:meter"/></span>
       <p class="dashboard-metric-log">
         ><xsl:value-of select="$data/*:summary/*:data/*:entry[last()]/*:value"/>
       <span class="units"><xsl:value-of select="$data/*:units"/></span>
       </p>
       log level: <i><xsl:value-of select="$errors[1]/*:loglevel"/></i>
       <div class="pure-u log-display">
       <table class="pure-table pure-table-striped log-table">
       <thead>
       <tr>
       <th>ts</th>
       <th><xsl:value-of select="model:resource"/></th>
       <th>value</th>
       </tr>
       </thead>
       <tbody>
       <xsl:for-each select="$errors">
        <tr title="{{*:message}}">
          <td style="font-size:.8em"><xsl:value-of select="*:ts"/></td>
          <td><xsl:value-of select="*:name"/></td>
          <td><xsl:value-of select="*:value"/></td>
        </tr>
       </xsl:for-each>
       </tbody>
       </table>
       </div>
       <br/>
      <span class="xml">[
       <a href="/log/reload" target="_test">generate test errors &amp; reload ErrorLog triples</a>
      ]</span>
       </div>
     </div>
   </xsl:template>
  <xsl:template match="text()"/>
</xsl:transform>

let $xml  := dash-model:get(xs:unsignedLong($id))
let $result := xdmp:xslt-eval($xslt,$xml)
return
('<!DOCTYPE html>',
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>dashML</title>
<meta name="description" content=""/>
<meta name="viewport" content="width=device-width"/>
<link rel="stylesheet"
  href="/resources/css/pure-min.css"></link>
<link rel="stylesheet"
  href="http://weloveiconfonts.com/api/?family=fontawesome"></link>
<link rel="stylesheet" href="/resources/css/main.css"></link>
<link rel="stylesheet" href="/resources/css/custom.css"></link>
<script src="/resources/js/vendor/jquery-1.9.1.min.js">&#160;</script>
<script src="/resources/js/vendor/modernizr-2.6.2.min.js">>&#160;</script>
<script type="text/javascript" language="javascript" src="/resources/sparkle/sparkle.js">&#160;</script>
<script type="text/javascript">
  $(function() {{
      $('.inlinesparkline').sparkline('html',{{
          type:'line',
          height:80,
          width:200,
          lineColor:'#000',
          fillColor:'#ccc'
      }});
  }})
</script>
</head>
<body>
  <header>
    <nav class="pure-menu pure-menu-open pure-menu-horizontal pure-menu-blackbg">
      <ul>
        {for $d in dash-model:all()/*
        order by $d/dash-model:title/data()
        return
        <li class="{if($d/@id/string(.) eq $id) then 'pure-menu-selected' else ()}"><a href="/render/{$d/@id}" >{$d/dash-model:title/data(.)}</a></li>
        }
      </ul>
      <span class="make-live"> Live <input id="makelive" type="checkbox" title="refresh every 30 seconds"/> <!-- refresh (secs) <input id="refresh" size="2" type="text" value="10"/--></span>      <span style="padding-right:10px;float:right;"><select id="period">
      {if(xdmp:get-request-field('period')) then
      if(xdmp:get-request-field('period') eq 'hour')
          then <option value="hour">last 24 hours</option>
          else if(xdmp:get-request-field('period') eq 'day')
          then <option value="day">last 30 days</option>
          else <option value="raw">last 60 minutes</option>
      else ()}
      <optgroup label="----------"></optgroup>
      <option value="raw">last 60 minutes</option>
      <option value="hour">last 24 hours</option>
      <option value="day">last 30 days</option>
      </select>
      </span>
    </nav>
  </header>
  <section class="dashboard pure-g-r clearfix">
    {$result}
  </section>
  <footer>
  &copy; 2013 <a href="https://github.com/xquery/dashML">Jim Fuller</a>
  <span style="float:right;">last updated: {current-dateTime()}</span>
  </footer>
  
  <script src="/resources/js/plugins.js">&#160;</script>
  <script src="/resources/js/main.js">&#160;</script>
</body>
</html>
)
};


(:~ view:reload-error-triples() - converts ErrorLog into triples and loads into triple store
:
: @param id
:
: @return html
:)
declare
  %rxq:GET
  %rxq:path('/log/reload')
function view:reload-error-triples(
    $id
)
{
let $_ := history-model:generate-test-error()
let $_ := history-model:remove-error-log-triples()
let $_ := history-model:load-error-triples()
return 'OK'
};



(:~ TODO - PROVIDE METERS API FOR USE WHEN DASHBOARD WIDGETS CONSUME JSON :)

(:~ view:get-database() -
:
: @param meter
: @param period
: @param start
:
: @return xml
:)
declare
  %rxq:GET
  %rxq:path('/history/databases/(.*)/(.*)(/?)')
  %rxq:produces('application/xml')
function view:get-databases(
  $meter,
  $period,
  $start
)
{
let $result := history-model:get-database(
  $meter,$period,
  (),fn:current-dateTime(),
  "sum","xml",true(),false(),
  ())
return $result[1]/*
};

(:~ view:get-forest() -
:
: @param meter
: @param period
: @param start
:
: @return xml
:)
declare
  %rxq:GET
  %rxq:path('/history/forests/(.*)/(.*)(/?)')
  %rxq:produces('application/xml')
function view:get-forests(
  $meter,
  $period,
  $start
)
{
let $result := history-model:get-forest(
  $meter,$period,
  (),fn:current-dateTime(),
  "sum","xml",true(),false(),
  ())
return $result
};


(:~ view:get-server() -
:
: @param meter
: @param period
: @param start
:
: @return xml
:)
declare
  %rxq:GET
  %rxq:path('/history/servers/(.*)/(.*)(/?)')
  %rxq:produces('application/xml')
function view:get-servers(
  $meter,
  $period,
  $start
)
{
let $result := history-model:get-server(
  $meter,$period,
  (),fn:current-dateTime(),
  "sum","xml",true(),false(),
  ())
return $result
};



(:~ view:get-host() -
:
: @param meter
: @param period
: @param start
:
: @return xml
:)
declare
  %rxq:GET
  %rxq:path('/history/hosts/(.*)/(.*)(/?)')
  %rxq:produces('application/xml')
function view:get-hosts(
  $meter,
  $period,
  $start
)
{
let $result := history-model:get-host(
  $meter,$period,
  (),fn:current-dateTime(),
  "sum","xml",true(),false(),
  ())
return $result
};