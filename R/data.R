#' Example code list for object types
#'
#' Contains fictional codes for various types of objects
#'
#' \itemize{
#'   \item \code{code} the code used for the object
#'   \item \code{label} label of the code
#'   \item \code{parent} the parent of the object in the hierarchy
#'   \item \code{locale} the locale of the label of the code
#'   \item \code{missing} should the code be treated as a missing value
#' }
#'
#' @docType data
#' @keywords datasets
#' @name objectcodes
#' @format Data frame with 16 records and 5 columns.
NULL

#' Example data set to demonstrate working with code lists
#'
#' Contains fictional data with sales of various types of objects.
#'
#' \itemize{
#'   \item \code{product} the code used for the object. Corresponds
#'     to codes in \code{\link{objectcodes}}.
#'   \item \code{unitprice} price per object.
#'   \item \code{quantity} number of objects sold.
#'   \item \code{totalprice} total price of sold objects.
#' }
#'
#' @docType data
#' @keywords datasets
#' @name objectsales
#' @format Data frame with 100 records and 4 columns.
NULL

