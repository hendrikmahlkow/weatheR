#' Read weather data
#' 
#' @description
#' Reads weather data, obtained with `download_weather_data()`, from a file. Relative humidity is calculated from temperature and dew point.
#' 
#' @return data frame of weather data.
#' 
#' @param file Path to the weather data file.
#' 
#' @return Returns a data.frame with 10 columns.
#' \describe{
#' \item{station_id}{Station ID of the weather station.}
#' \item{time}{Time of the weather observation in GMT timezone.}
#' \item{wd}{Wind direction in degrees.}
#' \item{ws}{Wind speed in meters per second.}
#' \item{ceil_hgt}{Ceiling height in meters.}
#' \item{visibility}{Visibility in meters.}
#' \item{temp}{Temperature in degrees Celsius.}
#' \item{dew_point}{Dew point in degrees Celsius.}
#' \item{atmos_pres}{Atmospheric pressure in hPa.}
#' \item{rh}{Relative humidity in percent.}
#' }
#' 
#' @examples \dontrun{
#' # Read weather data from a file
#' data <- read_weather_data("data/037070-99999-2017.gz")
#' }
#' 
#' @importFrom lubridate ymd_hm
#' @importFrom lubridate ymd
#' @importFrom lubridate with_tz
#' @importFrom readr read_fwf
#' @importFrom readr fwf_widths
#' 
#' @export

read_weather_data <- function(file) {
  year <- substr(file, nchar(file) - 7, nchar(file) - 4)
  
  fwf_widths <- fwf_widths(widths = c(4, 6, 5, 4, 2, 2, 2, 2, 1, 6, 7, 5, 5, 5, 4, 3, 1, 1, 4, 1, 5, 1, 1, 1, 6, 1, 1, 1, 5, 1, 5, 1, 5, 1))
  col_types <- "ccciiiiiciicicciccicicccicccicicic"
  
  # Read the downloaded file using read_fwf
  data <- read_fwf(file, fwf_widths, col_types = col_types)
  
  # Select specific columns and rename them
  data <- data[, c(2:8, 16, 19, 21, 25, 29, 31, 33)]
  colnames(data) <- c("usaf", "wban", "year", "month", "day", "hour", "minute", "wd", "ws", "ceil_hgt", "visibility", "temp", "dew_point", "atmos_pres")
  
  # Create station-id
  data$station_id <- paste0(data$usaf, "-", data$wban)
  
  # Replace specific values with NA
  data$wd[data$wd == 999] <- NA
  data$ws[data$ws == 9999] <- NA
  data$temp[data$temp == 9999] <- NA
  data$dew_point[data$dew_point == 9999] <- NA
  data$atmos_pres[data$atmos_pres == 99999] <- NA
  data$ceil_hgt[data$ceil_hgt == 99999] <- NA
  data$visibility[data$visibility == 999999] <- NA
  
  # Divide variables by 10
  data$ws <- data$ws / 10
  data$temp <- data$temp / 10
  data$dew_point <- data$dew_point / 10
  data$atmos_pres <- data$atmos_pres / 10
  
  # Calculate relative humidity
  data$rh <- 100 * (exp((17.625 * data$dew_point) / (243.04 + data$dew_point)) / exp((17.625 * data$temp) / (243.04 + data$temp)))
  
  # Create time variable in GMT timezone
  data$time <- with_tz(ymd_hm(paste(data$year, data$month, data$day, data$hour, data$minute, sep = "-"), tz = "GMT"), tzone = "GMT")
  
  # Remove other time-related variables
  data <- data[, c("station_id", "time", "wd", "ws", "ceil_hgt", "visibility", "temp", "dew_point", "atmos_pres", "rh")]
  
  return(data)
}