# Author: John Paul Helveston
# Date: First written on Monday, October 14, 2019
#
# Description:
# Plots of investment and patenting in clean energy technologies by 
# country and over time. 

# For details on data sources, see the "data_source.txt" files in 
# "newEnergyInvestment" and "lcetPatenting" folders

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(ggrepel)

# --------------------------------------------------------------------------
# New clean energy investment plot

# Read in data
dfPath <- here::here('newEnergyInvestment', 'data', 'formattedData.csv')
df <- read_csv(dfPath)

# Reorder factors for plotting
df$country <- factor(df$country, c('China', 'EU', 'ROW', 'USA'))
df$type <- factor(df$type, c('Solar', 'Wind', 'Other'))

# Make the plot 
countrySummaryDf <- df %>% 
    group_by(year, country) %>% 
    summarise(investment = sum(investment))
investmentPlot <- countrySummaryDf %>% 
    ggplot(aes(x = year, y = investment, color = country)) + 
    geom_line(size = 0.8) +
    geom_point() +
    geom_text_repel(aes(label = country, color = country),
        data          = subset(countrySummaryDf, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 150), breaks=seq(0, 150, 50)) +
    scale_color_manual(
        values = jColors('extended', c('red', 'green', 'gray', 'blue'))) +
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
dfPath <- here::here('lcetPatenting', 'data', 'formattedData.csv')
df <- read_csv(dfPath)

# Make the plot 
patentPlot <- df %>% 
    ggplot(aes(x = year, y = numPatents, color = country)) +
    geom_line(size = 0.8) +
    geom_point() +
    geom_text_repel(aes(label = country, color = country),
        data          = subset(df, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 5100), breaks = seq(0, 5000, 2500)) +
    scale_color_manual(
    values = jColors('extended', c('red', 'green', 'yellow', 'gray', 'blue'))) +
    theme_cowplot() +
    labs(x       = 'Year',
         y       = 'Number of USPTO Patents \nin Clean Energy Technologies') +
    background_grid(major = "y", minor = "none", 
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.1)) +
    theme(legend.position = 'none')

# Generate the multiplot
multiplot <- plot_grid(investmentPlot, patentPlot, labels = c('A', 'B'), 
                       label_size = 12, nrow = 2)

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here::here('scienceCommentary2019', 'plots', 'multiplot.pdf'),
       multiplot, width=6, height=7, dpi=150)

ggsave(here::here('scienceCommentary2019', 'plots', 'multiplot.png'),
       multiplot, width=6, height=7, dpi=150)
