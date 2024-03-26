#' @title build_rdb_table_v2 
#'
#' @description rdb build function equipped to handle tables with sub-grouping
#' it is generalized so it still works on previously working tables
#'
#' @export
build_rdb_table_v3 <- function( table.name, doc=NULL, url=NULL, table.headers=NULL )
{

  # load the XML document

  if( is.null(doc) )
  {  
    try( doc <- xml2::read_xml( file(url) ), silent=T ) 
    if( is.null(doc) )
    { 
      cat( paste0( url, "\n" ), sep="", file="FAIL-LOG.txt", append=TRUE )
      return( NULL )
    }
    
    xml2::xml_ns_strip( doc )
  }
  
  
  
  ####----------------------------------------------------
  ####     KEYS
  ####----------------------------------------------------
  
  
  ## OBJECT ID
  
  OBJECTID <- get_object_id( url )
  
  
  
  ## URL
  
  URL <- url
  
  
  
  ## EIN
  
  EIN  <- xml2::xml_text( xml2::xml_find_all( doc, "//Return/ReturnHeader/Filer/EIN" ) )
  
  
  
  ## NAME
  
  V_990NAMEpost2014 <- "//Return/ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"
  V_990NAME_2013 <- "//Return/ReturnHeader/Filer/BusinessName/BusinessNameLine1"
  V_990NAMEpre2013  <- "//Return/ReturnHeader/Filer/Name/BusinessNameLine1"
  name.xpath <- paste( V_990NAME_2013, V_990NAMEpre2013, V_990NAMEpost2014, sep="|" )
  NAME <- xml2::xml_text( xml2::xml_find_all( doc, name.xpath ) )
  
  
  ## TYPE OF TAX FORM
  
  V_990TFpost2013 <- "//Return/ReturnHeader/ReturnTypeCd"
  V_990TFpre2013  <- "//Return/ReturnHeader/ReturnType"
  tax.form.xpath <- paste( V_990TFpost2013, V_990TFpre2013, sep="|" )
  FORMTYPE <- xml2::xml_text( xml2::xml_find_all( doc, tax.form.xpath ) )
  
  
  ## TAX YEAR
  
  V_990FYRpost2013 <- "//Return/ReturnHeader/TaxYr"
  V_990FYRpre2013  <- "//Return/ReturnHeader/TaxYear"
  fiscal.year.xpath <- paste( V_990FYRpost2013, V_990FYRpre2013, sep="|" )
  TAXYR <- xml2::xml_text( xml2::xml_find_all( doc, fiscal.year.xpath ) )
  
  


  ####  BUILD TABLE 
  
  # if( is.null(table.headers) )
  # { table.headers <- find_table_headers( table.name=table.name ) }
  
  df <- get_table_v2( doc, table.name, table.headers  )
  
  if( is.null(df) ){ return( NULL ) }
  
  v.map <- get_var_map( table.name=table.name )
  df <- re_name( df, v.map )
  
  rdb.table <- 
    data.frame( OBJECT_ID=OBJECTID, 
                EIN=EIN, 
                NAME=NAME, 
                TAXYR=TAXYR, 
                FORMTYPE=FORMTYPE, 
                URL=URL, 
                df )  # keys are recycled
                
  return ( rdb.table )
  
}

