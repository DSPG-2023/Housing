# The following R Script creates plots to visualize median income of communities.
# Grundy Center, Independence, and New Hampton were selected to be visualized. 
# You want to visualize these communities alongside their state, regional and national contexts as well.
# State context is Iowa. 
# Regional context would be the 12 states in the Midwest: ND, SD, NE, KS, MN, IA, MO, WI, MI, IL, IN, OH.
# National context is the United States of America.

# This link was helpful in creating some of these visualizations:
# https://walker-data.com/census-r/exploring-us-census-data-with-visualization.html

# We need to install and load the following packages for this R Script. 

#install.packages(tidyverse)
#install.packages(tidycensus)
#install.packages(ggthemes)
#install.packages(scales)

library(tidyverse)
library(tidycensus)
library(ggthemes)
library(scales)


# Median Income

# Getting median income data from the 5-Year American Community Survey. 
# The median income variable is "B19013_001."

# Create an object called "years" that lists the years you want to pull data from. 
# We want all of the years the ACS data is available. 
years <- 2009:2021
names(years) <- years

# Use get_acs() to pull median income data at the place level.
placeIncome <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("median_income" = "B19013_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") 

# Remove the " city, Iowa|, Iowa" from the end of the place names.
placeIncome <- placeIncome %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

# Filter placeIncome for desired cities.
# Add a geography column.
placeIncome <- placeIncome %>%
  filter(NAME %in% c("Grundy Center", "Independence", "New Hampton")) %>% 
  mutate(geography = "Place")


# Use get_acs() to pull median income data at the state level.
stateIncome <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("median_income" = "B19013_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") 

# Add a geography column. 
stateIncome <- stateIncome %>% 
  mutate(geography = "State")


# Use get_acs() to pull median income data at the regional level.
regionIncome <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("median_income" = "B19013_001"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") 

# Remove the " Region" from the end of the region names.
regionIncome <- regionIncome %>% 
  mutate(NAME = str_remove(NAME, " Region"))

# Filter regionIncome for Midwest.
# Add a geography column.
regionIncome <- regionIncome %>%
  filter(NAME %in% "Midwest") %>% 
  mutate(geography = "Region")


# Use get_acs() to pull median income data at the national level.
nationIncome <- map_dfr(years, ~{
  get_acs(
    geography = "us",
    variables = c("median_income" = "B19013_001"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Add a geography column.
nationIncome <- nationIncome %>% 
  mutate(geography = "Nation")

# Bind all geographies together with bind_rows().
income <- nationIncome %>% 
  bind_rows(regionIncome, stateIncome, placeIncome)

# Add a new column specifying if the geography is a nation, region, state, or place. 
income <- income %>% 
  mutate(grouping = ifelse(NAME %in% c("United States", "Midwest", "Iowa"), "Contextual Area", NAME))

# Create three separate plots for Grundy Center, Independence and New Hampton.
# Combine plots together using patchwork library. 
#install.packages("patchwork")
library(patchwork)

# Plot the median income for Grundy Center and its contextual geographies.       PLOT
plot1 <- income[income$NAME %in% c("Grundy Center", "United States", "Midwest", "Iowa"), ] %>% 
  ggplot(aes(x = year, y = median_incomeE, group = NAME)) +
  geom_ribbon(aes(ymax = median_incomeE + median_incomeM, ymin = median_incomeE - median_incomeM, fill = geography),
              alpha = 0.3) + 
  geom_line(aes(color = geography), linewidth = 1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k"),
                     limits = c(32250,80000))+
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "",
       color = "",
       linetype = "",
       subtitle = "2009-2021 5-Year ACS Estimates\nGrundy Center",
       fill = "",
       title = "Median Income") 

# Plot the median income for Independence and its contextual geographies.        PLOT 
plot2 <- income[income$NAME %in% c("Independence", "United States", "Midwest", "Iowa"), ] %>% 
  ggplot(aes(x = year, y = median_incomeE, group = NAME)) +
  geom_ribbon(aes(ymax = median_incomeE + median_incomeM, ymin = median_incomeE - median_incomeM, fill = geography),
              alpha = 0.3) + 
  geom_line(aes(color = geography), linewidth = 1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k"),
                     limits = c(32250,80000))+
  theme(legend.position = "none", axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(x = "",
       color = "",
       linetype = "",
       subtitle = "\nIndependence",
       caption = "",
       fill = "")

# Plot the median income for New Hampton and its contextual geographies.         PLOT 
plot3 <- income[income$NAME %in% c("New Hampton", "United States", "Midwest", "Iowa"), ] %>% 
  ggplot(aes(x = year, y = median_incomeE, group = NAME)) +
  geom_ribbon(aes(ymax = median_incomeE + median_incomeM, ymin = median_incomeE - median_incomeM, fill = geography),
              alpha = 0.3) + 
  geom_line(aes(color = geography), linewidth = 1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k"),
                     limits = c(32250,80000))+
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(x = "",
       color = "",
       linetype = "",
       subtitle = "\nNew Hampton",
       fill = "",
       caption = "Shaded area represents margin of error around the ACS estimate\nVariable: B19013_001")

# Combine plots. 
combined_plots <- wrap_plots(plot1, plot2, plot3)

# Save as a .png file.
combined_plots %>% ggsave(filename = "median_income.png", dpi = 400, width = 12, height = 6)
