#' Find the closest weather station(s) to a given location
#' 
#' @description
#' `closest_weather_station()` Finds the closest weather station(s) to a given location.
#' 
#' @return data frame of closest weather station(s).
#' 
#' @param latitude Latitude of the location.
#' @param longitude Longitude of the location.
#' @param stations Data frame of weather stations. Use `available_weather_stations()` to get all available weather stations.
#' @param n Number of closest weather stations to return.
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