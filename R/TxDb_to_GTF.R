#' Convert exons from the GRangesList to a dataframe compatible with the GTF format.
#'
#' @import TxDb.Hsapiens.UCSC.hg38.knownGene
#' @import GenomicFeatures
#' @param GRL a GRangesList obtained from TxDb
#' @param txdbTables a list of tables from TxDb
#' @return gtf
#' @examples
#' library(TxDb.Hsapiens.UCSC.hg38.knownGene)
#' library(GenomicFeatures)
#' exonsByTx <- exonsBy(TxDb.Hsapiens.UCSC.hg38.knownGene, by='tx', use.names=TRUE)
#' txdbTabs <- as.list(TxDb.Hsapiens.UCSC.hg38.knownGene)
#' TxDb_to_GTF(GRL=exonsByTx, txdbTables=txdbTabs)
#' @export

TxDb_to_GTF <- function(GRL,txdbTables) {
  if (missing(GRL) | missing(txdbTables)){
    stop('Both GRangesList and information of transcript and gene ids are required.')
  }else if (class(GRL) != "CompressedGRangesList"){
    stop('The inputted GRangesList is of the wrong class.')
  }else if (class(txdbTables) != "list"){
    stop('The inputted txdbTables is of the wrong class.') 
  }else{
    exonsdf <- as.data.frame(GRL)
    initTab <- merge(txdbTables$transcripts,txdbTables$genes,by="tx_id",all=TRUE)
    initTab <- initTab[!duplicated(initTab$tx_name),]
    Tab <- merge(initTab,exonsdf,by.x="tx_name",by.y="group_name",all=TRUE)
    Tab$gene_id <- paste('gene_id "',Tab$gene_id,'";',sep= '')
    Tab$tx_name <- paste('transcript_id "',Tab$tx_name,'";',sep= '')
    Tab$exon_rank <- paste('exon_number "',Tab$exon_rank,'";',sep= '')
    Tab$exon_id <- paste('exon_id "',Tab$exon_id,'";',sep= '')
    gtf <- data.frame(
      seqname=Tab$tx_chrom, source= c(rep("TxDb")),feature= c(rep("exon")),
      start=Tab$start,end=Tab$end,score=c(rep(".")),strand=Tab$strand,
      frame=c(rep(".")), attributes= paste(Tab$gene_id,Tab$tx_name,Tab$exon_rank,Tab$exon_id)
    )
  }
  return(gtf)
}
