# Example 1:M build script: 

# EXTRACT DOCUMENT ID FROM URL

get_object_id <- function( url ) {
    object.id <- gsub( "https://gt990datalake-rawdata.s3.amazonaws.com/EfileData/XmlFiles/",  "", url )
    object.id <- gsub( "_public.xml", "", object.id )
    return( object.id )
}

# Filter out any variables that don't belong in the table:
# 
# dc <- read.csv("https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/irs-efile-master-concordance-file/master/concordance.csv")
# TABLE.VARS:
# unique( dc$variable_name[ dc$rdb_table == "F9-P07-T02-CONTRACTORS" ] ) |> dput()




f <- function( url ) {

  TABLE.NAME <- "F9-P07-T02-CONTRACTORS"  

  TABLE.HEADERS <-   
    # c( "//IRS990/Activity2",
    #    "//Form990PartIII/Activity2",
    #    "//IRS990/ProgSrvcAccomActy2Grp",
    #    "//IRS990EZ/ProgSrvcAccomActy2Grp" )

  TABLE.VARS <-
    c( "F9_07_COMP_KONTR_ADDR_CITY", "F9_07_COMP_KONTR_ADDR_CNTR", 
       "F9_07_COMP_KONTR_ADDR_L1", "F9_07_COMP_KONTR_ADDR_L2", "F9_07_COMP_KONTR_ADDR_STATE", 
       "F9_07_COMP_KONTR_ADDR_ZIP", "F9_07_COMP_KONTR_COMP", "F9_07_COMP_KONTR_DESC_SVC", 
       "F9_07_COMP_KONTR_NAME_ORG_L1", "F9_07_COMP_KONTR_NAME_ORG_L2", 
       "F9_07_COMP_KONTR_NAME_PERS", "F9_07_COMP_KONTR_NONE")

  doc.i <- NULL
  try( doc.i <- xml2::read_xml( file(url) ), silent=T ) 
  if( is.null(doc.i) )
  { 
    object.id <- get_object_id( url )
    df <- data.frame( OBJECT_ID = object.id, URL=url )
    return( df ) 
  }

  xml2::xml_ns_strip( doc.i )

  one.to.many <- 
    build_rdb_table_v3( url=url, 
                        doc=doc.i,
                        table.name=TABLE.NAME, 
                        table.headers=TABLE.HEADERS )

  df <- dplyr::bind_rows( activity.02, activity.03, activity.99 )

  p.names <- 
   c("OBJECT_ID", "EIN", "NAME", "TAXYR", "FORMTYPE", 
     "URL", TABLE.VARS )

  df <- dplyr::select( df, any_of(p.names) )

  return( df )
}
