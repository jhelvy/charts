# Author: John Paul Helveston
# Date: First written on Saturday, May 26, 2018
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# "Barcode" plots showing the long term rise in global and US temperatures.
# Each vertical stripe represents the temperature of a single year, ordered
# from the earliest available data to the present.
#
# Original figures by Ed Hawkins:
# http://www.climate-lab-book.ac.uk/2018/warming-stripes/#more-5516
#
# Data Sources: See "data_sources.txt" for details
#
# NASA (2018) "Goddard Institute for Space Studies (GISS)".
# retrieved from
# https://climate.nasa.gov/vital-signs/global-temperature/
#
# NOAA National Centers for Environmental information, Climate
# at a Glance: National Time Series, published May 2018,
# retrieved from http://www.ncdc.noaa.gov/cag/

# Load libraries and plot colors
library(ggplot2)
library(RColorBrewer)
library(here)

plotColors = rev(brewer.pal(10, "RdBu"))

# Load data
nasa_global <- read.table(
    here('climateChangeBarcode', 'data', 'nasa_global_data.txt'),
    col.names = c('year', 'meanTempCelsius', 'smoothTempCelsius'), skip=5)
noaa_global <- read.csv(
    here('climateChangeBarcode', 'data', 'noaa_global_data.csv'),
    skip = 4, header=T)
noaa_us <- read.csv(
    here('climateChangeBarcode', 'data', 'noaa_us_data.csv'),
    skip = 4, header=T)
nasa_global$group <- "group"
noaa_global$group <- "group"
noaa_us$group     <- "group"

# Make plots
nasa_global_plot <- ggplot(data = nasa_global,
    aes(x = group, y = as.factor(year))) +
    geom_tile(aes(fill = meanTempCelsius)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none", axis.ticks.length = unit(0, "pt"))
noaa_global_plot <- ggplot(data = noaa_global,
    aes(x = group, y = as.factor(Year))) +
    geom_tile(aes(fill = Value)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none", axis.ticks.length = unit(0, "pt"))
noaa_us_plot <- ggplot(data = noaa_us,
    aes(x = group, y = as.factor(Date))) +
    geom_tile(aes(fill = Anomaly)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none", axis.ticks.length = unit(0, "pt"))

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('climateChangeBarcode', 'plots', 'nasa_global.pdf'),
       nasa_global_plot, width=8, height=5, dpi=150)
ggsave(here('climateChangeBarcode', 'plots', 'noaa_global.pdf'),
       noaa_global_plot, width=8, height=5, dpi=150)
ggsave(here('climateChangeBarcode', 'plots', 'noaa_us.pdf'),
       noaa_us_plot, width=8, height=5, dpi=150)

ggsave(here('climateChangeBarcode', 'plots', 'nasa_global_preview.png'),
       nasa_global_plot, width=8, height=5, dpi=150)
ggsave(here('climateChangeBarcode', 'plots', 'noaa_global_preview.png'),
       noaa_global_plot, width=8, height=5, dpi=150)
ggsave(here('climateChangeBarcode', 'plots', 'noaa_us_preview.png'),
       noaa_us_plot, width=8, height=5, dpi=150)
