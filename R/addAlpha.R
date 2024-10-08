#' Estimate alpha diversity indices
#' 
#' The function estimates alpha diversity indices optionally using rarefaction,
#' then stores results in \code{\link{colData}}.
#' 
#' @param x a \code{\link{SummarizedExperiment}} object.
#' 
#' @param assay.type \code{Character scalar}. Specifies the name of assay 
#'   used in calculation. (Default: \code{"counts"})
#'   
#' @param index \code{Character vector}. Specifies the alpha diversity 
#'   indices to be calculated.
#'   
#' @param name \code{Character vector}. A name for the column of the 
#'   \code{colData} where results will be stored. (Default: \code{index})
#' 
#' @param niter \code{Integer scalar}. Specifies the number of
#'   rarefaction rounds. Rarefaction is not applied when \code{niter=NULL}
#'   (see Details section). (Default: \code{NULL})
#'   
#' @param ... optional arguments:
#' \itemize{
#'   \item \code{sample}: \code{Integer scalar}. Specifies the rarefaction
#'   depth i.e. the number of counts drawn from each sample.
#'   (Default: \code{min(colSums2(assay(x, assay.type)))})
#'   
#'   \item \code{tree.name}: \code{Character scalar}. Specifies which rowTree 
#'    will be used. ( Faith's index). (Default: \code{"phylo"})
#'   
#'   \item \code{node.label}: \code{Character vector} or \code{NULL} Specifies the 
#'   links between rows and node labels of phylogeny tree specified 
#'   by \code{tree.name}. If a certain row is not linked with the tree, missing 
#'   instance should be noted as NA. When \code{NULL}, all the rownames should 
#'   be found from the tree. (Faith's index). (Default: \code{NULL})
#'   
#'   \item \code{only.tips}: (Faith's index). \code{Logical scalar}. Specifies
#'   whether to remove internal nodes when Faith's index is calculated. 
#'   When \code{only.tips=TRUE}, those rows that are not tips of tree are 
#'   removed. (Default: \code{FALSE})
#'   
#'   \item \code{threshold}: (Coverage and all evenness indices). \code{Numeric scalar}. 
#'   From \code{0 to 1}, determines the threshold for coverage and evenness
#'   indices. When evenness indices are calculated values under or equal to
#'   this threshold are denoted as zeroes. For coverage index, see details.
#'   (Default: \code{0.5} for coverage, \code{0} for evenness indices)
#'   
#'   \item \code{quantile}: (log modulo skewness index). \code{Numeric scalar}. 
#'   Arithmetic abundance classes are evenly cut up to to this quantile of the data. 
#'   The assumption is that abundances higher than this are not common, and they 
#'   are classified in their own group. (Default: \code{0.5})
#'   
#'   \item \code{nclasses}: (log modulo skewness index). \code{Integer scalar}. 
#'   The number of arithmetic abundance classes from zero to the quantile cutoff 
#'   indicated by \code{quantile}. (Default: \code{50})
#'   
#'   \item \code{ntaxa}: (absolute and relative indices). \code{Integer scalar}. 
#'   The n-th position of the dominant taxa to consider. (Default: \code{1})
#'   
#'   \item \code{aggregate}: (absolute, dbp, dmn, and relative indices). 
#'   \code{Logical scalar}. Aggregate the values for top members selected by 
#'   \code{ntaxa} or not. If \code{TRUE}, then the sum of relative abundances 
#'   is returned. Otherwise the relative abundance is returned for the single 
#'   taxa with the indicated rank (default: \code{aggregate = TRUE}).
#'   
#'   \item \code{detection}: (observed index). \code{Numeric scalar} Selects
#'   detection threshold for the abundances (Default: \code{0})
#' }
#' 
#' @return \code{x} with additional \code{colData} column(s) named \code{code}
#' 
#' @details
#' 
#' ## Diversity
#' 
#' Alpha diversity is a joint quantity that combines elements or community
#' richness and evenness. Diversity increases, in general, when species richness
#' or evenness increase.
#' 
#' The following diversity indices are available:
#' 
#' \itemize{
#' 
#' \item 'coverage': Number of species needed to cover a given fraction of
#' the ecosystem (50 percent by default). Tune this with the threshold
#' argument.
#' 
#' \item 'faith': Faith's phylogenetic alpha diversity index measures how
#' long the taxonomic distance is between taxa that are present in the sample.
#' Larger values represent higher diversity. Using this index requires
#' rowTree. (Faith 1992)
#' 
#' If the data includes features that are not in tree's tips but in
#' internal nodes, there are two options. First, you can keep those features,
#' and prune the tree to match features so that each tip can be found from
#' the features. Other option is to remove all features that are not tips.
#' (See \code{only.tips} parameter)
#' 
#' \item 'fisher': Fisher's alpha; as implemented in
#' \code{\link[vegan:diversity]{vegan::fisher.alpha}}. (Fisher et al. 1943)
#' 
#' \item 'gini_simpson': Gini-Simpson diversity i.e. \eqn{1 - lambda},
#' where \eqn{lambda} is the
#' Simpson index, calculated as the sum of squared relative abundances.
#' This corresponds to the diversity index
#' 'simpson' in \code{\link[vegan:diversity]{vegan::diversity}}.
#' This is also called Gibbs–Martin, or Blau index in sociology,
#' psychology and management studies. The Gini-Simpson index (1-lambda)
#' should not be
#' confused with Simpson's dominance (lambda), Gini index, or
#' inverse Simpson index (1/lambda).
#' 
#' \item 'inverse_simpson': Inverse Simpson diversity:
#' \eqn{1/lambda} where \eqn{lambda=sum(p^2)} and p refers to relative
#' abundances.
#' This corresponds to the diversity index
#' 'invsimpson' in vegan::diversity. Don't confuse this with the
#' closely related Gini-Simpson index
#'
#' \item 'log_modulo_skewness': The rarity index characterizes the
#' concentration of species at low abundance. Here, we use the skewness of
#' the frequency 
#' distribution of arithmetic abundance classes (see Magurran & McGill 2011).
#' These are typically right-skewed; to avoid taking log of occasional
#' negative skews, we follow Locey & Lennon (2016) and use the log-modulo
#' transformation that adds a value of one to each measure of skewness to
#' allow logarithmization.
#'
#' \item 'shannon': Shannon diversity (entropy).
#' 
#' }
#' 
#' ## Dominance
#' 
#' A dominance index quantifies the dominance of one or few species in a
#' community. Greater values indicate higher dominance.
#'
#' Dominance indices are in general negatively correlated with alpha diversity
#' indices (species richness, evenness, diversity, rarity). More dominant
#' communities are less diverse.
#'
#' The following community dominance indices are available:
#'
#' \itemize{
#' 
#' \item 'absolute': Absolute index equals to the absolute abundance of the
#' most dominant n species of the sample (specify the number with the argument
#' \code{ntaxa}). Index gives positive integer values.
#' 
#' \item 'dbp': Berger-Parker index (See Berger & Parker 1970) calculation
#' is a special case of the 'relative' index. dbp is the relative abundance of
#' the most
#' abundant species of the sample. Index gives values in interval 0 to 1,
#' where bigger value represent greater dominance.
#'
#' \deqn{dbp = \frac{N_1}{N_{tot}}}{%
#' dbp = N_1/N_tot} where \eqn{N_1} is the absolute abundance of the most
#' dominant species and \eqn{N_{tot}} is the sum of absolute abundances of all
#' species.
#' 
#' \item 'core_abundance': Core abundance index is related to core species.
#' Core species are species that are most abundant in all samples, i.e., in
#' whole data set. Core species are defined as those species that have
#' prevalence over 50\%. It means that in order to belong to core species,
#' species must be prevalent in 50\% of samples. Core species are used to
#' calculate the core abundance index. Core abundance index is sum of relative
#' abundances of core species in the sample. Index gives values in interval
#' 0 to 1, where bigger value represent greater dominance.
#'
#' \deqn{core_abundance = \frac{N_{core}}{N_{tot}}}{%
#' core_abundance = N_core/N_tot} where \eqn{N_{core}} is the sum of absolute
#' abundance of the core species and \eqn{N_{tot}} is the sum of absolute
#' abundances of all species.
#' 
#' \item 'gini':  Gini index is probably best-known from socio-economic
#' contexts (Gini 1921). In economics, it is used to measure, for example, how
#' unevenly income is distributed among population. Here, Gini index is used
#' similarly, but income is replaced with abundance. 
#' 
#' If there is small group of species
#' that represent large portion of total abundance of microbes, the inequality
#' is large and Gini index closer to 1. If all species has equally large
#' abundances, the equality is perfect and Gini index equals 0. This index
#' should not be confused with Gini-Simpson index, which quantifies diversity.
#'
#' \item 'dmn': McNaughton’s index is the sum of relative abundances of the two
#' most abundant species of the sample (McNaughton & Wolf, 1970). Index gives
#' values in the unit interval:
#'
#' \deqn{dmn = (N_1 + N_2)/N_tot}
#'
#' where \eqn{N_1} and \eqn{N_2} are the absolute
#' abundances of the two most dominant species and \eqn{N_{tot}} is the sum of
#' absolute abundances of all species.
#'
#' \item 'relative': Relative index equals to the relative abundance of the
#' most dominant n species of the sample (specify the number with the
#' argument \code{ntaxa}).
#' This index gives values in interval 0 to 1.
#'
#' \deqn{relative = N_1/N_tot}
#'
#' where \eqn{N_1} is the absolute abundance of the most
#' dominant species and \eqn{N_{tot}} is the sum of absolute abundances of all
#' species.
#'
#' \item 'simpson_lambda': Simpson's (dominance) index or Simpson's lambda is
#' the sum of squared relative abundances. This index gives values in the unit interval.
#' This value equals the probability that two randomly chosen individuals
#' belongs to the
#' same species. The higher the probability, the greater the dominance (See
#' e.g. Simpson 1949).
#'
#' \deqn{lambda = \sum(p^2)}
#'
#' where p refers to relative abundances.
#'
#' There is also a more advanced Simpson dominance index (Simpson 1949).
#' However, this is not provided and the simpler squared sum of relative
#' abundances is used instead as the alternative index is not in the unit
#' interval and it is highly
#' correlated with the simpler variant implemented here.
#' 
#' }
#' 
#' ## Evenness
#' 
#' Evenness is a standard index in community ecology, and it quantifies how
#' evenly the abundances of different species are distributed. The following
#' evenness indices are provided:
#'
#' By default, this function returns all indices.
#'
#' The available evenness indices include the following (all in lowercase):
#' \itemize{
#'   \item 'camargo': Camargo's evenness (Camargo 1992)
#'   \item 'simpson_evenness': Simpson’s evenness is calculated as inverse Simpson diversity (1/lambda) divided by
#'   observed species richness S: (1/lambda)/S.
#'   \item 'pielou': Pielou's evenness (Pielou, 1966), also known as Shannon or Shannon-Weaver/Wiener/Weiner
#'     evenness; H/ln(S). The Shannon-Weaver is the preferred term; see Spellerberg and Fedor (2003).
#'   \item 'evar': Smith and Wilson’s Evar index (Smith & Wilson 1996).
#'   \item 'bulla': Bulla’s index (O) (Bulla 1994).
#' }
#'   
#' Desirable statistical evenness metrics avoid strong bias towards very
#' large or very small abundances; are independent of richness; and range
#' within the unit interval with increasing evenness (Smith & Wilson 1996).
#' Evenness metrics that fulfill these criteria include at least camargo,
#' simpson, smith-wilson, and bulla. Also see Magurran & McGill (2011)
#' and Beisel et al. (2003) for further details.
#' 
#' ## Richness
#' 
#' The richness is calculated per sample. This is a standard index in community
#' ecology, and it provides an estimate of the number of unique species in the
#' community. This is often not directly observed for the whole community but
#' only for a limited sample from the community. This has led to alternative
#' richness indices that provide different ways to estimate the species
#' richness.
#'
#' Richness index differs from the concept of species diversity or evenness in
#' that it ignores species abundance, and focuses on the binary presence/absence
#' values that indicate simply whether the species was detected.
#'
#' The function takes all index names in full lowercase. The user can provide
#' the desired spelling through the argument \code{\link{name}} (see examples).
#'
#' The following richness indices are provided.
#'
#' \itemize{
#'   
#'   \item 'ace': Abundance-based coverage estimator (ACE) is another
#'   nonparametric richness
#'   index that uses sample coverage, defined based on the sum of the
#'   probabilities
#'   of the observed species. This method divides the species into abundant
#'   (more than 10
#'   reads or observations) and rare groups
#'   in a sample and tends to underestimate the real number of species. The
#'   ACE index
#'   ignores the abundance information for the abundant species,
#'   based on the assumption that the abundant species are observed regardless
#'   of their
#'   exact abundance. We use here the bias-corrected version
#'   (O'Hara 2005, Chiu et al. 2014) implemented in
#'   \code{\link[vegan:specpool]{estimateR}}.
#'   For an exact formulation, see \code{\link[vegan:specpool]{estimateR}}.
#'   Note that this index comes with an additional column with standard
#'   error information.
#'   
#'   \item 'chao1': This is a nonparametric estimator of species richness. It
#'   assumes that rare species carry information about the (unknown) number
#'   of unobserved species. We use here the bias-corrected version
#'   (O'Hara 2005, Chiu et al. 2014) implemented in
#'   \code{\link[vegan:specpool]{estimateR}}. This index implicitly
#'   assumes that every taxa has equal probability of being observed. Note
#'   that it gives a lower bound to species richness. The bias-corrected
#'   for an exact formulation, see \code{\link[vegan:specpool]{estimateR}}.
#'   This estimator uses only the singleton and doubleton counts, and
#'   hence it gives more weight to the low abundance species.
#'   Note that this index comes with an additional column with standard
#'   error information.
#'   
#'   \item 'hill': Effective species richness aka Hill index
#'   (see e.g. Chao et al. 2016).
#'   Currently only the case 1D is implemented. This corresponds to the exponent
#'   of Shannon diversity. Intuitively, the effective richness indicates the
#'   number of
#'   species whose even distribution would lead to the same diversity than the
#'   observed
#'   community, where the species abundances are unevenly distributed.
#'   
#'   \item 'observed': The _observed richness_ gives the number of species that
#'   is detected above a given \code{detection} threshold in the observed sample
#'   (default 0). This is conceptually the simplest richness index. The
#'   corresponding index in the \pkg{vegan} package is "richness".
#'   
#' }
#'
#' @references
#' 
#' Beisel J-N. et al. (2003)
#' A Comparative Analysis of Diversity Index Sensitivity.
#' _Internal Rev. Hydrobiol._ 88(1):3-15.
#' \url{https://portais.ufg.br/up/202/o/2003-comparative_evennes_index.pdf}
#' 
#' Berger WH & Parker FL (1970)
#' Diversity of Planktonic Foraminifera in Deep-Sea Sediments.
#' _Science_ 168(3937):1345-1347. doi: 10.1126/science.168.3937.1345
#' 
#' Bulla L. (1994)
#' An  index of diversity and its associated diversity measure.
#' _Oikos_ 70:167--171
#' 
#' Camargo, JA. (1992)
#' New diversity index for assessing structural alterations in aquatic
#' communities.
#' _Bull. Environ. Contam. Toxicol._ 48:428--434.
#' 
#' Chao A. (1984)
#' Non-parametric estimation of the number of classes in a population.
#' _Scand J Stat._ 11:265–270.
#' 
#' Chao A, Chun-Huo C, Jost L (2016).
#' Phylogenetic Diversity Measures and Their Decomposition:
#' A Framework Based on Hill Numbers. Biodiversity Conservation and
#' Phylogenetic Systematics,
#' Springer International Publishing, pp. 141–172,
#' doi:10.1007/978-3-319-22461-9_8.
#' 
#' Chiu, C.H., Wang, Y.T., Walther, B.A. & Chao, A. (2014).
#' Improved nonparametric lower bound of species richness via a modified
#' Good-Turing frequency formula.
#' _Biometrics_ 70, 671-682.
#' 
#' Faith D.P. (1992)
#' Conservation evaluation and phylogenetic diversity.
#' _Biological Conservation_ 61(1):1-10.
#'
#' Fisher R.A., Corbet, A.S. & Williams, C.B. (1943)
#' The relation between the number of species and the number of individuals in
#' a random sample of animal population.
#' _Journal of Animal Ecology_ *12*, 42-58.
#'
#' Gini C (1921)
#' Measurement of Inequality of Incomes.
#' _The Economic Journal_ 31(121): 124-126. doi: 10.2307/2223319
#' 
#' Locey KJ and Lennon JT. (2016)
#' Scaling laws predict global microbial diversity.
#' _PNAS_ 113(21):5970-5975; doi:10.1073/pnas.1521291113.
#' 
#' Magurran AE, McGill BJ, eds (2011)
#' Biological Diversity: Frontiers in Measurement and Assessment
#' (Oxford Univ Press, Oxford), Vol 12.
#' 
#' McNaughton, SJ and Wolf LL. (1970).
#' Dominance and the niche in ecological systems.
#' _Science_ 167:13, 1--139
#' 
#' O'Hara, R.B. (2005).
#' Species richness estimators: how many species can dance on the head of a pin?
#' _J. Anim. Ecol._ 74, 375-386.
#' 
#' Pielou, EC. (1966)
#' The measurement of diversity in different types of
#' biological collections. _J Theoretical Biology_ 13:131--144.
#'
#' Simpson EH (1949)
#' Measurement of Diversity.
#' _Nature_ 163(688). doi: 10.1038/163688a0
#' 
#' Smith B and Wilson JB. (1996)
#' A Consumer's Guide to Evenness Indices.
#' _Oikos_ 76(1):70-82.
#'
#' Spellerberg and Fedor (2003).
#' A tribute to Claude Shannon (1916 –2001) and a plea for more rigorous use of
#' species richness, species diversity and the ‘Shannon–Wiener’ Index.
#' _Alpha Ecology & Biogeography_ 12, 177–197.
#'
#' @seealso
#' \itemize{
#'   \item \code{\link[scater:plotColData]{plotColData}}
#'   \item \code{\link[vegan:specpool]{estimateR}}
#'   \item \code{\link[vegan:diversity]{diversity}}
#' }
#' 
#' 
#' @examples
#' 
#' data("GlobalPatterns")
#' tse <- GlobalPatterns
#' 
#' # Calculate the default Shannon index with no rarefaction
#' tse <- addAlpha(tse, index = "shannon")
#' 
#' # Shows the estimated Shannon index
#' tse$shannon
#'
#' # Calculate observed richness with 10 rarefaction rounds
#' tse <- addAlpha(tse,
#'    assay.type = "counts",
#'    index = "observed_richness",
#'    sample = min(colSums(assay(tse, "counts")), na.rm = TRUE),
#'    niter=10)
#' 
#' # Shows the estimated observed richness
#' tse$observed_richness
#' 
#' @name addAlpha
#' @export
NULL

