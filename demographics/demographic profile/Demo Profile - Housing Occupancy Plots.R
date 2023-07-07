# The following R Script creates plots to visualize Housing Occupancy Rates of communities.
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


# Home Ownership, Rental, and Vacancy Rates                                 

# Getting owner occupied data and total occupied units from 5-Year American Community Survey. 
# Using years object that was defined earlier.
placeOwn <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("Owner Occupied" = "B25003_002",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
  )
}, .id = "year") 

# Create a new column for percent own.
placeOwn <- placeOwn %>%
  group_by(year, GEOID, NAME) %>%
  mutate(percent = estimate / first(estimate))
  filter(variable != "total")

# Getting renter occupied data and total occupied units from 5-Year American Community Survey.
# Using years object defined earlier. 
placeRent <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("Renter Occupied" = "B25003_003",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
  )
}, .id = "year")

# Add a new column for percent rent.
placeRent <- placeRent %>%
  group_by(year, GEOID, NAME) %>%
  mutate(percent = estimate / first(estimate)) %>% 
  filter(variable != "total")

# Getting vacant units and total units from 5-Year ACS.
# Using years object defined earlier. 
placeVacant <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    state = "IA",
    variables = c("Vacant" = "B25002_003",
                  "total" = "B25001_001"),
    year = .x,
    survey = "acs5",
  )
}, .id = "year")

# Create new column for vacant percent.
placeVacant <- placeVacant %>% 
  group_by(year, GEOID, NAME) %>% 
  mutate(percent = estimate / first(estimate)) %>% 
  filter(variable != "total")

# Combine all data into one data frame.
placeRate <- placeOwn %>% 
  bind_rows(placeRent, placeVacant)

# To simplify the filtering process from now on, create an object for desired cities. 
target_cities <- c("Independence city, Iowa","New Hampton city, Iowa", "Grundy Center city, Iowa")

# Filter for desired cities.
placeRate <- placeRate %>% 
  filter(NAME %in% target_cities) %>% 
  mutate(NAME = str_remove(NAME," city, Iowa"))

# Add a geography column.
placeRate <- placeRate %>% 
  mutate(geography = "Place")

#######################################################
# bar plot option ?
ggplot(data = placeRate, aes(x = year, y = percent, group = NAME, fill = variable)) +
  geom_col(position = "fill") +
  facet_wrap(~NAME)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = scales::percent)+
  scale_x_discrete(labels = ) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(fill = "",
       title = "Housing Occupancy Rates",
       caption = "2009-2021 5-Year American Community Survey")

# what if we plot all of them together in the same bar plot (just owner variable) and change the transparency of the NAME/fill
ggplot(data = placeRate, aes(x = year, y = percent, group = NAME)) +
  geom_line(aes(color = NAME)) +
  geom_point() +
  facet_wrap(~variable)
#############################################################


### STATE TIME

# Getting owner occupied data and total occupied units from 5-Year American Community Survey for Iowa. 
# Using years object that was defined earlier.
stateOwn <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("Owner Occupied" = "B25003_002",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
  )
}, .id = "year")

# Create a column called prc_own for percent home ownership. 
# Create column for the margin of error of prc_own.
# Filter the data frame for the desired cities. 
stateOwn <- stateOwn %>% 
  group_by(year) %>% 
  mutate(percent = estimate/first(estimate)) %>%
  filter(variable != "total")

# Repeat the process for Renter Occupied and Vacant Units. 
stateRent <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("Renter Occupied" = "B25003_003",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
  )
}, .id = "year")
# Calculate percent.
stateRent <- stateRent %>% 
  group_by(year) %>% 
  mutate(percent = estimate/first(estimate)) %>%
  filter(variable != "total")

# Vacant Units time.
stateVacant <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("Vacant" = "B25002_003",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
  )
}, .id = "year")
# Calculate percent.
stateVacant <- stateVacant %>% 
  group_by(year) %>% 
  mutate(percent = estimate/first(estimate)) %>%
  filter(variable != "total")

# Combine all rates and add geography.
stateRate <- stateOwn %>% 
  bind_rows(stateRent, stateVacant) %>% 
  mutate(geography = "State")


