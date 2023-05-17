#' Find the closest weather station(s) to a given location
#' 
#' @description
#' Finds the closest weather station(s) to a given location. The function uses the [geosphere](https://cran.r-project.org/package=geosphere) package to calculate the distances.
#' 
#' @return data frame of closest weather station(s).
#' 
#' @param latitude Latitude of the location.
#' @param longitude Longitude of the location.
#' @param stations Data frame of weather stations. Use `available_weather_stations()` to get all available weather stations.
#' @param n Number of closest weather stations to return.
#' 
#' @return Returns a data.frame with 10 columns.
#' \describe{
#' \item{latitude}{Latitude of the given location.}
#' \item{longitude}{Longitude of the given location.}
#' \item{distance}{Distance in meters between the given location and the closest weather station.}
#' \item{closest_station_usaf}{USAF identifier of the closest weather station.}
#' \item{closest_station_wban}{WBAN identifier of the closest weather station.}
#' \item{closest_station_name}{Name of the closest weather station.}
#' \item{closest_station_country}{Country of the closest weather station. Note: NOAA don't use ISO country codes.}
#' \item{closest_station_elev}{Elevation of the closest weather station in meters.}
#' \item{closest_station_begin_date}{Begin date of the closest weather station.}
#' \item{closest_station_end_date}{End date of the closest weather station.}
#' }
#' 
#' @examples \dontrun{
#' # Finds the closest weather station to Berlin, Germany.
#' station_in_Berlin = closest_weather_station(52.5200, 13.4050, stations)
#' }
#' 
#' @importFrom geosphere distm
#' @importFrom geosphere distVincentySphere
#' 
#' @export

closest_weather_station <- function(latitude, longitude, stations, n = 1) {
  # Calculate distances between the given coordinates and all weather stations
  distances <- distm(stations[, c("lon", "lat")], c(longitude, latitude), fun = distVincentySphere)
  
  # Find the indices of the n closest weather stations
  closest_indices <- order(distances)[1:n]
  
  # Get the closest weather station information and distances
  closest_stations <- stations[closest_indices, ]
  closest_distances <- distances[closest_indices]
  
  # Create a data frame with the closest station information and distances
  result <- data.frame(latitude = latitude,
                       longitude = longitude,
                       distance = round(closest_distances, digits = 0),
                       closest_station_usaf = closest_stations$usaf,
                       closest_station_wban = closest_stations$wban,
                       closest_station_name = closest_stations$name,
                       closest_station_country = closest_stations$country,
                       closest_station_elev = closest_stations$elev,
                       closest_station_begin_date = closest_stations$begin_date,
                       closest_station_end_date = closest_stations$end_date)
  
  return(result)
}