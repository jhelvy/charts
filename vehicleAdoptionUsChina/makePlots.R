# =============================================================================
# makePlots.R
# Annual new passenger (light-duty) vehicle sales vs. passenger vehicles per
# 1,000 people, U.S. (1931-2024) and China (1995-2024).
#
# Input : data/clean/passenger_sales_ownership.csv  (from formatData.R)
# Output: plots/salesVsOwnership.png / .pdf
# Run from anywhere in the charts repo:  Rscript vehicleAdoptionUsChina/makePlots.R
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(cowplot)
  library(ggrepel)
  library(ggtext)
})

# All paths are relative to this chart's folder in the charts repo
root <- here::here('vehicleAdoptionUsChina')

# Plot settings ----

font <- 'Roboto Condensed'
plotColors <- c('China' = '#E41A1C', 'U.S.' = '#2171B5')

# Years to label; years not in the data are dropped
labelYears <- list(
  'U.S.'  = c(1931, 1941, 1955, 1965, 1970, 1975, 1982, 1986, 1991,
              2000, 2009, 2024),
  'China' = c(1995, 2005, 2009, 2013, 2016, 2019, 2024)
)

title <- paste0(
  "<span style='color:", plotColors['China'], "'>China</span> ",
  "sells more new cars a year than the ",
  "<span style='color:", plotColors['U.S.'], "'>U.S.</span> ever has, ",
  "with a quarter of the cars per person"
)
subtitle <- paste(
  "Annual new passenger vehicle sales vs. passenger vehicles in use per 1,000 people"
)
caption <- paste0(
  "U.S.: light-duty vehicles (cars + light trucks). Stock: FHWA/BTS registrations ",
  "(pre-1970 estimated from total registrations) / Census population.\n",
  "Sales: WardsAuto (1931-1975, scaled to light vehicles), BEA (1976-).\n",
  "China: passenger vehicles. Stock: NBS / NBS population. Sales: China Statistical ",
  "Yearbook passenger cars (1995-2004),\nCAAM passenger vehicles net of exports (2005-).\n",
  "Dotted U.S. segment: no sales data 1942-1950 (civilian production halted in WWII)."
)

# Data ----

d <- read_csv(
  file.path(root, 'data', 'clean', 'passenger_sales_ownership.csv'),
  show_col_types = FALSE
) |>
  mutate(country = factor(country, levels = c('China', 'U.S.'))) |>
  arrange(country, year)

# Split each series where consecutive years are more than 2 years apart, so
# the WWII gap is drawn as a dotted connector instead of a solid line
d <- d |>
  group_by(country) |>
  mutate(segment = cumsum(c(1, diff(year) > 2))) |>
  ungroup()

gaps <- d |>
  group_by(country) |>
  mutate(xend = lead(vehicles_per_1000), yend = lead(sales_millions),
         next_segment = lead(segment)) |>
  filter(!is.na(next_segment), next_segment != segment) |>
  ungroup()

labelDf <- d |>
  filter(map2_lgl(as.character(country), year, \(k, y) y %in% labelYears[[k]]))

# Latest year gets a fixed label to the right of its point
lastDf <- d |> filter(year == max(year), .by = country)
labelDf <- labelDf |>
  anti_join(lastDf, by = c('country', 'year')) |>
  mutate(
    label = as.character(year),
    # Starting offsets (data units) that move labels into open space where
    # repel alone settles on top of a line
    nx = case_when(
      country == 'U.S.' & year == 1941 ~ -35,
      country == 'China' & year == 2005 ~ 35,
      country == 'China' & year == 1995 ~ 30,
      country == 'U.S.' & year == 2000 ~ -30,
      .default = 0
    ),
    ny = case_when(
      country == 'U.S.' & year == 1941 ~ 1.8,
      country == 'China' & year == 2005 ~ -0.6,
      country == 'China' & year == 1995 ~ 0.4,
      country == 'U.S.' & year == 2000 ~ 1.2,
      .default = 0
    )
  )

