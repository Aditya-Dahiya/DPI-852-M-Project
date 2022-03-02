# Indian Express Story
# https://indianexpress.com/article/opinion/columns/india-polpulation-family-planning-emergency-india-births-rate-total-fertility-rate-2914318/

# Load libraries
library(tidyverse)
library(summarytools)
library(naniar)
library(ggthemes)
library(ggrepel)
library(ggpmisc)
library(gganimate)
library(viridis)
library(hrbrthemes)
library(scales)
library(gganimate)

# Data Set on fertility
fertility = read_csv("fertilityNFHS.csv")

# India TFR, GDP and Growth Rate trends
TFRtrend = read_csv("tfr_trends.csv") %>%
    select(-`Indicator Name`) %>%
    filter(`Country Name` %in% c("India", "Pakistan", "Bangladesh", "Sri Lanka", 
                                 "Nepal", "World")) %>%
    pivot_longer(-`Country Name`, names_to = "Year", values_to = "TFR")
    
GDPtrend = read_csv("gdp-world-bank.csv") %>%
    select(-`Indicator Name`) %>%
    filter(`Country Name` %in% c("India", "Pakistan", "Bangladesh", "Sri Lanka", 
                                 "Nepal", "World")) %>%
    pivot_longer(-`Country Name`, names_to = "Year", values_to = "GDP")

GDPgrowthTrend = read_csv("gdp-growth-world-bank.csv") %>%
    select(-`Indicator Name`) %>%
    filter(`Country Name` %in% c("India", "Pakistan", "Bangladesh", "Sri Lanka", 
                                 "Nepal", "World")) %>%
    pivot_longer(-`Country Name`, names_to = "Year", values_to = "GDP_Growth")

### Creating Data Set
dfa = inner_join(GDPgrowthTrend, GDPtrend, by = c("Country Name" = "Country Name", 
                                            "Year" = "Year"))
dfa = inner_join(dfa, TFRtrend, by = c("Year" = "Year", "Country Name" = "Country Name"))

dfa = dfa %>%
     rename(Country = `Country Name`) %>%
     mutate(Year = as.numeric(Year))
write_csv(dfa, "Z_Trends_Over_Time.csv")

dfx = dfa %>% 
    filter(Country %in% c("India", "Pakistan", "Sri Lanka")) %>%
    mutate(Year = as.numeric(Year)) %>%
    pivot_longer(-c(Country, Year), names_to = "Type", values_to = "Value")

ggplot(dfx, aes(x = Year, y = Value,
                group = Country,
                col = Country, 
                fill = Country)) + 
    geom_line(se = F) + 
    facet_wrap(~ Type, scales = "free", nrow = 3) +
    theme_few() +
    scale_x_continuous(breaks = seq(1960, 2020, by = 20))

############################# REPREX ######################################
#### Work on GIF 1 for GDP per capita over the years
dfa = read_csv("Z_Trends_Over_Time.csv")
dfa1 = dfa %>% 
    filter(Country%in% c("India", "Pakistan", "Sri Lanka")) %>%
    mutate(Country = factor(Country, levels = c("India", "Pakistan", "Sri Lanka")))

a1 = ggplot(dfa1, aes(x = Year, y = GDP, col = Country, group = Country)) +
    geom_line(alpha = 1, lwd = 1) +
    geom_point(alpha = 1) +
    labs(title = "GDP per capita (US$)", y = NULL, x = NULL) +
    scale_y_continuous(labels = label_number(suffix = " K", scale = 1e-3)) +
    theme_minimal() +
    scale_color_manual(values=c("#19b1da", "#37c57b", "#ffa600")) +
    theme(legend.position = "bottom") +
    transition_reveal(Year)

animate(a1)
anim_save("a1.gif")
a2 = ggplot(dfa1, 
            aes(x = Year, y = TFR, col = Country, group = Country)) +
    geom_line(alpha = 1, lwd = 1) +
    geom_point(alpha = 1) +
    labs(title = "Total Fertility Rates", y = NULL, x = NULL) +
    theme_minimal() +
    scale_color_manual(values=c("#19b1da", "#37c57b", "#ffa600")) +
    theme(legend.position = "bottom") +
    transition_reveal(Year)
animate(a2)
anim_save("a2.gif")

## TFR in States of India
states_gdp = read_csv("states_gdp_growth.csv")
states_tfr = read_csv("states_tfr.csv")
dfs = full_join(states_gdp, states_tfr, by = "State")

write_csv(dfs, "Z_States_GDPGrowth_TFR.csv")

## Add states population and density data
names(temp1)
library(strex)
temp1 = read_csv("temp1_states.csv") %>%
    mutate(Density = str_first_number(Density))

dfs = full_join(dfs, temp1, by = "State")
write_csv(dfs, "Z_States_GSP_Pop_Lit_TFR.csv")
names(dfs)


#### Checking NFHS-5 data
List_Indicators = fertility %>%
    distinct(Indicator)

### Wide Fertility Data
temp = fertility %>% select(State, District, Indicator, NFHS5) %>% 
    pivot_wider(names_from = Indicator, values_from = NFHS5)

temp = temp %>% 
    mutate(State_Type = if_else(State %in% c("Bihar", "Uttar Pradesh", "Meghalaya"),
                                true = "High-Fertility States",
                                false = "Rest of India"))
write_csv(temp, "Z_Districts_Fertility.csv")

###### Finding Districts GDP data ######
distcen = read_csv("districts-census.csv") %>% select(-starts_with("Power"))
names(distcen)

# Create ID variables in both datasets before fuzzy match
temp = temp %>%
    mutate(ID_1 = 1:nrow(temp))
distcen = distcen %>%
    mutate(ID_2 = 1:nrow(distcen))
library(fedmatch)

fuzzy_result = merge_plus(data1 = temp, 
                           data2 = distcen,
                           by = "District", match_type = "fuzzy", 
                           unique_key_1 = "ID_1",
                           unique_key_2 = "ID_2")
names(fuzzy_result)
Z_districts_census = fuzzy_result$matches %>% 
    select(-c(ID_2, ID_1, State_2, District_2)) %>%
    rename(State = State_1,
           District = District_1) %>%
    mutate(Percent_Literacy = round(100*Literate_Education/Population, 2),
           Percent_Muslims = round(100*Muslims/Population, 2))
hist(Z_districts_census$Percent_Muslims)
write_csv(Z_districts_census, "Z_districts_census.csv")
