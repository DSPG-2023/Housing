# The following R Script creates plots to visualize population characteristics of communities.
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


### The first thing we want to visualize is population change.

# 1. Population Change                                                          

# Define the variables before getting the data.
# The Census API code for total population for 2000 and 2010 is P001001.
pop00 <- c("pop" = "P001001")
pop10 <- c("pop" = "P001001")
# The API code for total population changed for 2020.
# The Census API code for total population is P1_001N for 2020. 
pop20 <- c("pop" = "P1_001N")

###
## National Context: nationPop
# Getting 2000 total population data for the USA.
nation00 <- get_decennial(geography = "us",
                          year = 2000,
                          variable = pop00,
                          output = "wide") %>% 
  mutate(year = 2000)
# Getting 2010 total population data for the USA.
nation10 <- get_decennial(geography = "us",
                          year = 2010,
                          variable = pop10,
                          output = "wide") %>% 
  mutate(year = 2010)
# Getting 2020 total population data for the USA.
nation20 <- get_decennial(geography = "us",
                          year = 2020,
                          variable = pop20,
                          output = "wide") %>% 
  mutate(year = 2020)
# Bind the years together using bind_rows to create data frame for national context. 
nationPop <- nation20 %>% 
  bind_rows(nation10,nation00) %>% 
  mutate(geography = "Nation") 


###
## Regional Context: regionPop
# Getting 2000 total population data from the Midwest.
region00 <- get_decennial(geography = "region",
                          year = 2000,
                          variable = pop00,
                          output = "wide") %>% 
  mutate(year = 2000)
# Getting 2010 total population data for the Midwest.
region10 <- get_decennial(geography = "region",
                          year = 2010,
                          variable = pop10,
                          output = "wide") %>% 
  mutate(year = 2010)
# Getting 2020 total population data for the Midwest.
region20 <- get_decennial(geography = "region",
                          year = 2020,
                          variable = pop20,
                          output = "wide") %>% 
  mutate(year = 2020)
# Bind the years together using bind_rows to create data frame for regional context. 
# Filter to keep just the Midwest Region. 
regionPop <- region20 %>% 
  bind_rows(region10,region00) %>% 
  filter(NAME == "Midwest Region") %>% 
  mutate(NAME = str_remove(NAME, " Region")) %>% # Use str_remove() to remove " Region" from Midwest. 
  mutate(geography = "Region")


###
## State Context: statePop
# Getting the 2000 total population data for the state of Iowa from the Decennial Census.
iowa00 <- get_decennial(geography = "state",
                        state = "IA",
                        year = 2000,
                        output = "wide",
                        variable = pop00) %>% 
  mutate(year = 2000)
# Getting the 2010 total population data for the state of Iowa from the Decennial Census.
iowa10 <- get_decennial(geography = "state",
                        state = "IA",
                        variable = pop10,
                        year = 2010,
                        output = "wide") %>% 
  mutate(year = 2010)
# Getting the 2020 total population data for the state of Iowa from the Decennial Census.
iowa20 <- get_decennial(geography = "state",
                        state = "IA",
                        variable = pop20,
                        year = 2020,
                        output = "wide") %>% 
  mutate(year = 2020)

# Bind the years together using bind_rows to create data frame for state context. 
statePop <- iowa20 %>% 
  bind_rows(iowa10,iowa00) %>% 
  mutate(geography = "State")


###
## Places: 
# Getting 2000 total population data for all places in Iowa.
place00 <- get_decennial(geography = "place",
                         state = "IA",
                         year = 2000,
                         output = "wide",
                         variables = pop00) %>% 
  mutate(year = 2000)
place10 <- get_decennial(geography = "place",
                         state = "IA",
                         year = 2010,
                         output = "wide",
                         variables = pop10) %>% 
  mutate(year = 2010)
place20 <- get_decennial(geography = "place",
                         state = "IA",
                         variable = pop20,
                         year = 2020,
                         output = "wide") %>% 
  mutate(year = 2020)
