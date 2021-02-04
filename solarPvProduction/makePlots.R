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
library(jhelvyr)

plotColors <- jColors(
    palette = "redToGray", 
    colors = rev(c("red", "green", "purple", "yellow", "green", "blue", "gray")))

# Read in and format data
df <- read_csv(here::here('data', 'formattedData.csv')) %>% 
    mutate(
        country = str_to_title(country), 
        country = ifelse(country == "Row", "ROW", country), 
        country = ifelse(country == "Us", "USA", country), 
        country = fct_relevel(country, rev(c(
            "China", "Taiwan", "Malaysia", "Japan", "Europe", "USA", "ROW"))),
        year = as.factor(year))

# Make the bar plot
solarBars <- 
    ggplot(df,
    aes(x = year, y = production_gw)) +
    geom_col(aes(fill = country), width = 0.7, alpha = 0.9) +
    scale_y_continuous(
        limits = c(0, 140), breaks=seq(0, 140, 20), 
        expand = expansion(mult = c(0, 0.05))) +
    scale_fill_manual(values = plotColors) +
    theme_minimal_hgrid(font_family = "Fira Sans Condensed", font_size = 16) +
    theme(
        legend.position = c(0.01, 0.7),
        legend.background = element_rect(
            fill = "white", color = "black", size = 0.2),
        legend.margin = margin(6, 8, 8, 6)) +
    labs(x = 'Year',
         y = 'Annual Cell Production (GW)',
         title = 'Annual Solar Voltaic Cell Production (GW)',
         fill  = 'Country')

ggsave(here::here("plots", "solarBars.pdf"),
  solarBars, width = 8, height = 6, device = cairo_pdf)
ggsave(here::here("plots", "solarBars.png"),
  solarBars, width = 8, height = 6, dpi = 300)
