# weatheR <img src='man/figures/logo.png' align="right" height="250px" /></a>

***

This package provides weather data for around 28,000 weather stations around the world. The data is provided by the National Oceanic and Atmospheric Administration's (NOAA) [Integrated Surface Data (ISD)](https://www.ncei.noaa.gov/products/land-based-station/integrated-surface-database). The package provides a function to download the data and to load it into R. The data is provided as a data frame with the following columns: `station_id`, `date`, `element`, `value`, `mflag`, `qflag`, `sflag`, `time`. The data is provided in the [ISD-Hourly format](https://www1.ncdc.noaa.gov/pub/data/noaa/readme.txt).

This package is largly inspired by the [stationaRy](https://github.com/rich-iannone/stationaRy) packagy by Richard Iannone. Currently, the package is not updated since 2020 and can't download recent years. This package is an attempt to provide a similar package that is updated and maintained. If Richard updates his package, go over to [stationaRy](https://github.com/rich-iannone/stationaRy) as it provides more functionality.


To install and load the package, run the following code:

``` r 
devtools::install_github("hendrikmahlkow/weatheR")
library(weatheR)
```

To download all available weather stations, run the following code:

``` r
stations = download_weather_stations(save_file = FALSE)
```

To find the closest weather station to Kiel, Germany, run the following code:

``` r
closest_station = closest_weather_station(latitude = 54.323293, longitude = 10.122765, stations)
```

To download the data for Kiel's closest weather station, run the following code:

``` r
download_weather_data(
    usaf = closest_station$closest_station_usaf,
    wban = closest_station$closest_station_wban, 
    year = 2022, 
    dir = "temp"
    )
```

To load the data, run the following code:

``` r
weather_data <- read_weather_data(file = list.files("temp", full.names = TRUE))
```
