## Initialise database with necessary tables
paths <- commandArgs(trailingOnly = TRUE)
db_path <- as.character(paths[1])

# Initiate an SQLite DB 
logging_db <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_path)

# Define logging table
logging_table <- data.frame(BamFilename=character(0), HasBaiFile=integer(0), HasVcfFile=integer(0), ProcessStatus=character(0))

# create logging table in DB
DBI::dbWriteTable(logging_db, "InputFiles", logging_table)
