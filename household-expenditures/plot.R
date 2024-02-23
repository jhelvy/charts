library(tidyverse)
library(cowplot)

df <- read_csv(here::here('data', 'combined.csv')) %>% 
  janitor::clean_names() %>% 
  filter(! item %in% c(
    'num_respondents_thousdands', 'income_pre_tax', 'Total'
  )) %>% 
  pivot_longer(
    names_to = 'year', 
    values_to = 'amount', 
    cols = -item
  ) %>% 
  mutate(year = parse_number(year)) %>% 
  pivot_wider(
    names_from = item, 
    values_from = amount
  ) %>% 
  pivot_longer(
    names_to = 'item', 
    values_to = 'amount', 
    cols = -c('year', 'income_post_tax')
  ) %>% 
  mutate(percent = amount / income_post_tax)

df %>%
  ggplot(aes(x = year, y = percent, color = item, label = item)) +
  geom_line() +
  geom_point() +
  geom_text(
    data = df %>% filter(year == max(year)),
    hjust = 0, nudge_x = 0.5, size = 5,
    family = 'Fira Sans Condensed'
  ) +
  geom_vline(xintercept = 2000) +
  geom_hline(yintercept = 0) +
  scale_y_continuous(
    expand = expansion(c(0, 0.05)), 
    labels = scales::percent
  ) +
  scale_x_continuous(
    limits = c(2000, 2025),
    breaks = seq(2000, 2020, 5),
    expand = expansion(add = c(0, 3))
  ) +
  scale_color_brewer(palette = 'Dark2') +
  coord_cartesian(ylim = c(0, 0.31)) +
  theme_minimal_grid(font_family = 'Fira Sans Condensed') +
  theme(
    legend.position = 'none', 
    panel.background = element_rect(fill = 'white'),
    plot.background = element_rect(fill = 'white')
  ) +
  labs(
    x = 'Year',  
    y = 'Percentage of Household Income',
    title = 'U.S. Expenditures as Percentage of Household Income',
    subtitle = 'Percentages computed using post-tax income',
    caption = 'Data source: US BLS: https://www.bls.gov/cex/tables/top-line-means.htm'
  )

ggsave(
  here::here('plots', 'household-expenditures.png'), 
  height = 5.5, width = 7
)
