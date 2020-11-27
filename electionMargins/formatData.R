# Data Sources: See "data_sources.txt" for details

library(tidyverse)
library(lubridate)
library(ggtext)
options(dplyr.width = Inf)

elections <- read_csv(here::here('data', 'elections.csv')) %>% 
    filter(!is.na(popular_vote)) %>% 
    group_by(year) %>% 
    mutate(
        p_pop = popular_vote / sum(popular_vote),
        p_elec = electoral_vote / sum(electoral_vote)) %>% 
    arrange(year, desc(winner), desc(p_pop), desc(p_elec)) %>% 
    slice(1:2) %>% 
    mutate(
        total_pop = sum(p_pop),
        total_elec = sum(p_elec),
        opponent_pop = total_pop - p_pop,
        opponent_elec = total_elec - p_elec,
        margin_pop = p_pop - opponent_pop,
        margin_elec = p_elec - opponent_elec) %>% 
    ungroup() %>% 
    mutate(
        political_party = ifelse(
            political_party %in% c("Democratic", "Republican"), 
            political_party, "Other"),
        candidate = paste0(candidate, " (", year, ")"),
        political_party = fct_relevel(political_party, c(
        "Democratic", "Republican", "Other"))) %>% 
    filter(winner == 1) %>% 
    select(
        year, candidate, political_party, electoral_vote, popular_vote,
        p_pop, p_elec, margin_pop, margin_elec)