# Bind the years together using bind_rows() to create data frame for all places in Iowa. 
placePop <- place20 %>% 
  bind_rows(place10,place00) %>% 
  mutate(geography = "Place")

# Filter for Independence, Grundy Center, and New Hampton. 
placePop <- placePop[placePop$NAME %in% c("Grundy Center city, Iowa", "Independence city, Iowa", "New Hampton city, Iowa"), ] %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa")) # Use str_remove() to remove "city, Iowa" from behind the place names. 

# Combine nationPop, regionPop, statePop, and placePop using bind_rows().
population <- nationPop %>% 
  bind_rows(regionPop,statePop,placePop)

# Calculate the change in population.
population <- population %>%
  group_by(NAME) %>%
  arrange(year) %>%
  mutate(pop_change = pop - lag(pop)) 




# Start visualizing total population now that master data frame is created. 


# Plot the change in total population for Independence.                           PLOT
# Filter population for Independence.
population %>% 
  filter(NAME == "Independence") %>% 
  ggplot(aes(x = year, y = pop))+
  geom_line()+
  geom_point(size = 2)+
  geom_text(aes(label = scales::comma(pop)), hjust = -.31)+
  scale_y_continuous(label = scales::comma)+
  scale_x_continuous(limits = c(1997, 2023),
                     breaks = c(2000,2010,2020))+
  theme_fivethirtyeight()+
  theme(legend.position = "bottom")+
  labs(title = "Change in Total Population",
       subtitle = "Independence, Iowa",
       y = "Population",
       x = "",
       color = "", 
       caption = "2000-2020 Decennial Census")


# Plot the change in total population for New Hampton.                           PLOT
# Filter population for New Hampton.
population %>% 
  filter(NAME == "New Hampton") %>% 
  ggplot(aes(x = year, y = pop))+
  geom_line()+
  geom_point(size = 2)+
  geom_text(aes(label = scales::comma(pop)),hjust = -.3)+ 
  scale_y_continuous(label = scales::comma)+
  scale_x_continuous(limits = c(1997, 2023),
                     breaks = c(2000,2010,2020))+
  theme_fivethirtyeight()+
  theme(legend.position = "bottom")+
  labs(title = "Change in Total Population",
       subtitle = "New Hampton, Iowa",
       y = "Population",
       x = "",
       color = "", 
       caption = "2000-2020 Decennial Census")


# Plot the change in total population Grundy Center.                              PLOT
# Filter population for Grundy Center.
population %>% 
  filter(NAME == "Grundy Center") %>% 
  ggplot(aes(x = year, y = pop))+
  geom_line()+
  geom_point(size = 2)+
  geom_text(aes(label = scales::comma(pop)),hjust = -.3)+
  scale_y_continuous(label = scales::comma)+
  scale_x_continuous(limits = c(1997, 2023),
                     breaks = c(2000,2010,2020))+
  theme_fivethirtyeight()+
  theme(legend.position = "bottom")+
  labs(title = "Change in Total Population",
       subtitle = "Grundy Center, Iowa",
       y = "Population",
       x = "",
       color = "", 
       caption = "2000-2020 Decennial Census")


# Plot total population for all cities.                                           PLOT    
# Filter for the cities. 
# Assign the plot to an object.
change_pop_cities.png <- population[population$NAME %in% c("Grundy Center", "Independence", "New Hampton"), ] %>% 
  ggplot(aes(x = year, y = pop, group = NAME))+
  geom_line(aes(color = NAME), linewidth = 1)+
  geom_point(size = 2)+
  geom_text(aes(label = scales::comma(pop_change)),vjust = -1)+
  scale_y_continuous(label = scales::comma,
                     limits = c(2500,6300))+
  scale_x_continuous(limits = c(1998, 2022),
                     breaks = c(2000,2010,2020))+
  theme_fivethirtyeight()+
  theme(legend.position = "bottom")+
  labs(title = "Change in Total Population",
       subtitle = "2000-2020 Decennial Census",
       y = "Population",
       x = "",
       color = "", 
       caption = "Variables: P1_001N and P001001")

