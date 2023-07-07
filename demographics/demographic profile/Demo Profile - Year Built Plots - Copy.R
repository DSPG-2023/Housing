# The following R Script creates plots to visualize the house age and value by house age of communities.
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


# House Age                                                               

# Want to plot Year Built data as percentages to standardize that data over different geography sizes.
# Get Year Built data and Total Structure data from 2021 5-year American Community Survey (ACS) for all places in Iowa.
placeAge <- get_acs(
  geography = "place", 
  state = "IA", 
  variables = c("2020 or later" = "B25034_002", 
                "2010 to 2019" = "B25034_003", 
                "2000 to 2009" = "B25034_004",
                "1990 to 1999" = "B25034_005",
                "1980 to 1989" = "B25034_006",
                "1970 to 1979" = "B25034_007",
                "1960 to 1969" = "B25034_008",
                "1950 to 1959" = "B25034_009",
                "1940 to 1949" = "B25034_010",
                "1939 or earlier" = "B25034_011",
                "total" = "B25034_001"), 
  year = 2021)
# Filter for desired cities. 
placeAge <- placeAge %>% 
  filter(NAME %in% c("Grundy Center city, Iowa", "Independence city, Iowa", "New Hampton city, Iowa"))
# Remove " city, Iowa" using str_remove().
placeAge <- placeAge %>% 
  mutate(NAME = str_remove(NAME, "city, Iowa"))
# Group the house age data frame by NAME and calculate the percent by dividing the estimate value by the total value. 
placeAge <- placeAge %>% 
  group_by(NAME) %>% 
  mutate(percent = estimate/ first(estimate)) %>% 
  filter(variable != "total") # Removes rows containing the total.

# Get Year Built data and Total Structure data from 2021 5-year American Community Survey (ACS) for Iowa.
stateAge <- get_acs(
  geography = "state", 
  state = "IA", 
  variables = c("2020 or later" = "B25034_002", 
                "2010 to 2019" = "B25034_003", 
                "2000 to 2009" = "B25034_004",
                "1990 to 1999" = "B25034_005",
                "1980 to 1989" = "B25034_006",
                "1970 to 1979" = "B25034_007",
                "1960 to 1969" = "B25034_008",
                "1950 to 1959" = "B25034_009",
                "1940 to 1949" = "B25034_010",
                "1939 or earlier" = "B25034_011",
                "total" = "B25034_001"), 
  year = 2021)
# Calculate the percent by dividing the estimate value by the total value. 
stateAge <- stateAge %>% 
  mutate(percent = estimate/ first(estimate)) %>% 
  filter(variable != "total") # Removes rows containing the total.

# Get Year Built data and Total Structure data from 2021 5-year American Community Survey (ACS) for the Midwest.
regionAge <- get_acs(
  geography = "region", 
  variables = c("2020 or later" = "B25034_002", 
                "2010 to 2019" = "B25034_003", 
                "2000 to 2009" = "B25034_004",
                "1990 to 1999" = "B25034_005",
                "1980 to 1989" = "B25034_006",
                "1970 to 1979" = "B25034_007",
                "1960 to 1969" = "B25034_008",
                "1950 to 1959" = "B25034_009",
                "1940 to 1949" = "B25034_010",
                "1939 or earlier" = "B25034_011",
                "total" = "B25034_001"), 
  year = 2021)
# Filter for desired cities. 
regionAge <- regionAge %>% 
  filter(NAME == "Midwest Region")
# Remove " city, Iowa" using str_remove().
regionAge <- regionAge %>% 
  mutate(NAME = str_remove(NAME, " Region"))
# Group the house age data frame by NAME and calculate the percent by dividing the estimate value by the total value. 
regionAge <- regionAge %>% 
  mutate(percent = estimate/ first(estimate)) %>% 
  filter(variable != "total") # Removes rows containing the total.

# Get Year Built data and Total Structure data from 2021 5-year American Community Survey (ACS) for the United States.
nationAge <- get_acs(
  geography = "us", 
  variables = c("2020 or later" = "B25034_002", 
                "2010 to 2019" = "B25034_003", 
                "2000 to 2009" = "B25034_004",
                "1990 to 1999" = "B25034_005",
                "1980 to 1989" = "B25034_006",
                "1970 to 1979" = "B25034_007",
                "1960 to 1969" = "B25034_008",
                "1950 to 1959" = "B25034_009",
                "1940 to 1949" = "B25034_010",
                "1939 or earlier" = "B25034_011",
                "total" = "B25034_001"), 
  year = 2021)
# Calculate the percent by dividing the estimate value by the total value. 
nationAge <- nationAge %>% 
  mutate(percent = estimate/ first(estimate)) %>% 
  filter(variable != "total") # Removes rows containing the total.

# Bind contextual data together using bind_rows().
contextAge <- stateAge %>% 
  bind_rows(regionAge, nationAge)

