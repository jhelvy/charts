# Author: John Paul Helveston
# Date: First written on Monday, October 14, 2019
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Plots of investment and patenting in clean energy technologies by
# country and over time.

# For details on data sources, see the "data_source.txt" file

library(tidyverse)
library(cowplot)
library(here)
library(ggrepel)

# Set plot colors:
plotColors = c(
    'red'    = "#e3394a", 
    'green'  = "#39e37d", 
    'yellow' = "#e3d139", 
    'gray'   = "grey70", 
    'blue'   = "#399ee3")

# --------------------------------------------------------------------------
# New clean energy investment plot

# Read in data
investmentDf <- read_csv(
    here::here('scienceCommentary2019', 'data', 'countryEnergyInvestment.csv'))

# Reorder factors and create summary data frame for plotting
investmentDf$country <- factor(investmentDf$country, 
                               c('China', 'EU', 'ROW', 'USA'))

# Make the plot
colors <- as.vector(plotColors[c('red', 'green', 'gray', 'blue')])
investmentPlot <- investmentDf %>%
    ggplot(aes(x = year, y = investment, color = country)) +
    geom_line(size = 0.8) +
    geom_point() +
    geom_text_repel(aes(label = country, color = country),
        data          = subset(investmentDf, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 150), breaks=seq(0, 150, 50)) +
    scale_color_manual(values = colors) +
    theme_cowplot() +
    labs(x       = '',
         y       = 'New Investment in Clean\nEnergy (USD $ Billions)',
         fill    = 'Country / Region') +
    background_grid(major = "y", minor = "none",
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.1)) +
    theme(legend.position = 'none')

# --------------------------------------------------------------------------
# Clean energy patenting plot

# Read in and format data
path <- here::here('scienceCommentary2019', 'data', 'lcetPatenting.csv')
lcetPatentdf <- read_csv(path)

# Make the plot
colors <- as.vector(plotColors[c('red', 'green', 'yellow', 'gray', 'blue')])
patentPlot <- lcetPatentdf %>%
    ggplot(aes(x = year, y = numPatents, color = country)) +
    geom_line(size = 0.8) +
    geom_point() +
    geom_text_repel(aes(label = country, color = country),
        data          = subset(lcetPatentdf, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 5100), breaks = seq(0, 5000, 2500)) +
    scale_color_manual(values = colors) +
    theme_cowplot() +
    labs(x       = 'Year',
         y       = 'Number of USPTO Patents \nin Clean Energy Technologies') +
    background_grid(major = "y", minor = "none",
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.1)) +
    theme(legend.position = 'none')

# Generate the multiplot
figure1 <- plot_grid(investmentPlot, patentPlot, labels = c('A', 'B'),
                     label_size = 12, nrow = 2)

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here::here('scienceCommentary2019', 'plots', 'figure1.pdf'),
       figure1, width=6, height=7, dpi=150)

ggsave(here::here('scienceCommentary2019', 'plots', 'figure1.png'),
       figure1, width=6, height=7, dpi=150)
