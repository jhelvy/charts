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
election_margins <- elections %>% 
    mutate(
        candidateLabelPos = ifelse(margin > 0, -0.004, 0.004),
        candidateLabelHjust = ifelse(margin > 0, 1, 0),
        marginLabel = scales::percent(margin, accuracy = 0.1),
        marginLabelHjust = ifelse(margin > 0, 0, 1),
        marginLablePos = ifelse(margin > 0, margin + 0.005, margin - 0.005)) %>% 
    ggplot() +
    geom_col(aes(x = margin, y = candidate, fill = political_party)) + 
    geom_vline(xintercept = 0) +
    geom_text(aes(x = candidateLabelPos, y = candidate, label = candidate, 
                  hjust = candidateLabelHjust), family = "Roboto Condensed") +
    geom_text(aes(x = marginLablePos, y = candidate, label = marginLabel,
                  hjust = marginLabelHjust),
              family = "Roboto Condensed") +
    scale_x_continuous(
        expand = expansion(mult = c(0, 0.05)),
        breaks = seq(-0.15, 0.3, 0.15),
        limits = c(-0.15, 0.3),
        labels = scales::percent) +
    scale_fill_manual(values = plotColors) +
    theme_map(font_size = 16, font_family = "Roboto Condensed") +
    theme(
        axis.line = element_blank(), # Remove y axis line
        legend.position = c(0.77, 0.995), 
        legend.justification = c(0, 1),
        legend.background = element_rect(
            fill = "white", color = "black", size = 0.2
        ),
        legend.margin = margin(6, 6, 6, 6),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        plot.caption.position = "plot",
        plot.caption = element_text(
            hjust = 1, size = 10, family = "Roboto Condensed", face = "italic"
        ),
        plot.title.position = "plot",
        plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm")
        ) +
    coord_cartesian(clip = "off") +
    labs(
        title = "Popular vote margin of elected US presidents",
        subtitle = "The candidate that lost the popular vote has won the presidency 5 times",
        caption = "Data from Encyclopaedia Britannica, United States Presidential Election Results\nChart by John Paul Helveston",
        fill = "President party")

ggsave(here::here("plots", "election_margins.pdf"),
       election_margins, width = 7, height = 10, device = cairo_pdf)

ggsave(here::here("plots", "election_margins.png"),
       election_margins, width = 7, height = 10)
