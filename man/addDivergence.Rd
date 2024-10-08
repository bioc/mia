% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimateDivergence.R
\name{addDivergence}
\alias{addDivergence}
\alias{addDivergence,SummarizedExperiment-method}
\alias{getDivergence}
\alias{getDivergence,SummarizedExperiment-method}
\title{Estimate divergence}
\usage{
addDivergence(x, name = "divergence", ...)

\S4method{addDivergence}{SummarizedExperiment}(x, name = "divergence", ...)

getDivergence(
  x,
  assay.type = assay_name,
  assay_name = "counts",
  reference = "median",
  method = "bray",
  ...
)

\S4method{getDivergence}{SummarizedExperiment}(
  x,
  assay.type = assay_name,
  assay_name = "counts",
  reference = "median",
  method = "bray",
  ...
)
}
\arguments{
\item{x}{a \code{\link{SummarizedExperiment}} object.}

\item{name}{\code{Character scalar}. The name to be used to store the result
in metadata of the output. (Default: \code{method})}

\item{...}{optional arguments}

\item{assay.type}{\code{Character scalar}. Specifies which assay to use for
calculation. (Default: \code{"counts"})}

\item{assay_name}{Deprecated. Use \code{assay.type} instead.}

\item{reference}{\code{Character scalar}. A column name from
\code{colData(x)} or either \code{"mean"} or \code{"median"}.
(Default: \code{"median"})}

\item{method}{\code{Character scalar}. Specifies which dissimilarity to
calculate. (Default: \code{"bray"})}
}
\value{
\code{x} with additional \code{\link{colData}} named \code{*name*}
}
\description{
Estimate divergence against a given reference sample.
}
\details{
Microbiota divergence (heterogeneity / spread) within a given sample
set can be quantified by the average sample dissimilarity or beta
diversity with respect to a given reference sample.

The calculation makes use of the function \code{getDissimilarity()}. The
divergence
measure is sensitive to sample size. Subsampling or bootstrapping can be
applied to equalize sample sizes between comparisons.
}
\examples{
data(GlobalPatterns)
tse <- GlobalPatterns

# By default, reference is median of all samples. The name of column where
# results is "divergence" by default, but it can be specified. 
tse <- addDivergence(tse)

# The method that are used to calculate distance in divergence and 
# reference can be specified. Here, euclidean distance is used. Reference is
# the first sample. It is recommended # to add reference to colData.
tse[["reference"]] <- rep(colnames(tse)[[1]], ncol(tse))
tse <- addDivergence(
    tse, name = "divergence_first_sample", 
    reference = "reference",
    method = "euclidean")

# Here we compare samples to global mean
tse <- addDivergence(tse, name = "divergence_average", reference = "mean")

# All three divergence results are stored in colData.
colData(tse)

}
\seealso{
\code{\link[scater:plotColData]{plotColData}}
\itemize{
\item{\code{\link[mia:estimateRichness]{estimateRichness}}}
\item{\code{\link[mia:estimateEvenness]{estimateEvenness}}}
\item{\code{\link[mia:estimateDominance]{estimateDominance}}}
}
}
