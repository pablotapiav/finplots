
#' plot_distr create a distribution plot
#' @param data A \code{data.frame} with al least two variables.
#'    \enumerate{
#'    \item first variable represents dates (date format) min: daily basis (intraday not supported right now)
#'    \item{from second variable it supports numeric values (prices)}
#' }
#' @param frequency A string representing how do you want to see return values
#' @returns a distribution plot using [ggplot2] as base. According to your parameters will show returns on the \code{frequency} you selected.
#' @examples
#' ##Dummy example using base data()
#' airmiles_df <- data.frame(
#' date = as.Date(paste0(time(airmiles), "-01-01")),
#' airmiles = as.numeric(airmiles))
#' plot_distr(airmiles_df, frequency = "daily") #This will generate expected plot.
#'
#' #For more advanced examples please visit github site.
#' @export

plot_distr <- function(data, frequency = c("daily", "weekly", "monthly", "yearly")) {

  value <- variable <- NULL

  #Checking parameters
  allowed_frequencies <- c("daily", "weekly", "monthly", "yearly")
  if (!(frequency %in% allowed_frequencies)) {
    stop("Invalid frequency value. Allowed values are daily, weekly, monthly, and yearly.")
  }

  #Internal Function
  df <- tidy_data(data, frequency)

  # If any variable has NA, complete row is deleted
  df <- df[complete.cases(df), ]

  #melt function creates a long table useful for ggplot
  dfplot <- reshape2::melt(df, id = 1)

  # Generate a plot
  plot <- ggplot2::ggplot(dfplot, aes(x = value * 100, fill = variable)) +
    ggplot2::geom_density(alpha = 0.6, position = "stack") +
    ggplot2::labs(
      title = "Return Distribution",
      subtitle = paste0("Data range: ", dfplot[1, 1], " / ", dfplot[nrow(dfplot), 1]), caption = "Return behaviour",
      x = "Values (in %)"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = element_text(colour = "#282828", face = "bold", size = 18),
      plot.subtitle = element_text(colour = "#757575", size = 12),
      legend.position = "bottom", panel.background = element_rect(fill = "#F9F9F9"),
      plot.background = element_rect(fill = "#F9F9F9"), legend.background = element_rect(fill = "#F9F9F9")
    )

  return(plot)
}
