# GENERAL TABLE BUILDING FOR NON SIMPLISTIC TABLE STRUCTURE

# library( dplyr )

###---------------------------------------------------
###   RELATIONAL DATABASE FUNCTIONS (first new/improved, then old)
###---------------------------------------------------

# "group" here means the root xpath that defines
# a collection of variables on a one-to-many table


###---------------------------------------------------

#' @title find_group_names_2 (improved from rdb-functions-v2)
#'
#' @description identifies all possible roots/xpaths from a table name
#'
#' @export
find_table_headers <- function( table.name )
{
  # data(concordance)
  TABLE <- dplyr::filter( concordance, rdb_table == table.name )
  xpaths <- TABLE$xpath %>% as.character()
  xpaths <- gsub( "IRS990EZ", "IRS990", xpaths )
  nodes <- strsplit( xpaths, "/" )
  d1 <- suppressWarnings( data.frame( do.call( cbind, nodes ), stringsAsFactors=F ) )
  not.equal <- apply( d1, MARGIN=1, FUN=function(x){ length( unique( x )) > 1 } ) 
  this.one <- which( not.equal == T )[ 1 ]
  group.names <- d1[ this.one,  ] %>% as.character() %>% unique()
  group.names <- paste0( group.names, "/")
  # print("OLD")
  # print(group.names)
  # if(table.name == "F9-P03-T01-PROGRAMS"){
  #   group.names <- head(group.names,-5)
  # }
  updated.group.names <- collapse_nodes(group.names)
  # print("UDPATED")
  # print(updated.group.names)
  return( updated.group.names )
}



###---------------------------------------------------

#' @title collapse_nodes (new)
#'
#' @description helper function:
#' takes in a list of possible roots and finds sub-roots if existing
#' i.e. collapses possible subparenting/subgrouping structure in xml files
#' 
#'
#' @export
collapse_nodes <- function( lc.xpaths )
{
  data(concordance)
  comb.names <- c()
  for( i in 1:length( lc.xpaths )){
    lc.xpath <- lc.xpaths[i]
    TABLE <- dplyr::filter( concordance, grepl( lc.xpath, xpath ) )
    # print(TABLE)
    xpaths <- TABLE$xpath %>% as.character()
    xpaths <- gsub( "IRS990EZ", "IRS990", xpaths )
    nodes <- strsplit( xpaths, "/" )
    d1 <- suppressWarnings( data.frame( do.call( cbind, nodes ), stringsAsFactors=F ) )
    # print(d1)
    not.equal <- apply( d1, MARGIN=1, FUN=function(x){ length( unique( x )) > 1 } ) 
    # print(not.equal)
    this.one <- which( not.equal == T )[ 1 ]
    group.names <- d1[ this.one,  ] %>% as.character() %>% unique()
    group.names <- paste0( "//", lc.xpath, group.names )
    # if(table.name == "F9-P03-T01-PROGRAMS"){
    #   group.names <- head(group.names,-5)
    # }
    comb.names <- append(comb.names,group.names)
  }
  return( comb.names )
}


###---------------------------------------------------

