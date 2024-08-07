% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mia.R
\docType{data}
\name{enterotype}
\alias{enterotype}
\title{Human gut microbiome dataset from 22 subjects based on shotgun DNA sequencing}
\format{
A TreeSummarizedExperiment with 553 features and 280 samples. The
rowData contains taxonomic information at Genus level. The colData includes:

\describe{
\item{Enterotype}{enterotype the sample belongs to (1, 2 and 3)}
\item{Sample_ID}{sample ID of samples from all studies}
\item{SeqTech}{sequencing technology}
\item{SampleID}{sample ID of complete samples}
\item{Project}{original project from which sample was obtained (gill06,
turnbaugh09, MetaHIT, MicroObes, MicroAge and kurokawa07)}
\item{Nationality}{participant's nationality (american, danish, spanish,
french, italian and japanese)}
\item{Gender}{participant's gender (F or M)}
\item{Age}{participant's age (0.25 -- 87)}
\item{ClinicalStatus}{participant's clinical status (healthy, obese, CD,
UC and elderly)}
}
}
\source{
\url{http://www.bork.embl.de/Docu/Arumugam_et_al_2011/downloads.html}
}
\usage{
data(enterotype)
}
\description{
The enterotype data of the human gut microbiome includes taxonomic profiling
for 280 fecal samples from 22 subjects based on shotgun DNA sequencing. The
authors claimed that the data naturally clumps into three community-level
clusters, or "enterotypes", that are not immediately explained by sequencing
technology or demographic features of the subjects. In a later addendum from
2014 the authors stated that enterotypes should not be seen as discrete
clusters, but as a way of stratifying samples to reduce complexity. It was
converted into a TreeSummarizedExperiment from the \pkg{phyloseq} package.
}
\references{
Arumugam, M., et al. (2011). Enterotypes of the human gut microbiome.
Nature, 473(7346), 174-180. \url{https://doi.org/10.1038/nature09944}

Arumugam, M., et al. (2014). Addendum: Enterotypes of the human gut microbiome.
Nature 506, 516 (2014). \url{https://doi.org/10.1038/nature13075}
}
\seealso{
\code{\link{mia-datasets}}
}
\author{
Arumugam, M., Raes, J., et al.
}
\keyword{datasets}
