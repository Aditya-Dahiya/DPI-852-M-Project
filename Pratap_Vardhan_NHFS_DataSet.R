# Load libraries
library(tidyverse)
library(summarytools)
library(naniar)

# Load data set from GitHub PratapVardhan
districts = read_csv("https://raw.githubusercontent.com/pratapvardhan/NFHS-5/master/NFHS-5-Districts.csv")
states = read_csv("https://raw.githubusercontent.com/pratapvardhan/NFHS-5/master/NFHS-5-States.csv")

# Variables check
names(districts)
names(states)

# Check data for its summary features
districts %>% vis_miss()
view(districts %>% freq(`NFHS-5-note`))
view(districts %>% freq(`NFHS-4-note`))

# Part 1: focus on the values, without looking at comments on weightage cases numbers
# Create the data set for manipulation
df = districts %>%
    select(1:6)

# This is a long data set
# Checking the number of indicators
df %>% select(Indicator) %>%
    freq() %>% view()

# Checking districts
df %>% select(District) %>% freq() %>% view()

# Separate Indicator ID
df = df %>% 
    separate(Indicator, c("Id", "Indicator"),
                     sep = ". ", extra = "merge") %>%
    mutate(Id = as.numeric(Id)) %>%
    rename(State_Code = `State-Code`)

# Check variable names now
names(df)
