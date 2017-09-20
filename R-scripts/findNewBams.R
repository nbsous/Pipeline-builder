# Identify all bam files present in bam_repo, check whether already present in SQLite database, if not, add.
library(magrittr)

paths <- commandArgs(trailingOnly = TRUE)
bam_repo <- as.character(paths[1])
db_path <- as.character(paths[2])

# system(paste("echo \"", bam_repo, db_path, "\" > tmp.txt"))

# Connect SQLite DB 
logging_db <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_path)

# get all bam files in repo
all_bams_in_repo <- bam_repo %>% list.files(pattern=".bam$")
# get all bai files in repo
all_bais_in_repo <- bam_repo %>% list.files(pattern=".bai$")
# get all vcf files in repo
all_vcfs_in_repo <- bam_repo %>% list.files(pattern=".vcf$")

# get all bam files in db
all_bams_in_db <- DBI::dbGetQuery(logging_db, "SELECT BamFilename FROM InputFiles") %>% unlist()

# all new bams not in db
all_new_bams_in_repo <- setdiff(all_bams_in_repo, all_bams_in_db)

if (length(all_new_bams_in_repo) > 0) {
  # bai file exists
  bai_file_exists <- match(all_new_bams_in_repo, all_bais_in_repo %>% stringr::str_replace(".bai", "")) %>% is.na() %>% not()
  # vcf file exists
  vcf_file_exists <- match(all_new_bams_in_repo, all_bais_in_repo %>% stringr::str_replace(".vcf", "")) %>% is.na() %>% not()
  
  
  # Define new bam table
  new_bam_table <- data.frame(BamFilename=all_new_bams_in_repo, 
                              HasBaiFile=bai_file_exists, 
                              HasVcfFile=vcf_file_exists, 
                              ProcessStatus="Queued")
  
  # append newly detected bam files to table in DB
  DBI::dbWriteTable(logging_db, "InputFiles", new_bam_table, append = TRUE)
  
}

# Disconnect DB
DBI::dbDisconnect(logging_db)