# Plot the Year Built data.                                                      PLOT
# Group by name. Set geom_col() position to dodge to get the data displayed side by side. 
house_age <- ggplot() +
  geom_line(data = contextAge, aes(x = variable, y = percent, group = NAME, linetype = NAME), linewidth = 1, alpha = .6) +
  geom_col(data = placeAge, aes(x = variable, y = percent, group = NAME, fill = NAME), position = "dodge", alpha = .9) +
  scale_y_continuous(labels = scales::percent) +
  theme_fivethirtyeight() +
  theme(legend.position = "none") +
  labs(title = "Year Structure Built",
       subtitle = "2017-2021 5-Year ACS Estimates",
       x = "",
       y = "ACS estimate",
       fill = "",
       linetype = "")+
  #  caption = "Variables: B25034_002, B25034_003, B25034_004, B25034_005, B25034_006,\nB25034_007, B25034_008, B25034_009,B25034_010, B25034_011, B25034_001")+
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

house_age <- ggsave(filename = "house_age.png", width = 8, height = 6, dpi = 400)



# Median Home Value by Year Structure Built                                

# Get data from 2021 5-year American Community Survey for all places in Iowa.
placeValueAge <- get_acs(
  geography = "place", 
  state = "IA", 
  variables = c("2020 or later" = "B25107_002", 
                "2010 to 2019" = "B25107_003", 
                "2000 to 2009" = "B25107_004",
                "1990 to 1999" = "B25107_005",
                "1980 to 1989" = "B25107_006",
                "1970 to 1979" = "B25107_007",
                "1960 to 1969" = "B25107_008",
                "1950 to 1959" = "B25107_009",
                "1940 to 1949" = "B25107_010",
                "1939 or earlier" = "B25107_011"), 
  year = 2021)
# Filter for desired cities. 
placeValueAge <- placeValueAge %>% 
  filter(NAME %in% c("Grundy Center city, Iowa", "Independence city, Iowa", "New Hampton city, Iowa")) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa"))

# Get data from 2021 5-year American Community Survey for Iowa.
stateValueAge <- get_acs(
  geography = "state", 
  state = "IA", 
  variables = c("2020 or later" = "B25107_002", 
                "2010 to 2019" = "B25107_003", 
                "2000 to 2009" = "B25107_004",
                "1990 to 1999" = "B25107_005",
                "1980 to 1989" = "B25107_006",
                "1970 to 1979" = "B25107_007",
                "1960 to 1969" = "B25107_008",
                "1950 to 1959" = "B25107_009",
                "1940 to 1949" = "B25107_010",
                "1939 or earlier" = "B25107_011"), 
  year = 2021)

# Get data from 2021 5-year American Community Survey for the Midwest.
regionValueAge <- get_acs(
  geography = "region", 
  variables = c("2020 or later" = "B25107_002", 
                "2010 to 2019" = "B25107_003", 
                "2000 to 2009" = "B25107_004",
                "1990 to 1999" = "B25107_005",
                "1980 to 1989" = "B25107_006",
                "1970 to 1979" = "B25107_007",
                "1960 to 1969" = "B25107_008",
                "1950 to 1959" = "B25107_009",
                "1940 to 1949" = "B25107_010",
                "1939 or earlier" = "B25107_011"), 
  year = 2021)
# Filter for the Midwest. 
regionValueAge <- regionValueAge %>% 
  filter(NAME == "Midwest Region") %>% 
  mutate(NAME = str_remove(NAME, " Region"))

# Get data from 2021 5-year American Community Survey for the United States.
nationValueAge <- get_acs(
  geography = "us", 
  variables = c("2020 or later" = "B25107_002", 
                "2010 to 2019" = "B25107_003", 
                "2000 to 2009" = "B25107_004",
                "1990 to 1999" = "B25107_005",
                "1980 to 1989" = "B25107_006",
                "1970 to 1979" = "B25107_007",
                "1960 to 1969" = "B25107_008",
                "1950 to 1959" = "B25107_009",
                "1940 to 1949" = "B25107_010",
                "1939 or earlier" = "B25107_011"), 
  year = 2021)

# Join all geographies.
contextValueAge <- stateValueAge %>% 
  bind_rows(regionValueAge, nationValueAge)

# plot median home value by year structure built                                  PLOT
house_value_by_year <- ggplot() +
  geom_line(data = contextValueAge, aes(x = variable, y = estimate, group = NAME, linetype = NAME), linewidth = 1, alpha = .6) +
  geom_col(data = placeValueAge, aes(x = variable, y = estimate, group = NAME, fill = NAME), position = "dodge", alpha = .9) +
  scale_y_continuous(labels = scales::dollar) +
  theme_fivethirtyeight() +
  labs(title = "Median Home Value by Year Structure Built",
       subtitle = "2017-2021 5-Year ACS Estimates",
       x = "",
       y = "ACS estimate",
       fill = "",
       linetype = "",
       caption = "Variables: B25034_002, B25034_003, B25034_004, B25034_005, B25034_006,\nB25034_007, B25034_008, B25034_009,B25034_010, B25034_011, B25034_001") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

house_value_by_year %>% ggsave(filename = "house_value_by_year.png", width = 8, height = 6, dpi = 400)

#Use patchwork library to parse together year built and median value by year built plots.

library(patchwork)

value_and_year_built <- house_age +house_value_by_year +
  plot_layout(ncol = 1)

value_and_year_built %>% ggsave(filename = "value_and_year_built.png", width = 8, height = 10, dpi = 400)

