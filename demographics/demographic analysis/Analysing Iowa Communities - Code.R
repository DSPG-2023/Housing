# create a large database with all filtering characteristics



library(tidycensus)
library(tidyverse)

## starting with POPULATION data for all places in Iowa ##
##########################################################

# pop API = P1_001N
# 2010 and 2000 pop API = P001001
pop <- get_decennial(geography = "place",
                     state = "IA",
                     variables = c("pop20" = "P1_001N"),
                     year = 2020,
                     output = "wide")
pop10 <- get_decennial(geography = "place",
                state = "IA",
                variable = c("pop10"="P001001"),
                year = 2010,
                output = "wide")
pop00 <- get_decennial(geography = "place",
                       state = "IA",
                       variable = c("pop00"="P001001"),
                       year = 2000,
                       output = "wide")
# join 2020,2010,2000 data
pop <- pop %>% 
  left_join(pop10,by = c("GEOID","NAME"))
pop <- pop %>% 
  left_join(pop00,by = c("GEOID","NAME"))

# figure out if the places are growing, shrinking, or stable
# calculate percent population change
# stable = between -2 and 2
# increasing > 2
# decreasing < -2
pop <- pop %>%
  mutate(prc_change = ((pop20 - pop00) / pop20)) %>%
  mutate(change_label = ifelse(prc_change > .02, "Growing",
                             ifelse(prc_change < -.02, "Shrinking", "Stable")))

## age of residents ##
######################

# adding to pop 

# get the median age of all people in all places in Iowa from ACS
pop_age <- get_acs(geography = "place",
               state = "IA",
               year = 2021,
               variable = c("med_age" = "B01002_001"),
               output = "wide") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

# get the number of people under 18 and over 65
male <- get_acs(geography = "place",
                  state = "IA",
                  year = 2021,
                  variable = c("under5" = "B01001_003",
                               "a5to9" = "B01001_004",
                               "a10to14" = "B01001_005",
                               "a15to17" = "B01001_006",
                               "a65to66" = "B01001_020",
                               "a67to69" = "B01001_021",
                               "a70to74" = "B01001_022",
                               "a75to79" = "B01001_023",
                               "a80to84" = "B01001_024",
                               "over85" = "B01001_025",
                               "total" = "B01001_002"),
                output = "wide") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))
male <- male %>% 
  mutate(under18E = under5E + a5to9E + a10to14E + a15to17E) %>%
  mutate(under18M = sqrt(under5M^2 + a5to9M^2 + a10to14M^2 + a15to17M^2)) %>%
  #mutate(prc_under18E = under18E / totalE) %>% 
  #mutate(prc_under18M = moe_ratio(under18E, totalE, under18M, totalM)) %>% 
  mutate(over65E = a65to66E + a67to69E + a70to74E + a75to79E + a80to84E + over85E) %>%
  mutate(over65M =  sqrt(a65to66M^2 + a67to69M^2 + a70to74M^2 + a75to79M^2 + a80to84M^2 + over85M^2))
 # mutate(prc_over65E = over65E / totalE) %>% 
  #mutate(prc_over65M = moe_ratio(over65E, totalE, over65M, totalM)) 

# do the same for the female data
female <- get_acs(geography = "place",
                state = "IA",
                year = 2021,
                variable = c("under5" = "B01001_027",
                             "a5to9" = "B01001_028",
                             "a10to14" = "B01001_029",
                             "a15to17" = "B01001_030",
                             "a65to66" = "B01001_044",
                             "a67to69" = "B01001_045",
                             "a70to74" = "B01001_046",
                             "a75to79" = "B01001_047",
                             "a80to84" = "B01001_048",
                             "over85" = "B01001_049",
                             "total" = "B01001_026"),
                output = "wide") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))
female <- female %>% 
  mutate(under18E = under5E + a5to9E + a10to14E + a15to17E) %>%
  mutate(under18M = sqrt(under5M^2 + a5to9M^2 + a10to14M^2 + a15to17M^2)) %>%
  #mutate(prc_under18E = under18E / totalE) %>% 
 #mutate(prc_under18M = moe_ratio(under18E, totalE, under18M, totalM)) %>% 
  mutate(over65E = a65to66E + a67to69E + a70to74E + a75to79E + a80to84E + over85E) %>%
  mutate(over65M =  sqrt(a65to66M^2 + a67to69M^2 + a70to74M^2 + a75to79M^2 + a80to84M^2 + over85M^2)) 
  #mutate(prc_over65E = over65E / totalE) %>% 
  #mutate(prc_over65M = moe_ratio(over65E, totalE, over65M, totalM)) 

