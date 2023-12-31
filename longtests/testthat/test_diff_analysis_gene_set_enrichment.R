context("Testing Differential Analysis and GSEA functions.")

library(testthat)

# Functions for testing purposes
out = create_scDataset_raw(featureType = "window")
mat = out$mat
annot = out$annot

scExp = create_scExp(mat,annot)

scExp = normalize_scExp(scExp)

scExp = reduce_dims_scExp(scExp)

scExp = feature_annotation_scExp(scExp,ref = "hg38")

scExp = correlation_and_hierarchical_clust_scExp(scExp)

scExp_cf = filter_correlated_cell_scExp(scExp, random_iter = 10, verbose = FALSE)

scExp_cf = consensus_clustering_scExp(scExp_cf)

scExp_cf = choose_cluster_scExp(scExp_cf, nclust = 2)

test_that("Differential Analysis - Wrong inputs.", {
  expect_error(differential_analysis_scExp(NULL))
  expect_error(differential_analysis_scExp(scExp_cf, de_type = "ABC"))
  expect_error(differential_analysis_scExp(scExp_cf, qval.th = "ABC"))
  
  scExp_cf. = scExp_cf
  SummarizedExperiment::colData(scExp_cf.)$chromatinGroup = NULL  
  expect_error(differential_analysis_scExp(scExp.))
  
  scExp_cf. = scExp_cf
  SummarizedExperiment::rowData(scExp_cf.)$Gene = NULL
  expect_error(differential_analysis_scExp(scExp.))

})


######################### Tests two clusters ###################################

scExp_cf = differential_analysis_scExp(scExp_cf, qval.th = 0.8, cdiff.th = 0.3)

test_that("Differential Analysis - Right inputs. n = 2", {
  expect_s4_class(differential_analysis_scExp(scExp_cf),
                "SingleCellExperiment")
  #When 2 clusters, pairwise & one vs rest should yield the same results
  scExp_cf.pw = differential_analysis_scExp(scExp_cf, de_type = "pairwise",
                                            qval.th = 0.8, cdiff.th = 0.3)
  scExp_cf.ovr = differential_analysis_scExp(scExp_cf, qval.th = 0.8,
                                            cdiff.th = 0.3)
  
  scExp_cf.pw@metadata$diff$res[1:5,]
  scExp_cf.ovr@metadata$diff$res[1:5,]
  
  expect_equal(as.character(scExp_cf.ovr@metadata$diff$res$ID),
            rowData(scExp_cf.ovr)$ID)
  expect_equal(as.character(scExp_cf.pw@metadata$diff$res$ID),
            rowData(scExp_cf.pw)$ID)
  expect_equal(scExp_cf.ovr@metadata$diff$summary,
            scExp_cf.pw@metadata$diff$summary)
})


scExp_cf = gene_set_enrichment_analysis_scExp(scExp_cf, enrichment_qval = 0.1,
                                            ref = "hg38", qval.th = 0.8,
                                            cdiff.th = 0.3,
                                            peak_distance = 1000,
                                            use_peaks = FALSE)

test_that("GSEA - Wrong inputs.  n = 2", {
  expect_error(gene_set_enrichment_analysis_scExp(NULL))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                enrichment_qval = "a"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                ref = "dm3"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                qval.th = "a"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                cdiff.th = "a"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                peak_distance = "a"))
  
  scExp_cf. = scExp_cf
  scExp_cf.@metadata$diff = NULL  
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf.))
  
  scExp_cf. = scExp_cf
  SummarizedExperiment::rowData(scExp_cf.)$Gene = NULL
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf.))
  
  expect_equal(scExp_cf@metadata$diff$summary[1,],scExp_cf@metadata$diff$summary[2,] +
                scExp_cf@metadata$diff$summary[3,])
})

test_that("GSEA - Right inputs.  n = 2", {
  
  GencodeGenes = as.character(hg38.GeneTSS$gene)

  expect_is(scExp_cf@metadata$enr$Both[[1]], "data.frame")
  expect_equal(length(scExp_cf@metadata$enr$Both), length(unique(SingleCellExperiment::colData(scExp_cf)$cell_cluster)))
  expect_equal(length(scExp_cf@metadata$enr$Overexpressed), length(unique(SingleCellExperiment::colData(scExp_cf)$cell_cluster)))
  expect_equal(length(scExp_cf@metadata$enr$Underexpressed), length(unique(SingleCellExperiment::colData(scExp_cf)$cell_cluster)))
})


######################### Tests four clusters ##################################

scExp = create_scExp(mat,annot)

scExp = normalize_scExp(scExp)

scExp = reduce_dims_scExp(scExp)

scExp = feature_annotation_scExp(scExp,ref = "hg38")

scExp = correlation_and_hierarchical_clust_scExp(scExp)

scExp_cf = filter_correlated_cell_scExp(scExp,random_iter = 10, verbose = FALSE)

scExp_cf = consensus_clustering_scExp(scExp_cf)

scExp_cf = choose_cluster_scExp(scExp_cf, nclust = 4)

scExp_cf = differential_analysis_scExp(scExp_cf, qval.th = 0.8, cdiff.th = 0.3)

