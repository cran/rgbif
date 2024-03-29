% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gbif_citation.R
\name{gbif_citation}
\alias{gbif_citation}
\title{Get citation for datasets used}
\usage{
gbif_citation(x)
}
\arguments{
\item{x}{(character) Result of call to \code{\link[=occ_search]{occ_search()}}, \code{\link[=occ_data]{occ_data()}},
\code{\link[=occ_download_get]{occ_download_get()}}, \code{\link[=occ_download_meta]{occ_download_meta()}}, a dataset key, or occurrence key
(character or numeric)}
}
\value{
list with S3 class assigned, used by a print method to pretty print
citation information. Though you can unclass the output or just index to the
named items as needed.
}
\description{
Get citation for datasets used
}
\details{
Returns a set of citations, one for each dataset. We pull out
unique dataset keys and get citations, so the length of citations may not
be equal to the number of records you pass in.

Currently, this function gives back citations at the dataset level, not
at the individual occurrence level. If occurrence keys are passed in, then
we track down the dataset the key is from, and get the citation for
the dataset.
}
\examples{
\dontrun{

# character class inputs
## pass in a dataset key
gbif_citation(x='0ec3229f-2b53-484e-817a-de8ceb1fce2b')
## pass in an occurrence key
# gbif_citation(x='1101144669')

# pass in an occurrence key as a numeric (won't work for a dataset key)
# gbif_citation(x=1101144669)

# Downloads
## occ_download_get()
# d1 <- occ_download(pred("country", "BG"), pred_gte("year", 2020))
# occ_download_meta(d1) # wait until status = succeeded
# d1 <- occ_download_get(d1, overwrite = TRUE)
# gbif_citation(d1)

## occ_download_meta()
# key <- "0000122-171020152545675"
# res <- occ_download_meta(key)
# gbif_citation(res)
}
}
