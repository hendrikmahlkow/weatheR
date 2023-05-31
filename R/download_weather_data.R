#' Download weather data from NOAA
#' 
#' @description
#' Downloads weather data from [NOAA](https://www.noaa.gov ). The data is downloaded in a compressed `gz` format.
#' 
#' @param station_id Identifier of the closest weather station. Consists of 6-digit USAF and 5-digit WBAN identifier
#' @param year Year of the weather data.
#' @param dir Directory to save the weather data files.
#' 
#' @examples \dontrun{
#' # Download weather data for the weather station with USAF identifier 037070 and WBAN identifier 99999 for the year 2017.
#' download_weather_data(station_id = "037070-99999", year = "2017", dir = "data")
#' } 
#' 
#' @export

download_weather_data <- function(station_id, year, dir) {
  
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
