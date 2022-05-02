library(kiln)
library(purrr)
cache_dir <- "cache"
mkdir(cache_dir)

# list the files
host <- "ftp.ncbi.nih.gov"
dir <- "/snp/latest_release/VCF"

system(paste0("ncftpls ", "ftp://", host, dir, "/"), intern = TRUE) |>
    purrr::keep(~ grepl("*39*.gz$", .x)) |>
    walk(~ system(paste0(
        "ncftpget -A -B 33554432 -R ",
        host, " ", cache_dir, " ", file.path(dir, .x))))