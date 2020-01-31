#' Convert exons from the GRangesList to a dataframe compatible with the GTF format.
#'
#' @import TxDb.Hsapiens.UCSC.hg38.knownGene
#' @import GenomicFeatures
#' @return gtf
#' @examples
#' TxDb_to_GTF()
#' @export

TxDb_to_GTF <- function() {
  message("This will take a little less than four minutes.")
  exonsByTx <- exonsBy(TxDb.Hsapiens.UCSC.hg38.knownGene, by='tx', use.names=TRUE)
  exonsdf <- as.data.frame(exonsByTx)
  txdbTables <- as.list(TxDb.Hsapiens.UCSC.hg38.knownGene)
  initTab <- merge(txdbTables$transcripts,txdbTables$genes,by="tx_id",all=TRUE)
  initTab <- initTab[!duplicated(initTab$tx_name),]
  Tab <- merge(initTab,exonsdf,by.x="tx_name",by.y="group_name",all=TRUE)
  Tab$gene_id <- paste("gene_id",Tab$gene_id,sep= " ")
  Tab$tx_name <- paste("transcript_id",Tab$tx_name,sep= " ")
  Tab$exon_id <- paste("exon_id",Tab$exon_id,sep= " ")
  #Tab$tx_chrom <- gsub("\\chr","",Tab$tx_chrom)  #not necessary
  gtf <- data.frame(
    seqname=Tab$tx_chrom, source= c(rep("TxDb")),feature= c(rep("exon")),
    start=Tab$start,end=Tab$tx_end,score=c(rep(".")),strand=Tab$strand,
    frame=c(rep(".")), attributes= paste(Tab$gene_id,Tab$tx_name,Tab$exon_id,sep="; ")
  )
  return(gtf)
}
