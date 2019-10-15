# Author: John Paul Helveston
# Date: First written on Monday, October 14, 2019
#
# Description:
# Plots of patenting in clean energy technologies by country and over time

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(ggrepel)

# Read in and format data
dfPath <- here::here('lcetPatenting', 'data', 'formattedData.csv')
df <- read_csv(dfPath)

patentPlot <- df %>% 
    ggplot(aes(x = year, y = numPatents, color = country)) +
    geom_point() + 
    geom_line(size = 0.8) + 
    geom_text_repel(aes(label = country, color = country),
        data          = subset(df, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2019), breaks = seq(2006, 2016, 2)) +
    # scale_color_manual(
    # values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    theme_cowplot() +
    labs(x       = 'Year',
         y       = 'Number of Patents',
         title   = 'Annual USPTO Patents in Clean Energy Technologies',
         caption = paste('Data Source: 2018 U.S. National Science Foundation',
                        '\nScience & Engineering Indicators', sep = '')) +
    background_grid(major = "y", minor = "none", 
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.2)) +
    theme(legend.position = 'none')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('lcetPatenting', 'plots', 'patentPlot.pdf'),
       patentPlot, width=7, height=5, dpi=150)

ggsave(here('lcetPatenting', 'plots', 'patentPlot.png'),
       patentPlot, width=7, height=5, dpi=150)
