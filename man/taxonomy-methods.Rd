% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/taxonomy.R
\name{taxonomy-methods}
\alias{taxonomy-methods}
\alias{taxonomyRanks}
\alias{taxonomyRanks,SummarizedExperiment-method}
\alias{taxonomyRankEmpty}
\alias{taxonomyRankEmpty,SummarizedExperiment-method}
\alias{checkTaxonomy}
\alias{checkTaxonomy,SummarizedExperiment-method}
\alias{setTaxonomyRanks}
\alias{getTaxonomyRanks}
\alias{getTaxonomyLabels}
\alias{getTaxonomyLabels,SummarizedExperiment-method}
\alias{mapTaxonomy}
\alias{mapTaxonomy,SummarizedExperiment-method}
\alias{IdTaxaToDataFrame}
\title{Functions for accessing taxonomic data stored in \code{rowData}.}
\usage{
taxonomyRanks(x)

\S4method{taxonomyRanks}{SummarizedExperiment}(x)

taxonomyRankEmpty(
  x,
  rank = taxonomyRanks(x)[1L],
  empty.fields = c(NA, "", " ", "\\t", "-", "_")
)

\S4method{taxonomyRankEmpty}{SummarizedExperiment}(
  x,
  rank = taxonomyRanks(x)[1],
  empty.fields = c(NA, "", " ", "\\t", "-", "_")
)

checkTaxonomy(x, ...)

\S4method{checkTaxonomy}{SummarizedExperiment}(x)

setTaxonomyRanks(ranks)

getTaxonomyRanks()

getTaxonomyLabels(x, ...)

\S4method{getTaxonomyLabels}{SummarizedExperiment}(
  x,
  empty.fields = c(NA, "", " ", "\\t", "-", "_"),
  with.rank = with_rank,
  with_rank = FALSE,
  make.unique = make_unique,
  make_unique = TRUE,
  resolve.loops = resolve_loops,
  resolve_loops = FALSE,
  ...
)

mapTaxonomy(x, ...)

\S4method{mapTaxonomy}{SummarizedExperiment}(
  x,
  taxa = NULL,
  from = NULL,
  to = NULL,
  use.grepl = use_grepl,
  use_grepl = FALSE
)

IdTaxaToDataFrame(from)
}
\arguments{
\item{x}{\code{\link[TreeSummarizedExperiment:TreeSummarizedExperiment-class]{TreeSummarizedExperiment}}.}

\item{rank}{\code{Character scalar}. Defines a taxonomic rank. Must be a value of
\code{taxonomyRanks()} function.}

\item{empty.fields}{\code{Character vector}. Defines which values should be
regarded as empty. (Default: \code{c(NA, "", " ", "\t")}). They will be
removed if \code{na.rm = TRUE} before agglomeration.}

\item{...}{optional arguments not used currently.}

\item{ranks}{\code{Character vector}. A vector of ranks to be set.}

\item{with.rank}{\code{Logical scalar}. Should the level be add as a
suffix? For example: "Phylum:Crenarchaeota". (Default: \code{FALSE})}

\item{with_rank}{Deprecated. Use \code{with.rank} instead.}

\item{make.unique}{\code{Logical scalar}. Should the labels be made
unique, if there are any duplicates? (Default: \code{TRUE})}

\item{make_unique}{Deprecated. Use \code{make.unique} instead.}

\item{resolve.loops}{\code{Logical scalar}. Should \code{resolveLoops}
be applied to the taxonomic data? Please note that has only an effect,
if the data is unique. (Default: \code{TRUE})}

\item{resolve_loops}{Deprecated. Use \code{resolve.loops} instead.}

\item{taxa}{\code{Character vector}. Used for subsetting the
taxonomic information. If no information is found,\code{NULL} is returned
for the individual element. (Default: \code{NULL})}

\item{from}{\itemize{
\item For \code{mapTaxonomy}: \code{character scalar}. A value which
must be a valid taxonomic rank. (Default: \code{NULL})
\item otherwise a \code{Taxa} object as returned by
\code{\link[DECIPHER:IdTaxa]{IdTaxa}}
}}

\item{to}{\code{Character Scalar}. Must be a valid
taxonomic rank. (Default: \code{NULL})}

\item{use.grepl}{\code{Logical}. Should pattern matching via
\code{grepl} be used? Otherwise literal matching is used.
(Default: \code{FALSE})}

\item{use_grepl}{Deprecated. Use \code{use.grepl} instead.}
}
\value{
\itemize{
\item \code{taxonomyRanks}: a \code{character} vector with all the
taxonomic ranks found in \code{colnames(rowData(x))}
\item \code{taxonomyRankEmpty}: a \code{logical} value
\item \code{mapTaxonomy}: a \code{list} per element of taxa. Each
element is either a \code{DataFrame}, a \code{character} or \code{NULL}.
If all \code{character} results have the length of one, a single
\code{character} vector is returned.
}
}
\description{
These function work on data present in \code{rowData} and define a way to
represent taxonomic data alongside the features of a
\code{SummarizedExperiment}.
}
\details{
\code{taxonomyRanks} returns, which columns of \code{rowData(x)} are regarded
as columns containing taxonomic information.

\code{taxonomyRankEmpty} checks, if a selected rank is empty of information.

\code{checkTaxonomy} checks, if taxonomy information is valid and whether
it contains any problems. This is a soft test, which reports some
diagnostic and might mature into a data validator used upon object
creation.

\code{getTaxonomyLabels} generates a character vector per row consisting of
the lowest taxonomic information possible. If data from different levels,
is to be mixed, the taxonomic level is prepended by default.

\code{IdTaxaToDataFrame} extracts taxonomic results from results of
\code{\link[DECIPHER:IdTaxa]{IdTaxa}}.

\code{mapTaxonomy} maps the given features (taxonomic groups; \code{taxa})
to the specified taxonomic level (\code{to} argument) in \code{rowData}
of the \code{SummarizedExperiment} data object
(i.e. \code{rowData(x)[,taxonomyRanks(x)]}). If the argument \code{to} is
not provided, then all matching taxonomy rows in \code{rowData} will be
returned. This function allows handy conversions between different

Taxonomic information from the \code{IdTaxa} function of \code{DECIPHER}
package are returned as a special class. With \code{as(taxa,"DataFrame")}
the information can be easily converted to a \code{DataFrame} compatible
with storing the taxonomic information a \code{rowData}. Please note that the
assigned confidence information are returned as \code{metatdata} and can
be accessed using \code{metadata(df)$confidence}.
}
\examples{
data(GlobalPatterns)
GlobalPatterns
taxonomyRanks(GlobalPatterns)

checkTaxonomy(GlobalPatterns)

table(taxonomyRankEmpty(GlobalPatterns,"Kingdom"))
table(taxonomyRankEmpty(GlobalPatterns,"Species"))

getTaxonomyLabels(GlobalPatterns[1:20,])

# mapTaxonomy
## returns the unique taxonomic information
mapTaxonomy(GlobalPatterns)
# returns specific unique taxonomic information
mapTaxonomy(GlobalPatterns, taxa = "Escherichia")
# returns information on a single output
mapTaxonomy(GlobalPatterns, taxa = "Escherichia",to="Family")

# setTaxonomyRanks
tse <- GlobalPatterns
colnames(rowData(tse))[1] <- "TAXA1"

setTaxonomyRanks(colnames(rowData(tse)))
# Taxonomy ranks set to: taxa1 phylum class order family genus species 

# getTaxonomyRanks is to get/check if the taxonomic ranks is set to "TAXA1"
getTaxonomyRanks()
}
\seealso{
\code{\link[=agglomerate-methods]{agglomerateByRank}},
\code{\link[TreeSummarizedExperiment:toTree]{toTree}},
\code{\link[TreeSummarizedExperiment:resolveLoop]{resolveLoop}}
}
