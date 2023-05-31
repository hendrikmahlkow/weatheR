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
#' \item{distance}{Distance in meters between the given location and the closest weather station.}
#' \item{station_id}{Identifier of the closest weather station. Consists of 6-digit USAF and 5-digit WBAN identifier}
#' \item{name}{Name of the closest weather station.}
#' \item{country}{Country of the closest weather station. Note: NOAA don't use ISO country codes.}
#' \item{elev}{Elevation of the closest weather station in meters.}
#' \item{begin_date}{Begin date of the closest weather station.}
#' \item{end_date}{End date of the closest weather station.}
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
  result <- data.frame(distance = round(closest_distances, digits = 0),
                       station_id = closest_stations$station_id,
                       name = closest_stations$name,
                       country = closest_stations$country,
                       elev = closest_stations$elev,
                       begin_date = closest_stations$begin_date,
                       end_date = closest_stations$end_date)
  
  return(result)
}