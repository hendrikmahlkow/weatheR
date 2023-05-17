#' Download weather data from NOAA
#' 
#' @description
#' Downloads weather data from [NOAA](https://www.noaa.gov ). The data is downloaded in a compressed `gz` format.
#' 
#' @param usaf USAF identifier of the weather station. Togehter with the `wban` identifier, this uniquely identifies the weather station.
#' @param wban WBAN identifier of the weather station. Togehter with the `usaf` identifier, this uniquely identifies the weather station.
#' @param year Year of the weather data.
#' @param dir Directory to save the weather data files.
#' 
#' @example \dontrun{
#' # Download weather data for the weather station with USAF identifier 037070 and WBAN identifier 99999 for the year 2017.
#' download_weather_data(usaf = "037070", wban = "99999", year = "2017", dir = "data")
#' } 
#' 
#' @export

download_weather_data <- function(usaf, wban, year, dir) {
  # Create station ID
  station_id <- paste0(usaf, "-", wban)
  
  # Construct the file name
  file <- paste0(station_id, "-", year, ".gz")
  
  # Construct the URL
  base_url <- "https://www1.ncdc.noaa.gov/pub/data/noaa"
  url <- file.path(base_url, year, file)
  
  # Construct the destination file path
  destfile <- file.path(dir, file)
  
  # Download the file
  download.file(url, destfile, method = "curl")
}