ownership_place.png <- place_state %>% 
  filter(variable == "Owner Occupied") %>% 
  ggplot(aes(x = year, y = percent, group = NAME, color = NAME)) +
  geom_line(linewidth = 1) +
  geom_point(size =2, color = "black") +
  scale_y_continuous(labels = scales::percent)+
  theme_fivethirtyeight() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Home Ownership Rate",
       caption = "Variable: B25003_002",
       color = "",
       subtitle = "2009-2021 5-Year ACS Estimates")
ownership_place.png %>% ggsave(filename = "ownership_place.png", dpi = 400, width = 8, height = 6)



#### REGION TIME

# Getting owner occupied data and total occupied units from 5-Year American Community Survey for the Midwest. 
# Using years object that was defined earlier.
regionOwn <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("Owner Occupied" = "B25003_002",
                  "total" = "B25001_001"),
    year = .x,
    survey = "acs5",
  )
}, .id = "year")

# Calculate percent home ownership rate.
regionOwn <- regionOwn %>% 
  group_by(year, GEOID, NAME) %>% 
  mutate(percent  = estimate/first(estimate)) %>% 
  filter(variable != "total")

# Repeat for Renter Occupied data.
regionRent <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("Renter Occupied" = "B25003_003",
                  "total" = "B25001_001"),
    year = .x,
    survey = "acs5"
  )
}, .id = "year")
# Calculate percent rent.
regionRent <- regionRent %>% 
  group_by(year, GEOID, NAME) %>% 
  mutate(percent = estimate / first(estimate)) %>% 
  filter(variable != "total")

# One last time for vacant units. 
regionVacant <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("Vacant" = "B25002_003",
                  "total" = "B25001_001"),
    year = .x,
    survey = "acs5"
  )
}, .id = "year")
# Calculate Vacant.
regionVacant <- regionVacant %>% 
  group_by(year, GEOID, NAME) %>% 
  mutate(percent = estimate/ first(estimate)) %>% 
  filter(variable != "total")

# Combine owner, renter, and vacant.
regionRate <- regionOwn %>% 
  bind_rows(regionRent, regionVacant)

# To simplify the filtering process from now on, create an object for desired region 
target_region <- "Midwest Region"

# Filter for Midwest.
# Drop " Region."
# Add a geography column.
regionRate <- regionRate %>% 
  filter(NAME %in% target_region) %>% 
  mutate(NAME = str_remove(NAME, " Region")) %>% 
  mutate(geography = "Region")



## NATION TIME

# Get data from the 5-Year ACS.
nationRate <- map_dfr(years, ~{
  get_acs(
    geography = "us",
    variables = c("Owner Occupied" = "B25003_002",
                  "Renter Occupied" = "B25003_003",
                  "Vacant" = "B25002_003",
                  "total" = "B25001_001"),
    year = .x,
    survey = "acs5"
  )
}, .id = "year")

# Calculate rates.
# Add geography.
nationRate <- nationRate %>% 
  group_by(year) %>% 
  mutate(percent = estimate/ first(estimate)) %>% 
  filter(variable != "total") %>% 
  mutate(geography = "Nation")


# Create plots for home ownership rate at all geographies.
# HOME OWNERSHIP RATE

# I want state, region, and nation in their own contextRate so that they can be displayed by linetype.

# Filter placeRate for variable == "Owner Occupied"
filtered_placeRate <- placeRate %>%
  filter(variable == "Owner Occupied")

# Bind context.
contextRate <- stateRate %>% 
  bind_rows(regionRate, nationRate)
# Filter stateRate for variable == "Owner Occupied"
filtered_contextRate <- contextRate %>%
  filter(variable == "Owner Occupied")

# Create data frame to hold text labels.
#labels <- data.frame(
#  x = as.character(c(2021, 2021, 2021, 2021, 2021, 2021)),
#  y = c(.7917399, .6082836, .6630566, .5739626, .6075528, .6488302),
#  label = c("Grundy Center", "Independence", "New Hampton", "United States", "Midwest", "Iowa")
#)

