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

-----------------------------------------------------------------------------
                       xpath                              variable_name      
--------------------------------------------------- -------------------------
      /Return/ReturnHeader/Filer/NameControl           F9_00_NAME_ORG_CTRL   

 /Return/ReturnHeader/Filer/BusinessNameControlTxt     F9_00_NAME_ORG_CTRL   

           /Return/ReturnHeader/BuildTS              F9_00_BUILD_TIME_STAMP  

          /Return/ReturnHeader/Timestamp             F9_00_RETURN_TIME_STAMP 

           /Return/ReturnHeader/ReturnTs             F9_00_RETURN_TIME_STAMP 

          /Return/ReturnHeader/ReturnType               F9_00_RETURN_TYPE    
-----------------------------------------------------------------------------

Table: Table continues below

 
---------------------------------------------------------------------------
         description           location_code_xsd    location_code_family   
----------------------------- ------------------- -------------------------
 Name of Filing Organization                       F990-PC-PART-00-LINE-00 
       (Control Text)                                                      

 Name of Filing Organization                       F990-PC-PART-00-LINE-00 
       (Control Text)                                                      

   Build time stamp - IRS                          F990-PC-PART-00-LINE-00 
       internal field                                                      

 The date and time when the                        F990-PC-PART-00-LINE-00 
     return was created                                                    

 The date and time when the                        F990-PC-PART-00-LINE-00 
     return was created                                                    

         Return type                               F990-PC-PART-00-LINE-00 
---------------------------------------------------------------------------

Table: Table continues below

 
---------------------------------------------------------------------------
      location_code        form   form_type   form_part   form_line_number 
------------------------- ------ ----------- ----------- ------------------
 F990-PC-PART-00-LINE-00   F990      PC        PART-00        Line 00      

 F990-PC-PART-00-LINE-00   F990      PC        PART-00        Line 00      

 F990-PC-PART-00-LINE-00   F990      PC        PART-00        Line 00      

 F990-PC-PART-00-LINE-00   F990      PC        PART-00        Line 00      

 F990-PC-PART-00-LINE-00   F990      PC        PART-00        Line 00      

 F990-PC-PART-00-LINE-00   F990      PC        PART-00        Line 00      
---------------------------------------------------------------------------

Table: Table continues below

 
--------------------------------------------------------------------------------
 variable_scope        data_type_xsd        data_type_simple   rdb_relationship 
---------------- ------------------------- ------------------ ------------------
       HD         BusinessNameControlType         text               ONE        

       HD         BusinessNameControlType         text               ONE        

       HD                                         date               ONE        

       HD              TimestampType              date               ONE        

       HD              TimestampType              date               ONE        

       HD               StringType                text               ONE        
--------------------------------------------------------------------------------

Table: Table continues below

 
------------------------------
     rdb_table       required 
------------------- ----------
 F9-P00-T00-HEADER    FALSE   

 F9-P00-T00-HEADER    FALSE   

 F9-P00-T00-HEADER      NA    

 F9-P00-T00-HEADER      NA    

 F9-P00-T00-HEADER      NA    

 F9-P00-T00-HEADER      NA    
------------------------------

Table: Table continues below

 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                                  versions                                                                                  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 2009v1.0;2009v1.1;2009v1.2;2009v1.3;2009v1.4;2009v1.7;2010v3.2;2010v3.4;2010v3.6;2010v3.7;2011v1.2;2011v1.3;2011v1.4;2011v1.5;2012v2.0;2012v2.1;2012v2.2;2012v2.3;2012v3.0 

                                              2013v3.0;2013v3.1;2013v4.0;2014v5.0;2014v6.0;2015v2.0;2015v2.1;2015v3.0;2016v3.0                                              

                                                                                                                                                                            

 2009v1.0;2009v1.1;2009v1.2;2009v1.3;2009v1.4;2009v1.7;2010v3.2;2010v3.4;2010v3.6;2010v3.7;2011v1.2;2011v1.3;2011v1.4;2011v1.5;2012v2.0;2012v2.1;2012v2.2;2012v2.3;2012v3.0 

                                              2013v3.0;2013v3.1;2013v4.0;2014v5.0;2014v6.0;2015v2.0;2015v2.1;2015v3.0;2016v3.0                                              

 2009v1.0;2009v1.1;2009v1.2;2009v1.3;2009v1.4;2009v1.7;2010v3.2;2010v3.4;2010v3.6;2010v3.7;2011v1.2;2011v1.3;2011v1.4;2011v1.5;2012v2.0;2012v2.1;2012v2.2;2012v2.3;2012v3.0 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Table: Table continues below

 
-----------------------------------------------------------------------------
 latest_version   duplicated   current_version   production_rule   validated 
---------------- ------------ ----------------- ----------------- -----------
      2012          FALSE           TRUE               NA             NA     

      2016          FALSE           TRUE               NA             NA     

       NA             NA             NA                NA             NA     

      2012          FALSE           TRUE               NA             NA     

      2016          FALSE           TRUE               NA             NA     

      2012          FALSE           TRUE               NA             NA     
-----------------------------------------------------------------------------


The full data dictionary for all tables in the efile database: 

[DATA DICTIONARY](https://nonprofit-open-data-collective.github.io/irs990efile/data-dictionary/data-dictionary.html)

More information about the **concordance file** that documents the crosswalks needed to convert XML files into a traditional rectangular database. 

https://github.com/Nonprofit-Open-Data-Collective/irs990efile/tree/main/data-raw/concordance



-------

## All One-to-Many Tables