test_that("Differential Analysis + GSEA - Right inputs. n = 4", {
  expect_s4_class(differential_analysis_scExp(scExp_cf),
                  "SingleCellExperiment")
  #When 2 clusters, pairwise & one vs rest should yield the same results
  scExp_cf.pw = differential_analysis_scExp(scExp_cf, de_type = "pairwise",
                                            qval.th = 0.8, cdiff.th = 0.3)
  scExp_cf.ovr = differential_analysis_scExp(scExp_cf, qval.th = 0.8,
                                             cdiff.th = 0.3)
  scExp_cf.pw.edgeR = differential_analysis_scExp(
    scExp_cf, de_type = "pairwise", qval.th = 0.8, cdiff.th = 0.3,
    method = "neg.binomial")
  scExp_cf.ovr.edgeR = differential_analysis_scExp(
    scExp_cf, qval.th = 0.8,cdiff.th = 0.3, method = "neg.binomial")

  expect_equal(dim(scExp_cf.pw),dim(scExp_cf.ovr))
  expect_equal(dim(scExp_cf.pw.edgeR),dim(scExp_cf.ovr.edgeR))
  
  expect_equal(scExp_cf.pw@metadata$diff$res$Count.C1,
               scExp_cf.ovr@metadata$diff$res$Count.C1)

  expect_equal(as.character(scExp_cf.ovr@metadata$diff$res$ID),
               rowData(scExp_cf.ovr)$ID)
  expect_equal(as.character(scExp_cf.pw@metadata$diff$res$ID),
               rowData(scExp_cf.pw)$ID)
  
  scExp_cf.pw = gene_set_enrichment_analysis_scExp(scExp_cf.pw,
                                                   qval.th = 0.8,
                                                   cdiff.th = 0.3)
  scExp_cf.ovr = gene_set_enrichment_analysis_scExp(scExp_cf.ovr,
                                                    qval.th = 0.8,
                                                    cdiff.th = 0.3)
  scExp_cf.pw.edgeR = gene_set_enrichment_analysis_scExp(scExp_cf.pw.edgeR,
                                                         qval.th = 0.8,
                                                         cdiff.th = 0.3)
  scExp_cf.ovr.edgeR = gene_set_enrichment_analysis_scExp(scExp_cf.ovr.edgeR,
                                                          qval.th = 0.8,
                                                          cdiff.th = 0.3)
  expect_is(scExp_cf.pw@metadata$enr$Both[[1]], "data.frame")
  expect_equal(length(scExp_cf.pw@metadata$enr$Both),
               length(unique(
                 SingleCellExperiment::colData(scExp_cf.pw)$cell_cluster)))
  expect_equal(length(
    scExp_cf.pw@metadata$enr$Overexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.pw)$cell_cluster)))
  expect_equal(length(
    scExp_cf.pw@metadata$enr$Underexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.pw)$cell_cluster)))
  
  expect_is(scExp_cf.ovr@metadata$enr$Both[[1]], "data.frame")
  expect_equal(length(scExp_cf.ovr@metadata$enr$Both),
               length(unique(
                 SingleCellExperiment::colData(scExp_cf.ovr)$cell_cluster)))
  expect_equal(length(
    scExp_cf.ovr@metadata$enr$Overexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.ovr)$cell_cluster)))
  expect_equal(length(
    scExp_cf.ovr@metadata$enr$Underexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.ovr)$cell_cluster)))
  
  expect_is(scExp_cf.pw.edgeR@metadata$enr$Both[[1]], "data.frame")
  expect_equal(length(scExp_cf.pw.edgeR@metadata$enr$Both),
               length(unique(
                 SingleCellExperiment::colData(scExp_cf.pw.edgeR)$cell_cluster)))
  expect_equal(length(
    scExp_cf.pw.edgeR@metadata$enr$Overexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.pw.edgeR)$cell_cluster)))
  expect_equal(length(
    scExp_cf.pw.edgeR@metadata$enr$Underexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.pw.edgeR)$cell_cluster)))
  
  expect_is(scExp_cf.ovr.edgeR@metadata$enr$Both[[1]], "data.frame")
  expect_equal(length(scExp_cf.ovr.edgeR@metadata$enr$Both),
               length(unique(
                 SingleCellExperiment::colData(scExp_cf.ovr.edgeR)$cell_cluster)))
  expect_equal(length(
    scExp_cf.ovr.edgeR@metadata$enr$Overexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.ovr.edgeR)$cell_cluster)))
  expect_equal(length(
    scExp_cf.ovr.edgeR@metadata$enr$Underexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf.ovr.edgeR)$cell_cluster)))
  
})


scExp_cf = gene_set_enrichment_analysis_scExp(scExp_cf, enrichment_qval = 0.1,
                                              ref = "hg38", qval.th = 0.8,
                                              cdiff.th = 0.3,
                                              peak_distance = 1000,
                                              use_peaks = FALSE)

test_that("GSEA - Wrong inputs.  n = 4", {
  expect_error(gene_set_enrichment_analysis_scExp(NULL))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                  enrichment_qval = "a"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                  ref = "dm3"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                  qval.th = "a"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                  cdiff.th = "a"))
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf,
                                                  peak_distance = "a"))
  
  scExp_cf. = scExp_cf
  scExp_cf.@metadata$diff = NULL  
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf.))
  
  scExp_cf. = scExp_cf
  SummarizedExperiment::rowData(scExp_cf.)$Gene = NULL
  expect_error(gene_set_enrichment_analysis_scExp(scExp_cf.))
  
  expect_equal(scExp_cf@metadata$diff$summary[1,],scExp_cf@metadata$diff$summary[2,] +
                 scExp_cf@metadata$diff$summary[3,])
})

test_that("GSEA - Right inputs.  n = 4", {
  
  GencodeGenes = as.character(hg38.GeneTSS$gene)
  
  expect_is(scExp_cf@metadata$enr$Both[[1]], "data.frame")
  expect_equal(length(scExp_cf@metadata$enr$Both),
               length(unique(
                 SingleCellExperiment::colData(scExp_cf)$cell_cluster)))
  expect_equal(length(
    scExp_cf@metadata$enr$Overexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf)$cell_cluster)))
  expect_equal(length(
    scExp_cf@metadata$enr$Underexpressed), length(
      unique(SingleCellExperiment::colData(scExp_cf)$cell_cluster)))
})

