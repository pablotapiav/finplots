
#' plot_line creates a line plot
#' @param data A \code{data.frame} with al least two variables.
#'    \enumerate{
#'    \item first variable represents dates (date format) min: daily basis (intraday not supported right now)
#'    \item{from second variable it supports numeric values (prices)}
#' }

#' @param method A string. \code{"raw"} if you want to plot data as it comes. \code{"comparison"} transforms data on to a common base (factor 100). \code{"returns"} transform your data using ((today/yesterday) -1) formula.
#' @param frequency A string. Representing how do you want to see values.
#' @param display A string. In case you want to return data instead of a plot object.
#' @returns according to your \code{"display"} value:
#'   \enumerate{
#'    \item a plot(default): using \code{ggplot2} as base. According to your parameters will show returns on the \code{frequency} you selected.
#'    \item{a table: returns a dataframe with parameters you selected. Useful if you want to run a sanity check}
#' }
#' @examples
#' ##Dummy example using base data()
#' airmiles_df <- data.frame(
#' date = as.Date(paste0(time(airmiles), "-01-01")),
#' airmiles = as.numeric(airmiles))
#' plot_line(airmiles_df, method = "raw", frequency = "yearly", display = "plot")
#' #This will generate expected plot.
#'
#' #If you only need store data:
#' dummy = plot_line(airmiles_df, method = "raw", frequency = "yearly", display = "table")
#' #This will generate expected plot.
#'
#' #For more advanced examples please visit github site.
#' @export

plot_line <- function(data, method = c("raw", "comparison", "returns"), frequency = c("daily", "weekly", "monthly", "yearly"), display = c("plot","table")) {

   cumulative_returns <- last_col <- last_price <- monthly_return <- price <- price_cols <- stock <- value <- variable <- weekly_return <- year_month <- year_week <- yearly_return <- NULL

   year_month  <- stock  <- price  <- last_price  <- yearly_return  <- year_week  <- weekly_return  <- value  <- variable  <- cumulative_returns <- NULL

  #Checking parameters
  allowed_methods <- c("raw", "comparison", "returns")
  if (!(method %in% allowed_methods)) {
    stop("Invalid method value. Allowed values are raw, returns, or comparison.")
  }

  allowed_frequencies <- c("daily", "weekly", "monthly", "yearly")
  if (!(frequency %in% allowed_frequencies)) {
    stop("Invalid frequency value. Allowed values are daily, weekly, monthly, and yearly.")
  }

  allowed_display <- c("plot", "table")
  if (!(display %in% allowed_display)) {
    stop("Invalid display value. Allowed values are plot or table.")
  }

  #return to original names
  price_cols <- colnames(data)[-1]

  #If any row contains a NA, entire row is deleted
  data <- data[complete.cases(data), ]

  #Several combinations according to arguments passed
  if (method == "returns") {
    df <- tidy_data(data, frequency)

  } else if (method == "raw" & frequency == "daily") {
    df <- data

  } else if (method == "raw" & frequency == "monthly") {
    # Convert the 'date' column to proper date format
    data[[1]] <- as.Date(data[[1]])

    # Create a new column for year and month
    data$year_month <- format(data[[1]], "%Y-%m")

    #If any row contains a NA, entire row is deleted
    data <- data[complete.cases(data), ]

    # Transform to monthly returns
    data_long <- data %>%
      tidyr::pivot_longer(cols = starts_with(price_cols), names_to = "stock", values_to = "price")

    data_long <- data_long %>%
      dplyr::group_by(year_month, stock) %>%
      dplyr::summarize(last_price = last(price))

    # Reshape the data back to wide format
    data_wide <- data_long %>%
      tidyr::pivot_wider(names_from = stock, values_from = last_price)

    # Turn year_month in to a date format column
    data_wide$year_month <- as.Date(paste0(data_wide$year_month, "-28"), format = "%Y-%m-%d")

    df <- data_wide

  } else if (method == "raw" & frequency == "yearly") {

    # Convert the 'date' column to proper date format
    data[[1]] <- as.Date(data[[1]])

    # Create a new column for the year
    data$year <- format(data[[1]], "%Y")

    #If any row contains a NA, entire row is deleted
    data <- data[complete.cases(data), ]

    # Reshape the data to long format
    data_long <- data %>%
      tidyr::pivot_longer(cols = starts_with(price_cols), names_to = "stock", values_to = "price")

    # Calculate the yearly returns
    data_long <- data_long %>%
      dplyr::group_by(year, stock) %>%
      dplyr::summarize(yearly_return = last(price))

    # Reshape the data back to wide format
    data_wide <- data_long %>%
      tidyr::pivot_wider(names_from = stock, values_from = yearly_return)

    # Convert the 'year' column to date format
    data_wide$year <- as.Date(paste0(data_wide$year, "-12-31"), format = "%Y-%m-%d")

    df <- data_wide

  } else if (method == "raw" & frequency == "weekly") {

    # Convert the 'date' column to proper date format
    data[[1]] <- as.Date(data[[1]])

    # Create a new column for year and week number
    data$year_week <- format(data[[1]], "%Y-%U")

    #If any row contains a NA, entire row is deleted
    data <- data[complete.cases(data), ]

    # Reshape the data to long format
    data_long <- data %>%
      tidyr::pivot_longer(cols = starts_with(price_cols), names_to = "stock", values_to = "price")

    # Calculate the weekly returns
    data_long <- data_long %>%
      dplyr::group_by(year_week, stock) %>%
      dplyr::summarize(weekly_return = last(price))

    # Reshape the data back to wide format
    data_wide <- data_long %>%
      tidyr::pivot_wider(names_from = stock, values_from = weekly_return)

    # Convert the 'year_week' column to date format
    data_wide$year_week <- as.Date(paste0(data_wide$year_week, "-1"), format = "%Y-%U-%u")

    df <- data_wide

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
    paste0("Line plot for: ", price_cols[1])
  } else if (length(df) == 3) {
    paste0("Line plot for: ", price_cols[1], " & ", price_cols[2])
  } else {
    paste0("Line plot")
  }

  caption <- if (method == "raw") {
    paste0("Line built with raw values.")
  } else {
    paste0("Price returns starting from a common base (value = 100)")
  }

  #Building a plot
  plot <- ggplot2::ggplot(data = dfplot, aes(dfplot[, 1], value, colour = variable)) +
    ggplot2::geom_line() +
    ggplot2::labs(
      title = title,
      subtitle = paste0("Data range: ", dfplot[1, 1], " / ", dfplot[nrow(dfplot), 1], " (", frequency, ")"),
      caption = caption, y = "Value", x = "Date", colour = "Series"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = element_text(colour = "#282828", face = "bold", size = 18),
      plot.subtitle = element_text(colour = "#757575", size = 12),
      legend.position = "bottom", panel.background = element_rect(fill = "#F9F9F9"),
      plot.background = element_rect(fill = "#F9F9F9"), legend.background = element_rect(fill = "#F9F9F9")
    )

  ifelse(length(unique(dfplot$variable)) > 4,
    print("Hint: Don't use more than 4 series on same plot."),
    print("Building your plot.")
  )

  #List is created and will display table or plot (list's element)
  list <- list(plot = plot, table = df)

  if (display == "plot") {
    return(list$plot)
  } else if (display == "table") {
    return(list$table)
  } else {
    return(print("Please check any typo or your df structure."))
  }
}
