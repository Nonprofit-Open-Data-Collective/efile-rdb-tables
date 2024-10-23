library( xml2 )
library( xmltools )
library( dplyr )

url <- "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201301709349200115_public.xml"

doc <- NULL
try( doc <- xml2::read_xml( file(url) ), silent=T ) 
if( is.null(doc) ){ return( NULL ) }
xml2::xml_ns_strip( doc )

doc %>%
  xmltools::xml_get_paths() %>% 
  unlist() %>% 
  unique()
