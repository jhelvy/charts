# =============================================================================
# formatData.R
# Builds a tidy country-year table comparing PASSENGER vehicle fleets and
# PASSENGER vehicle sales in the United States and China:
#   x = passenger (light-duty) vehicles in use per 1,000 people
#   y = annual new passenger (light-duty) vehicle sales, millions
#
# Definitions (see README.md for full detail):
#   U.S.  : "light-duty vehicles" = cars + SUVs + pickups + vans (light trucks).
#           Motorcycles, buses, and medium/heavy trucks are excluded.
#           Sales: BEA ALTSALES (autos + light trucks).
#   China : NBS "passenger vehicles" (载客汽车; small/mini cars, SUVs, MPVs,
#           plus a small share of buses). Sales: CAAM passenger vehicles
#           (乘用车), by default net of passenger-vehicle exports.
#
# Input : data/raw/*.csv
#         data/clean/us_sales_historical.csv, china_sales_historical.csv
#         (from formatHistoricalSales.R)
# Output: data/clean/passenger_sales_ownership.csv
# Run from anywhere in the charts repo:  Rscript vehicleAdoptionUsChina/formatData.R
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

# All paths are relative to this chart's folder in the charts repo
root <- here::here('vehicleAdoptionUsChina')

# ---- Options ----------------------------------------------------------------
# China sales basis: "domestic" = CAAM passenger sales minus passenger exports
# (comparable to BEA U.S. sales, which count vehicles sold in the U.S.);
# "incl_exports" = CAAM headline passenger sales (factory shipments incl. exports).
CHINA_SALES_BASIS <- "domestic"

# U.S. light-duty counts are only published from 1970. For years before 1970
# (needed for the 1931-1969 Wards sales), hold the 1970 light-duty share of
# all registrations constant. Set FALSE to drop pre-1970 years instead.
US_BACKCAST_PRE1970 <- TRUE
# -----------------------------------------------------------------------------

raw <- function(f) file.path(root, "data", "raw", f)
clean <- function(f) file.path(root, "data", "clean", f)
rd  <- function(f) read_csv(raw(f), show_col_types = FALSE, comment = "#")

# Linear interpolation helper (no extrapolation)
interp <- function(x, y, xout) approx(x, y, xout = xout, rule = 1)$y

# =============================================================================
# 1. UNITED STATES: light-duty vehicles per 1,000 people
# =============================================================================
us_ldv   <- rd("us_light_duty_registrations.csv")
us_total <- rd("us_registrations_fhwa.csv") |>
  mutate(total = registered_vehicles_millions * 1e6)
us_pop   <- rd("us_population.csv")

# Light-duty share of all registrations at the years where it is published;
# interpolate the share for unpublished years (1971-74, 76-79, 81-84, 86-89)
# and apply it to FHWA total registrations.
anch <- inner_join(us_ldv, us_total, by = "year") |>
  mutate(share = light_duty_vehicles / total)

grid <- us_total |>
  select(year, total) |>
  left_join(us_ldv |> select(year, light_duty_vehicles), by = "year") |>
  mutate(share = interp(anch$year, anch$share, year))

share_1970 <- anch$share[anch$year == 1970]

us_stock <- grid |>
  mutate(
    ldv = case_when(
      !is.na(light_duty_vehicles) ~ light_duty_vehicles,
      !is.na(share)               ~ share * total,
      year < 1970 & US_BACKCAST_PRE1970 ~ share_1970 * total,
      TRUE ~ NA_real_),
    own_method = case_when(
      !is.na(light_duty_vehicles) ~ "published",
      !is.na(share)               ~ "interpolated LDV share x FHWA total",
      year < 1970 & US_BACKCAST_PRE1970 ~ "backcast: 1970 LDV share x FHWA total",
      TRUE ~ NA_character_)) |>
  filter(!is.na(ldv)) |>
  inner_join(us_pop |> select(year, population), by = "year") |>
  transmute(year,
            vehicles_per_1000 = ldv / population * 1000,
            own_source = paste("FHWA/BTS light-duty vehicles / Census pop.;", own_method))

