# =============================================================================
# formatHistoricalSales.R
# Cleans the historical sales series used in the original (2017) version of
# this figure so they can extend the modern series back in time:
#   U.S.  : WardsAuto U.S. vehicle sales, 1931-2014 (cars + trucks)
#   China : China Statistical Yearbook passenger car sales, 1995-2014
#
# The modern series (BEA ALTSALES from 1976; CAAM passenger vehicles from 2005)
# always take priority. These historical series fill only the earlier years.
#
# Input : data/raw/us_sales_wards_1931_2014.csv
#         data/raw/china_sales_yearbook_1995_2014.csv
#         data/raw/us_sales_bea_altsales_monthly.csv (for the U.S. splice)
# Originals: ~/pCloud Drive/data/cars/us/sales/1931-2014_us_vehicle_sales.csv
#            ~/pCloud Drive/data/cars/china/sales/aggregateSales_1995_2014.csv
# Output: data/clean/us_sales_historical.csv
#         data/clean/china_sales_historical.csv
# Run from anywhere in the charts repo:  Rscript vehicleAdoptionUsChina/formatHistoricalSales.R
# =============================================================================

suppressPackageStartupMessages(library(tidyverse))

# All paths are relative to this chart's folder in the charts repo
root <- here::here('vehicleAdoptionUsChina')

# ---- Options ----------------------------------------------------------------
# Wards totals include medium and heavy trucks; BEA ALTSALES counts only light
# vehicles. Over 1976-1980 the BEA/Wards ratio is stable at about 0.975. If
# TRUE, scale the pre-1976 Wards totals by that ratio so the U.S. series has
# no jump at the 1975/1976 splice. Set FALSE to use the published Wards totals.
US_SCALE_WARDS_TO_BEA <- TRUE
SPLICE_YEARS <- 1976:1980
# -----------------------------------------------------------------------------

raw <- function(f) file.path(root, "data", "raw", f)

# ---- U.S.: WardsAuto 1931-2014 ----------------------------------------------
# The file has a block of placeholder rows (1932-1940, all NA) and only every
# other year before 1963. Keep only the published values.
wards <- read_csv(raw("us_sales_wards_1931_2014.csv"), show_col_types = FALSE) |>
  filter(!is.na(total)) |>
  distinct(year, .keep_all = TRUE) |>
  mutate(year = as.integer(year))

bea <- read_csv(raw("us_sales_bea_altsales_monthly.csv"), show_col_types = FALSE) |>
  mutate(year = as.integer(substr(as.character(date), 1, 4))) |>
  summarise(n = n(), bea = mean(saar_millions) * 1e6, .by = year) |>
  filter(n == 12)

splice_ratio <- inner_join(wards, bea, by = "year") |>
  filter(year %in% SPLICE_YEARS) |>
  summarise(r = mean(bea / total)) |>
  pull(r)

us_hist <- wards |>
  filter(year < min(bea$year)) |>
  transmute(
    year,
    sales_millions = total / 1e6 * if (US_SCALE_WARDS_TO_BEA) splice_ratio else 1,
    sales_source = if (US_SCALE_WARDS_TO_BEA)
      sprintf("WardsAuto cars + trucks x %.3f (BEA/Wards %d-%d ratio)",
              splice_ratio, min(SPLICE_YEARS), max(SPLICE_YEARS)) else
      "WardsAuto cars + trucks"
  )

# ---- China: Statistical Yearbook passenger cars 1995-2014 -------------------
# Values are in millions. CAAM's passenger-vehicle (乘用车) category begins in
# 2005, so only 1995-2004 are used here. Exports before 2005 were negligible,
# so these values are comparable with the "domestic" CAAM basis.
cn_hist <- read_csv(raw("china_sales_yearbook_1995_2014.csv"), show_col_types = FALSE) |>
  rename(year = Year, sales_millions = `Passenger Cars`) |>
  filter(year < 2005) |>
  transmute(year = as.integer(year), sales_millions,
            sales_source = "China Statistical Yearbook passenger cars")

# ---- Write ------------------------------------------------------------------
dir.create(file.path(root, "data", "clean"), showWarnings = FALSE, recursive = TRUE)
write_csv(us_hist |> mutate(sales_millions = round(sales_millions, 3)),
          file.path(root, "data", "clean", "us_sales_historical.csv"))
write_csv(cn_hist, file.path(root, "data", "clean", "china_sales_historical.csv"))

message(sprintf("U.S. historical sales: %d years, %d-%d (splice ratio %.3f, applied: %s)",
                nrow(us_hist), min(us_hist$year), max(us_hist$year),
                splice_ratio, US_SCALE_WARDS_TO_BEA))
message(sprintf("China historical sales: %d years, %d-%d",
                nrow(cn_hist), min(cn_hist$year), max(cn_hist$year)))
