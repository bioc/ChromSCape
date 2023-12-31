% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/diff_analysis_gene_set_enrichment.R
\name{enrich_TF_ChEA3_genes}
\alias{enrich_TF_ChEA3_genes}
\title{Find the TF that are enriched in the differential genes using ChEA3 API}
\usage{
enrich_TF_ChEA3_genes(genes)
}
\arguments{
\item{genes}{A character vector with the name of genes to enrich for TF.}
}
\value{
Returns a SingleCellExperiment object containing list of enriched
Gene Sets for each cluster, either in depleted features, enriched features
or simply differential features (both).
}
\description{
Find the TF that are enriched in the differential genes using ChEA3 API
}
\examples{
data(scExp)
enrich_TF_ChEA3_genes(head(unlist(strsplit(SummarizedExperiment::rowData(scExp)$Gene, split = ",", fixed = TRUE)), 15))

}
\references{
Keenan AB, Torre D, Lachmann A, Leong AK, Wojciechowicz M, Utti V,
Jagodnik K, Kropiwnicki E, Wang Z, Ma'ayan A (2019)
ChEA3: transcription factor enrichment analysis by orthogonal omics integration.
Nucleic Acids Research. doi: 10.1093/nar/gkz446
+
}