# Save the plot as a .png file.
change_pop_cities.png %>% ggsave(filename = "change_pop_cities.png", width = 8, height = 6, dpi = 400)

## Plot change in total population with line type = NAME.                           PLOT
population[population$NAME %in% c("Grundy Center", "Independence", "New Hampton"), ] %>% 
  ggplot(aes(x = year, y = pop, group = NAME, linetype = NAME))+
  geom_line()+
  geom_point(size = 2)+
  geom_text(aes(label = scales::comma(pop)),vjust = -1)+  
  scale_y_continuous(label = scales::comma,
                     limits = c(2500,6500))+
  scale_x_continuous(limits = c(1998, 2022),
                     breaks = c(2000,2010,2020))+
  theme_fivethirtyeight()+
  theme(legend.position = "bottom")+
  labs(title = "Change in Total Population",
       subtitle = "Comparison between Grundy Center, Independence,\nand New Hampton",
       y = "Population",
       x = "",
       color = "", 
       linetype = "",
       caption = "2000-2020 Decennial Census")

# Plot total population for all geographies.                                      PLOT
# Assign the plot to an object.
all_population.png <- population %>% 
  ggplot(aes(x = year, y = pop, group = NAME)) +
  geom_line(aes(linetype = geography, color = NAME), linewidth = 1)+
  geom_point(size = 2)+
  scale_y_log10(label = scales::comma) +
  scale_x_continuous(limits = c(2000, 2020),
                     breaks = c(2000,2010,2020))+
  theme_fivethirtyeight()+
  theme(legend.position = "bottom")+
  labs(title = "Change in Total Population",
       y = "Population (log scale)",
       subtitle = "2000-2020 Decennial Census",
       x = "",
       color = "", 
       linetype = "",
       caption = "Variables: P1_001N and P001001")

# Save the plot as a .png file.
all_population.png %>% ggsave(filename = "all_population.png", width = 8, height = 6, dpi = 400)



# The next thing we want to visualize is the PERCENT CHANGE in population.
# 2. Percent Population Change                                                  

# Create anew column called prc_change.
# Group by "NAME" so that the calculations occur individually for each place. 
# Percent change is calculated by subtracting year2 from year1 and dividing by year2. 
population <- population %>%
  group_by(NAME) %>%
  mutate(prc_change = case_when(
    year == 2000 ~ NA,
    year == 2010 ~ (pop - lag(pop, n = 10, default = last(pop))) / lag(pop, n = 10, default = last(pop)),
    year == 2020 ~ (pop - lag(pop, n = 20, default = last(pop))) / lag(pop, n = 20, default = last(pop))
  ))

# Create a grouping column in the population data
population <- population %>%
  mutate(grouping = ifelse(NAME %in% c("United States", "Midwest", "Iowa"), "Contextual Area", "Places"))


## Plot the percent change in population for all geographies.                    PLOT
# Assign the plot to an object.
all_percent_change.png <- population %>% 
  ggplot(aes(x = year, y = prc_change, group = NAME)) +
  geom_line(aes(color = NAME, linetype = grouping), linewidth = 1) +
  geom_text(aes(x= 2020.65, y = .1777, label = "17.77%"), size = 3.5) +
  geom_text(aes(x= 2020.65, y = .09023, label = "9.02%"), vjust = -.2, size = 3.5) +
  geom_text(aes(x= 2020.65, y = .07132, label = "7.13%"), vjust = 1.2, size = 3.5) +
  geom_text(aes(x= 2020.65, y = .0770416, label = "7.70%"), size = 3.5, vjust = -.000002) +
  geom_text(aes(x= 2020.65, y = .0083139, label = "0.83%"), size = 3.5) +
  geom_text(aes(x= 2020.65, y = -.053629, label = "-5.36%"), size = 3.5) +
  geom_point(size = 2) +
  scale_y_continuous(label = scales::percent) +
  scale_x_continuous(breaks = c(2010, 2015,2020), limits = c(2010,2021)) +
  theme_fivethirtyeight() +
  theme(strip.text = element_text(face = "bold"))+
  labs(title = "Percent Change in Total Population",
       subtitle = "2000-2020 Decennial Census",
       color = "",
       caption = "Variables: P1_001N and P001001",
       linetype = "") 


