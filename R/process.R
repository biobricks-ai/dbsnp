library(kiln)
library(arrow)
library(purrr)
library(stringr)
library(vroom)

cache_dir <- "cache"
data_dir <- "data"

mkdir(cache_dir)
mkdir(data_dir)

gzip_file <- list.files(cache_dir) |>
    purrr::keep(~ (grepl("*.gz", .x))) |>
    pluck(1)
gzip_inputfile <- file.path(cache_dir,gzip_file)
# gunzip file
system(str_interp("gunzip -f ${gzip_inputfile}"))

gunzipped_file <- list.files(cache_dir) |>
    purrr::keep(~ !(grepl("*.gz", .x))) |>
    pluck(1)
gunzipped_inputfile <- file.path(cache_dir,gunzipped_file)

arrow::write_dataset(arrow::open_dataset(gunzipped_inputfile,
        format = "tsv"),
    format = "parquet",
    path = data_dir)

parquet_file <- file.path(data_dir,list.files(data_dir))
# move the file 
file.rename(parquet_file,file.path(data_dir,"dbSNP.parquet"))
# delete the cache