#' @rdname addAlpha
#' @export
setGeneric(
    "addAlpha", signature = c("x"),
    function(
        x, assay.type = "counts", 
        index = c(
            "coverage_diversity", "fisher_diversity", "faith_diversity",
            "gini_simpson_diversity", "inverse_simpson_diversity",
            "log_modulo_skewness_diversity", "shannon_diversity",
            "absolute_dominance", "dbp_dominance",
            "core_abundance_dominance", "gini_dominance",
            "dmn_dominance", "relative_dominance",
            "simpson_lambda_dominance", "camargo_evenness",
            "pielou_evenness", "simpson_evenness",
            "evar_evenness", "bulla_evenness", "ace_richness",
            "chao1_richness", "hill_richness", "observed_richness"),
        name = index, niter = NULL, ...)
    standardGeneric("addAlpha"))

#' @rdname addAlpha
#' @export
setMethod("addAlpha", signature = c(x = "SummarizedExperiment"),
    function(
        x, assay.type = "counts", 
        index = c(
            "coverage_diversity", "fisher_diversity", "faith_diversity",
            "gini_simpson_diversity", "inverse_simpson_diversity",
            "log_modulo_skewness_diversity", "shannon_diversity",
            "absolute_dominance", "dbp_dominance",
            "core_abundance_dominance", "gini_dominance",
            "dmn_dominance", "relative_dominance",
            "simpson_lambda_dominance", "camargo_evenness",
            "pielou_evenness", "simpson_evenness",
            "evar_evenness", "bulla_evenness", "ace_richness",
            "chao1_richness", "hill_richness", "observed_richness"),
        name = index, niter = NULL, ...){
        ############################## Input check #############################
        # Check that index is a character vector
        if( !.is_non_empty_character(index) ){
            stop("'index' should be a character vector.", call. = FALSE)
        }
        # if multiple indices to be estimated, name should a vector of
        # same length
        if( !.is_non_empty_character(name) || length(name) != length(index) ){
            stop(
                "'name' must be a non-empty character value and have the ",
                "same length than 'index'.",
                call. = FALSE)
        }
        # Check n.tier
        if( !(is.null(niter) || (.is_an_integer(niter) && niter >= 0)) ){
            stop("'niter' must be NULL or an integer.", call. = FALSE)
        }
        # Check if index exists. For each index input, detect it and get
        # information (e.g. internal function) to calculate the index.
        index <- .get_indices(index, name, x, assay.type, ...)

        ############################ Input check end ###########################
        # Looping over the vector of indices to be estimated
        for( i in seq_len(nrow(index)) ){
            # Performing rarefaction if sample is specified
            if( !is.null(niter) && niter > 0 ){
                x <- .alpha_rarefaction(
                    x, assay.type = assay.type, niter = niter,
                    FUN = index[i, "FUN"], index = index[i, "index"],
                    name = index[i, "name"], ...)
            } else {
                # Estimate index without rarefaction
                args <- c(
                    list(x, assay.type = assay.type, index = index[i, "index"],
                        name = index[i, "name"]), list(...))
                x <- do.call(index[i, "FUN"], args = args)
            }
        }
        return(x)
    }
)

