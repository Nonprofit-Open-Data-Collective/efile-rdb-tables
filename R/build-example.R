# see all table names: 
# table( concordance$rdb_table, concordance$rdb_relationship )
# for example: 
# F9-P03-T01-PROGRAMS
# F9-P07-T02-CONTRACTORS 
# F9-P07-T01-COMPENSATION



# view all xpaths in the table 
concordance$xpath[ concordance$rdb_table == "F9-P07-T01-COMPENSATION" ]


# check possible parent nodes 
find_group_names( table.name="F9-P07-T01-COMPENSATION" )


# map to standardize variable names across table versions 
get_var_map( table.name="F9-P07-T01-COMPENSATION" )


table.name <- "F9-P07-T01-COMPENSATION"

results.list <- list()

for( i in 1:length(test.urls) )
{
  url <- test.urls[i]
  results.list[[i]] <- build_rdb_table( url, table.name )
}


df <- dplyr::bind_rows( results.list )

write.csv( df, paste0( table.name, ".csv"), row.names=F )