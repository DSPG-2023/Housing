# The following R Script creates plots to visualize the reason for vacancy of communities.
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


# Reason for Vacancy                                                      

placeReason <- get_acs(geography = "place",
                   state = "IA",
                   year = 2021,
                   variables = c("For rent" = "B25004_002",
                                 "Rented, not occupied" = "B25004_003",
                                 "For sale" = "B25004_004",
                                 "Sold, not occupied" = "B25004_005",
                                 "Seasonal" = "B25004_006",
                                 "Migrant worker" = "B25004_007",
                                 "Other" = "B25004_008",
                                 "total" = "B25004_001"))

# Filter for desired cities.
placeReason <- placeReason %>% 
  filter(NAME %in% target_cities) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa"))

# Turn values into percents of the total.
placeReason <- placeReason %>% 
  group_by(NAME) %>% 
  mutate(percent = estimate / first(estimate)) %>% 
  filter(variable != "total")

# Plot reason for vacancy.                                                       PLOT
vacant_reason <- placeReason %>% 
  ggplot(aes(x=factor(variable, level=c("For rent","Rented, not occupied","For sale","Sold, not occupied","Seasonal","Migrant worker","Other")), y = percent, group = NAME, fill = NAME)) +
  geom_col(position = "dodge") +
  theme_fivethirtyeight()+
  scale_y_continuous(labels = scales::percent,
                     breaks = c(0,.1,.2,.3,.4)) +
  labs(title = "Reason for Vacancy",
       subtitle = "2017-2021 5-Year ACS Estimates",
       x = "",
       y = "ACS estimate",
       fill = "",
       alpha = "",
       caption = "Variables: B25004_001, B25004_002, B25004_003, B25004_004,\nB25004_005, B25004_006, B25004_007, B25004_008")+
  theme(axis.text.x=element_text(angle = 45, hjust = 1),
        plot.caption = element_text(size = 8))

vacant_reason %>% ggsave(filename = "vacant_reason.png", width = 8, height = 6, dpi = 400)
