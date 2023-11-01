library(weatheR)
library(data.table)
library(tidyverse)
library(countrycode)
pacman::p_load(ggmap)


d =available_weather_stations()
d = as.data.table(d)

# Set the data.table key to "country" for grouping
setkey(d, country)

# Get the first location for each country
first_locations <- d[, .SD[1], by = country]
first_locations = first_locations[!is.na(country),.(country, lat, lon)]
first_locations[, loca := paste(lon, lat, sep = ", ")]

# find location (google maps)

data_export = data.table()
  
    register_google(key = "AIzaSyCgUsq6rZuByK4zFKn_OWS4J56nD0s7bv4")
  
  for (i in 1:first_locations[,.N]) {
    data_temp = first_locations[i,]
    # find lat-lon of stadium_data
    geocodes = revgeocode(c(data_temp$lon, data_temp$lat),
                          output = "address")
    
    # Extract words after the last comma using regular expressions
    # country_name <- str_extract(geocodes, "(?<=,\\s| - )(.*?)$")
    temp = data.table(NOAA_ccode = data_temp$country,
               country = geocodes)
    data_export = rbind(data_export, temp)
  }
  
  temp = copy(data_export)
temp[NOAA_ccode %in% c("WS", "WI"), country_name :=  "Western Sahara"]
temp[NOAA_ccode %in% c("WF"), country_name :=  "Wallis and Futuna"]
temp[NOAA_ccode %in% c("IZ"), country_name :=  "Iraq"]
temp[NOAA_ccode %in% c("AF"), country_name :=  "Afghanistan"]
temp[country_name %in% c("Taiwan 337"), country_name :=  "Taiwan"]
temp[country_name %in% c("Türkiye"), country_name :=  "Turkey"]
temp[str_detect(countrx, ", "), country_name := str_extract(country, "(?<=,\\s| - )(.*?)$")]
temp[str_detect(country_name, ", "), ]
temp[str_detect(country_name, ", "), country_name := str_extract(country, "(?<=,\\s)([^,]+)$")]
View(temp[str_detect(country, ", "), ])
temp[is.na(country_name), country_name := str_extract(country, "\\s(.*)$")]
temp = rbind(temp, data.table(NOAA_ccode = "GQ", country_name = "Guam"), fill = T)

temp[, country_code := countrycode(country_name, origin = "country.name", "iso3c")]
country_concordance =  as.data.frame(temp[,.(NOAA_ccode, country_name, country_code)])
save(country_concordance, file = "data/country_concordance.rda")
fwrite(data_export, "temp.csv")


library(ggplot2)
library(maps)
library(sf)
library(rnaturalearth)

station_coords_sf <- st_as_sf(stations, coords = c("lon", "lat"), crs = "+proj=longlat")
# Transform station coordinates to Robinson projection
station_coords_transformed <- st_transform(station_coords_sf, crs = "+proj=robin")


world_map <- ne_countries(scale = "medium", returnclass = "sf") %>%
  st_transform(crs = "+proj=robin") %>%
  fortify()

p = ggplot() +
  geom_sf(data = world_map, fill = "lightgray", color = "lightgray") +
  geom_sf(data = station_coords_transformed, color = "#ff6361", size = 0.25) +
  theme_void() +
  coord_sf(crs = "+proj=robin") +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("man/figures/map_stations.png", width = 16, height = 8, dpi = 72)

png("man/figures/map_stations_t.png", width = 1000, height = 500, units = "px", bg = "transparent")

country_concordance
country_concordance = as.data.table(country_concordance)
german_stations = country_concordance[country_code == "DEU", NOAA_ccode]
stations = as.data.table(d)

closest_weather_station(latitude = 54.323293, longitude = 10.122765, stations, n = 5)

download_weather_data(
  station_id = "100465-99999",
  year = 2022, 
  dir = "temp"
)
data = read_weather_data(file = list.files("temp", full.names = TRUE)) %>% setDT
data

library(readr)
fwf_widths <- fwf_widths(widths = c(4, 6, 5, 4, 2, 2, 2, 2, 1, 6, 7, 5, 5, 5, 4, 3, 1, 1, 4, 1, 5, 1, 1, 1, 6, 1, 1, 1, 5, 1, 5, 1, 5, 1))
col_types <- "ccciiiiiciicicciccicicccicccicicic"

# Read the downloaded file using read_fwf
data <- read_fwf("temp/100465-99999-2022.gz", fwf_widths, col_types = col_types)
data


dat = readLines("temp/100465-99999-2022.gz") %>%
  strsplit("REM") %>%
  vapply(function(x) x[[1]], character(1))

field_categories <- c(
    "AA1", "AB1", "AC1", "AD1", "AE1", "AG1", "AH1", "AI1", "AJ1",
    "AK1", "AL1", "AM1", "AN1", "AO1", "AP1", "AU1", "AW1", "AX1",
    "AY1", "AZ1", "CB1", "CF1", "CG1", "CH1", "CI1", "CN1", "CN2",
    "CN3", "CN4", "CR1", "CT1", "CU1", "CV1", "CW1", "CX1", "CO1",
    "CO2", "ED1", "GA1", "GD1", "GF1", "GG1", "GH1", "GJ1", "GK1",
    "GL1", "GM1", "GN1", "GO1", "GP1", "GQ1", "GR1", "HL1", "IA1",
    "IA2", "IB1", "IB2", "IC1", "KA1", "KB1", "KC1", "KD1", "KE1",
    "KF1", "KG1", "MA1", "MD1", "ME1", "MF1", "MG1", "MH1", "MK1",
    "MV1", "MW1", "OA1", "OB1", "OC1", "OE1", "RH1", "SA1", "ST1",
    "UA1", "UG1", "UG2", "WA1", "WD1", "WG1"
  )
data_categories = field_categories

data_categories_counts <- rep(0L, length(data_categories))

# Determine which additional parameters have been measured
for (i in seq_along(data_categories)) {
  
  data_categories_counts[i] <-
    stringr::str_detect(dat, data_categories[i]) %>% sum()
}


# Filter those measured parameters and obtain string of identifiers
data_categories <- data_categories[data_categories_counts >= 1]

data_categories[data_categories %in% add_fields]