# combine the data frames
age <- female %>% 
  bind_rows(male)

# aggregate by city NAME
aggregated_age <- age %>% 
  group_by(NAME) %>% 
             summarize(under18E = sum(under18E),
                       under18M = sqrt(sum(under18M^2)),
                       over65E = sum(over65E),
                       over65M = sqrt(sum(over65M)),
                       prc_under18E = sum(under18E)/sum(totalE),
                       prc_under18M = sqrt(sum(under18M^2) / sum(totalE)^2 + (sum(under18E)^2 * sum(totalM^2)) / sum(totalE)^4),
                       prc_over65E = sum(over65E)/sum(totalE),
                       prc_over65M = sqrt(sum(over65M^2) / sum(totalE)^2 + (sum(over65E)^2 * sum(totalM^2)) / sum(totalE)^4))

# add a column that states whether a place is "aged", "stable" or "young"
# using a 2% difference to gauge a stable population
aggregated_age <- aggregated_age %>%
  mutate(age_label = ifelse(prc_under18E - prc_over65E > .02, "Young",
                               ifelse(prc_under18E - prc_over65E < -.02, "Aging", "Stable")))

## add to pop dataframe
pop <- pop %>% 
  left_join(aggregated_age,by = c("NAME")) %>% 
  left_join(pop_age, by = c("GEOID","NAME"))


## next is housing information ##
#################################

# getting from 2021 5-Year ACS

# total housing units = B25001_001
# owner occupied units = B25003_002
# total occupied units = B25002_002
# total vacant units = B25002_003
# median house value = B25077_001 
# median house age = B25035_001

housing <- get_acs(geography = "place",
                   state = "IA",
                   variable = c("total_units" = "B25001_001",
                                "occupied_units" = "B25002_002",
                                "vacant_units" = "B25002_003",
                                "owner_occupied" = "B25003_002",
                                "renter_occupied" = "B25003_003",
                                "median_house_value" = "B25077_001"),
                   year = 2021,
                   output = "wide")
# this didn't have to be done separately
median_age <- get_acs(geography = "place",
                      state = "IA",
                      variable = c("median_year_built" = "B25035_001"),
                      year = 2021,
                      output = "wide") 
# calculate median_house_age by subtracting year built from 2023
median_age <- median_age %>%
  mutate(median_year_builtE = ifelse(median_year_builtE == 0, NA, median_year_builtE)) %>%
  mutate(median_house_ageE = 2023 - median_year_builtE) %>% 
  mutate(median_house_ageM = median_year_builtM) # don't have to make a new moe bc the subtraction didn't introduce new errors

housing <- housing %>% 
  left_join(median_age, by = c("GEOID","NAME"))

## ALL RATES ARE PERCENTAGES
# calculate home ownership, vacany, and rental rates
housing <- housing %>% 
  mutate(home_ownership_rateE = (owner_occupiedE / occupied_unitsE)) %>%  # divide owner occupied by occupied units
  mutate(home_ownership_rateM = (sqrt((owner_occupiedM^2) / (occupied_unitsE^2) + ((owner_occupiedE * occupied_unitsM)^2) / (occupied_unitsE^4)))) %>%  # calculate new moe
  mutate(rental_rateE = (renter_occupiedE / occupied_unitsE)) %>%  # divide renter occupied by occupied units
  mutate(rental_rateM = (sqrt((renter_occupiedM^2) / (occupied_unitsE^2) + ((renter_occupiedE * occupied_unitsM)^2) / (occupied_unitsE^4)))) %>% # calculate new moe
  mutate(vacancy_rateE = (vacant_unitsE / total_unitsE)) %>%  # divide vacant units by total units
  mutate(vacancy_rateM = (sqrt((vacant_unitsM^2) / (total_unitsE^2) + ((vacant_unitsE * total_unitsM)^2) / (total_unitsE^4)))) # calculate new moe


## next is Taxable Property Values from Liesl ##
################################################

#link to data: https://data.iowa.gov/Local-Government-Finance/Taxable-Property-Values-in-Iowa-by-Tax-District-an/ig9g-pba5