# ggrepel keeps labels off data points but not off the lines between them.
# Sample many unlabeled points along every line segment (including the dotted
# WWII gap) so repel treats the lines themselves as obstacles.
densify <- function(df, n = 25) {
  df |>
    group_by(country) |>
    mutate(x2 = lead(vehicles_per_1000), y2 = lead(sales_millions)) |>
    ungroup() |>
    filter(!is.na(x2)) |>
    mutate(t = list(seq(0, 1, length.out = n))) |>
    unnest(t) |>
    transmute(
      country,
      vehicles_per_1000 = vehicles_per_1000 + t * (x2 - vehicles_per_1000),
      sales_millions = sales_millions + t * (y2 - sales_millions),
      label = ''
    )
}
repelDf <- bind_rows(labelDf, densify(d)) |>
  mutate(across(c(nx, ny), \(v) replace_na(v, 0)))

countryDf <- tibble(
  country = factor(c('China', 'U.S.'), levels = c('China', 'U.S.')),
  vehicles_per_1000 = c(40, 600),
  sales_millions = c(22.5, 7)
)

# Plot ----

plot <- ggplot(d, aes(x = vehicles_per_1000, y = sales_millions, color = country)) +
  geom_segment(
    data = gaps,
    aes(xend = xend, yend = yend),
    linetype = 'dotted',
    linewidth = 0.5
  ) +
  geom_path(aes(group = interaction(country, segment)), linewidth = 0.5) +
  geom_point(size = 0.9) +
  geom_text_repel(
    data = repelDf,
    aes(label = label),
    family = font,
    size = 3.3,
    min.segment.length = 0,
    segment.size = 0.25,
    segment.color = 'grey60',
    box.padding = 0.3,
    point.padding = 0.25,
    force = 2,
    max.iter = 20000,
    max.time = 10,
    max.overlaps = Inf,
    nudge_x = repelDf$nx,
    nudge_y = repelDf$ny,
    seed = 42,
    show.legend = FALSE
  ) +
  geom_text(
    data = lastDf,
    aes(label = year),
    family = font,
    fontface = 'bold',
    size = 3.3,
    hjust = 0,
    nudge_x = 10
  ) +
  annotate(
    'text', x = 300, y = 4.6, label = 'WWII', family = font,
    size = 3.2, color = 'grey50', fontface = 'italic'
  ) +
  geom_text(
    data = countryDf,
    aes(label = country),
    family = font,
    fontface = 'bold',
    size = 6,
    hjust = 0
  ) +
  scale_color_manual(values = plotColors) +
  scale_x_continuous(
    breaks = seq(0, 800, 200),
    expand = expansion(mult = c(0.01, 0.03))
  ) +
  scale_y_continuous(
    breaks = seq(0, 25, 5),
    expand = expansion(mult = c(0, 0.05))
  ) +
  coord_cartesian(xlim = c(0, 860), ylim = c(0, NA), clip = 'off') +
  labs(
    x = 'Passenger vehicles per 1,000 people',
    y = 'Annual new passenger vehicle sales (millions)',
    title = title,
    subtitle = subtitle,
    caption = caption
  ) +
  theme_minimal_grid(font_family = font, font_size = 13) +
  theme(
    legend.position = 'none',
    plot.title.position = 'plot',
    plot.caption.position = 'plot',
    plot.title = element_markdown(family = font, size = 16),
    plot.subtitle = element_text(color = 'grey30', margin = margin(b = 10)),
    plot.caption = element_text(hjust = 0, size = 8.5, color = 'grey40',
                                lineheight = 1.1, margin = margin(t = 12)),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA),
    plot.margin = margin(12, 16, 8, 12)
  )

# Save ----

dir.create(file.path(root, 'plots'), showWarnings = FALSE)
ggsave(
  file.path(root, 'plots', 'salesVsOwnership.png'),
  plot,
  width = 9,
  height = 6.5,
  dpi = 300
)
ggsave(
  file.path(root, 'plots', 'salesVsOwnership.pdf'),
  plot,
  width = 9,
  height = 6.5,
  device = cairo_pdf
)
message('Saved plots/salesVsOwnership.png and .pdf')
