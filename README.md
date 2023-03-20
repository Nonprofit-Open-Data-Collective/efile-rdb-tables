# efile-rdb-tables

Documentation of the one-to-many tables in the efile database.



## Install the efile package **irs990efile**: 

```r
devtools::install_github( 'ultinomics/xmltools' )
devtools::install_github( 'nonprofit-open-data-collective/irs990efile' )
```

## Concordance Files

The **concordance** file contains the documentation on all of the XML xpaths that are defined in 990 efile schemas and the crosswalk to the set of unique fields included on Form 990. This includes a mapping of fields between Form 990 and Form 990-EZ onto the set of fields shared by both forms. 

```r
library( irs990efile )
head( concordance )
```

```
                                              xpath           variable_name
1            /Return/ReturnHeader/Filer/NameControl     F9_00_NAME_ORG_CTRL
2 /Return/ReturnHeader/Filer/BusinessNameControlTxt     F9_00_NAME_ORG_CTRL
3                      /Return/ReturnHeader/BuildTS  F9_00_BUILD_TIME_STAMP
4                    /Return/ReturnHeader/Timestamp F9_00_RETURN_TIME_STAMP
5                     /Return/ReturnHeader/ReturnTs F9_00_RETURN_TIME_STAMP
6                   /Return/ReturnHeader/ReturnType       F9_00_RETURN_TYPE
                                    description location_code_xsd
1    Name of Filing Organization (Control Text)                  
2    Name of Filing Organization (Control Text)                  
3         Build time stamp - IRS internal field                  
4 The date and time when the return was created                  
5 The date and time when the return was created                  
6                                   Return type                  
     location_code_family           location_code form form_type form_part
1 F990-PC-PART-00-LINE-00 F990-PC-PART-00-LINE-00 F990        PC   PART-00
2 F990-PC-PART-00-LINE-00 F990-PC-PART-00-LINE-00 F990        PC   PART-00
3 F990-PC-PART-00-LINE-00 F990-PC-PART-00-LINE-00 F990        PC   PART-00
4 F990-PC-PART-00-LINE-00 F990-PC-PART-00-LINE-00 F990        PC   PART-00
5 F990-PC-PART-00-LINE-00 F990-PC-PART-00-LINE-00 F990        PC   PART-00
6 F990-PC-PART-00-LINE-00 F990-PC-PART-00-LINE-00 F990        PC   PART-00
  form_line_number variable_scope           data_type_xsd data_type_simple
1          Line 00             HD BusinessNameControlType             text
2          Line 00             HD BusinessNameControlType             text
3          Line 00             HD                                     date
4          Line 00             HD           TimestampType             date
5          Line 00             HD           TimestampType             date
6          Line 00             HD              StringType             text
  rdb_relationship         rdb_table required
1              ONE F9-P00-T00-HEADER    FALSE
2              ONE F9-P00-T00-HEADER    FALSE
3              ONE F9-P00-T00-HEADER       NA
4              ONE F9-P00-T00-HEADER       NA
5              ONE F9-P00-T00-HEADER       NA
6              ONE F9-P00-T00-HEADER       NA
                                                                                                                                                                    versions
1 2009v1.0;2009v1.1;2009v1.2;2009v1.3;2009v1.4;2009v1.7;2010v3.2;2010v3.4;2010v3.6;2010v3.7;2011v1.2;2011v1.3;2011v1.4;2011v1.5;2012v2.0;2012v2.1;2012v2.2;2012v2.3;2012v3.0
2                                                                                           2013v3.0;2013v3.1;2013v4.0;2014v5.0;2014v6.0;2015v2.0;2015v2.1;2015v3.0;2016v3.0
3                                                                                                                                                                           
4 2009v1.0;2009v1.1;2009v1.2;2009v1.3;2009v1.4;2009v1.7;2010v3.2;2010v3.4;2010v3.6;2010v3.7;2011v1.2;2011v1.3;2011v1.4;2011v1.5;2012v2.0;2012v2.1;2012v2.2;2012v2.3;2012v3.0
5                                                                                           2013v3.0;2013v3.1;2013v4.0;2014v5.0;2014v6.0;2015v2.0;2015v2.1;2015v3.0;2016v3.0
6 2009v1.0;2009v1.1;2009v1.2;2009v1.3;2009v1.4;2009v1.7;2010v3.2;2010v3.4;2010v3.6;2010v3.7;2011v1.2;2011v1.3;2011v1.4;2011v1.5;2012v2.0;2012v2.1;2012v2.2;2012v2.3;2012v3.0
  latest_version duplicated current_version production_rule validated
1           2012      FALSE            TRUE            <NA>      <NA>
2           2016      FALSE            TRUE            <NA>      <NA>
3             NA         NA              NA            <NA>      <NA>
4           2012      FALSE            TRUE            <NA>      <NA>
5           2016      FALSE            TRUE            <NA>      <NA>
6           2012      FALSE            TRUE            <NA>      <NA>
```


The full data dictionary for all tables in the efile database: 

[DATA DICTIONARY](https://nonprofit-open-data-collective.github.io/irs990efile/data-dictionary/data-dictionary.html)

More information about the **concordance file** that documents the crosswalks needed to convert XML files into a traditional rectangular database. 

https://github.com/Nonprofit-Open-Data-Collective/irs990efile/tree/main/data-raw/concordance



-------

## All One-to-Many Tables

