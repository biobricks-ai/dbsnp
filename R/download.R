library(fs)
library(purrr)
download_dir <- "download"
fs::dir_create(download_dir)

print("Downloading Files")
url <- "http://ftp.ncbi.nih.gov/snp/latest_release/VCF"
ftp = stringr::str_replace(url,"http","ftp")
url |> rvest::read_html() |>
rvest::html_elements("a") |>
rvest::html_attr("href") |>
purrr::keep(~ grepl("\\.gz$",.x)) |>  # Get all .gz files
purrr::keep(~ grepl("GCF_\\d+\\.\\d+\\.gz$", .x)) |>  # Keep only those matching the GCF pattern
(\(files) {
  # Extract version numbers
  versions <- files |> 
    purrr::map_dbl(~ as.numeric(stringr::str_extract(.x, "\\d+(?=\\.gz$)")))
  
  # Find the file with the highest version number
  latest_file <- files[which.max(versions)]
  
  # Print which file is being downloaded
  print(paste("Downloading latest version:", latest_file))
  
  # Download the latest file
  # Use wget for faster download
  print("Using wget for parallel downloads")
  system2("wget", c("-O", file.path(download_dir, latest_file), file.path(ftp, latest_file)))
})()
print("Download complete")