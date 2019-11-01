# Author: John Paul Helveston
# Date: First written on Tuesday, July 2, 2019
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Barplot of global annual solar photovoltaic cell production by country
#
# Original figures by Ed Hawkins:
# http://www.climate-lab-book.ac.uk/2018/warming-stripes/#more-5516

library(tidyverse)
library(cowplot)
library(here)
library(ggrepel)

plotColors <- c("grey70", "#e3394a", "#399ee3")

# Read in and format data
dfPath <- here::here('solarPvProduction', 'data', 'formattedData.csv')
solarDf <- read_csv(dfPath) %>% 
    mutate(Country = if_else(Country == "ROW", "Rest of World", Country))

# Reorder factors for plotting
solarDf$Country <- factor(solarDf$Country,
                          c('Rest of World', 'China', 'United States'))

# Make the bar plot
solarBars <- ggplot(solarDf %>% filter(Year > 2000),
    aes(x = Year, y = Production)) +
    geom_bar(aes(fill = Country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(1999, 2019),
                       breaks = c(seq(2000, 2015, 5), 2018)) +
    scale_y_continuous(limits = c(0, 120), breaks=seq(0, 120, 30)) +
    scale_fill_manual(values = plotColors) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x = 'Year',
         y = 'Annual Cell Production (GW)',
         title = 'Annual Solar Voltaic Cell Production (GW)',
         fill  = 'Country')

# Make the line plot
solarLines <- ggplot(solarDf %>% filter(Year > 2000),
                    aes(x = Year, y = Production, color = Country)) +
    geom_line(size = 0.8) +
    geom_point() +
    geom_text_repel(aes(label = Country, color = Country),
        data          = subset(solarDf, Year == max(Year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2000, 2022),
                       breaks = c(seq(2000, 2015, 5), 2018)) +
    scale_y_continuous(limits = c(0, 90), breaks=seq(0, 90, 30)) +
    scale_color_manual(values = plotColors) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    theme(legend.position = 'none') +
    labs(x = 'Year',
         y = 'Annual Cell Production (GW)',
         title = 'Annual Solar Voltaic Cell Production (GW)',
         fill  = 'Country')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('solarPvProduction', 'plots', 'solarBars.pdf'),
       solarBars, width=8, height=5, dpi=150)
ggsave(here('solarPvProduction', 'plots', 'solarLines.pdf'),
       solarLines, width=8, height=5, dpi=150)

ggsave(here('solarPvProduction', 'plots', 'solarBars.png'),
       solarBars, width=8, height=5, dpi=150)
ggsave(here('solarPvProduction', 'plots', 'solarLines.png'),
       solarLines, width=8, height=5, dpi=150)

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
