#' Get quick pre-computed occurrence counts of a limited number of dimensions. 
#' @name occ_count_
#' @param publishingCountry The 2-letter country code (as per ISO-3166-1)
#' the country from which the occurrence was published.
#' @param country (character) The 2-letter country code (ISO-3166-1) 
#' in which the occurrence was recorded.
#' @param year The 4 digit year. Supports range queries, 'smaller,larger' 
#' (e.g., '1990,1991', whereas 1991, 1990' wouldn't work).
#' @param curlopts (list) curl options.
#' 
#' @details 
#' Get quick pre-computed counts of a limited number of dimensions. 
#' 
#' `occ_count_country()` will return a data.frame with occurrence counts by 
#' country. By using `occ_count_country(publishingCountry="DK")` will
#' return the occurrence contributions Denmark has made to each country.
#' 
#' `occ_count_pub_country()` will return a data.frame with occurrence counts by 
#' publishing country. Using `occ_count_pub_country(country="DK")`, will return
#' the occurrence contributions each country has made to that focal `country=DK`.  
#'   
#' `occ_count_year()` will return a data.frame with the total occurrences 
#' mediated by GBIF for each year. By using `occ_counts_year(year="1800,1900")`
#' will only return counts for that range.
#' 
#' `occ_count_basis_of_record()` will return a data.frame with total occurrences
#' mediated by GBIF for each basis of record. 
#' 
#' @return
#' A `data.frame` of counts. 
#'
#' @seealso [occ_count()]
#'
#' @examples \dontrun{
#' # total occurrence counts for all countries and iso2 places
#' occ_count_country()  
#' # the occurrences Mexico has published in other countries 
#' occ_count_country("MX") 
#' # the occurrences Denmark has published in other countries 
#' occ_count_country("DK")
#' 
#' # the occurrences other countries have published in Denmark
#' occ_count_pub_country("DK")
#' # the occurrences other countries have published in Mexico
#' occ_count_pub_country("MX")
#' 
#' # total occurrence counts for each year that an occurrence was 
#' # recorded or collected.
#' occ_count_year()
#' # supports ranges
#' occ_count_year("1800,1900")
#' 
#' # table of occurrence counts by basis of record
#' occ_count_basis_of_record()
#' 
#' }
#' @export
#' @rdname occ_count_
occ_count_country <- function(publishingCountry = NULL) {
  assert(publishingCountry,"character")
  url <- paste0(gbif_base(),'/occurrence/counts/countries')
  args <- rgbif_compact(list(publishingCountry=publishingCountry))
  res <- tibble::as_tibble(gbif_GET(url,args=args))
  res <- data.table::transpose(res,keep.names="x")
  res <- stats::setNames(res,c("enumName","count"))
  res <- merge(res,enumeration_country(),by="enumName")
  res <- res[c("title","enumName","iso2","iso3","isoNumerical","gbifRegion","count")]
  res[rev(order(res$count)),]
}

#' @export
#' @rdname occ_count_
occ_count_pub_country <- function(country = NULL) {
  assert(country,"character")
  if(is.null(country)) stop("Supply a iso2 countrycode.")
  url <- paste0(gbif_base(),'/occurrence/counts/publishingCountries')
  res <- tibble::as_tibble(gbif_GET(url,args=list(country=country)))
  res <- data.table::transpose(res,keep.names="x")
  res <- stats::setNames(res,c("enumName","count"))
  res <- merge(res,enumeration_country(),by="enumName")
  res <- res[c("title","enumName","iso2","iso3","isoNumerical","gbifRegion","count")]
  res[rev(order(res$count)),]
}

#' @export
#' @rdname occ_count_
occ_count_year <- function(year=NULL) {
  url <- paste0(gbif_base(),'/occurrence/counts/year')
  res <- tibble::as_tibble(gbif_GET(url,args=list(year=year)))
  res <- data.table::transpose(res,keep.names="x")
  res <- stats::setNames(res,c("year","count"))
  res[rev(order(res$year)),]
}

#' @export
#' @rdname occ_count_
occ_count_basis_of_record <- function(curlopts=list()) {
  url <- paste0(gbif_base(),'/occurrence/counts/basisOfRecord')
  res <- tibble::as_tibble(gbif_GET(url,args=NULL))
  res <- data.table::transpose(res,keep.names="x")
  res <- stats::setNames(res,c("basisOfRecord","count"))
  res[rev(order(res$count)),]
}
