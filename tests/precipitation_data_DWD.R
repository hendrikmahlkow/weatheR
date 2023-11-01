# Precipitation 

library(rdwd)
library(ggplot2)
library(dplyr)
library(lubridate)

# find weather stations
findID(name = "Kiel", exactmatch = F)

# select a dataset (e.g. last year's daily dataate data from Potsdam city):
link <- selectDWD("Kiel-Holtenau", res="daily", var="kl", per="hr")

# Actually download that dataset, returning the local storage file name:
file <- dataDWD(link, read=FALSE)

# Read the file from the zip folder:
data <- readDWD(file, varnames=T) # can happen directly in dataDWD
data = rbindlist(data)

# plot daily values ----
ggplot(data = data[MESS_DATUM > "2023-07-01"], aes(x = MESS_DATUM, y = RSK.Niederschlagshoehe)) + 
  geom_bar(stat = "identity", fill = "blue") +
  labs(x = "Date", y = "Precipitation (mm)", title = "Daily Precipitation") +
  theme_minimal()

# plot weekly values ----
data_weekly <- data %>%
  mutate(Week = floor_date(MESS_DATUM, "week")) %>%
  group_by(Week) %>%
  summarize(Total_Precipitation = sum(RSK.Niederschlagshoehe, na.rm = TRUE)) %>% setDT
data_weekly[, week_number := week(Week)]

ggplot(data = data_weekly[Week> "2023-03-01"], aes(x = Week, y = Total_Precipitation)) + 
  geom_bar(stat = "identity", fill = "blue") +
  labs(x = "Week", y = "Total Precipitation (mm)", title = "Weekly Precipitation") +
  theme_minimal()

data_plot = merge(
  data_weekly[Week> "2023-03-01"],
  data_weekly[Week < "2020-01-01" & Week > "2010-01-01", .(mean_2010er = mean(Total_Precipitation)), by = week_number],
  by = "week_number"
)
data_plot = merge(
  data_plot,
  data_weekly[Week < "2000-01-01" & Week > "1990-01-01", .(mean_2000er = mean(Total_Precipitation)), by = week_number],
  by = "week_number"
)
setnames(data_plot, "Total_Precipitation", "2023")
data_plot = melt(data_plot, id.vars = "Week", measure.vars = c("2023", "mean_2010er", "mean_2000er"))

ggplot(data_plot, aes(x=Week, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge")
ggplot(data_plot, aes(x=Week, y=value, color=variable)) +
  geom_line()+
  labs(title = "Weekly precipitation", x = "", y = "in mm", subtitle = "Kiel Holtenau")

# plot weekly values ----
data_monthly <- data %>%
  mutate(Month = floor_date(MESS_DATUM, "month")) %>%
  group_by(Month) %>%
  summarize(Total_Precipitation = sum(RSK.Niederschlagshoehe, na.rm = TRUE)) %>% setDT
data_monthly[, month_name := month(Month)]

data_plot = merge(
  data_monthly[Month> "2023-03-01"],
  data_monthly[Month < "2020-01-01" & Month > "2010-01-01", .(historic_mean = mean(Total_Precipitation)), by = month_name],
  by = "month_name"
)

data_plot = melt(data_plot, id.vars = "Month", measure.vars = c("Total_Precipitation", "historic_mean"))
ggplot(data_plot, aes(x=Month, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge")
