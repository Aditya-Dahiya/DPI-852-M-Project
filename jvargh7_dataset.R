############ R-Script for DPI 852 M project #############

############ Author: Aditya Dahiya

##### Credits for data: https://github.com/jvargh7/nfhs5_factsheets

################ Insights from the data #################

# Load libraries
library(tidyverse)
library(summarytools)
library(naniar)
library(ggthemes)
library(ggrepel)
library(ggpmisc)

# Saved tidy data online at GitHub

# Load data
districts_ph2 = read_csv("https://raw.githubusercontent.com/jvargh7/nfhs5_factsheets/main/phase%202%20release/NFHS-5%20Phase%202%20District%20Factsheets.csv")
states_ph2 = read_csv("https://raw.githubusercontent.com/jvargh7/nfhs5_factsheets/main/phase%202%20release/NFHS-5%20Phase%202%20State%20Factsheets.csv")

################# Districts' Level Phase 2 data #########################
# Examining the Districts Phase 2 data set
names(districts_ph2)
vis_miss(districts_ph2)

# Checking the type of data that is missing
districts_ph2 %>% select(Flag_NFHS4) %>% freq() %>% view()
districts_ph2 %>% select(Flag_NFHS5) %>% freq() %>% view()
# These are weightage issues and can be ignored for now in visualizations

# Checking how many states and districts covered in this data
# Number of States Covered
unique(districts_ph2$state)

# Number of districts covered
districts_ph2 %>% select(district) %>% n_distinct()

# Number of indicators covered
districts_ph2 %>% select(Indicator) %>% freq() %>% view()

# Removing ID number form Indocator name and removing Flag columns
df = districts_ph2 %>%
    select(-c(Flag_NFHS5, Flag_NFHS4)) %>%
    separate(Indicator, c("Id_Indicator", "Indicator"),
             sep = ". ", extra = "merge") %>%
    mutate(Id_Indicator = as.numeric(Id_Indicator)) %>%
    rename(State = state,
           District = district) %>%
    mutate(Change = NFHS5 - NFHS4)

dfwide = df %>%
    select(-NFHS4, -Id_Indicator) %>%
    pivot_wider(
        names_from = Indicator, 
        values_from = NFHS5)
write_csv(dfwide, "dftableauNFHS5.csv")


# Create a list of indicators for plot labeling
List_Indicators = df %>% select(Id_Indicator, Indicator) %>% distinct()


# Plot histograms for some indicators
Id_to_view = 3
title_text = df %>% filter(Id_Indicator == Id_to_view) %>%
    distinct(Indicator) %>% as.character()
df %>% filter(Id_Indicator == Id_to_view) %>%
    ggplot(aes(text = Indicator)) + 
    geom_histogram(aes(NFHS4), fill = "white", col = "grey") +
    labs(title = title_text)


# Scatter plot of one variable vs. another
Id_to_view_x = 103
Id_to_view_y = 104
names(df)
g = df %>% 
    filter(Id_Indicator %in% c(Id_to_view_x, Id_to_view_y)) %>%
    select(-NFHS4, -Indicator) %>%
    mutate(Id_Indicator = if_else(Id_Indicator == Id_to_view_x,
                                 "IndicatorX",
                                 "IndicatorY")) %>%
    pivot_wider(names_from = Id_Indicator,
                values_from = NFHS5) %>%
    ungroup() %>%
    ggplot(aes(x = IndicatorX, y = IndicatorY, label = District)) + 
        geom_point(alpha = 0.5, size = 3, pch = 21) + 
        labs(x = List_Indicators[Id_to_view_x,2],
             y = List_Indicators[Id_to_view_y,2],
             title = "Districts in India: NFHS 5 data") +
    geom_smooth(method = "lm", col = "darkred") +
    theme_minimal() +
    stat_dens2d_filter(geom = "text_repel", keep.fraction = 0.02)
g

# Create and save some graphs
# Dummy dataframe to use for indexing
printer = data.frame(Var1 = 1:103,
                    Var2 = 2:104)
nrow(printer)

######### Dont run this without being sure of directory #######
# Produces 103 plots
for(i in 1:103){
    filename = paste0("Plot_",i,".png")
    
    df %>% 
    filter(Id_Indicator %in% c(printer$Var1[i], printer$Var2[i])) %>%
    select(-NFHS4, -Indicator) %>%
    mutate(Id_Indicator = if_else(Id_Indicator == printer$Var1[i],
                                  "IndicatorX",
                                  "IndicatorY")) %>%
    pivot_wider(names_from = Id_Indicator,
                values_from = NFHS5) %>%
    drop_na() %>%
    ungroup() %>%
    ggplot(aes(x = IndicatorX, y = IndicatorY, label = District)) + 
    geom_point(alpha = 0.5, size = 3, pch = 21) + 
    labs(x = List_Indicators[printer$Var1[i],2],
         y = List_Indicators[printer$Var2[i],2],
         title = "Districts in India: NFHS 5 data") +
    geom_smooth(method = "lm", col = "darkred") +
    theme_minimal() +
    stat_dens2d_filter(geom = "text_repel", keep.fraction = 0.02)
ggsave(filename, device = "jpeg")
    
}

names(df)

# Plot histograms for change in some indicators
Id_to_view = 20
title_text = df %>% filter(Id_Indicator == Id_to_view) %>%
    distinct(Indicator) %>% as.character()
df %>% filter(Id_Indicator == Id_to_view) %>%
    ggplot(aes(text = Indicator)) + 
    geom_histogram(aes(Change), fill = "white", col = "black",
                   bins = 50) +
    geom_vline(xintercept = 0, col = "red", lty = 1,lwd = 2, alpha = 0.5) +
    labs(title = title_text,
         subtitle = "Histogram of change in Indicator") +
    theme_pander()

######### Don't run this without being sure of directory #######
# Produces 103 histograms
for (i in 1:104){
    Id_to_view = i
    
    title_text = df %>% filter(Id_Indicator == Id_to_view) %>%
        distinct(Indicator) %>% as.character()
    
    g = df %>% filter(Id_Indicator == Id_to_view) %>%
    ggplot(aes(text = Indicator)) + 
    geom_histogram(aes(Change), fill = "white", col = "black",
                   bins = 50) +
    geom_vline(xintercept = 0, col = "red", lty = 1,lwd = 2, alpha = 0.5) +
    labs(title = title_text,
         subtitle = "Histogram of change in Indicator") +
    theme_pander()
    filename = paste0("Change_Histogram_",i,".jpeg")
    ggsave(filename, device = "jpeg")
}


########### Importing GDP growth rate and Per Capita GDP data #############
########### Source: data.gov.in

statelist = c("Andhra Pradesh", "Assam", "Bihar", "Karnataka",
              "Kerala", "Maharashtra", "Odisha", "Punjab", "Uttar Pradesh",
              "West Bengal")
length(statelist)
income = data.frame()
for (i in 1:10) {
    temp = read_csv(paste0("GDP_Growth_", statelist[i] , ".csv")) %>% 
    pivot_longer(cols = -c(Year, Description),
                             names_to = "District",
                             values_to = "Value") %>%
    mutate(State = statelist[i]) %>%
    unite(Indicator, Year:Description, sep = " ")  %>%
    pivot_wider(names_from = Indicator,
                values_from = Value) %>%
    relocate(State)
    
    income = bind_rows(income, temp)
}

vis_miss(income)
