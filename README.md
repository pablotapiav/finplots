# finplots - Financial Visualization Package (R)

[![GitHub license](https://img.shields.io/github/license/your-username/finplots.svg)](https://github.com/your-username/finplots/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/your-username/finplots.svg)](https://github.com/your-username/finplots/releases)
[![GitHub issues](https://img.shields.io/github/issues/your-username/finplots.svg)](https://github.com/your-username/finplots/issues)
[![GitHub stars](https://img.shields.io/github/stars/your-username/finplots.svg)](https://github.com/your-username/finplots/stargazers)

**finplots** is an R package designed for creating beautiful financial visualizations with just a single line of code. This package aims to simplify the process of generating common financial plots, making it easier for analysts and researchers to visualize their data.

## Installation

You can install the latest version of **finplots** from GitHub using the `devtools` package:

~~~r
devtools::install_github("pablotapiav/finplots")
~~~


## Functions

*plot_line:* Create line charts to visualize time series data.

*plot_boxplot:* Generate box plots to understand data distribution.

*plot_distr:* Visualize data distribution using density plots.

*tidy_bbg:* Custom function to transform data from Bloomberg using rblpapi.


## Usage

~~~r
library(readr)
data <- read.csv("https://raw.githubusercontent.com/pablotapiav/pablotapiav.github.io/master/raw_sample.csv")

library(finplots)
plot_line(data, frequency = "monthly", method = "comparison", display = "plot")
~~~

![Plot line example](https://raw.githubusercontent.com/pablotapiav/finplots/website/plotline600.png)

## Known issues and following versions
* This is a beta version intended to work with large data using daily values. So intraday prices are not supported.
* Following version will focus on be smart enough to guess frequency basis and plot what is intended.
* Boxplot will have return method added.


## Contact

For questions or feedback you can reach me at my twitter: `@pabloandrestv`