# Create the line plot: Home Ownership Rate
home_ownership.png <- ggplot() +
  geom_line(data = filtered_contextRate, aes(x = year, y = percent, group = NAME, linetype = NAME),
            color = "black", linewidth = 1, alpha = .4) +
  geom_line(data = filtered_placeRate, aes(x = year, y = percent, group = NAME, color = NAME), linewidth = 1.75) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(.54,.8),
                     breaks = c(.55,.6,.65,.7,.75,.8))+
  theme_fivethirtyeight() +
  labs(title = "Home Ownership Rate",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Variable: B25003_002",
       color = "",
       linetype = "") 

home_ownership.png %>% ggsave(filename = "home_ownership.png", dpi = 400, height = 6, width = 8)

# Create plots for vacancy rate at all geographies.
# VACANCY RATE

# filter for vacancy
vacancy_placeRate <- placeRate %>% 
  filter(variable == "Vacant")
vacancy_contextRate <- contextRate %>% 
  filter(variable == "Vacant")

# Create the line plot: Vacancy Rate
vacancy_rate.png <- ggplot() +
  geom_line(data = vacancy_contextRate, aes(x = year, y = percent, group = NAME, linetype = NAME),
            color = "black", linewidth = 1, alpha = .4) +
  geom_line(data = vacancy_placeRate, aes(x = year, y = percent, group = NAME, color = NAME), linewidth = 1.5) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(.0, .15),
                     breaks = c(0, .05, .1, .15)) +
  labs(title = "Vacancy Rate",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Variable: B25002_003",
       color = "",
       linetype = "",
       x = "",
       y = "") +
  theme_fivethirtyeight()

vacancy_rate.png %>% ggsave(filename = "vacancy_rate.png", dpi = 400, height = 6, width = 8)





###################################################################################################################
###################################################################################################################
###################################################################################################################

# NOT USED FOR FINAL PRESENTATION PLOTS



# 8. Home Ownership Rates                                                       Home Ownership Rates

