% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convertFromBIOM.R
\name{importBIOM}
\alias{importBIOM}
\title{Loading a BIOM file}
\usage{
importBIOM(file, ...)
}
\arguments{
\item{file}{BIOM file location}

\item{...}{additional arguments to be passed to \code{convertFromBIOM}}
}
\value{
\code{importBIOM} returns an object of class
\code{\link[TreeSummarizedExperiment:TreeSummarizedExperiment-class]{TreeSummarizedExperiment}}
}
\description{
Loading a BIOM file
}
\details{
\code{importBIOM} loads a BIOM file and creates a
\code{\link[TreeSummarizedExperiment:TreeSummarizedExperiment-class]{TreeSummarizedExperiment}}
object from the BIOM object contained in the loaded file.
}
\seealso{
\code{\link[=importMetaPhlAn]{importMetaPhlAn}}
\code{\link[=convert]{convertFromPhyloseq}}
\code{\link[=convert]{convertFromBIOM}}
\code{\link[=convert]{convertFromDADA2}}
\code{\link[=importQIIME2]{importQIIME2}}
\code{\link[=importMothur]{importMothur}}
\code{\link[=importHUMAnN]{importHUMAnN}}
}