# Data Sources: See "data_sources.txt" for details

library(tidyverse)
library(lubridate)
library(ggtext)
options(dplyr.width = Inf)

pres_elections <- read_csv(
  here::here('scotus', 'data', 'pres_elections.csv')) %>%
  mutate(
    date_vote = str_replace_all(date_vote, "\\*", ""),
    date_vote = dmy(date_vote))
pres_elections <- as.character(pres_elections$date_vote)

scotus <- read_csv(here::here('scotus', 'data', 'scotus.csv')) %>%
  filter(! result %in% c("declined", "withdrawn", "postponed")) %>%
  mutate(
    number = row_number(),
    nominee = str_to_upper(nominee),
    dateOfNomination = mdy(dateOfNomination),
    dateOfResult = mdy(dateOfResult),
    presidentParty = case_when(
      presidentParty == "Dem" ~ "Democrat",
      presidentParty == "Rep" ~ "Republican",
      TRUE ~ "Other")
    )

# Add presidential election dates to scotus data
dateNextElection <- c()
for (i in 1:nrow(scotus)) {
  dateNom <- scotus[i, ]$dateOfNomination
  dateNextElection <- c(dateNextElection,
                     pres_elections[which(pres_elections >= dateNom)][1])
}
scotus$dateNextElection <- ymd(dateNextElection)
scotus <- scotus %>%
  mutate(
    daysNomTilNextElection = as.numeric(dateNextElection - dateOfNomination),
    daysResTilNextElection = as.numeric(dateNextElection - dateOfResult),
    presidentParty = fct_relevel(presidentParty, c("D", "R", "Other"))) %>%
  filter(!is.na(daysResTilNextElection)) %>% 
  mutate(
    nominatedInElectionYear = ifelse(
      year(dateOfNomination) == year(dateNextElection), 1, 0)) %>% 
  arrange(daysNomTilNextElection)
