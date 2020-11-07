# Data Sources: See "data_sources.txt" for details

library(tidyverse)
library(lubridate)
library(ggtext)
options(dplyr.width = Inf)

elections <- read_csv(here::here('data', 'elections.csv')) %>% 
    filter(!is.na(popular_vote)) %>% 
    group_by(year) %>% 
    mutate(p_pop = popular_vote / sum(popular_vote)) %>% 
    arrange(year, desc(winner), desc(p_pop)) %>% 
    slice(1:2) %>% 
    mutate(
        total = sum(p_pop),
        opponent = total - p_pop,
        margin = p_pop - opponent) %>% 
    ungroup() %>% 
    mutate(
        political_party = ifelse(
            political_party %in% c("Democratic", "Republican"), 
            political_party, "Other"),
        candidate = paste0(candidate, " (", year, ")"),
        candidate = fct_reorder(candidate, -margin),
        political_party = fct_relevel(political_party, c(
        "Democratic", "Republican", "Other"))) %>% 
    filter(winner == 1) %>% 
    select(
        year, candidate, political_party, electoral_vote, popular_vote,
        p_pop, margin)
