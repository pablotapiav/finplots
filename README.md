# finplots - Financial Visualization Package (R)

[![GitHub license](https://img.shields.io/github/license/pablotapiav/finplots.svg)](https://github.com/pablotapiav/finplots/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/pablotapiav/finplots.svg)](https://github.com/pablotapiav/finplots/releases)
[![GitHub issues](https://img.shields.io/github/issues/pablotapiav/finplots.svg)](https://github.com/pablotapiav/finplots/issues)
[![GitHub stars](https://img.shields.io/github/stars/pablotapiav/finplots.svg)](https://github.com/pablotapiav/finplots/stargazers)

**finplots** is an R package designed for creating beautiful financial visualizations with just a single line of code. This package aims to simplify the process of generating common financial plots, making it easier for analysts and researchers to visualize their data.

## Installation

You can install the latest version of **finplots** from GitHub using the `devtools` package:

~~~r
devtools::install_github("pablotapiav/finplots")
~~~


## Functions

*plot_line:* Create line charts to visualize time series data. You can extract a table as well using `display = "table"` if you only need transformed data.

*plot_boxplot:* Generate box plots to understand data distribution.

*plot_distr:* Visualize data distribution using density plots.

*tidy_bbg:* Custom function to transform data from Bloomberg using rblpapi.


# Usage
<sub>(more examples comming soon)</sub>

## line_plot
~~~r
library(readr)
data <- read.csv("https://raw.githubusercontent.com/pablotapiav/pablotapiav.github.io/master/raw_sample.csv")

library(finplots)
plot_line(data, frequency = "monthly", method = "comparison", display = "plot")
~~~

![Plot line example](https://raw.githubusercontent.com/pablotapiav/finplots/website/plotline600.png)

for a more detailed explanation and notes please visit:
https://pablotv.medium.com/finplots-y-algunas-notas-sobre-crear-un-paquete-6c5545b0f916


## Known issues and following versions
* This is a beta version intended to work with large data using daily values. So intraday prices are not supported.
* Following version will focus on be smart enough to guess frequency basis and plot what is intended.
* Boxplot will have return method added.
* tidy function for yahoo data 


## Contact

For questions or feedback you can reach me at my twitter: `@pabloandrestv`