# Save the plot as a .png file.
all_percent_change.png %>% ggsave(filename = "all_percent_change.png", width = 8, height = 6, dpi = 400)


## Plot the percent change in total population for just the places.
# Filter the population data frame for places. 
# Assign the plot to an object.
prc_change_cities.png <- population[population$NAME %in% c("Grundy Center", "Independence", "New Hampton"), ] %>% 
  ggplot(aes(x = year, y = prc_change, group = NAME)) +
  geom_line(aes(color = NAME), linewidth = 1) +
  geom_point(size = 2) +
  geom_text(aes(label = scales::percent(prc_change)), hjust = .5,vjust = -.75 )+
  scale_y_continuous(label = scales::percent, limits = c(-.06,.085)) +
  scale_x_continuous(breaks = c(2010,2015, 2020), limits = c(2008, 2022)) +
  theme_fivethirtyeight() +
  theme(strip.text = element_text(face = "bold"),
        legend.position = "bottom")+  # Align legend to the right
  labs(title = "Percent Change in Total Population",
       subtitle = "2000-2020 Decennial Census",
       color = "",
       caption = "Variables: P1_001N and P001001",
       linetype = "")

# Save the plot as a .png file. 
prc_change_cities.png %>% ggsave(filename = "prc_change_cities.png", width = 8, height = 6, dpi = 400)



# Finally, we want to visualize the population estimates. 
# In this case, we will be estimated the 2030 population.
# 3. Population Estimates                                                       

# Calculate AAAC for each geography.
# AAAC = 2020 population - 2000 population / 20
# AKA. AAAC = population - population / time
population <- population %>%
  group_by(NAME) %>%
  mutate(AAAC = (pop[year == 2020] - pop[year == 2000]) / 20)

# Create a new data frame for the projected population in 2030.
proj_2030 <- population %>%
  filter(year == 2020) %>%
  mutate(year = 2030, pop = pop + (AAAC*10))

# Combine the original data frame and the projected population data for 2030.
population <- bind_rows(population, proj_2030)

# Remove the AAAC column.
population <- population %>%
  select(-AAAC)

# Add a new column specifying if the population is actual or a projection.
population <- population %>% 
  mutate(type = if_else(year == 2030, "Projection", "Actual"))


# Plot the actual and projected total population from 2000 to 2030               PLOT 
pop_projection_cities.png <- population[population$NAME %in% c("Grundy Center", "Independence", "New Hampton"), ] %>% 
  ggplot(aes(x = year, y = pop, group = NAME, linetype = NAME)) +
  geom_line(linewidth = 1)+
  geom_point(aes(color = type), size = 2)+
  geom_text(aes(label = scales::comma(round(pop))),
            vjust = -1)+
  theme_fivethirtyeight()+
  scale_y_continuous(labels = scales::comma,
                     limits = c(2500,6500))+
  scale_x_continuous(limits = c(1998,2032),
                     labels = c("2000","2010","2020", "2030 Est."))+
  theme(legend.position = "bottom")+
  labs(x = "",
       color = "",
       linetype = "",
       title = "Total Population",
       caption = "2030 Population Estimated with AAAC\nVariables: P1_001N and P001001",
       subtitle = "2000-2020 Decennial Census")

pop_projection_cities.png %>% ggsave(filename = "pop_projection_cities.png", width = 8, height = 6, dpi = 400)