################################ HELP FUNCTIONS ################################

# Search alpha diversity index that user wants to calculate.

.get_indices <- function(index, name, x, assay.type, tree = NULL,...){
    # Initialize list for supported indices
    supported <- list()
    # Supported diversity indices
    temp <- c(
        "coverage", "faith", "fisher", "gini_simpson", "inverse_simpson",
        "log_modulo_skewness", "shannon")
    temp <- data.frame(index = temp)
    temp[["measure"]] <- "diversity"
    temp[["index_long"]] <- paste0(temp[["index"]], "_", temp[["measure"]])
    temp[["FUN"]] <- ".estimate_diversity"
    temp[["non_neg"]] <- c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE)
    supported[["diversity"]] <- temp
    # Supported dominance indices
    temp <- c(
        "absolute", "dbp", "core_abundance", "gini", "dmn", "relative",
        "simpson_lambda")
    temp <- data.frame(index = temp)
    temp[["measure"]] <- "dominance"
    temp[["index_long"]] <- paste0(temp[["index"]], "_", temp[["measure"]])
    temp[["FUN"]] <- ".estimate_dominance"
    temp[["non_neg"]] <- c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
    supported[["dominance"]] <- temp
    # Supported evenness indices
    temp <- c(
        "camargo", "pielou", "simpson", "evar", "bulla")
    temp <- data.frame(index = temp)
    temp[["measure"]] <- "evenness"
    temp[["index_long"]] <- paste0(temp[["index"]], "_", temp[["measure"]])
    temp[["FUN"]] <- ".estimate_evenness"
    temp[["non_neg"]] <- c(FALSE, FALSE, FALSE, FALSE, FALSE)
    supported[["eveness"]] <- temp
    # Supported richness indices
    temp <- c(
        "ace", "chao1", "hill", "observed")
    temp <- data.frame(index = temp)
    temp[["measure"]] <- "richness"
    temp[["index_long"]] <- paste0(temp[["index"]], "_", temp[["measure"]])
    temp[["FUN"]] <- ".estimate_richness"
    temp[["non_neg"]] <- c(FALSE, FALSE, FALSE, FALSE)
    supported[["richness"]] <- temp
    # Combine
    supported <- do.call(rbind, supported)
    # Find the index that user wants to calculate
    ind <- match(tolower(index), supported[["index_long"]])
    ind_short <- match(tolower(index), supported[["index"]])
    ind[ is.na(ind) ] <- ind_short[ is.na(ind) ]
    detected <- supported[ind, ]
    # Add the index that was searched
    detected[["search"]] <- index
    # Add names that user wants to use when storing results to colData
    detected[["name"]] <- name
    # Check if there are indices that were not detected
    if( any(is.na(detected[["index"]])) ){
        not_detected <- paste0(
            detected[is.na(detected[["index"]]), "search"], collapse = "', '")
        not_detected <- paste0("'", not_detected, "'")
        stop(
            "'index' is corresponding to none of the alpha diversity ",
            "indices. The following 'index' was not detected: ", not_detected,
            call. = FALSE)
    }
    # Faith index is available only for TreeSE with rowTree
    tse_with_tree <- (is(x, "TreeSummarizedExperiment") &&
        !is.null(rowTree(x))) || !is.null(tree)
    if( "faith" %in% detected[["index"]] && !tse_with_tree ){
        # Drop faith index from indices being calculated
        detected <- detected[!detected[["index"]] %in% c("faith"), ]
        # If there are still other indices being calculated, give warning.
        # Otherwise, give error if faith was the only index that user wants to
        # calculate.
        FUN <- if( nrow(detected) == 0 ) stop else warning
        FUN("'faith' index can be calculated only for TreeSE with rowTree(x) ",
            "populated or with 'tree' provided separately.", call. = FALSE)
    }
    # Check for unsupported values (negative values)
    if( any(assay(x, assay.type) < 0) ){
        ind <- detected[["non_neg"]]
        index_rm <- detected[!ind, "index"]
        detected <- detected[ind, ]
        if( length(index_rm) > 0 ){
            FUN <- if (nrow(detected) == 0) stop else warning
            FUN("The following indices cannot be calculated due to unsupported 
                values (negative values): ", paste(index_rm, collapse = ", "), 
                call. = FALSE)
        }
    }
    return(detected)
}

