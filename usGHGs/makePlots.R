# Author: John Paul Helveston
# Date: First written on Friday, May 26, 2023
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# US Greenhouse Gas emissions by sector over time
#
# For details on data sources, see the "README.md" file

library(tidyverse)
library(cowplot)
library(here)
library(jph)

plotColors <- jph::jColors(
    'bright', 
    cs(gray, gray, blue, gray, gray, red)
)
names(plotColors) <- NULL

plot_theme <- function() {
    return(
        theme_minimal_grid(
            font_family = 'Roboto Condensed',
            font_size = 12
        ) + 
            panel_border() +
            theme(
                plot.background = element_rect(fill = "white"),
                panel.background = element_rect(fill = "white"),
                plot.title.position = "plot",
                strip.background = element_rect(fill = "grey80"),
                strip.text = element_text(face = "bold"),
                panel.grid.major = element_line(size = 0.3, colour = "grey90"),
                axis.line.x = element_blank(),
                plot.caption.position = "plot",
                plot.caption = element_text(
                    hjust = 1, size = 11, face = "italic"),
                plot.title = element_text(face = "bold"),
                legend.position = "none"
            ) 
    )
}

# Read in data

df <- read_csv(here::here('usGHGs', 'us_ghgs_by_sector.csv')) %>% 
    janitor::clean_names() %>% 
    rename(sector = u_s_emissions_by_economic_sector_mmt_co2_eq) %>% 
    filter(sector != 'Gross total') %>% 
    filter(sector != 'U.S. territories') %>% 
    pivot_longer(
        names_to = 'year', 
        values_to = 'emissions', 
        cols = -sector
    ) %>% 
    mutate(
        year = parse_number(year), 
        sector = ifelse(
            sector == 'Electric power industry', 
            'Electric power', sector)
    )

# Make figure

fig <- df %>% 
    ggplot(aes(x = year, y = emissions, color = sector)) + 
    geom_line() + 
    plot_theme() + 
    scale_color_manual(values = plotColors) + 
    labs(
        x = "Year", 
        y = "Million Tons CO2 Equivalent", 
        title = "GHG Emissions by U.S. Sector"
    ) + 
    geom_text_repel(
        data = df %>%
            filter(year == max(year)),
        aes(x = year, y = emissions, color = sector, label = sector),
        hjust = 0, nudge_x = 0.5, size = 4, nudge_y = 0.5,
        family = 'Roboto Condensed', 
        direction = 'y'
    ) +
    # Create space for labels on right side
    scale_x_continuous(
        breaks = seq(1990, 2020, 10), 
        expand = expansion(add = c(0.5, 6.5))
    )

ggsave(
    here::here('usGHGs', 'figs', 'ghg_emissions.png'), fig, 
    width = 6.4, height = 4
)

