# library module: com.blakeley.cprof


## Table of Contents

* Variables: [$p:report-xsl](#var_p_report-xsl), [$STACK](#var_STACK), [$IS-DISABLED](#var_IS-DISABLED)
* Functions: [p:push\#1](#func_p_push_1), [p:reports-merge\#1](#func_p_reports-merge_1), [p:enabled\#0](#func_p_enabled_0), [p:enable\#0](#func_p_enable_0), [p:disable\#0](#func_p_disable_0), [p:eval\#3](#func_p_eval_3), [p:eval\#2](#func_p_eval_2), [p:eval\#1](#func_p_eval_1), [p:invoke\#3](#func_p_invoke_3), [p:invoke\#2](#func_p_invoke_2), [p:invoke\#1](#func_p_invoke_1), [p:value\#1](#func_p_value_1), [p:reset\#0](#func_p_reset_0), [p:report\#1](#func_p_report_1), [p:report\#0](#func_p_report_0), [p:xslt-eval\#4](#func_p_xslt-eval_4), [p:xslt-eval\#3](#func_p_xslt-eval_3), [p:xslt-eval\#2](#func_p_xslt-eval_2), [p:xslt-invoke\#4](#func_p_xslt-invoke_4), [p:xslt-invoke\#3](#func_p_xslt-invoke_3), [p:xslt-invoke\#2](#func_p_xslt-invoke_2)


## Variables

### <a name="var_p_report-xsl"/> $p:report-xsl
```xquery
$p:report-xsl as 
```

### <a name="var_STACK"/> $STACK
```xquery
$STACK as  element(prof:report)\*
```

### <a name="var_IS-DISABLED"/> $IS-DISABLED
```xquery
$IS-DISABLED as  xs:boolean
```



## Functions

### <a name="func_p_push_1"/> p:push\#1
```xquery
p:push(
  $list as item()+
) as  item()*
```

#### Params

* $list as  item()+


#### Returns
*  item()\*

### <a name="func_p_reports-merge_1"/> p:reports-merge\#1
```xquery
p:reports-merge(
  $parent as element(prof:report)
) as  element(prof:report)
```

#### Params

* $parent as  element(prof:report)


#### Returns
*  element(prof:report)

### <a name="func_p_enabled_0"/> p:enabled\#0
```xquery
p:enabled(
) as  xs:boolean
```

#### Returns
*  xs:boolean

### <a name="func_p_enable_0"/> p:enable\#0
```xquery
p:enable(
) as  empty-sequence()
```

#### Returns
*  empty-sequence()

### <a name="func_p_disable_0"/> p:disable\#0
```xquery
p:disable(
) as  empty-sequence()
```

#### Returns
*  empty-sequence()

### <a name="func_p_eval_3"/> p:eval\#3
```xquery
p:eval(
  $xquery as xs:string,
  $vars as item()*,
  $options as element(xe:options)?
) as  item()*
```

#### Params

* $xquery as  xs:string

* $vars as  item()\*

* $options as  element(xe:options)?


#### Returns
*  item()\*

### <a name="func_p_eval_2"/> p:eval\#2
```xquery
p:eval(
  $xquery as xs:string,
  $vars as item()*
) as  item()*
```

#### Params

* $xquery as  xs:string

* $vars as  item()\*


#### Returns
*  item()\*

### <a name="func_p_eval_1"/> p:eval\#1
```xquery
p:eval(
  $xquery as xs:string
) as  item()*
```

#### Params

* $xquery as  xs:string


#### Returns
*  item()\*

### <a name="func_p_invoke_3"/> p:invoke\#3
```xquery
p:invoke(
  $path as xs:string,
  $vars as item()*,
  $options as element(xe:options)?
) as  item()*
```

#### Params

* $path as  xs:string

* $vars as  item()\*

* $options as  element(xe:options)?


#### Returns
*  item()\*

### <a name="func_p_invoke_2"/> p:invoke\#2
```xquery
p:invoke(
  $path as xs:string,
  $vars as item()*
) as  item()*
```

#### Params

* $path as  xs:string

* $vars as  item()\*


#### Returns
*  item()\*

### <a name="func_p_invoke_1"/> p:invoke\#1
```xquery
p:invoke(
  $path as xs:string
) as  item()*
```

#### Params

* $path as  xs:string


#### Returns
*  item()\*

### <a name="func_p_value_1"/> p:value\#1
```xquery
p:value(
  $expr as xs:string
) as  item()*
```

#### Params

* $expr as  xs:string


#### Returns
*  item()\*

### <a name="func_p_reset_0"/> p:reset\#0
```xquery
p:reset(
) as  empty-sequence()
```

#### Returns
*  empty-sequence()

### <a name="func_p_report_1"/> p:report\#1
```xquery
p:report(
  $merge as xs:boolean
) as  element(prof:report)*
```

#### Params

* $merge as  xs:boolean


#### Returns
*  element(prof:report)\*

### <a name="func_p_report_0"/> p:report\#0
```xquery
p:report(
) as  element(prof:report)*
```

#### Returns
*  element(prof:report)\*

### <a name="func_p_xslt-eval_4"/> p:xslt-eval\#4
```xquery
p:xslt-eval(
  $stylesheet as element(),
  $input as node()?,
  $params as map:map?,
  $options as element(xe:options)?
) as  item()*
```

#### Params

* $stylesheet as  element()

* $input as  node()?

* $params as  map:map?

* $options as  element(xe:options)?


#### Returns
*  item()\*

### <a name="func_p_xslt-eval_3"/> p:xslt-eval\#3
```xquery
p:xslt-eval(
  $stylesheet as element(),
  $input as node()?,
  $params as map:map
) as  item()*
```

#### Params

* $stylesheet as  element()

* $input as  node()?

* $params as  map:map


#### Returns
*  item()\*

### <a name="func_p_xslt-eval_2"/> p:xslt-eval\#2
```xquery
p:xslt-eval(
  $stylesheet as element(),
  $input as node()?
) as  item()*
```

#### Params

* $stylesheet as  element()

* $input as  node()?


#### Returns
*  item()\*

### <a name="func_p_xslt-invoke_4"/> p:xslt-invoke\#4
```xquery
p:xslt-invoke(
  $path as xs:string,
  $input as node()?,
  $params as map:map?,
  $options as element(xe:options)?
) as  item()*
```

#### Params

* $path as  xs:string

* $input as  node()?

* $params as  map:map?

* $options as  element(xe:options)?


#### Returns
*  item()\*

### <a name="func_p_xslt-invoke_3"/> p:xslt-invoke\#3
```xquery
p:xslt-invoke(
  $path as xs:string,
  $input as node()?,
  $params as map:map
) as  item()*
```

#### Params

* $path as  xs:string

* $input as  node()?

* $params as  map:map


#### Returns
*  item()\*

### <a name="func_p_xslt-invoke_2"/> p:xslt-invoke\#2
```xquery
p:xslt-invoke(
  $path as xs:string,
  $input as node()?
) as  item()*
```

#### Params

* $path as  xs:string

* $input as  node()?


#### Returns
*  item()\*





*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
