# Data Sources: See "data_sources.txt" for details
#
# Jobs data from The Solar Foundation (2019 is forecasted)
# Copied from this article:
# https://www.bloomberg.com/news/articles/2019-02-12/trump-s-tariffs-took-a-bite-out-of-once-booming-solar-job-market
#
# PV Solar module data from the US EIA:
# https://www.eia.gov/renewable/monthly/solar_photo/

library(tidyverse)
library(here)
library(readxl)

# Read in modules data
# Modules units:
# total_shipments = peak kilowatts
# value           = thousand dollars
# ave_value       = dollars per peak watt
df <- read_excel(here::here('usSolarIndustry', 'data', 'pv_table3.xlsx'),
                 skip = 2)
colnames(df) <- c("year", "total_shipments", "value", "ave_value")
id17 <- which(df$year == '2017*')
id18 <- which(df$year == '2018*')
id19 <- which(df$year == '2019*')
modules <- df17 <- df[1:(id17-1),]
modules$year <- as.numeric(modules$year)
df17 <- df[(id17+1):(id18-1),]
df18 <- df[(id18+1):(id19-1),]
df19 <- df[(id19+1):(nrow(df)-2),]
dfTemp <- data.frame(
    year = c(2017, 2018, 2019),
    total_shipments = c(sum(df17$total_shipments), sum(df18$total_shipments),
                        sum(df19$total_shipments)),
    value = c(sum(df17$value), sum(df18$value), sum(df19$value)),
    ave_value = c(mean(df17$ave_value), mean(df18$ave_value),
                  mean(df19$ave_value))
)
modules <- bind_rows(modules, dfTemp)

# Export formatted data to "data" folder:
write_csv(modules, here::here('usSolarIndustry', 'data', 'modulesData.csv'))
