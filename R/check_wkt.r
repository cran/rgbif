#' Check input WKT
#' 
#' @import assertthat rgeos plyr
#' @importFrom stringr str_extract
#' @export
#' @param wkt A Well Known Text object
#' @examples 
#' check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
#' check_wkt('POINT(30.1 10.1)')
#' check_wkt('LINESTRING(3 4,10 50,20 25)')
#' 
#' # this passes this check, but isn't valid for GBIF
#' wkt <- 'POLYGON((-178.59375 64.83258989321493,-165.9375 59.24622380205539,
#' -147.3046875 59.065977905449806,-130.78125 51.04484764446178,-125.859375 36.70806354647625,
#' -112.1484375 23.367471303759686,-105.1171875 16.093320185359257,-86.8359375 9.23767076398516,
#' -82.96875 2.9485268155066175,-82.6171875 -14.812060061226388,-74.8828125 -18.849111862023985,
#' -77.34375 -47.661687803329166,-84.375 -49.975955187343295,174.7265625 -50.649460483096114,
#' 179.296875 -42.19189902447192,-176.8359375 -35.634976650677295,176.8359375 -31.835565983656227,
#' 163.4765625 -6.528187613695323,152.578125 1.894796132058301,135.703125 4.702353722559447,
#' 127.96875 15.077427674847987,127.96875 23.689804541429606,139.921875 32.06861069132688,
#' 149.4140625 42.65416193033991,159.2578125 48.3160811030533,168.3984375 57.019804336633165,
#' 178.2421875 59.95776046458139,-179.6484375 61.16708631440347,-178.59375 64.83258989321493))'
#' check_wkt(gsub("\n", '', wkt))

check_wkt <- function(wkt=NULL){
  if(!is.null(wkt)){
    assert_that(is.character(wkt))
    y <- str_extract(wkt, "[A-Z]+")
    if(!y %in% c('POINT','POLYGON','LINESTRING','LINEARRING')) 
      stop("WKT must be of type POINT, POLYGON, LINESTRING, or LINEARRING")
#     res <- try_default(readWKT(wkt), 'notvalid', quiet = TRUE)
    res <- tryCatch(readWKT(wkt), error = function(e) e)
    if(!is(res, 'Spatial'))
#       stop(sprintf("Your WKT malformed somehow:\n%s", res), call. = FALSE)
      stop(res)
    wkt
  } else { NULL }
}