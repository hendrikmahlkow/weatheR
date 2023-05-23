# weatheR <img src='man/figures/logo.png' align="right" height="139" />

***

This package provides weather data for around 28,000 weather stations around the world. The data is provided by the [Global Historical Climatology Network](https://www.ncdc.noaa.gov/ghcn-daily-description) (GHCN-Daily) database. The package provides a function to download the data and to load it into R. The data is provided as a data frame with the following columns: `station_id`, `date`, `element`, `value`, `mflag`, `qflag`, `sflag`, `time`. The data is provided in the [GHCN-Daily format](https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/GHCND_documentation.pdf).

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
