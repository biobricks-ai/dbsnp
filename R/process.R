library(arrow,include.only=c("write_parquet"))
library(purrr)
library(future)
future::plan(future::multisession(workers = 5))

out <- fs::dir_create("data/dbSNP.parquet/")

read.fn <- \(con,num){ readLines(con, n=num) }
write   <- \(tbl,pos){ arrow::write_parquet(tbl,fs::path(out,pos,ext="parquet")); T }
load.fn <- \(lns,pos){ read.table(text=lns,sep="\t",comment.char="#") |> write(pos=pos) }
stop.fn <- \(lns,pos){ length(lns) < 1000 }

options(future.globals.maxSize=4e9)
processor <- function(con, read.fn, load.fn, stop.fn, nrow=10,p=\(){}){
  futures   <- list()
  \(pos=1,...){
    cat("reading ",pos,"\n")
    tbl     <-  read.fn(con,nrow) 
    futures <<- c(futures,future({load.fn(tbl,pos)}))
    if(stop.fn(tbl,pos)){ value(futures); done(futures) }else{ pos+nrow }
  }
}

con <- fs::dir_ls("download",regexp="*.gz$")[1] |> gzfile("rb")
reduce(1:1e9, processor(con, read.fn, load.fn, stop.fn, nrow=1e7))