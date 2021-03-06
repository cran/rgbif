#' Get number of occurrence records.
#'
#' @export
#'
#' @param taxonKey Species key
#' @param georeferenced Return only occurrence records with lat/long data
#' (`TRUE`) or those that don't have that data (`FALSE`, default). Note that
#' you can also get record count with [occ_search()] by setting `limit=0`
#' @param basisOfRecord Basis of record
#' @param datasetKey Dataset key
#' @param date Collection date
#' @param typeStatus A type status. See [typestatus()] dataset for
#' options
#' @param year Year data were collected in
#' @param country Country data was collected in, two letter abbreviation. See
#' https://countrycode.org/ for abbreviations.
#' @param protocol Protocol. E.g., 'DWC_ARCHIVE'
#' @param publishingCountry Publishing country, two letter ISO country code
#' @param from Year to start at
#' @param to Year to end at
#' @param type One of count (default), schema, basisOfRecord, countries, or
#' year.
#' @template occ
#'
#' @return A single numeric value, or a list of numerics.
#' @references https://www.gbif.org/developer/occurrence#metrics
#'
#' @details There is a slight difference in the way records are counted here vs.
#' results from [occ_search()]. For equivalent outcomes, in the
#' [occ_search()] function use `hasCoordinate=TRUE`, and
#' `hasGeospatialIssue=FALSE` to have the same outcome for this function
#' using `georeferenced=TRUE`.
#'
#' @section Supported dimensions:
#' That is, there are only a certain set of supported query parameter
#' combinations that GBIF allows on this API route. They can be found with the
#' call `occ_count(type='schema')`. They are also presented below:
#'
#' - basisOfRecord
#' - basisOfRecord, country
#' - basisOfRecord, country, isGeoreferenced
#' - basisOfRecord, country, isGeoreferenced, taxonKey
#' - basisOfRecord, country, taxonKey
#' - basisOfRecord, datasetKey
#' - basisOfRecord, datasetKey, isGeoreferenced
#' - basisOfRecord, datasetKey, isGeoreferenced, taxonKey
#' - basisOfRecord, datasetKey, taxonKey
#' - basisOfRecord, isGeoreferenced, taxonKey
#' - basisOfRecord, isGeoreferenced, publishingCountry
#' - basisOfRecord, isGeoreferenced, publishingCountry, taxonKey
#' - basisOfRecord, publishingCountry
#' - basisOfRecord, publishingCountry, taxonKey
#' - basisOfRecord, taxonKey
#' - country
#' - country, datasetKey, isGeoreferenced
#' - country, isGeoreferenced
#' - country, isGeoreferenced, publishingCountry
#' - country, isGeoreferenced, taxonKey
#' - country, publishingCountry
#' - country, taxonKey
#' - country, typeStatus
#' - datasetKey
#' - datasetKey, isGeoreferenced
#' - datasetKey, isGeoreferenced, taxonKey
#' - datasetKey, issue
#' - datasetKey, taxonKey
#' - datasetKey, typeStatus
#' - isGeoreferenced
#' - isGeoreferenced, publishingCountry
#' - isGeoreferenced, publishingCountry, taxonKey
#' - isGeoreferenced, taxonKey
#' - issue
#' - publishingCountry
#' - publishingCountry, taxonKey
#' - publishingCountry, typeStatus
#' - taxonKey
#' - taxonKey, typeStatus
#' - typeStatus
#' - protocol
#' - year
#'
#' @examples \dontrun{
#' occ_count(basisOfRecord='OBSERVATION')
#' occ_count(georeferenced=TRUE)
#' occ_count(country='DE')
#' occ_count(country='CA', georeferenced=TRUE, basisOfRecord='OBSERVATION')
#' occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#' occ_count(year=2012)
#' occ_count(taxonKey=2435099)
#' occ_count(taxonKey=2435099, georeferenced=TRUE)
#'
#' # Just schema
#' occ_count(type='schema')
#'
#' # Counts by basisOfRecord types
#' occ_count(type='basisOfRecord')
#' 
#' # Counts by basisOfRecord types and taxonkey
#' occ_count(taxonKey=2435099, basisOfRecord='OBSERVATION')
#'
#' # Counts by typeStatus
#' occ_count(typeStatus='ALLOTYPE')
#' occ_count(typeStatus='HOLOTYPE')
#'
#' # Counts by countries. publishingCountry must be supplied (default to US)
#' occ_count(type='countries')
#'
#' # Counts by year. from and to years have to be supplied, default to 2000
#' # and 2012
#' occ_count(type='year', from=2000, to=2012)
#'
#' # Counts by publishingCountry, must supply a country (default to US)
#' occ_count(type='publishingCountry')
#' occ_count(type='publishingCountry', country='BZ')
#'
#' # Pass on curl options
#' occ_count(type='year', from=2000, to=2012, curlopts = list(verbose = TRUE))
#' }

occ_count <- function(taxonKey = NULL, georeferenced = NULL,
  basisOfRecord = NULL, datasetKey = NULL, date = NULL, typeStatus = NULL,
  country = NULL, year = NULL, from = 2000, to = 2012, type = 'count', 
  publishingCountry = 'US', protocol = NULL, curlopts = list()) {

  args <- rgbif_compact(
    list(
      taxonKey=taxonKey, isGeoreferenced=asl(georeferenced),
      basisOfRecord=basisOfRecord, datasetKey=datasetKey,
      date=date, typeStatus=typeStatus,
      country=country, year=year, protocol=protocol))
  type <- match.arg(type, choices=c("count","schema","basisOfRecord",
                                    "countries","year","publishingCountry"))
  url <- switch(type,
                count = paste0(gbif_base(), '/occurrence/count'),
                schema = paste0(gbif_base(), '/occurrence/count/schema'),
                basisOfRecord = paste0(gbif_base(),
                                       '/occurrence/counts/basisOfRecord'),
                countries = paste0(gbif_base(), '/occurrence/counts/countries'),
                year = paste0(gbif_base(), '/occurrence/counts/year'),
                publishingCountry = paste0(
                  gbif_base(),
                  '/occurrence/counts/publishingCountries'))
  args <- switch(type,
                count = args,
                schema = list(),
                basisofRecord = list(),
                countries = rgbif_compact(
                  list(publishingCountry=publishingCountry)),
                year = rgbif_compact(list(from=from, to=to)),
                publishingCountry =
                  rgbif_compact(
                    list(country=ifelse(is.null(country), "US", country) )))
  res <- gbif_GET_content(url, args, curlopts)
  if (type == 'count') as.numeric(res) else jsonlite::fromJSON(res, FALSE)
}
