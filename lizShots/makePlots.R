# Author: John Paul Helveston
# Date: First written on Friday, March 12, 2021
#
# Description:
# A record of the COVID19 shots that Liz has scheduled for others

library(tidyverse)
library(lubridate)
library(cowplot)
library(gsheet)
library(usdata)
library(jhelvyr)
options(dplyr.width = Inf)

# Load data
url <- "https://docs.google.com/spreadsheets/d/1UMTxyOzFQmXH0GZK6PWTskvzJxP_Z9IExcQm6fnzeuI/"
df <- gsheet2tbl(url)

# Set plot colors
plotColors <- c(jColors("extended", c("blue", "red", "green")), "grey70")

# Create chart
bars <- df %>% 
  mutate(
    state = abbr2state(state),
    state = ifelse(is.na(state), "Unknown", state),
    type = str_to_title(type),
    month = month(date),
  ) %>% 
  ggplot() +
  geom_col(aes(x = date, y = n, fill = type), width = 0.7) +
  scale_x_date(date_breaks = "day", date_labels = "%m/%d") + 
  scale_y_continuous(
    limits = c(0, 10), 
    breaks = seq(0, 10, 2),
    expand = expansion(mult = c(0, 0.05))) +
  scale_fill_manual(values = plotColors) +
  theme_minimal_hgrid(
    font_size = 12, 
    font_family = "Fira Sans Condensed") + 
  labs(
    x = "Date", 
    y = "Number of shots scheduled", 
    fill = "Shot type",
    title = "COVID19 Shots Scheduled by Dr. Phung",
    subtitle = paste0("Total Shots Scheduled: ", sum(df$n))
  )

# Save
ggsave(here::here("plots", "bars.pdf"),
    bars, width = 12, height = 4.5, device = cairo_pdf)
ggsave(here::here("plots", "bars.png"),
    bars, width = 12, height = 4.5)
