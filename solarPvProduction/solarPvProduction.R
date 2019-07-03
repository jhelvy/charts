# Author: John Paul Helveston
# Date: First written on Tuesday, July 2, 2019
#
# Description:
# Barplot of global annual solar photovoltaic cell production by country
#
# Original figures by Ed Hawkins:
# http://www.climate-lab-book.ac.uk/2018/warming-stripes/#more-5516
#
# Data Sources: See "sources.txt" in "data" folder for details
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
library(cowplot)
library(here)
library(jhelvyr)
library(readxl)

# Read in and format 1995 to 2013 data
solar95_13 <- read_excel(
    here('solarPvProduction', 'data', 'book_tgt_solar_9.xlsx'),
    sheet = 'Cell Prod by Country', skip = 2)

# Drop first two (blank) rows,
solar95_13 <- solar95_13[-c(1:2), ] %>%
    # Drop summary rows past year 2012
    filter(Year <= 2013) %>%
    # Select focal columns
    select(Year, China, `United States`, World) %>%
    # Replace NAs with 0
    mutate(China = ifelse(China == 'n.a.', 0, China)) %>%
    # Convert to tidy format for plotting
    gather('Country', 'Production', 'China':'World') %>%
    # Convert from MW to GW
    mutate(Production = as.numeric(Production) / 10^3)

# Read in and format 2013 to 2018 data (Production in GW)
total <- read.csv(
    here('solarPvProduction', 'data', 'productionTotal.csv'), header=F)$V2
china <- read.csv(
    here('solarPvProduction', 'data', 'productionChina.csv'), header=F)$V2
us0 <- read.csv(
    here('solarPvProduction', 'data', 'productionUS0.csv'), header=F)$V2
us1 <- read.csv(
    here('solarPvProduction', 'data', 'productionUS1.csv'), header=F)$V2
solar05_18 <- tibble(
    Year            = c(2005, 2008, seq(2010, 2018)),
    China           = china,
    `United States` = us1 - us0,
    World           = total) %>%
    # Convert to tidy format for plotting
    gather('Country', 'Production', 'China':'World')

# Merge and gather for plotting
solarDf <- rbind(solar95_13, filter(solar05_18, Year > 2013)) %>%
    mutate(
        Year = as.numeric(Year),
        Country = ifelse(Country == 'World', 'Rest of World', Country))

# Reorder factors for plotting
solarDf$Country <- factor(solarDf$Country,
    c('Rest of World', 'China', 'United States'))

# Make the plot
solarPlot <- ggplot(solarDf %>% filter(Year > 2000),
    aes(x = Year, y = Production)) +
    geom_bar(aes(fill = Country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(1999, 2019),
                       breaks = c(seq(2000, 2015, 5), 2018)) +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x = 'Year',
         y = 'Solar Voltaic Cell Production (GW)',
         fill = 'Country')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('solarPvProduction', 'plots', 'solarPlot.pdf'), 
       solarPlot, width=8, height=5, dpi=150)

ggsave(here('solarPvProduction', 'plots', 'solarPlot.png'), 
       solarPlot, width=8, height=5, dpi=150)

# Summary of China's production: Since joining the WTO in 2001, 
# China went from producing 1% to 40% of the world’s solar panels
solarDf %>% 
    spread(Country, Production) %>% 
    mutate(
        world = China + `Rest of World` + `United States`,
        chinaPercent = 100*(China / world)
    ) %>% 
    select(Year, chinaPercent) %>% 
    as.data.frame()