taxable.csv <- read.csv("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/demographics/demographic analysis/Datasets/Taxable_Property_Values_in_Iowa_by_Tax_District_and_Year.csv")
# City name is stored in City.Name as all caps
# for census data, only the first letter is capitalized and city, Iowa is attached
# need to lowercase taxable_prop_values and remove city, Iowa from housing and pop

housing <- housing %>% 
  mutate(NAME = str_remove(NAME," city, Iowa|, Iowa"))
pop <- pop %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))
taxable.csv <- taxable.csv %>% 
  mutate(City.Name = str_to_sentence(City.Name)) #str_to_sentence() uses regular sentence formatting where the first letter is capitalized
                              # could have also used str_to_titletext()

# aggregated the column based on City.Name
# function = sum to get the sum of all values
# na.rm = TRUE, means the NAs get ignored
residential <- aggregate(Residential ~ City.Name, data = taxable.csv, FUN = sum, na.rm = TRUE)
ag_land <- aggregate(Ag.Land ~ City.Name, taxable.csv, FUN = sum, na.rm = TRUE)
ag_building <- aggregate(Ag.Building ~ City.Name, taxable.csv, FUN = sum, na.rm = TRUE)
commercial <- aggregate(Commercial ~ City.Name, taxable.csv, FUN = sum, na.rm = TRUE)
industrial <- aggregate(Industrial ~ City.Name, taxable.csv, FUN = sum, na.rm = TRUE)

taxable_prop_values <- residential %>%
  left_join(ag_land, by = "City.Name") %>%
  left_join(ag_building, by = "City.Name") %>%
  left_join(commercial, by = "City.Name") %>%
  left_join(industrial, by = "City.Name")

taxable_prop_values <- taxable_prop_values %>% 
  rename(NAME = City.Name)

# average home value from taxable property base
# total unitsE / Residential
iowa <- iowa %>% 
  mutate(avg_residential = Residential/total_unitsE)
  


## next is RAC and WAC data from Liesl ##
#########################################

# link to data structure set: https://lehd.ces.census.gov/data/lodes/LODES8/LODESTechDoc8.0.pdf
# interested in total number of jobs and ag related industries
# C000 = total
# CSN01 = ag related jobs

# WAC = how many people WORK in the city
# RAC = how many people live in the city AND have jobs

# downloaded the data as .csv
# need to read in the .csv file with read.csv()
ia_rac.csv <- read.csv("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/demographics/demographic analysis/Datasets/ia_rac_S000_JT00_2020.csv")

# rename w_geocode to geocode so it can easily be combined with geography2 dataframe
ia_rac.csv <- ia_rac.csv %>%
  rename(geocode = h_geocode)

# this .csv file contains the geography for the wac and rac data
# need to join to wac and rac files so we can aggregate by city
geography <- read.csv("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/demographics/demographic analysis/Datasets/ia_xwalk.csv")
# tabblk2020 = h_geocode 
#ctyname = county
#cbsaname = metropolitan area name
#stplc = FIPS state + FIPS Place
#stplcname = place name

# reduce geography data frame to just h_geocode and NAME
geography2 <- geography %>% 
  select("tabblk2020","stplc","stplcname") %>% 
  rename(geocode = tabblk2020) %>% 
  rename(GEOID = stplc) %>% 
  mutate(NAME = str_remove(stplcname, " city, IA|, IA")) %>% 
  select(-stplcname)

# use geography2 to assign city NAME to ia_rac.csv
rac_data <- geography2 %>% 
  left_join(ia_rac.csv, by = "geocode")
# remove all empty rows
rac_data <- rac_data %>% 
  filter(GEOID != 9999999)

# aggregate by city name
# have to remove h_geocode and GEOID so they don't aggregate
rac_data <- aggregate(. ~ NAME, data = rac_data[, !(names(rac_data) %in% c("geocode", "GEOID"))], FUN = sum, na.rm = TRUE)

# downloaded the data as .csv
# need to read in the .csv file with read.csv()
ia_wac.csv <- read.csv("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/demographics/demographic analysis/Datasets/ia_wac_S000_JT00_2020.csv")

# rename w_geocode to geocode so it can easily be combined with geography2 dataframe
ia_wac.csv <- ia_wac.csv %>%
  rename(geocode = w_geocode)
# join to geography2 data frame
wac_data <- geography2 %>% 
  left_join(ia_wac.csv, by = "geocode")
