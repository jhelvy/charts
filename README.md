charts
================

A repo of reproducible charts

# Table of Contents

  - [climateChangeBarcode](#climateChangeBarcode)
  - [electricityEIA](#electricityEIA)
  - [newEnergyInvestment](#newEnergyInvestment)
  - [solarPvProduction](#solarPvProduction)
  - [worldNuclearAssociation](#worldNuclearAssociation)

## climateChangeBarcode

**Description**: “Barcode” plots showing the long term rise in global
and US temperatures. Each vertical stripe represents the average
temperature of a single year, ordered from the earliest available data
to the present. Original figures by [Ed
Hawkins](http://www.climate-lab-book.ac.uk/2018/warming-stripes/#more-5516).

**Data Sources**: 1) [NASA (2018) “Goddard Institute for Space Studies
(GISS)”](https://climate.nasa.gov/vital-signs/global-temperature/); 2)
[NOAA National Centers for Environmental
information](http://www.ncdc.noaa.gov/cag/).

**Example Plot**: *Global temperatures, 1880 - 2018,
NASA*

<img src="./climateChangeBarcode/plots/nasa_global_preview.png" alt="climateChangeBarcode" width="300"/>

## electricityEIA

**Description**: Barplots of energy capacity and generation by country /
region using EIA data.

**Data Source**: [U.S. Energy Information Administration
(EIA)](https://www.eia.gov/beta/international/data/browser/)

**Example Plot**: *Installed Wind Power Capacity by Country / Region,
2000 -
2016.*

<img src="./electricityEIA/plots/windCapacity.png" alt="electricityEIA" width="600"/>

## newEnergyInvestment

**Description**: Barplots of new clean energy investment by country and
type.

**Data Source**: Clean energy investment by [Bloomberg New Energy
Finance](https://about.bnef.com/clean-energy-investment/)

**Example Plot**: *New Investment in Clean Energy ($USD Billion), 2005 -
2018*

<img src="./newEnergyInvestment/plots/facetPlot.png" alt="newEnergyInvestment" width="600"/>

## solarPvProduction

**Description**: Barplot of global annual solar photovoltaic cell
production by country.

**Data Sources**: 1995 to 2013: [Earth Policy
Institute](http://www.earth-policy.org/data_center/C23); 2014 to 2018:
[Jäger-Waldau, A. (2019). Snapshot of Photovoltaics—February 2019.
Energies, 12(5), 769](https://www.mdpi.com/1996-1073/12/5/769). Data
reverse engineered from Figure 1 using
[WebPlotDigitizer](https://automeris.io/WebPlotDigitizer/).

**Example Plot**: *Annual Solar Voltaic Cell Production (GW), 2000 -
2018*

<img src="./solarPvProduction/plots/solarPlot.png" alt="solarPvProduction" width="400"/>

## worldNuclearAssociation

**Description**: Barplots of nuclear energy capacity by country.

**Data Source**: Webscraped data from the [World Nuclear
Association](http://www.world-nuclear.org/information-library/facts-and-figures/world-nuclear-power-reactors-and-uranium-requireme.aspx)

**Example Plot**: *New Nuclear Energy Capacity (GW) by Country, 2008 -
2019*

<img src="./worldNuclearAssociation/plots/newCapacity.png" alt="newCapacity" width="400"/>

# Author and License

  - Author: John Paul Helveston (www.jhelvy.com)
  - License: GPL-3
