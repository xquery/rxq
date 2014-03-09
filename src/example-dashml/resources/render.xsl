<xsl:transform
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

    <xsl:variable name="period" select="xdmp:get-request-field('period','raw')"/>
    
<xdmp:import-module namespace="https://github.com/dashML/model/history"
                    href="modules/history-model.xqy"/>

   <xsl:template match="model:dash">
     <div class="pure-g-r">
       <xsl:apply-templates select="model:widget"/>
     </div>
   </xsl:template>

   <xsl:template match="model:widget[model:type eq 'sparkline']">
     <xsl:variable name="data" select="
     if(model:resource eq 'databases')
         then
         history-model:get-database(
  model:meter/string(),$period,
  (),current-dateTime(),
  'sum','xml',true(),false(),
  ())[1]/*
  else if (model:resource eq 'hosts') then
      history-model:get-host(
  model:meter/string(),$period,
  (),current-dateTime(),
  'sum','xml',true(),false(),
  ())
  else if (model:resource eq 'servers') then
      history-model:get-server(
  model:meter/string(),$period,
  (),current-dateTime(),
  'sum','xml',true(),false(),
  ())
  else
      history-model:get-forest(
  model:meter/string(),$period,
  (),current-dateTime(),
  'sum','xml',true(),false(),
  ())
     "/>
     <div  title="{$data//*:desc}" class="pure-u-1-3 dashboard-piece dashboard-piece-{if(model:resource eq 'servers') then 'blue'
     else if(model:resource eq 'hosts') then 'purple'
     else if(model:resource eq 'forests') then 'orange' 
     else 'red'}bg">
       <div class="dashboard-content">
       <span style="float:right;font-size:80%;margin:0px;padding-right:4px;color:#eee"><a href="http://localhost:8002/manage/v2/{model:resources}" target="_resources"><xsl:value-of select="model:resource"/></a>[<xsl:value-of select="$data/*:summary/*:count/data(.)"/>]</span><br/>
       <span style="font-size: 2.0em;line-height: 1;"><xsl:value-of select="model:meter"/></span>
       <h2>
             <span class="inlinesparkline">
             <xsl:value-of select="string-join($data/*:summary/*:data/*:entry/*:value,',')"/>
             </span>
       </h2>
       <p class="dashboard-metric"><xsl:value-of select="$data/*:summary/*:data/*:entry[last()]/*:value"/>
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
       <a href="http://localhost:8002/manage/v2/{model:resource}?view=metrics&amp;{replace(model:resource,'s$','')}-metrics={model:meter}&amp;period={$period}&amp;format=xml" target="_xml">xml</a> |
       <a href="http://localhost:8002/manage/v2/{model:resource}?view=metrics&amp;{replace(model:resource,'s$','')}-metrics={model:meter}&amp;period={$period}&amp;format=html" target="_html">html</a> |
       <a href="http://localhost:8002/manage/v2/{model:resource}?view=metrics&amp;{replace(model:resource,'s$','')}-metrics={model:meter}&amp;period={$period}&amp;format=json" target="_json">json</a>
      ]</span>
       </div>
       
     </div>
            
   </xsl:template>

   <xsl:template match="model:widget[model:type eq 'meter']">
       <div class="pure-u-1-4">
       display meter widget<br/>
       <a href="/history/{model:resource}/{model:meter}/raw">link</a>
       meter:<xsl:value-of select="model:resource"/>:<xsl:value-of select="model:meter"/>
       </div>
   </xsl:template>

   <xsl:template match="model:widget[model:type eq 'timeseries']">
     <div class="pure-u-1-4">
     display timeseries widget<br/>
       <a href="/history/{model:resource}/{model:meter}/raw">xml</a>
       meter:<xsl:value-of select="model:resource"/>:<xsl:value-of select="model:meter"/>
     </div>
   </xsl:template>

  <xsl:template match="text()"/>

</xsl:transform>
