## @knitr barcodePlot

# Load libraries and plot colors
library(ggplot2)
library(RColorBrewer)
library(here)

plotColors = rev(brewer.pal(10, "RdBu"))

# Load data
## NASA (2018) "Goddard Institute for Space Studies (GISS)".
# retrieved from
# https://climate.nasa.gov/vital-signs/global-temperature/
nasa_global <- read.table(here('climateChangeBarcode', 'data',
    'nasa_global_data.txt'),
    col.names = c('year', 'meanTempCelsius', 'smoothTempCelsius'), skip=5)
nasa_global$group <- "group"

# Make plots
nasa_global_plot = ggplot(data = nasa_global,
    aes(x = group, y = as.factor(year))) +
    geom_tile(aes(fill = meanTempCelsius)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none", axis.ticks.length = unit(0, "pt"))
nasa_global_plot
