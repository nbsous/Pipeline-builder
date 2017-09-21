## Initialise database with necessary tables
paths <- commandArgs(trailingOnly = TRUE)
db_path <- as.character(paths[1])

# Initiate an SQLite DB
logging_db <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_path)

# Define logging table
logging_table <- data.frame(BamFilename=character(0),
                            HasBaiFile=integer(0),
                            HasVcfFile=integer(0),
                            ProcessStatus=character(0)
                            # add time stamp, platform and fastq columns here .  fix findNewBams.R
                          )

# create logging table in DB
DBI::dbWriteTable(logging_db, "InputFiles", logging_table)

# FIXME  does this work as expected? maybe fix in makefile?
#DBI::dbSendStatement(logging_db, 'PRAGMA journal_mode = "WAL";')

DBI::dbDisconnect(logging_db)
