# Author: John Paul Helveston
# First written on Friday, October 30, 2020
# Last updated on Friday, October 30, 2020
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Scatterplot of SCOTUS nominees: days from nomination to result versus days 
# until next election

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
barrettLabel <- "Senate Republicans rushed to confirm Judge Amy C. Barrett just **7 days** before the 2020 presidential election - the closest confirmation to an election in U.S. history."
garlandLabel <- "In 2016, Senate Majority Leader Mitch McConnell (R) blocked the confirmation of Obama-nominated Judge Merrick Garland by refusing to hold a confirmation vote for a record-breaking **293 days** to “Let the American people decide” who should fill the seat left by the late Justice Antonin Scalia."
# Election year line & label
elecLineLabel <- "Judges nominated\nduring an\nelection year"
threshold <- scotus %>%
  filter(nominatedInElectionYear == 1) %>%
  filter(daysNomTilNextElection == max(daysNomTilNextElection))
elecLine <- threshold$daysNomTilNextElection

# Create main chart
scotus_nominations <- ggplot(scotus) +
  # Election line annotation
  geom_blank(aes(x = daysNomTilNextElection, y = daysUntilResult)) +
  geom_vline(xintercept = elecLine) +
  annotate(
    geom = "rect", xmin = 0, xmax = elecLine,
    ymin = -8, ymax = 300, fill = "#8C8C8C",
    alpha = 0.15
  ) +
  geom_vline(xintercept = 0) +
  annotate(
    geom = "text", x = 290, y = 223, label = elecLineLabel, 
    hjust = 0, size = 3.5, family = annFont, fontface = annFace, color = annColor
  ) +
  geom_segment(
    aes(x = elecLine, xend = 100, y = 245, yend = 245),
    color = annColor, arrow = arrow(30, unit(0.1, "inches"), "last")
  ) +
  # Main scatterplot
  geom_point(aes(x = daysNomTilNextElection, y = daysUntilResult, 
                  fill = presidentParty), 
              size = 2.5, shape = 21, color = "black") +
  scale_y_continuous(
    limits = c(-8, 300), 
    breaks = seq(0, 300, 100),
    expand = expansion(mult = c(0, 0))) +
  scale_x_reverse(
    labels = scales::comma,
    expand = expansion(mult = c(0, 0)),
    breaks = seq(1500, 0, -500), limits = c(1500, 0)
  ) +
  scale_fill_manual(values = plotColors) +
  # Add barrettLabel annotation
  geom_curve(data = data.frame(x = 350, xend = 42, y = 150, yend = 32),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = -0.2, size = 0.5, color = annColor, arrow = arrow(
      30, unit(0.1, "inches"), "last", "closed"), inherit.aes = FALSE) +
  geom_textbox(data = data.frame(x = 630, y = 160, label = barrettLabel),
    aes(x = x, y = y, label = label),
    width = unit(0.38, "npc"), size = 3.5, family = annFont, color = annColor,
    fontface = annFace) +
  # Add garlandLabel annotation
  geom_curve(data = data.frame(x = 430, xend = 245, y = 250, yend = 289),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = 0.2, size = 0.5, color = annColor, arrow = arrow(
      30, unit(0.1, "inches"), "last", "closed"), inherit.aes = FALSE) +
  geom_textbox(data = data.frame(x = 780, y = 250, label = garlandLabel),
    aes(x = x, y = y, label = label),
    width = unit(0.47, "npc"), size = 3.5, family = annFont, color = annColor,
    fontface = annFace) +
  theme_minimal_grid(font_size = 15, font_family = mainFont) +
  panel_border() +
  theme(
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
    x = "Days until the next presidential election\n",
    y = "Days from nomination to result",
    fill = "Party of\nnominating\npresident",
    title = titleLabel,
    subtitle = subtitleLabel,
    caption = captionLabel
  )

ggsave(here::here("plots", "scotus_nominations_5.pdf"),
  scotus_nominations, width = 9, height = 7, device = cairo_pdf)
ggsave(here::here("plots", "scotus_nominations_5.png"),
  scotus_nominations, width = 9, height = 7, dpi = 300)
