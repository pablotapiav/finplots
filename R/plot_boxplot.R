
#' plot_boxplot create a boxplot
#' @param data A \code{data.frame} with al least two variables.
#'    \enumerate{
#'    \item first variable represents dates (date format) min: daily basis (intraday not supported right now)
#'    \item{from second variable it supports numeric values (prices)}
#' }

#' @param method A string. \code{"raw"} if you want to plot data as it comes. \code{"comparison"} transforms data on to a common base (factor 100).
#' @param frequency A string. Representing how do you want to see return values.
#' @returns a boxplot using \code{ggplot2} as base. According to your parameters will show returns on the \code{frequency} you selected.
#' @examples
#' ##Dummy example using base data()
#' airmiles_df <- data.frame(
#' date = as.Date(paste0(time(airmiles), "-01-01")),
#' airmiles = as.numeric(airmiles))
#'
#' #This will generate expected plot:
#' plot_boxplot(airmiles_df, method = "raw", frequency = "yearly")
#'
#' #For more advanced examples please visit github site.
#' @export
#'


plot_boxplot <- function(data, method = c("raw","comparison"), frequency =  c("daily", "weekly", "monthly", "yearly")) {

  last_col <- price_cols  <- variable  <- value  <- NULL

  #Set names
  date_col <- colnames(data)[1]
  price_cols <- colnames(data)[-1]

  #Checking parameters
  allowed_frequencies <- c("daily", "weekly", "monthly", "yearly")
  if (!(frequency %in% allowed_frequencies)) {
    stop("Invalid frequency value. Allowed values are daily, weekly, monthly, and yearly.")
  }

  allowed_method <- c("raw", "comparison")
  if (!(method %in% allowed_method)) {
    stop("Invalid method value. Allowed values are raw or comparison.")
  }

  #Internal Function
  #df <- tidy_data(data, frequency)

  #If any row contains a NA, entire row is deleted
  #df <- df[complete.cases(df), ]

  if (method == "raw") {

    df = data[complete.cases(data), ]

  } else if (method == "comparison") {
    #Internal Function
    df <- tidy_data(data, frequency)

    #If any row contains a NA, entire row is deleted
    df <- df[complete.cases(df), ]
    # Insert a 100 in the first row
    df[1, 2:length(df)] <- 99

    # Calculate cumulative returns using cumprod
    df <- df %>%
      dplyr::ungroup() %>%
      dplyr::mutate(dplyr::across(2:last_col(), ~ cumprod(1 + .),
        .names = "{.col}_cumulative_return"
      )) %>%
      dplyr::select(1, contains("_cumulative_return"))
  } else {
    print("")
  }

  #return to original names
  colnames(df)[-1] <- price_cols

  #melt function creates a long table useful for ggplot
  dfplot <- reshape2::melt(df, id = 1)

  #Several cases for title & caption (plot)
  title <- if (length(df) == 2) {
    paste0("Boxplot for: ", price_cols[1])
  } else if (length(df) == 3) {
    paste0("Boxplot for: ", price_cols[1], " & ", price_cols[2])
  } else {
    paste0("Boxplot")
  }

  #Several cases for title & caption (plot)
  sub_freq <- if (method == "raw") {
    paste0("")
  } else if (method == "comparison") {
    paste0(frequency)
  } else {}

  #Several cases for caption (plot)
  caption <- if (method == "raw") {
    paste0("Each point is a value coming from original data.")
  } else if (method == "comparison") {
    paste0("Daily returns starting with base 100.")
  } else {}

  #Building a plot
  plot <- ggplot2::ggplot(dfplot, aes(variable, value, fill = variable)) +
    ggplot2::geom_boxplot(alpha = 0.8) +
   ggplot2::geom_jitter(aes(colour = variable), alpha = 0.1) +
    ggplot2::labs(
      title = title,
      subtitle = paste0("Data range: ", dfplot[1, 1], " / ", dfplot[nrow(dfplot), 1], " (", sub_freq, ")"),
      caption = caption
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = element_text(colour = "#282828", face = "bold", size = 18),
      plot.subtitle = element_text(colour = "#757575", size = 12),
      legend.position = "bottom", panel.background = element_rect(fill = "#F9F9F9"),
      plot.background = element_rect(fill = "#F9F9F9"), legend.background = element_rect(fill = "#F9F9F9")
    )

  #Hint messages
  if (method == "raw") {
    print("Hint: Each value is a return if you want a common base use method = comparison.")
  } else {
    print("Building your plot.")
  }

  if (nrow(data) > 1000) {
    print("Hint: If there are too many values, consider changing requency argument to transform it into a monthly or yearly basis.")
  } else { }


  return(plot)
}
