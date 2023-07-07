# The following R Script creates plots to visualize median home value of communities.
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


# Median House Value                                                         

# Getting housing value data from the 5-year 2020 American Community Survey.
# Specify county for just Chickasaw, Grundy, and Buchanan County.
# The API Code for median home value is "B25077_001."
housing_val <- get_acs(
  geography = "tract", 
  variables = "B25077_001", 
  state = "IA", 
  county = c("Chickasaw","Grundy","Buchanan"
  ),
  year = 2020
)
# Separate the median home value data into three separate geographies: tract, county, and state.
housing_val2 <- separate(
  housing_val, 
  NAME, 
  into = c("tract", "county", "state"), 
  sep = ", "
)  

# Filter median home value data by census tract. 
# The city of Independence falls into two census tracts: 9505 and 9504.
# Grundy Center is in tract 9603.
# New Hampton is in tract 704.
# Add a new column called "city" with the associated city name. 
ind_house_val <- housing_val2 %>% 
  filter(tract == c("Census Tract 9505", "Census Tract 9504")) %>% 
  mutate(city = "Independence")
hampton_house_val <- housing_val2 %>% 
  filter(tract == "Census Tract 704") %>% 
  mutate(city = "New Hampton")
grundy_house_val <- housing_val2 %>% 
  filter(tract == "Census Tract 9603") %>% 
  mutate(city = "Grundy Center")

# Bind individual data frames together with bind_rows().
cities_house_val <- ind_house_val %>% 
  bind_rows(hampton_house_val,grundy_house_val)

# Use the summarize function to find the minimum, maximum, median and mean of the median home value estimates. 
cities_house_val %>%
  group_by(city) %>%
  summarize(min = min(estimate, na.rm = TRUE), 
            mean = mean(estimate, na.rm = TRUE), 
            median = median(estimate, na.rm = TRUE), 
            max = max(estimate, na.rm = TRUE)) 

# Cannot visualize cities_house_val using this ggplot method because Grundy Center and New Hampton only have one value.
# Plot housing value by county instead.
# Add in a point that displays the median for each city from the 2020 5-Year ACS.
housing_val3 <- get_acs(
  geography = "place", 
  variables = "B25077_001", 
  state = "IA",
  year = 2020) %>% 
  filter(NAME %in% c("Grundy Center city, Iowa","New Hampton city, Iowa", "Independence city, Iowa"))

# grundy center = $130,600
# new hampton = $112,200
# independence = $129,900

# Create a density plot for median home value.                                   PLOT
med_house.jpg <- ggplot(housing_val2, aes(x = estimate, fill = county)) + 
  geom_density(alpha = 0.3, linewidth = 1) +
  geom_point(aes(y = 0.00002074, x = 112200), size = 2) + # New Hampton
  geom_point(aes(x = 129900, y = .00001405), size = 2) + # Independence
  geom_point(aes(x = 130600, y = .0000227), size = 2) + # Grundy Center
  geom_text(aes(y = 0.00002074, x = 112200, label = "New Hampton\n$112,200"), hjust = -.1, vjust = 1) +
  geom_text(aes(x = 129900, y = .00001405, label = "Independence\n$129,900"), hjust = -.1, vjust = 1) +
  geom_text(aes(x = 130600, y = .0000227, label = "Grundy Center\n$130,600"), hjust = 1.1, vjust = -.15) +
  labs(title = "Median House Values by Census Tract",
       subtitle = "2016-2020 5-Year ACS Estimates",
       y = "",
       x = "Median House Value",
       caption = "Points represent median house value for each city\nVariable: B25077_001",
       fill = "")+
  scale_x_continuous(labels = dollar_format()) +
  scale_y_continuous(labels = scales::comma,
                     limits = c(0,.000026))+
  theme_fivethirtyeight()

med_house.jpg %>% ggsave(filename = "med_house.png", width = 8, height = 6, dpi = 400)


# Now, want to plot all available data for median home value. 
# Getting median home value data from the 5-Year American Community Survey. 
# The median home value code is "B25077_001."

# Create an object called "years" that lists the years you want to pull data from. 
# We want all of the years the ACS data is available. 
years <- 2009:2021
names(years) <- years

# Use get_acs() to pull median home value data at the place level.
placeValue <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("median_value" = "B25077_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") 

# Remove the " city, Iowa|, Iowa" from the end of the place names.
placeValue <- placeValue %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

# Filter placeValue for desired cities.
# Add a geography column.
placeValue <- placeValue %>%
  filter(NAME %in% c("Grundy Center", "Independence", "New Hampton")) %>% 
  mutate(geography = "Place")


