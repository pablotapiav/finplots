
#' tidy_bbg prepare your data coming from bbg using Rblpapi.
#' @param df_list A list. This object comes from your call to bbg. And prepare it to use it with finplots.
#' @returns a `data.frame`.
#' @examples
#' \dontrun{
#' #Some tickers:
#' names <- c("IPSA Index", "SPX Index")
#'
#' Rblapi::bdh() is a function that calls data from bbg.
#'
#' databbg <- bdh(
#'   securities = names,
#'   fields = "PX_LAST",
#'   start.date = as.Date("2013-06-01"),
#'   end.date = as.Date("2023-06-01")
#' )
#'
#' #Apply function:
#' #dataplot <- tidy_bbg(databbg)
#'
#' #Then you can use it on any finplot function:
#' plot_line(dataplot, method = "comparison", frequency = "daily", display = "plot")
#' #This will generate expected plot.
#'
#' For more advanced examples please visit github site.
#' }
#' @seealso \href{https://dirk.eddelbuettel.com/code/rblpapi.html}{Rblpapi}, [Rblpapi::bdh()]

#' @export

tidy_bbg <- function(df_list) {
  combined_df <- df_list %>%
    purrr::reduce(dplyr::full_join, by = "date") %>%
    dplyr::select(date, dplyr::starts_with("PX_LAST"), tidyr::everything())

  # trabajo colnames
  new_colnames <- gsub("Equity|Index", "", names(df_list))
  colnames(combined_df)[2:length(combined_df)] <- new_colnames


  return(combined_df)
}
