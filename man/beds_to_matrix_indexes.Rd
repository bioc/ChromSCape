% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocessing_filtering_reduction.R
\name{beds_to_matrix_indexes}
\alias{beds_to_matrix_indexes}
\title{Count bed files on interval to create count indexes}
\usage{
beds_to_matrix_indexes(dir, which, BPPARAM = BiocParallel::bpparam())
}
\arguments{
\item{dir}{A directory containing the single cell BED files}

\item{which}{Genomic Range on which to count}

\item{BPPARAM}{BPPARAM object for multiprocessing. See
\link[BiocParallel]{bpparam} for more informations. Will take the default
BPPARAM set in your R session.}
}
\value{
A list containing a "feature index" data.frame and a
names of cells as vector both used to form the sparse matrix
}
\description{
Count bed files on interval to create count indexes
}