#' @title get_table_2 (improved from rdb-functions-v2)
#'
#' @description collects the information out of the relevant xpath roots
#' including the subgrouped roots and data as well
#'
#' @export
get_table_v2 <- function( doc, table.name, table.headers )
{

  data( concordance )

  TABLE <- dplyr::filter( concordance, rdb_table == table.name )
  original.xpaths <- TABLE$xpath %>% as.character()
  all.table.versions <- paste0( table.headers, collapse="|" )
  # print(all.groups)

  nd <- xml2::xml_find_all( doc, all.table.versions )
  
  if( length( nd ) == 0 ){ return(NULL) }
  
  # ensure group names unique to table 
  # (doesn't really apply for get_table_2 shenanigans)
  # i.e. we don't really need to validate group names
  # valid <- validate_group_names( nd, table.name )
  
  valid <- TRUE
  
  # ensure we are using root node for table
  
  table.xpaths <- 
    xmltools::xml_get_paths( nd, 
                             only_terminal_parent = TRUE )
  table.xpaths <- 
    table.xpaths %>% 
    unlist() %>% 
    unique()
  
  #since we have them all, just capture the data from here?
  # print(table.xpaths)
  
  nodes <- strsplit( table.xpaths, "/" )
  length.one <- length( nodes[[1]] )

  tr <- 
    paste0( "//", nodes[[1]][ length.one-1 ], 
            "/",  nodes[[1]][ length.one   ] )

  nd <- xml2::xml_find_all( doc, tr )

  
  rdb.table <- 
    suppressMessages( xmltools::xml_dig_df( nd, dig = TRUE ) ) %>% 
    bind_rows()

  rdb.table <- 
    rdb.table %>% 
    dplyr::mutate_if( is.factor, as.character )

  if( length( table.xpaths ) > 1 )
  {
    for( i in 2:length(table.xpaths) )
    {
      l <- length( nodes[[i]] )

      table.root <- 
        paste0( "//", nodes[[i]][ l-1 ], 
                "/",  nodes[[i]][ l   ] )

      nd <- xml2::xml_find_all( doc, table.root )

      if( ! (length(nd) < nrow(rdb.table) ) )
      {
        #weirdness occurs when we have mixed formatting 
        #for example if we have address us and address foreign
    
        temp.df <- 
          suppressMessages( xmltools::xml_dig_df( nd, dig = TRUE ) ) %>% 
          bind_rows() %>% 
          dplyr::mutate_if( is.factor, as.character )

        rdb.table <- cbind( rdb.table, temp.df )

      } else{  # end if

               print( "WEIRD TABLE FORMATTING" )
               print( url ) 

             } # end else

    } # end for

  } # end if

  return( rdb.table )

}


#' @title get_table_xpaths
#'
#' @description Return a vector of all unique xpaths
#' located within the specific RDB table. 
#'
#' @export
get_table_xpaths <- function( url, table.name, table.headers )
{
  doc <- NULL
  try( doc <- xml2::read_xml( file(url) ), silent=T ) 
  if( is.null(doc) ){ return( NULL ) }
  xml2::xml_ns_strip( doc )
  
  if( is.null(table.headers) )
  { table.headers <- find_table_headers( table.name=table.name ) }
  all.headers <- paste0( table.headers, collapse="|" )
  nd <- xml2::xml_find_all( doc, all.headers )
  
  unique.xpaths <- 
    nd %>% 
    xmltools::xml_get_paths() %>% 
    unlist() %>% 
    unique()
  
  return( unique.xpaths )
}



###---------------------------------------------------

#' @title build_rdb_table_v2 
#'
#' @description rdb build function equipped to handle tables with sub-grouping
#' it is generalized so it still works on previously working tables
#'
#' @export
build_rdb_table_v2 <- function( url, table.name, table.headers=NULL )
{

  # load the XML document

  doc <- NULL
  
  try( doc <- xml2::read_xml( file(url) ), silent=T ) 
  if( is.null(doc) )
  { 
    cat( paste0( url, "\n" ), sep="", file="FAIL-LOG.txt", append=TRUE )
    return( NULL )
  }
  
  xml2::xml_ns_strip( doc )

  
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
  
  


  # catalog all xpaths used in 1:m tables to 
  # ensure data is not gathered from outside tables

  # all.groups <- paste0( group.names, collapse="|" )
  # nd <- xml2::xml_find_all( doc, all.groups )
  # 
  # unique.xpaths <- 
  #   nd %>% 
  #   xmltools::xml_get_paths() %>% 
  #   unlist() %>% 
  #   unique()
  # 
  # cat( unique.xpaths, 
  #     sep="\n", 
  #      file="XPATH-LOG.txt", 
  #      append=TRUE )


  ####  BUILD TABLE 
  
  # reminder to add find_table_headers and re_name
  # to get_table_v2 once they are working properly
  
  if( is.null(table.headers) )
  { table.headers <- find_table_headers( table.name=table.name ) }
  
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



# library(irs990efile)
# # library(dplyr)
# index <- tinyindex  # random sample of 10,000 cases
# index <- filter( index, FormType %in% c("990","990EZ") )
# 
# results2 <- list()
# 
# time1 <- Sys.time()
# for( i in 1:length(index$URL) )
# {
#   print(i)
#   try( results[[i]] <- build_rdb_table_adapted( index$URL[i], "F9-P07-T01-COMPENSATION" ))
# }
# time2 <- Sys.time()
# print(paste0("RUNTIME (in min's): ", difftime(time2,time1)))
# 
# df <- dplyr::bind_rows( results)
# 
# write.csv( df, paste0( "F9-P07-T01-COMPENSATION-2", ".csv"), row.names=F )