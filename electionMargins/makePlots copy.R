# Author: John Paul Helveston
# First written on Saturday, November 07, 2020
# Last updated on Saturday, November 07, 2020
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Bar chart of US presidential election popular vote and outcome

library(tidyverse)
library(lubridate)
library(cowplot)
options(dplyr.width = Inf)

# Load data
source(here::here("formatData.R"))

# Chart settings
plotColors <- c("blue", "red", "grey70")
annFont <- "Roboto Condensed"
annColor <- "grey33"
annFace <- "italic"

# Make the chart 
election_margins <- ggplot(elections) +
    geom_col(aes(x = margin, y = candidate, fill = political_party)) + 
    geom_vline(xintercept = 0) +
    scale_x_continuous(
        expand = expansion(mult = c(0, 0.05)),
        breaks = seq(-0.15, 0.3, 0.15),
        limits = c(-0.15, 0.3),
        labels = scales::percent) +
    scale_fill_manual(values = plotColors) +
    theme_minimal_vgrid(font_size = 20, font_family = "Roboto Condensed") +
    theme(
        axis.line.x = element_blank(), # Remove y axis line
        legend.position = c(0.65,1), 
        legend.justification = c(0, 1),
        legend.background = element_rect(
            fill = "white", color = "black", size = 0.2
        ),
        legend.margin = margin(6, 6, 6, 6),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        axis.text.y = element_text(size = 10, family = "Georgia"),
        plot.caption.position = "plot",
        plot.caption = element_text(
            hjust = 0, size = 12, family = "Georgia", face = "italic"
        ),
        plot.title.position = "plot",
        plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm")
        ) +
    # panel_border() +
    labs(y = NULL, 
         x = "Popular vote margin over opponent", 
         fill = "President party")

ggsave(here::here("plots", "election_margins.pdf"),
       election_margins, width = 7, height = 10, device = cairo_pdf)
