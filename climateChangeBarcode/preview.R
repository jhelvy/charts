## @knitr barcodePlot

library(ggplot2)
library(RColorBrewer)
plotColors = rev(brewer.pal(10, "RdBu"))

# Load data (note: urls may be outdated)
## NASA (2018) "Goddard Institute for Space Studies (GISS)".
# retrieved from
# https://climate.nasa.gov/vital-signs/global-temperature/
nasa_global = read.table("https://climate.nasa.gov/system/internal_resources/details/original/647_Global_Temperature_Data_File.txt",
    col.names=c('year', 'meanTempCelsius', 'smoothTempCelsius'), skip=5)
nasa_global$group = "group"

# Make plots
nasa_global_plot = ggplot(data = nasa_global,
    aes(x = group, y = as.factor(year))) +
    geom_tile(aes(fill = meanTempCelsius)) +
    scale_fill_gradientn(colours = plotColors) +
    coord_flip() +
    theme_void() +
    theme(legend.position="none", axis.ticks.length = unit(0, "pt"))
nasa_global_plot