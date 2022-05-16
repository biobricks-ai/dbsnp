library(arrow)
library(purrr)

download_dir <- "download"
data_dir <- "data"

fs::dir_create(data_dir)

gzip_file <- list.files(download_dir) |>
    purrr::keep(~ (grepl("*.gz", .x))) |>
    purrr::pluck(1)
gzip_inputfile <- file.path(download_dir,gzip_file)
# gunzip file
system(sprintf("gunzip -f %s",gzip_inputfile))

gunzipped_file <- list.files(download_dir) |>
    purrr::keep(~ !(grepl("*.gz", .x))) |>
    purrr::pluck(1)
gunzipped_inputfile <- file.path(download_dir,gunzipped_file)
sed_mod_gunzipped_inputfile <- file.path(data_dir,gunzipped_file)

system(sprintf("sed '1,37d' %s > %s",gunzipped_inputfile,sed_mod_gunzipped_inputfile))

arrow::write_dataset(arrow::open_dataset(sed_mod_gunzipped_inputfile,
        format = "tsv"),
    format = "parquet",
    path = data_dir)

parquet_file <- fs::dir_ls(data_dir,regexp="*.parquet")
# move the file 
fs::file_move(parquet_file,file.path(data_dir,"dbSNP.parquet"))
# delete the sed file
unlink(sed_mod_gunzipped_inputfile)