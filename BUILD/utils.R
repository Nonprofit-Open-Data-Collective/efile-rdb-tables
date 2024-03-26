# INCLUDES Return & ReturnData NODES
create_edgelist_v1 <- function( xpaths )
{
  # xpaths <- gsub("^/Return/ReturnData/", "", xpaths )
  xpaths <- gsub("^/", "", xpaths )
  nodes <- strsplit( xpaths, "/" )
  xpath.levels <- sapply( nodes, length )
  max.lev <- max( xpath.levels )
  nodes <- lapply( nodes, function(x){ c(x, rep("",max.lev-length(x) ) ) } )
  xpath.levels <- data.frame( do.call( cbind, nodes ), stringsAsFactors=F )
  
  df <- NULL
  
  for( i in 1:ncol(xpath.levels) )
  {
    for( j in 1:(max.lev-1) )
    {
      df <- rbind( df, xpath.levels[ j:(j+1), i ] )
    }
  }
  
  df <- as.data.frame(df, stringsAsFactors=F )
  df <- unique( df )
  df <- df[ ! grepl( "$^", df$V2 ) , ]
  
  return( df )
}

# DROPS Return & ReturnData NODES
create_edgelist_v2 <- function( xpaths )
{
  xpaths <- gsub("^/Return/ReturnData/", "", xpaths )
  # xpaths <- gsub("^/", "", xpaths )
  nodes <- strsplit( xpaths, "/" )
  xpath.levels <- sapply( nodes, length )
  max.lev <- max( xpath.levels )
  nodes <- lapply( nodes, function(x){ c(x, rep("",max.lev-length(x) ) ) } )
  xpath.levels <- data.frame( do.call( cbind, nodes ), stringsAsFactors=F )
  
  df <- NULL
  
  for( i in 1:ncol(xpath.levels) )
  {
    for( j in 1:(max.lev-1) )
    {
      df <- rbind( df, xpath.levels[ j:(j+1), i ] )
    }
  }
  
  df <- as.data.frame(df, stringsAsFactors=F )
  df <- unique( df )
  df <- df[ ! grepl( "$^", df$V2 ) , ]
  
  return( df )
}


get_message <- function(x)
{
  x <- httr::GET(x)
  status <- httr::http_status(x)
  message <- status$message
  return(message)
}



get_unique_xpaths <- function(x)
{
  xpz <- 
    x %>% 
    xml_parent() %>% 
    xmltools::xml_get_paths() %>%
    unlist() %>% 
    unique()
  return(xpz)
}



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

