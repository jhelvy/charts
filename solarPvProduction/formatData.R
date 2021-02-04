# Data Sources: See "data_sources.txt" for details
#
# 1995 to 2013:
#   Earth Policy Institute
#   http://www.earth-policy.org/data_center/C23
# 2014 to 2018:
#   Jäger-Waldau, A. (2019). Snapshot of Photovoltaics—February 2019.
#   Energies, 12(5), 769. https://www.mdpi.com/1996-1073/12/5/769
#   Data reverse engineered from Figure 1 using WebPlotDigitizer:
#   https://automeris.io/WebPlotDigitizer/

library(tidyverse)
library(here)
library(readxl)

# Read in and format 1995 to 2013 data
solar95_13 <- read_excel(
    here::here('data', 'book_tgt_solar_9.xlsx'),
    sheet = 'Cell Prod by Country', skip = 2)

# Drop first two (blank) rows,
solar95_13 <- solar95_13[-c(1:2), ] %>%
    # Drop summary rows past year 2013
    filter(Year <= 2013) %>%
    # Select focal columns
    select(Year, China, `United States`, World) %>%
    # Replace NAs with 0
    mutate(
        China = as.numeric(China),
        China = if_else(is.na(China), 0, China)) %>% 
    # Compute ROW from World 
    mutate(ROW = World - China - `United States`) %>% 
    select(-World) %>% 
    # Convert to tidy format for plotting
    gather('Country', 'Production', 'China':'ROW') %>%
    # Convert from MW to GW
    mutate(Production = as.numeric(Production) / 10^3)

# Read in and format 2013 to 2018 data (Production in GW)
total <- read.csv(
    here::here('data', 'productionTotal.csv'), header=F)$V2
china <- read.csv(
    here::here('data', 'productionChina.csv'), header=F)$V2
us0 <- read.csv(
    here::here('data', 'productionUS0.csv'), header=F)$V2
us1 <- read.csv(
    here::here('data', 'productionUS1.csv'), header=F)$V2
solar05_18 <- tibble(
    Year            = c(2005, 2008, seq(2010, 2018)),
    China           = china,
    `United States` = us1 - us0,
    ROW             = total - China - `United States`) %>%
    # Convert to tidy format for plotting
    gather('Country', 'Production', 'China':'ROW')

# Merge and gather for plotting
solarDf <- rbind(solar95_13, filter(solar05_18, Year > 2013)) %>%
    mutate(Year = as.numeric(Year)) %>% 
    arrange(Year, Country)

# Export formatted data to "data" folder:
write_csv(solarDf, here::here('data', 'formattedData.csv'))
