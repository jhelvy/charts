## @knitr climateChangeBarcode
library(ggplot2)
library(RColorBrewer)
library(here)
plotColors = rev(brewer.pal(10, "RdBu"))
nasa_global <- read.table(here('charts', 'climateChangeBarcode', 'data',
    'nasa_global_data.txt'),
    col.names = c('year', 'meanTempCelsius', 'smoothTempCelsius'), skip=5)
nasa_global$group <- "group"
ggplot(data = nasa_global,
    aes(x = group, y = as.factor(year))) +
    geom_tile(aes(fill = meanTempCelsius)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none", axis.ticks.length = unit(0, "pt"))

## @knitr solarPvProduction
library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(readxl)
42