% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocessing_filtering_reduction.R
\name{warning_raw_counts_to_sparse_matrix}
\alias{warning_raw_counts_to_sparse_matrix}
\title{Warning for raw_counts_to_sparse_matrix}
\usage{
warning_raw_counts_to_sparse_matrix(
  files_dir_list,
  file_type = c("scBAM", "scBED", "SparseMatrix"),
  peak_file = NULL,
  n_bins = NULL,
  bin_width = NULL,
  genebody = NULL,
  extendPromoter = 2500,
  verbose = TRUE,
  ref = "hg38"
)
}
\arguments{
\item{files_dir_list}{A named character vector of directory containing
the raw files}

\item{file_type}{Input file(s) type(s) ('scBED','scBAM','SparseMatrix')}

\item{peak_file}{A file containing genomic location of peaks (NULL)}

\item{n_bins}{The number of bins to tile the genome (NULL)}

\item{bin_width}{The size of bins to tile the genome (NULL)}

\item{genebody}{Count on genes (body + promoter) ? (NULL)}

\item{extendPromoter}{If counting on genes, number of base pairs to extend up or
downstream of TSS (2500).}

\item{verbose}{Verbose (TRUE)}

\item{ref}{reference genome to use (hg38)}
}
\value{
Error or warnings if the input are not correct
}
\description{
Warning for raw_counts_to_sparse_matrix
}
