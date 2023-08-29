
#' tidy_data prepare your data and makes return calcs according to your arguments given.
#' @param data A data frame: first column must be date, from second column prices.
#' @param frequency You can pick daily, weekly, monthly or yearly.
#' @export

tidy_data <- function(data, frequency = c("daily", "weekly", "monthly", "yearly")) {

  cumulative_returns <- last_col <- last_price <- monthly_return <- price <- price_cols <- stock <- value <- variable <- weekly_return <- year_month <- year_week <- yearly_return <- NULL

  #Set names
  date_col <- colnames(data)[1]
  price_cols <- colnames(data)[-1]

  if (frequency == "daily") {
    # daily_returns
    # Calculate daily returns starting from the second row
    daily_returns <- data %>%
      dplyr::arrange({{ date_col }}) %>%
      dplyr::mutate(across({{ price_cols }}, ~ round(((.) / lag(.)) - 1, 2),
        .names = "{.col}_daily_return"
      )) %>%
      dplyr::select({{ date_col }}, dplyr::contains("daily_return"))

    #return to original names
    colnames(daily_returns)[-1] <- price_cols

    return(daily_returns)
  } else if (frequency == "weekly") {
    # checking code: Convert the 'date' column to proper date format
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
      dplyr::summarize(weekly_return = (last(price) / first(price)) - 1)

    # Reshape the data back to wide format
    data_wide <- data_long %>%
      tidyr::pivot_wider(names_from = stock, values_from = weekly_return)

    # Convert the 'year_week' column to date format
    data_wide$year_week <- as.Date(paste0(data_wide$year_week, "-1"), format = "%Y-%U-%u")

    # Print the resulting wide format data frame
    return(data_wide)

  } else if (frequency == "monthly") {

    # checking code: Convert the 'date' column to proper date format
    data[[1]] <- as.Date(data[[1]])

    # Create a new column for year and month
    data$year_month <- format(data[[1]], "%Y-%m")

    #If any row contains a NA, entire row is deleted
    data <- data[complete.cases(data), ]

    # Transform to monthly returns
    data_long <- data %>%
      tidyr::pivot_longer(cols = starts_with(price_cols), names_to = "stock", values_to = "price")

    # Calculate the monthly returns
    data_long <- data_long %>%
      dplyr::group_by(year_month, stock) %>%
      dplyr::summarize(monthly_return = round((last(price) / first(price)) - 1, 2))

    # Reshape the data back to wide format
    data_wide <- data_long %>%
      tidyr::pivot_wider(names_from = stock, values_from = monthly_return)

    # Turn year_month in to a date format column
    data_wide$year_month <- as.Date(paste0(data_wide$year_month, "-01"), format = "%Y-%m-%d")

    # Print the resulting wide format data frame
    return(data_wide)

  } else if (frequency == "yearly") {

    # checking code: Convert the 'date' column to proper date format
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
      dplyr::summarize(yearly_return = (dplyr::last(price) / dplyr::first(price)) - 1)

    # databc <- data_long %>%
    #   dplyr::group_by(year, stock) %>%
    #   dplyr::summarize(yearly_return = (dplyr::last(price)))

    # Reshape the data back to wide format
    data_wide <- data_long %>%
      tidyr::pivot_wider(names_from = stock, values_from = yearly_return)

    # Convert the 'year' column to date format
    data_wide$year <- as.Date(paste0(data_wide$year, "-01-01"), format = "%Y-%m-%d")

    # Print the resulting wide format data frame
    return(data_wide)

  } else {
    print("check your typo")
  }
}

# usage
# test = tidy_data(asd, frequency = "monthly")
