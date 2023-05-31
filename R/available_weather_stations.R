#' Download available weather stations
#'
#' @description
#' Downloads all available weather stations from NOAA (around 29,000).
#' 
#' ## Columns
#'
#' - `station_id`: NOAA's two digit country code
#' - `name`: country name (English)
#' - `country`: FIPS 10-4 country codes
#' - `state`: US state (two letter abbreviation) if applicable
#' - `icao`: International Civil Aviation Organization (ICAO) identifier
#' - `lat`: latitude
#' - `lon`: longitude
#' - `elev`: elevation (meters)
#' - `begin_date`: first date of operation
#' - `end_date`: last date of operation
#'
#' @return data frame of available weather stations.
#'
#' @param file_dir Directory to save the CSV file. If empty, a temporary directory is created.
#' @param save_file Logical indicating whether to save the CSV file. If `FALSE``, the CSV file is removed after reading. Default is `TRUE``.
#' 
#' @examples
#' # Download all available weather stations from NOAA.
#' stations <- available_weather_stations()
#' 
#' @importFrom lubridate ymd
#' @importFrom readr read_csv
#' 
#' @export

available_weather_stations <- function(file_dir = "", save_file = TRUE) {
  # Create a temporary directory if file_dir is empty
  if (file_dir == "") {
    file_dir <- tempdir()
  }
  
  # Download the CSV file
  csv_url <- "https://www1.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"
  file_path <- file.path(file_dir, "weatheR_stations.csv")  # Renamed file
  download.file(csv_url, destfile = file_path, method = "curl")
  
  # Read the CSV file
  weather_stations <- read_csv(file_path)
  
  # Rename columns
  colnames(weather_stations) = c("usaf", "wban", "name", "country", "state", "icao", "lat", "lon", "elev", "begin_date", "end_date")
  
  # Format date columns using lubridate
  weather_stations$begin_date <- ymd(weather_stations$begin_date)
  weather_stations$end_date <- ymd(weather_stations$end_date)
  
  # Remove stations with missing latitude or longitude
  weather_stations <- weather_stations[!is.na(weather_stations$lat) & !is.na(weather_stations$lon), ]
  
  # Concatenate station_id
  weather_stations$station_id = paste(weather_stations$usaf, weather_stations$wban, sep = "-")
  weather_stations <- weather_stations[, c("station_id", names(weather_stations)[-length(weather_stations)])]
  
  # Delete columns "usaf" and "wban"
  weather_stations <- weather_stations[, -which(names(weather_stations) %in% c("usaf", "wban"))]
  
  # Save or remove the file based on the save_file argument
  if (!save_file) {
    file.remove(file_path)
  }
  
  # Return the data frame
  return(as.data.frame(weather_stations))
}