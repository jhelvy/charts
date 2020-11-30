
<!-- README.md is generated from README.Rmd. Please edit that file -->

# charts

A repo of reproducible charts.

To reproduce any of these charts, follow these steps:

1.  Fork or download all of the files in this repository.
2.  If you haven’t already, [install R](https://cloud.r-project.org/)
    and [install
    RStudio](https://www.rstudio.com/products/rstudio/download/preview/)
    on your computer.
3.  Open the “charts.Rproj” file, which will open RStudio and set the
    working directory to the local folder on your computer containing
    the files in this repository.
4.  Open and run the “makePlots.R” file in any of the folders to produce
    the plots, which will be saved in the corresponding “plots” folder.

**Note**: Most of these plots require additional libraries - read the
top of each “makePlots.R” file to see which ones you should install.

# List of charts

  - [challengerOrings](#challengerOrings)
  - [climateChangeBarcode](#climateChangeBarcode)
  - [electionMargins](#electionMargins)
  - [electricityEIA](#electricityEIA)
  - [ggxaringan](#ggxaringan)
  - [lcetPatenting](#lcetPatenting)
  - [newEnergyInvestment](#newEnergyInvestment)
  - [scienceCommentary2019](#scienceCommentary2019)
  - [scotusNominations](#scotusNominations)
  - [solarPvProduction](#solarPvProduction)
  - [usHighwayFund](#usHighwayFund)
  - [usSolarIndustry](#usSolarIndustry)
  - [worldNuclearAssociation](#worldNuclearAssociation)

## challengerOrings

**Description**: Scatterplot of rocket o-ring damage vs. launch
temperature for test launches prior to Jan. 28, 1986 Challenger launch.
Original figure in [Tufte E.R. 1997. Visual Explanations. Graphics
Press](https://pubs.acs.org/doi/abs/10.1021/ci9804286). Cheshire,
Connecticut, U.S.A.

**Data**: Presidential Commission on the Space Shuttle Challenger
Accident, Vol. 1, 1986: 129-131.

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/challengerOrings" target="_blank"><img src="challengerOrings/plots/challengerOrings.png" alt="Scatterplot of rocket o-ring damage vs. launch temperature" width="90%" /></a>

<p class="caption">

Scatterplot of rocket o-ring damage vs. launch temperature

</p>

</div>

## climateChangeBarcode

**Description**: “Barcode” plots showing the long term rise in global
and US temperatures. Each vertical stripe represents the average
temperature of a single year, ordered from the earliest available data
to the present. Original figures by [Ed
Hawkins](http://www.climate-lab-book.ac.uk/2018/warming-stripes/)

**Data**: 1) [NASA (2018) “Goddard Institute for Space Studies
(GISS)”](https://climate.nasa.gov/vital-signs/global-temperature/); 2)
[NOAA National Centers for Environmental
information](http://www.ncdc.noaa.gov/cag/).

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/climateChangeBarcode" target="_blank"><img src="climateChangeBarcode/plots/nasa_global_preview.png" alt="Global temperatures, 1880 - 2018, NASA" width="75%" /></a>

<p class="caption">

Global temperatures, 1880 - 2018, NASA

</p>

</div>

## electionMargins

**Description**: Bar plots of the popular vote margin by elected U.S.
Presidents from 1824 to present.

**Data**: [Encyclopaedia Britannica, United States Presidential Election
Results](https://www.britannica.com/topic/United-States-Presidential-Election-Results-1788863)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/electionMargins" target="_blank"><img src="electionMargins/plots/election_margins_pop.png" alt="Bar plots of the popular vote margin by elected U.S. Presidents" width="60%" /></a>

<p class="caption">

Bar plots of the popular vote margin by elected U.S. Presidents

</p>

</div>

## electricityEIA

**Description**: Barplots of energy capacity and generation by country /
region using EIA data.

**Data**: [U.S. Energy Information Administration
(EIA)](https://www.eia.gov/beta/international/data/browser/)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/electricityEIA" target="_blank"><img src="electricityEIA/plots/windNuclearCapacityCompare.png" alt="Installed Wind and Nuclear Power Capacity by Country / Region, 2000 - 2016" width="75%" /></a>

<p class="caption">

Installed Wind and Nuclear Power Capacity by Country / Region, 2000 -
2016

</p>

</div>

## ggxaringan

This folder contains the files used to create [this short screen
recording](https://youtu.be/c436_dfk9-E) demonstrating how I use the
`inf_mr()` function from the [**xaringan**
package](https://github.com/yihui/xaringan) to interactively create and
customize a plot in R using ggplot2.

Watch the video here:

<a href="http://www.youtube.com/watch?v=l9yUGFelT5c" target="_blank">
<img alt="ggxaringan" src="http://img.youtube.com/vi/l9yUGFelT5c/0.jpg">
</a>

## lcetPatenting

**Description**: Patenting in clean energy technologies by country and
over time.

**Data**: [2018 U.S. NSF Science & Engineering
Indicators](https://www.nsf.gov/statistics/2018/nsb20181/report/sections/industry-technology-and-the-global-marketplace/global-trends-in-sustainable-energy-research-and-technologies)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/lcetPatenting" target="_blank"><img src="lcetPatenting/plots/patentPlot.png" alt="Annual USPTO Patents in Clean Energy Technologies, 2006 - 2016" width="60%" /></a>

<p class="caption">

Annual USPTO Patents in Clean Energy Technologies, 2006 - 2016

</p>

</div>

## newEnergyInvestment

**Description**: Plots of new clean energy investment by country and
type.

**Data**: Clean energy investment by [Bloomberg New Energy
Finance](https://about.bnef.com/clean-energy-investment/)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/newEnergyInvestment" target="_blank"><img src="newEnergyInvestment/plots/countryLines.png" alt="New Investment in Clean Energy ($USD Billion), 2005 - 2018" width="60%" /></a>

<p class="caption">

New Investment in Clean Energy ($USD Billion), 2005 - 2018

</p>

</div>

## scienceCommentary2019

**Description**: The chart in our [2019 Science Policy Forum
article](https://science.sciencemag.org/content/366/6467/794) -
investment and patenting in clean energy technologies by country and
over time.

**Data**: Clean energy investment by [Bloomberg New Energy
Finance](https://about.bnef.com/clean-energy-investment/); Patenting by
[2018 U.S. NSF Science & Engineering
Indicators](https://www.nsf.gov/statistics/2018/nsb20181/report/sections/industry-technology-and-the-global-marketplace/global-trends-in-sustainable-energy-research-and-technologies)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/scienceCommentary2019" target="_blank"><img src="scienceCommentary2019/plots/figure1.png" alt="Investment and patenting in clean energy technologies by country and over time" width="60%" /></a>

<p class="caption">

Investment and patenting in clean energy technologies by country and
over time

</p>

</div>

## scotusNominations

**Description**: Time from Nomination to Result of Every US Supreme
Court Justice.

**Data**:
[Wikipedia](https://en.wikipedia.org/wiki/List_of_nominations_to_the_Supreme_Court_of_the_United_States)
[The Green
Papers](https://www.thegreenpapers.com/Hx/PresidentialElectionEvents.phtml)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/scotusNominations" target="_blank"><img src="scotusNominations/plots/scotus_nominations.png" alt="Time from Nomination to Result of Every US Supreme Court Justice" width="65%" /></a>

<p class="caption">

Time from Nomination to Result of Every US Supreme Court Justice

</p>

</div>

## solarPvProduction

**Description**: Bar plot of global annual solar photovoltaic cell
production by country.

**Data**: 1995 to 2013: [Earth Policy
Institute](http://www.earth-policy.org/data_center/C23); 2014 to 2018:
[Jäger-Waldau, A. (2019). Snapshot of Photovoltaics—February 2019.
Energies, 12(5), 769](https://www.mdpi.com/1996-1073/12/5/769). Data
reverse engineered from Figure 1 using
[WebPlotDigitizer](https://automeris.io/WebPlotDigitizer/).

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/solarPvProduction" target="_blank"><img src="solarPvProduction/plots/solarBars.png" alt="Annual Solar Voltaic Cell Production (GW), 2000 - 2018" width="60%" /></a>

<p class="caption">

Annual Solar Voltaic Cell Production (GW), 2000 - 2018

</p>

</div>

## usHighwayFund

**Description**: The chart in my 2017 article: [“Perspective: Navigating
an Uncertain Future for US Roads,” Issues in Science and Technology 34,
no. 1 (Fall
2017)"](http://issues.org/34-1/perspective-navigating-an-uncertain-future-for-us-roads/).
The chart shows federal highway fund revenues and expenditures in real
dollars from 1980 to 2015.

**Data**: [Status of the Highway Trust Fund, Fiscal
Years 1957-2015](https://www.fhwa.dot.gov/policyinformation/statistics/2015/fe210.cfm)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/usHighwayFund" target="_blank"><img src="usHighwayFund/plots/usHighwayFund2015.png" alt="Federal highway fund revenues and expenditures in real dollars, 1980 - 2015" width="60%" /></a>

<p class="caption">

Federal highway fund revenues and expenditures in real dollars, 1980 -
2015

</p>

</div>

## usSolarIndustry

**Description**: Summary plots of the US solar industry, including total
module deployment and job growth pre- and post- the 2018 Trump
administration tariffs.

**Data**: Jobs data from [Solar
Foundation](https://www.bloomberg.com/news/articles/2019-02-12/trump-s-tariffs-took-a-bite-out-of-once-booming-solar-job-market);
modules data from [US
EIA](https://www.eia.gov/renewable/monthly/solar_photo/)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/usSolarIndustry" target="_blank"><img src="usSolarIndustry/plots/moduleShipments.png" alt="U.S. Solar Photovoltaic Module Shipments, 2006 - 2018" width="60%" /></a>

<p class="caption">

U.S. Solar Photovoltaic Module Shipments, 2006 - 2018

</p>

</div>

## worldNuclearAssociation

**Description**: Barplots of nuclear energy capacity by country.

**Data**: Webscraped data from the [World Nuclear
Association](http://www.world-nuclear.org/information-library/facts-and-figures/world-nuclear-power-reactors-and-uranium-requireme.aspx)

<div class="figure">

<a href="https://github.com/jhelvy/charts/tree/master/worldNuclearAssociation" target="_blank"><img src="worldNuclearAssociation/plots/newCapacity.png" alt="New Nuclear Energy Capacity (GW) by Country, 2008 - 2019" width="60%" /></a>

<p class="caption">

New Nuclear Energy Capacity (GW) by Country, 2008 - 2019

</p>

</div>

# License <svg style="height:0.8em;top:.04em;position:relative;" viewBox="0 0 496 512"><path d="M245.83 214.87l-33.22 17.28c-9.43-19.58-25.24-19.93-27.46-19.93-22.13 0-33.22 14.61-33.22 43.84 0 23.57 9.21 43.84 33.22 43.84 14.47 0 24.65-7.09 30.57-21.26l30.55 15.5c-6.17 11.51-25.69 38.98-65.1 38.98-22.6 0-73.96-10.32-73.96-77.05 0-58.69 43-77.06 72.63-77.06 30.72-.01 52.7 11.95 65.99 35.86zm143.05 0l-32.78 17.28c-9.5-19.77-25.72-19.93-27.9-19.93-22.14 0-33.22 14.61-33.22 43.84 0 23.55 9.23 43.84 33.22 43.84 14.45 0 24.65-7.09 30.54-21.26l31 15.5c-2.1 3.75-21.39 38.98-65.09 38.98-22.69 0-73.96-9.87-73.96-77.05 0-58.67 42.97-77.06 72.63-77.06 30.71-.01 52.58 11.95 65.56 35.86zM247.56 8.05C104.74 8.05 0 123.11 0 256.05c0 138.49 113.6 248 247.56 248 129.93 0 248.44-100.87 248.44-248 0-137.87-106.62-248-248.44-248zm.87 450.81c-112.54 0-203.7-93.04-203.7-202.81 0-105.42 85.43-203.27 203.72-203.27 112.53 0 202.82 89.46 202.82 203.26-.01 121.69-99.68 202.82-202.84 202.82z"/></svg><svg style="height:0.8em;top:.04em;position:relative;" viewBox="0 0 496 512"><path d="M314.9 194.4v101.4h-28.3v120.5h-77.1V295.9h-28.3V194.4c0-4.4 1.6-8.2 4.6-11.3 3.1-3.1 6.9-4.7 11.3-4.7H299c4.1 0 7.8 1.6 11.1 4.7 3.1 3.2 4.8 6.9 4.8 11.3zm-101.5-63.7c0-23.3 11.5-35 34.5-35s34.5 11.7 34.5 35c0 23-11.5 34.5-34.5 34.5s-34.5-11.5-34.5-34.5zM247.6 8C389.4 8 496 118.1 496 256c0 147.1-118.5 248-248.4 248C113.6 504 0 394.5 0 256 0 123.1 104.7 8 247.6 8zm.8 44.7C130.2 52.7 44.7 150.6 44.7 256c0 109.8 91.2 202.8 203.7 202.8 103.2 0 202.8-81.1 202.8-202.8.1-113.8-90.2-203.3-202.8-203.3z"/></svg><svg style="height:0.8em;top:.04em;position:relative;" viewBox="0 0 496 512"><path d="M247.6 8C389.4 8 496 118.1 496 256c0 147.1-118.5 248-248.4 248C113.6 504 0 394.5 0 256 0 123.1 104.7 8 247.6 8zm.8 44.7C130.2 52.7 44.7 150.6 44.7 256c0 109.8 91.2 202.8 203.7 202.8 103.2 0 202.8-81.1 202.8-202.8.1-113.8-90.2-203.3-202.8-203.3zM137.7 221c13-83.9 80.5-95.7 108.9-95.7 99.8 0 127.5 82.5 127.5 134.2 0 63.6-41 132.9-128.9 132.9-38.9 0-99.1-20-109.4-97h62.5c1.5 30.1 19.6 45.2 54.5 45.2 23.3 0 58-18.2 58-82.8 0-82.5-49.1-80.6-56.7-80.6-33.1 0-51.7 14.6-55.8 43.8h18.2l-49.2 49.2-49-49.2h19.4z"/></svg>

All charts are released under a [Creative Commons
Attribution-ShareAlike 4.0 International
License](https://creativecommons.org/licenses/by-sa/4.0/).