# remove all empty rows
wac_data <- wac_data %>% 
  filter(GEOID != 9999999)
# aggregate by city name
wac_data <- aggregate(. ~ NAME, data = wac_data[, !(names(wac_data) %in% c("geocode", "GEOID"))], FUN = sum, na.rm = TRUE)

## build new data frame based on wanted variables
wac_rac

# Select columns 1:2 and 9 from the wac_data
wac_subset <- wac_data[, c(1:2, 9)]

# Select columns 1:2 and 9 from the rac_data
rac_subset <- rac_data[, c(1:2, 9)]

# Combine the selected columns from both data frames into a new data frame
wac_rac <- wac_subset %>% 
  left_join(rac_subset, by = "NAME")
# wac = x
# rac = y

# rac c000 = total employed residents
# rac cns01 = total residents employed in ag
# wac c000 = total jobs in city
# wac cns01 = total ag jobs in city
wac_rac <- wac_rac %>% 
  rename(total_jobs = C000.x) %>% 
  rename(workforce_size = C000.y) %>% 
  rename(workforce_ag = CNS01.y) %>% 
  rename(ag_jobs = CNS01.x)

## prc_workforce locally employed = wac c000.x / rac c000
## prc_workforce in ag = rac cns01.y / rac c000.y
## prc_jobs in ag = wac cns01.x / wac c000.x
wac_rac <- wac_rac %>% 
  mutate(prc_local = total_jobs/workforce_size) %>% 
  mutate(prc_wrkf_ag = workforce_ag / workforce_size) %>% 
  mutate(prc_ag_jobs = ag_jobs / total_jobs)

## prc_population in workforce = rac c000.y / pop
# left_joined to iowa data frame
# dividing by pop20 because wac and rac data is from 2020
iowa <- iowa %>% 
  mutate(prc_pop_in_wrkf = workforce_size / pop20) %>% 
  mutate(prc_pop_employed = total_jobs / pop20)




## Unemployment ##
##################        

# % labor force unemployed
unemployment <- get_acs(state = "IA", 
                   geography = "place",
                   year = 2021,
                   variable = c("total_workforce" = "B23025_003",
                                "unemployed" = "B23025_005"),
                   output = "wide") %>% 
  mutate(prc_unemployed = unemployedE / total_workforceE,
         unemployed_moe = moe_ratio(unemployedE, total_workforceE, unemployedM, total_workforceM)) %>% 
  mutate(NAME = str_remove(NAME," city, Iowa|, Iowa"))


## Commuting ##
###############

# pct population traveling outside of city for work
prc_travel <- get_acs(geography = "place",
                     state = "IA",
                     variable = c("total" = "B08008_001",
                                  "travel" = "B08008_004"),
                     year = 2021,
                     output = "wide") %>% 
  mutate(prc_travel = travelE / totalE,
         travel_moe = (moe_ratio(travelE, totalE, travelM, totalM))) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))


## Income ##
############

# median household income = B19013_001
income <- get_acs(geography = "place",
                     state = "IA",
                     variables = c("income21" = "B19013_001"),
                     year = 2021,
                     output = "wide")
income20 <- get_acs(geography = "place",
                       state = "IA",
                       variable = c("income20"="B19013_001"),
                       year = 2020,
                       output = "wide")
income19 <- get_acs(geography = "place",
                       state = "IA",
                       variable = c("income19"="B19013_001"),
                       year = 2019,
                       output = "wide")
income18 <- get_acs(geography = "place",
                          state = "IA",
                          variable = c("income17"="B19013_001"),
                          year = 2018,
                          output = "wide")
income17 <- get_acs(geography = "place",
                          state = "IA",
                          variable = c("income18"="B19013_001"),
                          year = 2017,
                          output = "wide")
# join 2021, 2020, 2019, 2018, and 2017 data
income <- income %>% 
  left_join(income20,by = c("GEOID","NAME")) %>% 
  left_join(income19,by = c("GEOID","NAME")) %>% 
  left_join(income18,by = c("GEOID","NAME")) %>% 
  left_join(income17,by = c("GEOID","NAME")) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

# figure out how income is changing
# calculate percent income change
income <- income %>%
  mutate(prc_income_change = ((income21E - income17E) / income21E)) %>%
  mutate(income_change_label = ifelse(prc_income_change > 0, "Positive", "Negative"))


