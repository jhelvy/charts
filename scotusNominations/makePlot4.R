# Author: John Paul Helveston
# First written on Friday, October 30, 2020
# Last updated on Friday, October 30, 2020
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Point plot of days until nomination result

set.seed(42)
library(tidyverse)
library(lubridate)
library(cowplot)
library(ggtext)
options(dplyr.width = Inf)

# Load data
source("formatData2.R")
plotColors <- c("blue", "red", "grey70")
mainFont <- "Fira Sans Condensed"
annFont <- "Fira Sans Condensed"
annColor <- "grey33"
annFace <- "italic"
facetLabelElecYear <- "Nominated during **election** year"
facetLabelNonElecYear <- "Nominated during **non-election** year"

# Create labels and compute metrics for labels
titleLabel <- "Time from Nomination to Result of Every U.S. Supreme Court Justice"
subtitleLabel <- "Only 15 justice nominations have occured during an election year; during the two most recent (2016 & 2020), Senate Republicans\nused unprecedented measures (with contradicting justifications) to confirm more conservative justices to the court."
captionLabel <- paste0(
  "Data from Wikipedia, List of nominations to SCOTUS\n", 
  "Chart CC-BY-SA 4.0 John Paul Helveston")
barrettLabel <- "Senate Republicans rushed to confirm Judge Amy C. Barrett just **7 days** before the 2020 presidential election - the closet confirmation to an election in U.S. history."
garlandLabel <- "In 2016, Senate Majority Leader Mitch McConnell (R) blocked the confirmation of Obama-nominated Judge Merrick Garland by refusing to hold a confirmation vote for a record-breaking **293 days** to “Let the American people decide” who should fill the seat left by the late Justice Antonin Scalia."

# Create main chart
scotus_nominations <- scotus %>%
  mutate(nominatedInElectionYear = ifelse(
    nominatedInElectionYear == 1, facetLabelElecYear, facetLabelNonElecYear
  )) %>% 
  ggplot() +
  geom_jitter(aes(x = daysUntilResult, y = presidentParty, 
                  fill = presidentParty), 
              height = 0.2, size = 2.5, shape = 21, color = "black") + 
  facet_wrap(vars(nominatedInElectionYear), ncol = 1) + 
  scale_fill_manual(values = plotColors) +
  scale_x_continuous(
    expand = expansion(mult = c(0.01, 0)),
    limits = c(-1, 300), breaks = seq(0, 300, 100)) +
  # Add barrettLabel annotation
  geom_curve(data = data.frame(
    x = 50, xend = 10, y = 2.6, yend = 2.15,
    nominatedInElectionYear = facetLabelElecYear),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = 0.17, size = 0.5, color = annColor, arrow = arrow(
      30, unit(0.1, "inches"), "last", "closed"), inherit.aes = FALSE) +
  geom_textbox(data = data.frame(
    x = 87, y = 2.5, 
    nominatedInElectionYear = facetLabelElecYear, 
    label = barrettLabel),
    aes(x = x, y = y, label = label),
    width = unit(0.3, "npc"), size = 3.5, family = annFont, color = annColor, 
    fontface = annFace) +
  # Add garlandLabel annotation
  geom_curve(data = data.frame(
    x = 230, xend = 289, y = 1.8, yend = 0.89,
    nominatedInElectionYear = facetLabelElecYear),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = 0.17, size = 0.5, color = annColor, arrow = arrow(
      30, unit(0.1, "inches"), "last", "closed"), inherit.aes = FALSE) +
  geom_textbox(data = data.frame(
    x = 220, y = 2.5, 
    nominatedInElectionYear = facetLabelElecYear, 
    label = garlandLabel),
    aes(x = x, y = y, label = label),
    width = unit(0.43, "npc"), size = 3.5, family = annFont, color = annColor, 
    fontface = annFace) +
  theme_minimal_vgrid(font_size = 15, font_family = mainFont) +
  panel_border() +
  theme(
    legend.position = "none", 
    axis.line.y = element_blank(), # Remove y axis line
    axis.ticks.y = element_blank(),
    strip.text.x = element_markdown(),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(
      hjust = 0, size = 12, family = mainFont, face = annFace),
    plot.caption.position = "plot",
    plot.title.position = "plot",
    plot.margin = margin(0.3, 0.5, 0.3, 0.3, "cm")
  ) +
  labs(
    x = "Days from nomination to result\n",
    y = "Party of nominating president",
    title = titleLabel,
    subtitle = subtitleLabel,
    caption = captionLabel
  )

ggsave(here::here("plots", "scotus_nominations_4.pdf"),
  scotus_nominations, width = 9, height = 7, device = cairo_pdf)
ggsave(here::here("plots", "scotus_nominations_4.png"),
  scotus_nominations, width = 9, height = 7, dpi = 300)