# =============================================================================
# 2. UNITED STATES: light-duty vehicle sales
# =============================================================================
# BEA ALTSALES is a monthly seasonally adjusted annual rate (SAAR); the
# calendar-year total is the mean of the 12 monthly values.
us_sales <- rd("us_sales_bea_altsales_monthly.csv") |>
  mutate(year = as.integer(substr(as.character(date), 1, 4))) |>
  group_by(year) |>
  summarise(n = n(), sales_millions = mean(saar_millions), .groups = "drop") |>
  filter(n == 12) |>
  transmute(year, sales_millions, sales_source = "BEA ALTSALES (autos + light trucks)")

hist_us <- clean("us_sales_historical.csv")
if (file.exists(hist_us)) {
  h <- read_csv(hist_us, show_col_types = FALSE) |>
    filter(!year %in% us_sales$year)
  us_sales <- bind_rows(h, us_sales)
  message("Merged historical U.S. sales: ", min(h$year), "-", max(h$year))
}

us <- inner_join(us_stock, us_sales, by = "year") |> mutate(country = "U.S.")

# =============================================================================
# 3. CHINA: passenger vehicles per 1,000 people
# =============================================================================
cn_pv  <- rd("china_passenger_vehicle_stock_nbs.csv")
cn_civ <- rd("china_civil_vehicles_nbs.csv")
cn_pop <- rd("china_population_nbs.csv")

# 2012-2014 passenger-vehicle counts are not in the sources compiled here;
# interpolate the passenger share of all civil vehicles between 2011 and 2015.
sh <- inner_join(cn_pv, cn_civ, by = "year") |>
  mutate(share = passenger_vehicles_10k_units / civil_vehicles_10k_units)
gap <- cn_civ |>
  filter(!year %in% cn_pv$year) |>
  mutate(passenger_vehicles_10k_units = interp(sh$year, sh$share, year) * civil_vehicles_10k_units,
         source = "interpolated passenger share x NBS civil vehicles") |>
  select(year, passenger_vehicles_10k_units, source)

cn_stock <- bind_rows(cn_pv, gap) |>
  arrange(year) |>
  inner_join(cn_pop |> select(year, population_10k), by = "year") |>
  transmute(year,
            vehicles_per_1000 = passenger_vehicles_10k_units / population_10k * 1000,
            own_source = ifelse(grepl("interpolated", source),
                                "NBS passenger vehicles / NBS pop.; interpolated",
                                "NBS passenger vehicles / NBS pop.; published"))

# =============================================================================
# 4. CHINA: passenger vehicle sales
# =============================================================================
cn_sales <- rd("china_passenger_sales_caam.csv") |>
  mutate(units = if (CHINA_SALES_BASIS == "domestic") pv_sales_units - pv_exports_units
                 else pv_sales_units) |>
  transmute(year, sales_millions = units / 1e6,
            sales_source = if (CHINA_SALES_BASIS == "domestic")
              "CAAM passenger vehicles minus PV exports" else
              "CAAM passenger vehicles (incl. exports)")

hist_cn <- clean("china_sales_historical.csv")
if (file.exists(hist_cn)) {
  h <- read_csv(hist_cn, show_col_types = FALSE) |>
    filter(!year %in% cn_sales$year)
  cn_sales <- bind_rows(h, cn_sales)
  message("Merged historical China sales: ", min(h$year), "-", max(h$year))
}

cn <- inner_join(cn_stock, cn_sales, by = "year") |> mutate(country = "China")

# =============================================================================
# 5. Combine and write
# =============================================================================
out <- bind_rows(us, cn) |>
  select(country, year, vehicles_per_1000, sales_millions, own_source, sales_source) |>
  arrange(country, year) |>
  mutate(vehicles_per_1000 = round(vehicles_per_1000, 2),
         sales_millions    = round(sales_millions, 3))

dir.create(file.path(root, "data", "clean"), showWarnings = FALSE, recursive = TRUE)
write_csv(out, file.path(root, "data", "clean", "passenger_sales_ownership.csv"))

message("China sales basis: ", CHINA_SALES_BASIS)
message("Wrote data/clean/passenger_sales_ownership.csv")
print(out |> group_by(country) |>
        summarise(first = min(year), last = max(year), n = n(), .groups = "drop"))