# This function rarifies the data niter of times and calculates index for the
# rarified data. The result is a mean of the iterations.
#' @importFrom DelayedMatrixStats colMeans2
.alpha_rarefaction <- function(
        x, assay.type, niter, FUN, index, name, ...){
    # Calculating the mean of the subsampled alpha estimates ans storing them
    res <- lapply(seq(niter), function(i){
        # Subsampling the counts from the original TreeSE object.
        x_sub <- rarefyAssay(x, assay.type = assay.type, verbose = FALSE, ...)
        # Calculating the diversity indices on the subsampled object
        x_sub <- do.call(FUN, args = list(
            x_sub, assay.type = assay.type, index = index,
            name = "rarefaction_temp_result", list(...)))
        # Get results as a vector from colData
        temp <- colData(x_sub)[["rarefaction_temp_result"]]
        names(temp) <- colnames(x_sub)
        return(temp)
    })
    # Combine list of vectors from multiple iterations
    res <- do.call(rbind, res)
    # Calculate mean of iterations
    res <- colMeans2(res)
    # Give warning about missing samples. Same might have been dropped during
    # rarefaction leading to missing values for dropped samples.
    if( !all(colnames(x) %in% names(res)) ){
        warning(
            "Some samples were dropped during rarefaction leading to missing ",
            "diversity values. Consider lower 'sample'.", call. = FALSE)
    }
    # It might be that certain samples were dropped off if they have lower
    # abundance than rarefaction  depth --> order so that data includes all the
    # samples
    res <- res[match(colnames(x), names(res))]
    res <- unname(res)
    # Add to original data. The data must be in a list.
    res <- list(res)
    x <- .add_values_to_colData(x, res, name)
    return(x)
}
