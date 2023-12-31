% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/copy_number.R
\name{calculate_logRatio_CNA}
\alias{calculate_logRatio_CNA}
\title{Calculate the log2-ratio of tumor vs normal fraction of reads in
cytobands}
\usage{
calculate_logRatio_CNA(scExp, controls)
}
\arguments{
\item{scExp}{A SingleCellExperiment with "cytoBand" reducedDim slot filled.
\itemize{
\item see  \code{\link{calculate_cyto_mat}}
}}

\item{controls}{Sample IDs or Cell IDs of the normal sample to take as
reference.}
}
\value{
The SCE with the log2-ratio of fraction of reads in each cytobands
in each cells (of dimension cell x cytoband ) in the  reducedDim
slot "logRatio_cytoBand".
}
\description{
Given a SingleCellExperiment object with the slot "cytoBand" containing the
fraction of reads in each cytoband, calculates the log2-ratio of tumor vs
normal fraction of reads in cytobands, cell by cell.
If the average signal in normal sample in a cytoband is 0, set this value to
1 so that the ratio won't affect the fraction of read value.
}
\examples{

data("scExp")
scExp = calculate_cyto_mat(scExp, ref_genome="hg38")
scExp = calculate_logRatio_CNA(scExp, controls=unique(scExp$sample_id)[1])
SingleCellExperiment::reducedDim(scExp, "logRatio_cytoBand")

}
