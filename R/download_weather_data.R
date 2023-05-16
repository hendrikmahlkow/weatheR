#' Download weather data from NOAA
#' 
#' @description
#' `download_weather_data()` Downloads weather data from NOAA.
#' 
#' @param usaf USAF identifier of the weather station.
#' @param wban WBAN identifier of the weather station.
#' @param begin_year Beginning year of the weather data.
#' @param end_year Ending year of the weather data.
#' @param dict Directory to save the weather data files.
#' 
#' @export

download_weather_data <- function(usaf, wban, begin_year, end_year, dict) {
  base_url <- "https://www1.ncdc.noaa.gov/pub/data/noaa"
  station_id <- paste0(usaf, "-", wban)
  
  for (year in begin_year:end_year) {
    file <- paste0(station_id, "-", year, ".gz")
    url <- file.path(base_url, year, file)
    
    # Download the weather data file
    destfile <- file.path(dict, file)
    download.file(url, destfile = destfile, method = "curl")
  }
}