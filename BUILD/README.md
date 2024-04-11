Demo of RDB functions with Part III Programs table: 

https://nonprofit-open-data-collective.github.io/efile-rdb-tables/TABLE-F9-P03-T01-PROGRAMS.html



```r
#########################
#########################   CODE
#########################

# remotes::install_github( 'DavisVaughan/furrr' )
# devtools::install_github( 'ultinomics/xmltools' )
# devtools::install_github( 'nonprofit-open-data-collective/irs990efile' )

library( dplyr )
library( irs990efile )
library( furrr )

BASE <- "https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/efile-rdb-tables/main/BUILD/"

source( paste0( BASE, "rdb-functions-v3.R" ) )
source( paste0( BASE, "build-rdb-table-v3.R" ) )
source( paste0( BASE, "build-rdb-parallel-furrr.R" ) )
source( paste0( BASE, "utils.R" ) )
source( paste0( BASE, "CHUNKS-F9-P03-T00-PROGRAMS.R" ) )


#########################
#########################   ONE YEAR 
#########################

YEAR <- 2019

index.url <- paste0( "https://nccs-efile.s3.us-east-1.amazonaws.com/index/data-commons-index-file-", YEAR, ".csv" )
index <-
  index.url %>%
  data.table::fread( colClasses = 'character',
                     data.table = FALSE,
                     showProgress = FALSE )

index <- 
  index %>% 
  dplyr::filter( FormType %in% c("990","990EZ") )

# all orgs
urls <- index$URL
programs <- get_year( urls )

write.csv( programs, paste0( "PROGRAMS-", YEAR, ".csv"), row.names=F )
write.csv( index, paste0( "INDEX-", YEAR, ".csv"), row.names=F )




#########################
#########################   ALL YEARS 
#########################


for( i in 2010:2022 )
{
  index.url <- paste0( "https://nccs-efile.s3.us-east-1.amazonaws.com/index/data-commons-index-file-", i, ".csv" )
  index.i <- read.csv( index.url )

  index.i <- 
    index.i %>% 
    dplyr::filter( FormType %in% c("990","990EZ") )

  urls <- index.i$URL
  df <- get_year( urls )

  write.csv( df, paste0( "PROGRAMS-", i, ".csv"), row.names=F )
  write.csv( index.i, paste0( "INDEX-", i, ".csv"), row.names=F )
}

```
