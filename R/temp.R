library( irs990efile )
library( dplyr )

find_group_names_v2 <- function( table.name )
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

find_group_names_v2( table.name="F9-P07-T01-COMPENSATION" )




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






get_table_v2 <- function( doc, group.names, table.name )
{

  data( concordance )

  TABLE <- dplyr::filter( concordance, rdb_table == table.name )
  original.xpaths <- TABLE$xpath %>% as.character()
  all.groups <- paste0( group.names, collapse="|" )
  # print(all.groups)

  nd <- xml2::xml_find_all( doc, all.groups )
  
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
    xmltools::xml_dig_df( nd, dig = TRUE ) %>% 
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
          xmltools::xml_dig_df( nd, dig = TRUE ) %>% 
          bind_rows()

        temp.df <- temp.df %>% 
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



table.name <- "F9-P07-T01-COMPENSATION"
group.names <- find_group_names_v2( table.name )
demo.url <- "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201932329349300613_public.xml"
doc <- xml2::read_xml( demo.url )
xml2::xml_ns_strip( doc )

df.demo <- get_table_v2( doc, group.names, table.name )

v.map <- get_var_map( table.name=table.name )
df.demo2 <- re_name( df.demo, v.map )

df.demo2 %>% as.data.frame()



file("test.xml")

doc <- xml2::read_xml( file(url) )

build_rdb_table_v2 <- function( url, table.name )
{

  doc <- NULL
  try( doc <- xml2::read_xml( file(url) ), silent=T ) 
  if( is.null(doc) )
  { 
    # if( ! file.exists("FAIL-LOG.txt") )
    # { file.create("FAIL-LOG.txt") }
    cat( paste0( url, "\n" ), sep="", file="FAIL-LOG.txt", append=TRUE )
    return( NULL )
  }
  
  xml2::xml_ns_strip( doc )

  # all.xpaths <- doc %>% xmltools::xml_get_paths()
  # unique.xpaths <- all.xpaths %>% 
  #   unlist() %>% 
  #   unique()

  # if( ! file.exists("XPATH-LOG.txt") )
  # { file.create("XPATH-LOG.txt") }
  # cat( unique.xpaths, sep="\n", file="XPATH-LOG.txt", append=TRUE )

  # zz <- file( "XPATH-LOG.txt", open = "wt" )
  # sink( zz, split=T )
  # sink( zz, type = "message", append=TRUE )
  # sink( type="message" )
  # sink()      # close sink
  # close(zz)   # close connection
  # file.show( "BUILD-LOG.txt" )
  
  
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
  
  # print(find_group_names(table.name = table.name))
  group.names <- find_group_names( table.name=table.name )
  # print(group.names)

  all.groups <- paste0( group.names, collapse="|" )
  nd <- xml2::xml_find_all( doc, all.groups )

  unique.xpaths <- 
    nd %>% 
    xmltools::xml_get_paths() %>% 
    unlist() %>% 
    unique()

  cat( unique.xpaths, sep="\n", file="XPATH-LOG.txt", append=TRUE )


  df <- get_table_v2( doc, group.names, table.name  )
  
  if( is.null(df) ){ return( NULL ) }
  
  v.map <- get_var_map( table.name=table.name )
  df <- re_name( df, v.map )
  
  rdb.table <- data.frame( OBJECT_ID=OBJECTID, 
                           EIN=EIN, 
                           NAME=NAME, 
                           TAXYR=TAXYR, 
                           FORMTYPE=FORMTYPE, 
                           URL=URL, 
                           df, 
                           stringsAsFactors=F )
  return ( rdb.table )
  
}



build_rdb_table_v2( url=demo.url, table.name )





library( irs990efile )


# Create a sample: 

test.index <- dplyr::sample_n( tinyindex, 25 ) 
test.urls <- test.index$URL 


# [1] "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201932329349300613_public.xml"
# [2] "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/202031369349300738_public.xml"
# [3] "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201530289349300703_public.xml"
# [4] "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/202032179349200603_public.xml"
# [5] "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201531679349200223_public.xml"
# [6] "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201132169349100218_public.xml"


test.urls <- 
c("https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201932329349300613_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/202031369349300738_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201530289349300703_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/202032179349200603_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201531679349200223_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201943199349304224_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201842959349200509_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201642869349200629_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201202239349201015_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201413189349201536_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201443219349311314_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201632229349300983_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201543159349302049_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201642009349301064_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201723539349301107_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201812219349200341_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201721309349301237_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201221719349300447_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201413499349301266_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201903169349202410_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201203199349304605_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201101319349300145_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201530289349200208_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201612249349302251_public.xml", 
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201320079349200437_public.xml",
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/xxx201203199349304605_public.xml",
"https://nccs-efile.s3.us-east-1.amazonaws.com/xml/xxx201903169349202410_public.xml"
)



# view all xpaths in the table 
concordance$xpath[ concordance$rdb_table == "F9-P07-T01-COMPENSATION" ]

concordance[ concordance$rdb_table == "F9-P07-T01-COMPENSATION", c("xpath","variable_name") ] 



# check possible parent nodes 
find_group_names( table.name="F9-P07-T01-COMPENSATION" )


# map to standardize variable names across table versions 
get_var_map( table.name="F9-P07-T01-COMPENSATION" )


table.name <- "F9-P07-T01-COMPENSATION"



start.build.time <- Sys.time()

results.list <- list()
file.create("XPATH-LOG.txt") # reset xpath log
# file.show("XPATH-LOG.txt")
file.create("FAIL-LOG.txt")


for( i in 1:length( test.urls ) )
{
  url <- test.urls[i]
  results.list[[i]] <- build_rdb_table_v2( url, table.name )
}

end.build.time <- Sys.time()
end.build.time - start.build.time


df <- dplyr::bind_rows( results.list )




write.csv( df, paste0( table.name, ".csv"), row.names=F )



x <- readLines( "XPATH-LOG.txt" ) %>% unique() %>% sort()
x2 <- concordance$xpath[ concordance$rdb_table == "F9-P07-T01-COMPENSATION" ]
setdiff( x, x2 )





