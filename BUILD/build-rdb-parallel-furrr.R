
table.name <- "F9-P03-T01-PROGRAMS"  

table.headers.02 <- 
 c("//IRS990/Activity2",
  "//Form990PartIII/Activity2",
  "//IRS990/ProgSrvcAccomActy2Grp",
  "//IRS990EZ/ProgSrvcAccomActy2Grp" )

table.headers.03 <- 
  c( "//IRS990/Activity3",
  "//Form990PartIII/Activity3",
  "//IRS990/ProgSrvcAccomActy3Grp",
  "//IRS990EZ/ProgSrvcAccomActy3Grp" )

table.headers.99 <- 
 c("//IRS990/ActivityOther",
  "//Form990PartIII/ActivityOther",
  "//IRS990/ProgSrvcAccomActyOtherGrp",
  "//IRS990/ProgramServiceAccomplishments",
  "//IRS990EZ/ProgSrvcAccomActyOtherGrp",
  "//IRS990EZ/ProgramServiceAccomplishment",
  "//IRS990EZ/ProgramSrvcAccomplishmentGrp" )



get_object_id <- function( url )
{
    object.id <- gsub("https://gt990datalake-rawdata.s3.amazonaws.com/EfileData/XmlFiles/", 
        "", url)
    object.id <- gsub("_public.xml", "", object.id)
    return(object.id)
}



f <- function( url ) {

  doc.i <- NULL
  try( doc.i <- xml2::read_xml( file(url) ), silent=T ) 
  if( is.null(doc.i) )
  { 
    object.id <- get_object_id( url )
    df <- data.frame( OBJECT_ID = object.id, URL=url )
    return( df ) 
  }

  xml2::xml_ns_strip( doc.i )

  activity.02 <- 
    build_rdb_table_v3( url=url, 
                        doc=doc.i,
                        table.name="F9-P03-T01-PROGRAMS", 
                        table.headers=table.headers.02 )
  activity.03 <- 
    build_rdb_table_v3( url=url, 
                        doc=doc.i,
                        table.name="F9-P03-T01-PROGRAMS", 
                        table.headers=table.headers.03 )
  activity.99 <- 
    build_rdb_table_v3( url=url, 
                        doc=doc.i,
                        table.name="F9-P03-T01-PROGRAMS", 
                        table.headers=table.headers.99 )

  df <- dplyr::bind_rows( activity.02, activity.03, activity.99 )

  p.names <- 
   c("OBJECT_ID", "EIN", "NAME", "TAXYR", "FORMTYPE", 
     "URL", "F9_03_PROG_DESC", "F9_03_PROG_CODE", "F9_03_PROG_GRANT", 
     "F9_03_PROG_EXP", "F9_03_PROG_REV" )

  df <- dplyr::select( dfm, any_of(p.names) )

  return( df )
}



get_year <- function( urls )
{
  future::plan( "future::multisession" )
  message( "Number of parallel workers: ", future::nbrOfWorkers() )

  start.build.time <- Sys.time()    # --------------------

  results <- furrr::future_map( urls, f )
  df.programs <- dplyr::bind_rows( results )

  end.build.time <- Sys.time() 
  end.build.time - start.build.time  # --------------------

  return( df.programs )

}