# Getting owner occupied data and total occupied units from 5-Year American Community Survey. 
# Using years object that was defined earlier.
placeOwn <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("owner_occupied" = "B25003_002",
                  "occupied" = "B25002_002"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# To simplify the filtering process from now on, create an object for desired cities. 
target_cities <- c("Independence city, Iowa","New Hampton city, Iowa", "Grundy Center city, Iowa")

# Create a column called prc_own for percent home ownership. 
# Create column for the margin of error of prc_own.
# Filter the data frame for the desired cities. 
placeOwn <- placeOwn %>% 
  mutate(prc_own = owner_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(owner_occupiedM^2 - (prc_own^2 * occupiedM^2)) / occupiedE) %>% 
  filter(NAME %in% target_cities) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa"))

# Add a geography column.
placeOwn <- placeOwn %>% 
  mutate(geography = "Place")

# Getting owner occupied data and total occupied units from 5-Year American Community Survey for Iowa. 
# Using years object that was defined earlier.
stateOwn <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("owner_occupied" = "B25003_002",
                  "occupied" = "B25002_002"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column called prc_own for percent home ownership. 
# Create column for the margin of error of prc_own.
# Filter the data frame for the desired cities. 
stateOwn <- stateOwn %>% 
  mutate(prc_own = owner_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(owner_occupiedM^2 - (prc_own^2 * occupiedM^2)) / occupiedE)

# Add a geography column.
stateOwn <- stateOwn %>% 
  mutate(geography = "State")

# Getting owner occupied data and total occupied units from 5-Year American Community Survey for the Midwest. 
# Using years object that was defined earlier.
regionOwn <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("owner_occupied" = "B25003_002",
                  "occupied" = "B25002_002"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# To simplify the filtering process from now on, create an object for desired region 
target_region <- "Midwest Region"

# Create a column called prc_own for percent home ownership. 
# Create column for the margin of error of prc_own.
# Filter the data frame for the desired cities. 
regionOwn <- regionOwn %>% 
  mutate(prc_own = owner_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(owner_occupiedM^2 - (prc_own^2 * occupiedM^2)) / occupiedE) %>% 
  filter(NAME %in% target_region) %>% 
  mutate(NAME = str_remove(NAME, " Region"))

# Add a geography column.
regionOwn <- regionOwn %>% 
  mutate(geography = "Region")

# Getting owner occupied data and total occupied units from 5-Year American Community Survey for Iowa. 
# Using years object that was defined earlier.
nationOwn <- map_dfr(years, ~{
  get_acs(
    geography = "us",
    variables = c("owner_occupied" = "B25003_002",
                  "occupied" = "B25002_002"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column called prc_own for percent home ownership. 
# Create column for the margin of error of prc_own.
# Filter the data frame for the desired cities. 
nationOwn <- nationOwn %>% 
  mutate(prc_own = owner_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(owner_occupiedM^2 - (prc_own^2 * occupiedM^2)) / occupiedE)

# Add a geography column.
nationOwn <- nationOwn %>% 
  mutate(geography = "Nation")

# Bind contextual areas together with bind_rows().
contextOwn <- stateOwn %>% 
  bind_rows(regionOwn, nationOwn)

# Bind all geographies together.
Own <- placeOwn %>% 
  bind_rows(contextOwn)

# Change geography to remove Place.
Own <- Own %>% 
  mutate(geography = ifelse(geography %in% c("Nation","Region","State"),geography, NAME))

# Plot home ownership rate for cities as a line plot with ribbon moe.                       PLOT
placeOwn %>% 
  ggplot(aes(x = year, y = prc_own, group = NAME)) + 
  geom_ribbon(aes(ymax = prc_own + prc_moe, ymin = prc_own - prc_moe, fill = NAME),
              alpha = 0.3) + 
  geom_line(aes(color = NAME), linewidth = .75) + 
  geom_point(size = 1.5) + 
  theme_fivethirtyeight() + 
  scale_y_continuous(labels = scales::percent)+
  labs(title = "Home Ownership Rate",
       x = "Year",
       y = "ACS estimate",
       fill = "",
       color = "",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Shaded area represents margin of error around the ACS estimate") +
  theme(axis.text.x=element_text(angle = 45, hjust = 1))

ownership_rate %>% ggsave(filename = "ownership_rate.png", width = 8, height = 6, dpi = 400)


#########################################################                       ############
# 9. Rental Rates                                                               Rental Rates


placeRent <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("renter_occupied" = "B25003_003",
                  "occupied" = "B25002_002"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column for percentage renting. 
# Create column for new margin of error. 
# Filter the data frames for the desired cities. 
placeRent <- placeRent %>% 
  mutate(prc_rent = renter_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(renter_occupiedM^2 - (prc_rent^2 * occupiedM^2)) / occupiedE) %>% 
  filter(NAME %in% target_cities) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa"))

# Add a geography column.
placeRent <- placeRent %>% 
  mutate(geography = "Place")

# Getting renter occupied data and total occupied units from 5-Year American Community Survey for Iowa. 
# Using years object that was defined earlier.
stateRent <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("renter_occupied" = "B25003_003",
                  "occupied" = "B25002_002"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column called prc_rent for percent rent. 
# Create column for the margin of error of prc_rent.
stateRent <- stateRent %>% 
  mutate(prc_rent = renter_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(renter_occupiedM^2 - (prc_rent^2 * occupiedM^2)) / occupiedE)

# Add a geography column.
stateRent <- stateRent %>% 
  mutate(geography = "State")

# Getting renter occupied data and total occupied units from 5-Year American Community Survey for the Midwest. 
# Using years object that was defined earlier.
regionRent <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("renter_occupied" = "B25003_003",
                  "occupied" = "B25002_002"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# To simplify the filtering process from now on, create an object for desired region 
target_region <- "Midwest Region"

# Create a column called prc_rent for percent renting.
# Create column for the margin of error of prc_rent.
# Filter the data frame for the desired cities. 
regionRent <- regionRent %>% 
  mutate(prc_rent = renter_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(renter_occupiedM^2 - (prc_rent^2 * occupiedM^2)) / occupiedE) %>% 
  filter(NAME %in% target_region) %>% 
  mutate(NAME = str_remove(NAME, " Region"))

# Add a geography column.
regionRent <- regionRent %>% 
  mutate(geography = "Region")

# Getting renter occupied data and total occupied units from 5-Year American Community Survey for Iowa. 
# Using years object that was defined earlier.
nationRent <- map_dfr(years, ~{
  get_acs(
    geography = "us",
    variables = c("renter_occupied" = "B25003_003",
                  "occupied" = "B25002_002"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column called prc_rent for percent renting.
# Create column for the margin of error of prc_rent.
# Filter the data frame for the desired cities. 
nationRent <- nationRent %>% 
  mutate(prc_rent = renter_occupiedE/occupiedE) %>% 
  mutate(prc_moe = sqrt(renter_occupiedM^2 - (prc_rent^2 * occupiedM^2)) / occupiedE)

# Add a geography column.
nationRent <- nationRent %>% 
  mutate(geography = "Nation")

# Bind contextual areas together with bind_rows().
contextRent <- stateRent %>% 
  bind_rows(regionRent, nationRent)

# Bind all geographies together.
Rent <- placeRent %>% 
  bind_rows(contextRent)

# Change geography to remove Place.
#Rent <- Rent %>% 
#  mutate(geography = ifelse(geography %in% c("Nation","Region","State"),geography, NAME))

# rent, own, and vacant as ribbon
rent_and_own_rate <- placeOwn %>% 
  ggplot(aes(x = year, y = prc_own, group = NAME)) +
  geom_col(data = placeRent, aes(x=year, y=prc_rent, group = NAME, fill = NAME), position = "dodge") +
  geom_ribbon(aes(ymax = prc_own + prc_moe, ymin = prc_own - prc_moe, fill = NAME),
              alpha = 0.3) + 
  geom_line(aes(color = NAME), linewidth = .75) + 
  geom_point(size = 1.5) + 
  theme_fivethirtyeight() + 
  scale_y_continuous(labels = scales::percent)+
  labs(title = "Rental and Ownership Rate",
       x = "Year",
       y = "ACS estimate",
       fill = "",
       color = "",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Shaded area represents margin of error around the ACS estimate") +
  theme(axis.text.x=element_text(angle = 45, hjust = 1))

rent_and_own_rate %>% ggsave(filename = "rent_and_own_rate.png", width = 8, height = 6, dpi = 400)


##########################################################                      #############
# 10. Vacancy Rates                                                             Vacancy Rates     

# Get total vacant units and total units from 5-Year American Community Survey. 
placeVacant <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("vacant" = "B25002_003",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column for percent vacant.
# Filter in the NAME column for the names identified in target_cities.
# Add a geography column.
placeVacant <- placeVacant %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  filter(NAME %in% target_cities) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa")) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)) / totalE) %>% 
  mutate(geography = "Place")

# Getting from ACS.
stateVacant <- map_dfr(years, ~{
  get_acs(geography = "state",
          state = "IA",
          variables = c("vacant" = "B25002_003",
                        "total" = "B25001_001"),
          year = .x,
          survey = "acs5",
          output = "wide")
}, .id = "year")

# Create a column for percent vacant.
# Calculate the new margin of error. 
stateVacant <- stateVacant %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)/totalE)) %>% 
  mutate(geography = "State")

# Get total vacant units and total units from 5-Year American Community Survey. 
regionVacant <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("vacant" = "B25002_003",
                  "total" = "B25001_001"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Create a column for percent vacant.
# Filter for target regions. 
# Add a geography column.
regionVacant <- regionVacant %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  filter(NAME %in% target_region) %>% 
  mutate(NAME = str_remove(NAME, " Region")) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)) / totalE) %>% 
  mutate(geography = "Region")

# Getting from ACS.
nationVacant <- map_dfr(years, ~{
  get_acs(geography = "us",
          variables = c("vacant" = "B25002_003",
                        "total" = "B25001_001"),
          year = .x,
          survey = "acs5",
          output = "wide")
}, .id = "year")

# Create a column for percent vacant.
# Calculate the new margin of error. 
nationVacant <- nationVacant %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)/totalE)) %>% 
  mutate(geography = "Nation")

# Combine geographies. 
contextVacant <- stateVacant %>% 
  bind_rows(regionVacant, nationVacant)
Vacant <- placeVacant %>% 
  bind_rows(contextVacant)

# Combine Own, Rent, and Vacant together for each geography. 
nationRate <- nationOwn %>% 
  bind_rows(nationRent, nationVacant)
regionRate <- regionOwn %>% 
  bind_rows(regionRent, regionVacant)
stateRate <- stateOwn %>% 
  left_join(stateRent, by = c("GEOID","NAME","occupiedE","occupiedM"))
placeRate <- placeOwn %>% 
  bind_rows(placeRent, placeVacant)


# vacant cities as a bar plot                                                     PLOT
vacant_bar <- placeVacant %>% 
  ggplot(aes(x = year, y = prc_vacant, group = NAME, fill = NAME)) +
  geom_col(position = "dodge") +
  scale_y_continuous(label = scales::percent)+
  theme_fivethirtyeight()+
  labs(title = "Percent Vacant Homes",
       subtitle = "2009-2021 5-Year ACS Estimates",
       x = "",
       y = "ACS estimate",
       fill = "")+
  theme(axis.text.x=element_text(angle = 45, hjust = 1))

vacant_bar %>% ggsave(filename = "vacant_bar.png", width = 8, height = 6, dpi = 400)

# calculate prc_moe with the new estimate
# link to calculator tools:
# https://fyi.extension.wisc.edu/community-data-tools/2011/03/22/american-community-survey-acs-statistical-calculator/
# prc_moe = square root(vacantM^2 - (prc_vacant^2*totalM^2)) / totalE


# vacant cities as a line plot with ribbon moe                                    PLOT
vacant_ribbon <- placeVacant %>% 
  ggplot(aes(x = year, y = prc_vacant, group = NAME)) + 
  geom_ribbon(aes(ymax = prc_vacant + prc_moe, ymin = prc_vacant - prc_moe, fill = NAME),
              alpha = 0.3) + 
  geom_line(aes(color = NAME),linewidth = .1) + 
  geom_point(size = 1.5) + 
  theme_fivethirtyeight() + 
  scale_y_continuous(labels = scales::percent)+
  labs(title = "Percent Vacant Homes",
       x = "Year",
       y = "ACS estimate",
       fill = "",
       color = "",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Shaded area represents margin of error around the ACS estimate\nVariables: B25002_003 and B25001_001") +
  theme(axis.text.x=element_text(angle = 45, hjust = 1))

vacant_ribbon %>% ggsave(filename = "vacant_ribbon.png", width = 8, height = 6, dpi =400)

### compare to their counties
# going to do a facet wrap for each city and their respective county
# create a column called facet for this ^^^

# create separate data frames for each and make a facet column
# could do this with an if else statment but idk how
vacant_ind <- vacant %>% 
  filter(NAME == "Independence") %>% 
  mutate(facet = "Independence")%>% 
  mutate(type = "Independence")

vacant_hampton <- vacant %>% 
  filter(NAME == "New Hampton") %>% 
  mutate(facet = "New Hampton")%>% 
  mutate(type = "New Hampton")

vacant_grundy <- vacant %>% 
  filter(NAME == "Grundy Center") %>% 
  mutate(facet = "Grundy Center")%>% 
  mutate(type = "Grundy Center")

# pull acs data from vacant_years
vacant_counties <- map_dfr(vacant_years, ~{
  get_acs(
    geography = "county",
    variables = c("vacant" = "B25002_003",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# filter for target counties
vacant_g <- vacant_counties %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)) / totalE) %>% 
  filter(NAME == "Grundy County, Iowa") %>% 
  mutate(NAME = str_remove(NAME, ", Iowa")) %>% 
  mutate(facet = "Grundy Center") %>% 
  mutate(type = "Associated county")

vacant_b <- vacant_counties %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)) / totalE) %>% 
  filter(NAME == "Buchanan County, Iowa") %>% 
  mutate(NAME = str_remove(NAME, ", Iowa")) %>% 
  mutate(facet = "Independence")%>% 
  mutate(type = "Associated county")

vacant_c <- vacant_counties %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)) / totalE) %>% 
  filter(NAME == "Chickasaw County, Iowa") %>% 
  mutate(NAME = str_remove(NAME, ", Iowa")) %>% 
  mutate(facet = "New Hampton")%>% 
  mutate(type = "Associated county")

# bind_rows with vacant data frame
vacant_counties <- vacant_ind %>% 
  bind_rows(vacant_grundy,vacant_hampton, vacant_b,vacant_g,vacant_c) 

# plot as ribbon moe and facet wrap by city                                       PLOT
vacant_counties.png <- vacant_counties %>% 
  ggplot(aes(x = year, y = prc_vacant, group = NAME)) + 
  geom_ribbon(aes(ymax = prc_vacant + prc_moe, ymin = prc_vacant - prc_moe, fill = type),
              alpha = 0.3) + 
  geom_line(aes(color = type), linewidth =.75) + 
  geom_point(size = 1.5) + 
  theme_fivethirtyeight() + 
  facet_wrap(~facet)+
  scale_y_continuous(labels = scales::percent)+
  labs(title = "Percent Vacant Homes",
       x = "Year",
       y = "ACS estimate",
       color = "",
       fill = "",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Shaded area represents margin of error around the ACS estimate\n Variables: B25002_003 and B25001_001") +
  theme(axis.text.x=element_text(angle = 45, hjust = 1),
        strip.text = element_text(face = "bold"))

vacant_counties.png %>% ggsave(filename = "vacant_counties.png", width = 12, height = 6, dpi = 400)

# compare to Iowa
vacant_ia <- map_dfr(vacant_years, ~{
  get_acs(
    geography = "state",
    variables = c("vacant" = "B25002_003",
                  "total" = "B25001_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(prc_vacant = vacantE/totalE) %>% 
  mutate(prc_moe = sqrt(vacantM^2 - (prc_vacant^2 * totalM^2)) / totalE)

# combine vacant cities
vacant_ia <- vacant_ia %>% 
  bind_rows(vacant)

# plot iowa and cities
# as line plot                                                                    PLOT
iowa_vacant <- vacant_ia %>% 
  ggplot(aes(x = year, y = prc_vacant, group = NAME)) + 
  geom_ribbon(aes(ymax = prc_vacant + prc_moe, ymin = prc_vacant - prc_moe, fill = NAME),
              alpha = 0.3) + 
  geom_line(aes(color = NAME), linewidth = .75) + 
  geom_point(size = 1.5) + 
  theme_fivethirtyeight() + 
  scale_y_continuous(labels = scales::percent)+
  labs(title = "Percent Vacant Homes",
       x = "Year",
       y = "ACS estimate",
       color = "",
       fill = "",
       subtitle = "2009-2021 5-Year ACS Estimates",
       caption = "Shaded area represents margin of error around the ACS estimate\nVariables: B25002_003 and B25001_001") +
  theme(axis.text.x=element_text(angle = 45, hjust = 1))

iowa_vacant %>% ggsave(filename = "iowa_vacant.png", width = 8, height = 6, dpi = 400)

# as bar plot                                                                     PLOT
bar_iowa_vacant <- vacant_ia %>% 
  ggplot(aes(x = year, y = prc_vacant, group = NAME, fill = NAME)) +
  geom_col(position = "dodge", alpha = .9) +
  theme_fivethirtyeight()+
  scale_y_continuous(labels = scales::percent)+
  labs(title = "Percent Vacant Homes",
       subtitle = "2009-2021 5-Year ACS Estimates",
       x = "",
       y = "ACS estimate",
       fill = "",
       alpha = "",
       caption = "Variables: B25002_003 and B25001_001")+
  theme(axis.text.x=element_text(angle = 45, hjust = 1))

bar_iowa_vacant %>% ggsave(filename = "bar_iowa_vacant.png", width = 8, height = 6, dpi = 400)
