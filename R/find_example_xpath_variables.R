library( xml2 )
library( xmltools )
library( dplyr )

# parallelization 
# no required but makes searching much faster
library(foreach) 
library(parallel)

n.cores <- parallel::detectCores() -1 

my.cluster <- parallel::makeCluster(
  n.cores, 
  type = "PSOCK"
)
my.cluster

doParallel::registerDoParallel(cl = my.cluster)

paste(("is registered:"), (foreach::getDoParRegistered()))

paste(("workers:"), (foreach::getDoParWorkers()))




## Link to sample index csv
tab <- read.csv("https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/efile-rdb-tables/refs/heads/main/TABLE-SN-P01-T01-LIQUIDATION-TERMINATION-DISSOLUTION/sample-index.csv")


# Run through sample files to see which ones have the variable name of interest
# replace "foreach" with "for" if not using parallelization
has.var <- foreach(i = 1:nrow(tab),
       .packages = c( "xml2", "dplyr", "xmltools")) %dopar% {
  
  #Get the list of XML Paths
  url <- tab$URL[i]
  
  doc <- NULL
  try( doc <- xml2::read_xml( file(url) ), silent=T ) 
  if( is.null(doc) ){ return( NULL ) }
  xml2::xml_ns_strip( doc )
  
  paths <- doc %>%
    xmltools::xml_get_paths() %>% 
    unlist() %>% 
    unique() 
  
  # Check if any of these paths end with the variable name of interest
  test <- endsWith(paths,"BondLiabilitiesDischargedInd")
  
  #return TRUE if this return contains the variable name
  any(test)
 
}


## See the first few returns with the variable name of interest
tab[which(unlist(has.var)), c("EIN", "TaxYear", "URL")] %>% 
  head()


