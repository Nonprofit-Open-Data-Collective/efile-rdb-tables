library( tidyverse )

schedules <- 
c("SCHEDA", "SCHEDB", "SCHEDC", 
  "SCHEDD", "SCHEDE", "SCHEDF", 
  "SCHEDG", "SCHEDH", "SCHEDI", 
  "SCHEDJ", "SCHEDK", "SCHEDL", 
  "SCHEDM", "SCHEDN", "SCHEDO", 
  "SCHEDR")

url <- "https://www.dropbox.com/s/5o1i5qj6iu7jxhv/SCHEDULE-TABLE-2018.csv?dl=1"
d <- read_csv( url )

url2 <- "https://www.dropbox.com/s/faznk9vnis7tc9d/build-index.rds?dl=1"
index <- readRDS( gzcon( url(url2) ) )




        

# IN schedule-samples DIRECTORY
# dir.create( "schedule-samples" )
# setwd( "schedule-samples" )




for( i in schedules )
{
  # SELECT ONLY ORGS THAT FILE SCHEDULE i 
  these <- d[i] %>% unlist()
  d.sub <- dplyr::filter( d, these )
  
  n.row  <- nrow(d.sub)
  print( i )
  print( n.row )
  
  s.size <- ifelse( n.row < 10000, n.row, 10000 )
  samp  <- sample_n( d.sub, s.size, replace=F )
  
  index.sample <- dplyr::filter( index, URL %in% samp$URL )
  
  index.sample$URL <- 
    gsub( "https://s3.amazonaws.com/irs-form-990/",
          "https://nccs-efile.s3.us-east-1.amazonaws.com/xml/",
          index.sample$URL )
  
  write.csv( index.sample, paste0( i, ".csv" ), row.names=F )
}



