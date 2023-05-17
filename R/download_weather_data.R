#' Download weather data from NOAA
#' 
#' @description
#' `download_weather_data()` Downloads weather data from NOAA.
#' 
#' @param usaf USAF identifier of the weather station.
#' @param wban WBAN identifier of the weather station.
#' @param year Year of the weather data.
#' @param dict Directory to save the weather data files.
#' 
#' @export

download_weather_data <- function(usaf, wban, year, dict) {
  # Create station ID
  station_id <- paste0(usaf, "-", wban)
  
  # Construct the file name
  file <- paste0(station_id, "-", year, ".gz")
  
  # Construct the URL
  base_url <- "https://www1.ncdc.noaa.gov/pub/data/noaa"
  url <- file.path(base_url, year, file)
  
  # Construct the destination file path
  destfile <- file.path(dict, file)
  
  # Download the file
  download.file(url, destfile, method = "curl")
}
