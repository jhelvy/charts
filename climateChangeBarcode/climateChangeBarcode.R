# "Barcode" plots showing the long term rise in global and US temperatures.
# Each vertical stripe represents the temperature of a single year, ordered
# from the earliest available data to the present.
#
# First written by John Paul Helveston
# Saturday, May 26, 2018
#
# Original figures by Ed Hawkins:
# http://www.climate-lab-book.ac.uk/2018/warming-stripes/#more-5516
#
# Data Sources:
#
# NASA (2017) "Goddard Institute for Space Studies (GISS)".
# retrieved on May 26, 2018 from
# https://climate.nasa.gov/vital-signs/global-temperature/
#
# NOAA National Centers for Environmental information, Climate
# at a Glance: National Time Series, published May 2018,
# retrieved on May 26, 2018 from http://www.ncdc.noaa.gov/cag/

# Set working directory:
setwd("/Users/jhelvy/Documents/github/charts/climateChangeBarcode")

# Load libraries and plot colors
library(ggplot2)
library(RColorBrewer)
plotColors = rev(brewer.pal(10, "RdBu"))

# Load data (urls may be outdated - see original data sources for updates)
nasa_global = read.table("https://climate.nasa.gov/system/internal_resources/details/original/647_Global_Temperature_Data_File.txt",
    col.names=c('year', 'meanTempCelsius', 'smoothTempCelsius'))
noaa_global = read.csv("https://www.ncdc.noaa.gov/cag/global/time-series/globe/land_ocean/1/4/1880-2018.csv",
    skip = 4, header=T)
noaa_us = read.csv("https://www.ncdc.noaa.gov/cag/national/time-series/110-tavg-12-12-1895-2018.csv?base_prd=true&begbaseyear=1895&endbaseyear=2017",
    skip = 4, header=T)
nasa_global$group = "group"
noaa_global$group = "group"
noaa_us$group     = "group"

# Make plots
nasa_global_plot = ggplot(data = nasa_global,
    aes(x = group, y = as.factor(year))) +
    geom_tile(aes(fill = meanTempCelsius)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none")
noaa_global_plot = ggplot(data = noaa_global,
    aes(x = group, y = as.factor(Year))) +
    geom_tile(aes(fill = Value)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none")
noaa_us_plot = ggplot(data = noaa_us,
    aes(x = group, y = as.factor(Date))) +
    geom_tile(aes(fill = Anomaly)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none")

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave('./nasa_global.pdf', nasa_global_plot, width=4, height=2.5)
ggsave('./noaa_global.pdf', noaa_global_plot, width=4, height=2.5)
ggsave('./noaa_us.pdf',     noaa_us_plot,     width=4, height=2.5)

ggsave('./nasa_global_preview.png', nasa_global_plot, width=4, height=2.5)
ggsave('./noaa_global_preview.png', noaa_global_plot, width=4, height=2.5)
ggsave('./noaa_us_preview.png',     noaa_us_plot,     width=4, height=2.5)


