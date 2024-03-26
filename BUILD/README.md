```r
#########################
#########################   CODE
#########################

# remotes::install_github("DavisVaughan/furrr")
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


index.url.2021 <- "https://nccs-efile.s3.us-east-1.amazonaws.com/index/data-commons-index-file-2021.csv"
index.2021 <- read.csv( index.url.2021 )

index.2021 <- 
  index.2021 %>% 
  dplyr::filter( FormType %in% c("990","990EZ") )

# 100 orgs 
test.urls <- index.2021$URL[ 1:100 ]
df.prog <- get_year( test.urls )

# all orgs
urls.2021 <- index.2021$URL
df.prog <- get_year( urls.2021 )

write.csv( df.prog, "PROGRAMS-2021.csv", row.names=F )
write.csv( index.2021, "INDEX-2021.csv", row.names=F )




#########################
#########################   ALL YEARS 
#########################


for( i in 2010:2022 )
{
  index.url <- paste0( "https://nccs-efile.s3.us-east-1.amazonaws.com/index/data-commons-index-file-", i, ".csv" )
  index <- read.csv( index.url )

  index <- 
    index %>% 
    dplyr::filter( FormType %in% c("990","990EZ") )

  urls <- index$URL
  df.prog <- get_year( urls )

  write.csv( df.prog, paste0( "PROGRAMS-", i, ".csv"), row.names=F )
  write.csv( index.2021, paste0( "INDEX-", i, ".csv"), row.names=F )
}

```
