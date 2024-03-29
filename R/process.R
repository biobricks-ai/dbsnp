library(arrow,include.only=c("write_parquet"))
library(purrr)
library(readr)
library(future)
library(progressr)
future::plan(future::multisession(workers = 15))
library(furrr)

out   <- fs::dir_create("data/dbSNP.parquet/")
parts <- fs::path(out,"gcf.gz.part")

cmd <- paste0("pv download/GCF_000001405.39.gz | gunzip -c | split -l 10000000 - ",parts)
system(cmd)

colN <- c("CHROM","POS","ID","REF","ALT","QUAL","FILTER","INFO")
colT <- c(col_character(),col_double(),rep(col_character(),6))
read <- \(file){ read_tsv(file,comment="#",col_names=colN,col_types=colT) } 

path <- fs::dir_ls(out,regexp="gcf.gz.part*") 
sink <- fs::path(out,fs::path_ext(path),ext="parquet")

with_progress({
  p  <- progressr::progressor(steps=length(path))
  fn <- \(path,sink){ read(path) |> arrow::write_parquet(sink=sink); p() }
  furrr::future_walk2(path,sink,fn)
})

fs::dir_ls(out,regexp="*.gz.part*") |> fs::file_delete()
