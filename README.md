# dbSNP

<a href="https://github.com/biobricks-ai/dbSNP/actions"><img src="https://github.com/biobricks-ai/dbSNP/actions/workflows/bricktools-check.yaml/badge.svg?branch=master"/></a>

## Description
> The Single Nucleotide Polymorphism Database

## Usage

### R

```{R}
biobricks::install_brick("dbSNP")
biobricks::brick_pull("dbSNP")
biobricks::brick_load("dbSNP")
```

### Python

```{bash/zsh}
> biobricks install dbsnp
> python3
>>> import biobricks as bb
>>> import pyarrow.parquet as pq
>>> dbsnp_brick = bb.assets('dbsnp')
>>> pf = pq.ParquetDataset(dbsnp_brick.dbSNP_parquet).read()
```
