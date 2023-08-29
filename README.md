# finplots - Financial Visualization Package

[![GitHub license](https://img.shields.io/github/license/your-username/finplots.svg)](https://github.com/your-username/finplots/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/your-username/finplots.svg)](https://github.com/your-username/finplots/releases)
[![GitHub issues](https://img.shields.io/github/issues/your-username/finplots.svg)](https://github.com/your-username/finplots/issues)
[![GitHub stars](https://img.shields.io/github/stars/your-username/finplots.svg)](https://github.com/your-username/finplots/stargazers)

**finplots** is an R package designed for creating beautiful financial visualizations with just a single line of code. This package aims to simplify the process of generating common financial plots, making it easier for analysts and researchers to visualize their data.

## Installation

You can install the latest version of **finplots** from GitHub using the `devtools` package:

```r
devtools::install_github("your-username/finplots")


## Functions

*plot_line:* Create line charts to visualize time series data.
*plot_boxplot:* Generate box plots to understand data distribution.
*plot_distr:* Visualize data distribution using density plots.
*tidy_bbg:* Custom function to transform data from Bloomberg using rblpapi.


## Usage

library(finplots)

# Create a simple line chart
data <- data.frame(Date = seq(as.Date("2023-01-01"), by = "days", length.out = 10),
                   Value = c(100, 120, 130, 110, 105, 125, 140, 135, 128, 130))
                   
plot_line(data, x = Date, y = Value, title = "Stock Price Trend")

## Contact

Please replace pablotapiav` with your GitHub username and `pablotapiav@gmail.com` with your contact email.

