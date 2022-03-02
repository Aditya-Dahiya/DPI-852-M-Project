# DPI-852-M-Project
A Project on the course: *Data Visualization for DPI 852 M (HKS) by Hong Qu*

### Project by: Aditya Dahiya and Rajat Saini

## Topic: Insights from National Family Health Survey-5 and GDP growth rate in districts of India

## [Final Product: ArcGIS Story](https://arcg.is/ayLeq)


#### Sources of Data  
1. National Family Health Survey (NFHS-5), Govt. of India & USAID - Data avaialable from website of [International Institute for Population Sciences](http://rchiips.org/nfhs/factsheet_NFHS-5.shtml). Data Extraction credited to `rvest` package of `R`'s `tidyverse` and [Code](https://github.com/jvargh7/nfhs5_factsheets/tree/main/code) inspired from [Jithin Sam Varghese](https://github.com/jvargh7), Doctoral Student in Nutrition and Health Sciences Program at Emory Universty, Atlanta, GA. 
2. Data on GDP of districts and GDP Growth rate of different districts of India from Government's Open Government Data (OGD) Platform [data.gov.in](https://data.gov.in/catalog/district-wise-gdp-and-growth-rate-current-price2004-05?filters%5Bfield_catalog_reference%5D=164446&format=json&offset=0&limit=6&sort%5Bcreated%5D=desc).  
3. Census of India, 2011 - [Offical Website](https://censusindia.gov.in/2011-common/censusdata2011.html)


#### Methodology

1. Extract Data from GitHub on NFHS-5 ([Jithin's code](https://github.com/jvargh7/nfhs5_factsheets/tree/main/code)) and from Open Government Data (OGD) Platform ([self code](https://raw.githubusercontent.com/Aditya-Dahiya/DPI-852-M-Project/main/jvargh7_dataset.R)).
2. Exploratory Data Analysis to find insights - (a) Plots of all NFHS indicators vs. each other ([Graphs here](https://github.com/Aditya-Dahiya/DPI-852-M-Project/tree/main/Plots-of-Indicators)), (b) Plots of all NFHS indicators vs. GDP of the districts ([Graphs here](https://github.com/Aditya-Dahiya/DPI-852-M-Project/tree/main/Plots-with-District-GDP)), (c) Plots of all NFHS indicators vs. GDP growth rate ([Graphs here](https://github.com/Aditya-Dahiya/DPI-852-M-Project/tree/main/Plots-vs-GDP-Growth)).
3. Use R for data wrangling and combining data sets with fuzzy matching.
4. Insights found combine to form a narrative. Use Datawrapper, Tableau and R to create interactive graphics.
5. Overview first, zoom and filter, then details-on-demand.
6. Intended Audience: web surfers curious about trends from NFHS-5
7. A Tableau Dashboard for Details-On-Demand, allowing users to filter and view.

### Comments?
Please feel free to add in comments through Issues tab above, or [here](https://github.com/Aditya-Dahiya/DPI-852-M-Project/issues/1)
