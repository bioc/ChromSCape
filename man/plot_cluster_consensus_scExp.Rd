% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotting_functions.R
\name{plot_cluster_consensus_scExp}
\alias{plot_cluster_consensus_scExp}
\title{Plot cluster consensus}
\usage{
plot_cluster_consensus_scExp(scExp)
}
\arguments{
\item{scExp}{A SingleCellExperiment}
}
\value{
The consensus score for each cluster for each k as a barplot
}
\description{
Plot cluster consensus score for each k as a bargraph.
}
\examples{
data("scExp")

plot_cluster_consensus_scExp(scExp)

}
