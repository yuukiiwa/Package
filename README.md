# Package
Get into R and type the following to install Package from Github:
```
devtools::install_github("yuukiiwa/Package")
```
Load Package:
```
library(Package)
```
Run the GTF-dataframe-generating function:
```
gtf <- TxDb_to_GTF()
```
Export the the GTF dataframe into a tsv (will be located in the Package directory):
```
write.table(gtf, file='test.tsv', quote=FALSE, sep='\t', col.names = FALSE, row.names = FALSE)
```
