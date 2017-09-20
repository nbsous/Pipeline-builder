# Identify all bam files present in bam_repo, check whether already present in SQLite database, if not, add.
paths <- commandArgs(trailingOnly = TRUE)
bam_repo <- as.character(paths[1])
db_path <- as.character(paths[2])

system(paste("echo \"", bam_repo, db_path, "\" > tmp.txt"))
