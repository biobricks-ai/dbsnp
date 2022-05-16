library(fs)
library(purrr)
options(timeout=3600)
download_dir <- "download"
fs::dir_create(download_dir)

print("Downloading Files")
url <- "http://ftp.ncbi.nih.gov/snp/latest_release/VCF"
ftp = stringr::str_replace(url,"http","ftp")
url |> rvest::read_html() |>
rvest::html_elements("a") |>
rvest::html_attr("href") |>
purrr::keep(~ grepl("*39*.gz$",.x)) |>
purrr::pluck(1) |>
purrr::walk(~ download.file(url=file.path(ftp,.x),destfile=(file.path(download_dir,.x))))