# Use get_acs() to pull median home value data at the state level.
stateValue <- map_dfr(years, ~{
  get_acs(
    geography = "state",
    variables = c("median_value" = "B25077_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") 

# Add a geography column. 
stateValue <- stateValue %>% 
  mutate(geography = "State")


# Use get_acs() to pull median home value data at the regional level.
regionValue <- map_dfr(years, ~{
  get_acs(
    geography = "region",
    variables = c("median_value" = "B25077_001"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") 

# Remove the " Region" from the end of the region names
regionValue<- regionValue %>% 
  mutate(NAME = str_remove(NAME, " Region"))

# Filter regionValue for Midwest.
# Add a geography column.
regionValue <- regionValue %>%
  filter(NAME %in% "Midwest") %>% 
  mutate(geography = "Region")


# Use get_acs() to pull median home value data at the national level.
nationValue <- map_dfr(years, ~{
  get_acs(
    geography = "us",
    variables = c("median_value" = "B25077_001"),
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year")

# Add a geography column.
nationValue <- nationValue %>% 
  mutate(geography = "Nation")

# Bind all geographies together with bind_rows().
value <- nationValue %>% 
  bind_rows(regionValue, stateValue, placeValue)

# Add a new column specifying if the geography is a nation, region, state, or place. 
value <- value %>% 
  mutate(grouping = ifelse(NAME %in% c("United States", "Midwest", "Iowa"), "Contextual Area", NAME))

# Create three separate plots for Grundy Center, Independence and New Hampton.
# Combine plots together using patchwork library. 
#install.packages("patchwork")
library(patchwork)

# Plot the median home value for Grundy Center and its contextual geographies.       PLOT
plot1 <- value[value$NAME %in% c("Grundy Center", "United States", "Midwest", "Iowa"), ] %>% 
  ggplot(aes(x = year, y = median_valueE, group = NAME)) +
  geom_ribbon(aes(ymax = median_valueE + median_valueM, ymin = median_valueE - median_valueM, fill = geography),
              alpha = 0.3) + 
  geom_line(aes(color = geography), linewidth = 1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k"),
                     limits = c(85000,250000))+
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(x = "",
       color = "",
       linetype = "",
       subtitle = "2009-2021 5-Year ACS Estimates\nGrundy Center",
       fill = "",
       title = "Median Home Value")

# Plot the median home value for Independence and its contextual geographies.        PLOT 
plot2 <- value[value$NAME %in% c("Independence", "United States", "Midwest", "Iowa"), ] %>% 
  ggplot(aes(x = year, y = median_valueE, group = NAME)) +
  geom_ribbon(aes(ymax = median_valueE + median_valueM, ymin = median_valueE - median_valueM, fill = geography),
              alpha = 0.3) + 
  geom_line(aes(color = geography), linewidth = 1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k"),
                     limits = c(85000,250000))+
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(x = "",
       color = "",
       linetype = "",
       subtitle = "\nIndependence",
       fill = "")

# Plot the median value for New Hampton and its contextual geographies.         PLOT 
plot3 <- value[value$NAME %in% c("New Hampton", "United States", "Midwest", "Iowa"), ] %>% 
  ggplot(aes(x = year, y = median_valueE, group = NAME)) +
  geom_ribbon(aes(ymax = median_valueE + median_valueM, ymin = median_valueE - median_valueM, fill = geography),
              alpha = 0.3) + 
  geom_line(aes(color = geography), linewidth = 1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k"),
                     limits = c(85000,250000))+
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(x = "",
       color = "",
       linetype = "",
       subtitle = "\nNew Hampton",
       fill = "",
       caption = "Shaded area represents margin of error around the ACS estimate\nVariable: B25077_001")

# Combine plots. 
combined_plots1 <- wrap_plots(plot1, plot2, plot3)

# Save as a .png file.
combined_plots1 %>% ggsave(filename = "median_value.png", dpi = 400, width = 12, height = 6)


# Plot just the city median home value data.                                     PLOT
ribbon_med_house.jpg <- value[value$NAME %in% c("Grundy Center", "New Hampton", "Independence"), ] %>% 
  ggplot(aes(x = year, y = median_valueE, group = NAME, fill = NAME)) + 
  geom_ribbon(aes(ymax = median_valueE + median_valueM, ymin = median_valueE - median_valueM),
              alpha = 0.3) + 
  geom_line(aes(color = NAME), linewidth = 1) + 
  theme_fivethirtyeight() + 
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k")) +
  labs(title = "Median Home Value",
       subtitle = "2009-2021 5-Year ACS Estimates",
       x = "Year",
       y = "ACS estimate",
       fill = "",
       color = "",
       caption = "Shaded area represents margin of error around the ACS estimate\nVariable: B25077_001") +
  geom_text(aes(x = "2021", y =137100, label = "$137,000"), vjust = -1)+
  geom_text(aes(x = "2021", y = 133300, label = "$133,300"), vjust = 2) +
  geom_text(aes(x = "2021", y = 122600, label = "$122,600"), vjust = -1)

ribbon_med_house.jpg <- ggsave(filename = "ribbon_med_house.png", width = 8, height =6, dpi = 400)

