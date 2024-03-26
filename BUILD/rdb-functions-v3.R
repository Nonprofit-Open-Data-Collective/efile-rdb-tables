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
