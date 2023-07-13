# NOTES 7/9 10:13 AM
# finish manipulating the data (eg. changing to percentages) for tax data base and wac and rac
# save all data frames as csv files to put into Tableau



library(tidyverse)
library(tidycensus)


## starting with POPULATION data for all places in Iowa ##
##########################################################

# Define the variables before getting the data.
# The Census API code for total population for 2000 and 2010 is P001001.
pop00 <- c("pop" = "P001001")
pop10 <- c("pop" = "P001001")
# The API code for total population changed for 2020.
# The Census API code for total population is P1_001N for 2020. 
pop20 <- c("pop" = "P1_001N")

##
# Getting 2000 total population data for the USA.
pop00 <- get_decennial(geography = "place",
                       state = "IA",
                          year = 2000,
                          variable = pop00,
                          output = "wide") %>% 
  mutate(year = 2000)
# Getting 2010 total population data for the USA.
pop10 <- get_decennial(geography = "place",
                          state = "IA",
                          year = 2010,
                          variable = pop10,
                          output = "wide") %>% 
  mutate(year = 2010)
# Getting 2020 total population data for the USA.
pop20 <- get_decennial(geography = "place",
                          state = "IA",
                          year = 2020,
                          variable = pop20,
                          output = "wide") %>% 
  mutate(year = 2020)
# Bind the years together using bind_rows to create data frame for national context. 
pop <- pop20 %>% 
  bind_rows(pop10,pop00) 


# Create anew column called prc_change.
# Group by "NAME" so that the calculations occur individually for each place. 
# Percent change is calculated by subtracting year2 from year1 and dividing by year2. 
pop <- pop %>%
  group_by(NAME) %>%
  mutate(prc_change = ifelse(year == 2020, (pop - lead(pop)) / lead(pop),
                             ifelse(year == 2010, (pop - last(pop)) / last(pop), NA)))

# figure out if the places are growing, shrinking, or stable
# stable = between -2 and 2
# increasing > 2
# decreasing < -2
pop <- pop %>%
  mutate(change_label = ifelse(prc_change > .02, "Growing",
                             ifelse(prc_change < -.02, "Shrinking", "Stable"))) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

#rename the variables
pop <- pop %>% 
  rename(Population = pop) %>% 
  rename(Year = year) %>% 
  rename("Percent Change" = prc_change) %>% 
  rename(label = change_label)


pop %>% write.csv(file = "population_data.csv")

## age of residents ##
######################

# adding to pop 

# Create an object called "years" that lists the years you want to pull data from. 
# We want all of the years the ACS data is available. 
years <- 2009:2021
names(years) <- years

# get the median age of all people in all places in Iowa from ACS
median_age <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variables = c("median_age" = "B01002_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

# rename variables
median_age <- median_age %>% 
  rename(Year = year) %>% 
  rename("Median Age Estimate" = median_ageE) %>% 
  rename(moe = median_ageM)


# get the number of people under 18 and over 65
# API Codes seperated by gender, so have to pull twice
# starting with Male
male <- map_dfr(years, ~{
  get_acs(
    geography = "place",
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
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))
# now for Female
female <- map_dfr(years, ~{
  get_acs(
    geography = "place",
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
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))

# create new columns for under18 and over 65 for both male and female
# create a new column for gender
male <- male %>% 
  mutate(under18E = round(under5E + a5to9E + a10to14E + a15to17E)) %>%
  mutate(under18M = round(sqrt(under5M^2 + a5to9M^2 + a10to14M^2 + a15to17M^2))) %>%
  mutate(over65E = round(a65to66E + a67to69E + a70to74E + a75to79E + a80to84E + over85E)) %>%
  mutate(over65M =  round(sqrt(a65to66M^2 + a67to69M^2 + a70to74M^2 + a75to79M^2 + a80to84M^2 + over85M^2))) %>% 
  mutate(gender = "Male")

female <- female %>% 
  mutate(under18E = round(under5E + a5to9E + a10to14E + a15to17E)) %>%
  mutate(under18M = round(sqrt(under5M^2 + a5to9M^2 + a10to14M^2 + a15to17M^2))) %>%
  mutate(over65E = round(a65to66E + a67to69E + a70to74E + a75to79E + a80to84E + over85E)) %>%
  mutate(over65M =  round(sqrt(a65to66M^2 + a67to69M^2 + a70to74M^2 + a75to79M^2 + a80to84M^2 + over85M^2))) %>% 
  mutate(gender = "Female")


# combine the data frames
age <- female %>% 
  bind_rows(male)

# aggregate by city NAME, year, GEOID and gender
# create new columns for percent under 18 and percent over 65
aggregated_age <- age %>% 
  group_by(year,GEOID, NAME, gender) %>% 
             summarize(prc_under18E = sum(under18E)/sum(totalE),
                       prc_under18M = sqrt(sum(under18M^2) / sum(totalE)^2 + (sum(under18E)^2 * sum(totalM^2)) / sum(totalE)^4),
                       prc_over65E = sum(over65E)/sum(totalE),
                       prc_over65M = sqrt(sum(over65M^2) / sum(totalE)^2 + (sum(over65E)^2 * sum(totalM^2)) / sum(totalE)^4))

# add a column that states whether a place is "aged", "stable" or "young"
# using a 2% difference to gauge a stable population
aggregated_age <- aggregated_age %>%
  mutate(age_label = ifelse(prc_under18E - prc_over65E > .02, "Young",
                               ifelse(prc_under18E - prc_over65E < -.02, "Aging", "Stable")))

# left_join aggregated_age to age
age <- age %>% 
  left_join(aggregated_age, by = c("year","GEOID","NAME","gender"))

# rename variables
age <- age %>% 
  rename("Under 5" = under5E) %>% 
  rename("5 to 9" = a5to9E) %>% 
  rename("10 to 14" = a10to14E) %>% 
  rename("15 to 17" = a15to17E) %>% 
  rename("65 to 66" = a65to66E) %>% 
  rename("67 to 69" = a67to69E) %>% 
  rename("70 to 74" = a70to74E) %>% 
  rename("75 to 79" = a75to79E) %>% 
  rename("80 to 84" = a80to84E) %>% 
  rename("Over 85" = over85E) %>% 
  rename("Total Population Under 18" = under18E) %>% 
  rename("Total Population Over 65" = over65E) %>% 
  rename("Percent Population Under 18" = prc_under18E) %>% 
  rename("Percent Population Over 65" = prc_over65E) %>% 
  rename(Label = age_label) %>% 
  rename("Under 5 moe" = under5M) %>% 
  rename("5 to 9 moe" = a5to9M) %>% 
  rename("10 to 14 moe" = a10to14M) %>% 
  rename("15 to 17 moe" = a15to17M) %>% 
  rename("65 to 66 moe" = a65to66M) %>% 
  rename("67 to 69 moe" = a67to69M) %>% 
  rename("70 to 74 moe" = a70to74M) %>% 
  rename("75 to 79 moe" = a75to79M) %>% 
  rename("80 to 84 moe" = a80to84M) %>% 
  rename("Over 85 moe" = over85M) %>% 
  rename("Total Population Under 18 moe" = under18M) %>% 
  rename("Total Population Over 65 moe" = over65M) %>% 
  rename("Percent Population Under 18 moe" = prc_under18M) %>% 
  rename("Percent Population Over 65 moe" = prc_over65M)

# create a .csv file for age data and median age data
age %>% write.csv(file = "age_data.csv")
median_age %>% write.csv(file = "median_age_data.csv")


## next is housing information ##
#################################

# getting from 2021 5-Year ACS

# total housing units = B25001_001
# owner occupied units = B25003_002
# total occupied units = B25002_002
# total vacant units = B25002_003
# median house value = B25077_001 
# median house age = B25035_001

housing <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variable = c("total_units" = "B25001_001",
                 "occupied_units" = "B25002_002",
                 "vacant_units" = "B25002_003",
                 "owner_occupied" = "B25003_002",
                 "renter_occupied" = "B25003_003",
                 "median_house_value" = "B25077_001",
                 "median_year_built" = "B25035_001"),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))


## ALL RATES ARE PERCENTAGES
# calculate home ownership, vacany, and rental rates
housing <- housing %>% 
  mutate("Home Ownership Rate Estimate" = (owner_occupiedE / occupied_unitsE)) %>%  # divide owner occupied by occupied units
  mutate("Home Ownership Rate moe" = (sqrt((owner_occupiedM^2) / (occupied_unitsE^2) + ((owner_occupiedE * occupied_unitsM)^2) / (occupied_unitsE^4)))) %>%  # calculate new moe
  mutate("Rental Rate Estimate" = (renter_occupiedE / occupied_unitsE)) %>%  # divide renter occupied by occupied units
  mutate("Rental Rate moe" = (sqrt((renter_occupiedM^2) / (occupied_unitsE^2) + ((renter_occupiedE * occupied_unitsM)^2) / (occupied_unitsE^4)))) %>% # calculate new moe
  mutate("Vacancy Rate Estimate" = (vacant_unitsE / total_unitsE)) %>%  # divide vacant units by total units
  mutate("Vacancy Rate moe" = (sqrt((vacant_unitsM^2) / (total_unitsE^2) + ((vacant_unitsE * total_unitsM)^2) / (total_unitsE^4)))) %>% 
  mutate("Occupancy Rate Estimate" = (occupied_unitsE / total_unitsE)) %>% 
  mutate("Occupancy Rate moe" = (sqrt(occupied_unitsM^2) / (total_unitsE^2) + ((occupied_unitsE * total_unitsM^2) / total_unitsE^4)))# calculate new moe

# rename variables
housing <- housing %>% 
  rename("Total Housing Units" = total_unitsE) %>% 
  rename("Occupied Units" = occupied_unitsE) %>% 
  rename("Owner Occupied Units" = owner_occupiedE) %>% 
  rename("Renter Occupied Units" = renter_occupiedE) %>% 
  rename("Median House Value" = median_house_valueE) %>% 
  rename("Median Year Built" = median_year_builtE) %>% 
  rename("Total Housing Units moe" = total_unitsM) %>% 
  rename("Occupied Units moe" = occupied_unitsM) %>% 
  rename("Owner Occupied Units moe" = owner_occupiedM) %>% 
  rename("Renter Occupied Units moe" = renter_occupiedM) %>% 
  rename("Median House Value moe" = median_house_valueM) %>% 
  rename("Median Year Built moe" = median_year_builtM)

# create a .csv file with housing data
housing %>% write.csv(file = "housing_data.csv")


## next is Taxable Property Values from Liesl ##
################################################

#link to data: https://data.iowa.gov/Local-Government-Finance/Taxable-Property-Values-in-Iowa-by-Tax-District-an/ig9g-pba5

taxable.csv <- read.csv("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/demographics/demographic analysis/Datasets/Taxable_Property_Values_in_Iowa_by_Tax_District_and_Year.csv")
# City name is stored in City.Name as all caps
# for census data, only the first letter is capitalized and city, Iowa is attached
# need to lowercase taxable_prop_values and remove city, Iowa from housing and pop

taxable.csv <- taxable.csv %>% 
  mutate(City.Name = str_to_sentence(City.Name)) %>% 
  rename(NAME = City.Name) #str_to_sentence() uses regular sentence formatting where the first letter is capitalized
                              # could have also used str_to_titletext()

# aggregated the column based on City.Name
# function = sum to get the sum of all values
# na.rm = TRUE, means the NAs get ignored
aggregated_tax <- taxable.csv %>% 
  group_by(Assessment.Year,NAME) %>% 
  summarize(Residential = sum(Residential),
            Commercial = sum(Commercial),
            Industrial = sum(Industrial),
            Ag.Land = sum(Ag.Land),
            Ag.Building = sum(Ag.Building))
  
# rename variables 
aggregated_tax <- aggregated_tax %>% 
  rename(Year = Assessment.Year)

##########################################################################################################

aggregated_tax
# holds summed values for each type of property for a city
# needs further transforming for analysis
# could change aggregation to find the median value for each property type
# could be valuable to gather data for all years available.

##########################################################################################################



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
# remove all empty rows
geography2 <- geography2 %>% 
  filter(NAME != "")%>% 
  mutate(year = 2023)

# use geography2 to assign city NAME to ia_rac.csv
rac_data <- ia_rac.csv %>% 
  left_join(geography2, by = c("geocode"))

# aggregate by city name
# have to remove h_geocode and GEOID so they don't aggregate
rac_data <- aggregate(. ~ NAME, data = rac_data, FUN = sum, na.rm = TRUE) %>% 
  select(-c("geocode","GEOID","year","createdate")) %>% 
  mutate(year = 2023)


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
  filter(NAME != "")
# aggregate by city name
wac_data <- aggregate(. ~ NAME, data = wac_data[, !(names(wac_data) %in% c("geocode", "GEOID","createdate"))], FUN = sum, na.rm = TRUE) %>% 
  mutate(year = 2023)


# rename variables
rac_data <- rac_data %>% 
  rename("Total Number of Jobs" = C000) %>% 
  rename("Number of Jobs in NAICS sector 11 (Agriculture, Forestry, Fishing and Hunting)" = CNS01) %>% 
  rename("Number of Jobs in NAICS sector 21 (Mining, Quarrying, and Oil and Gas Extraction)" = CNS02) %>% 
  rename("Number of Jobs in NAICS sector 22 (Utilities)" = CNS03) %>% 
  rename("Number of Jobs in NAICS sector 23 (Construction)" = CNS04) %>% 
  rename("Number of Jobs in NAICS sector 32-33 (Manufacturing)" = CNS05) %>% 
  rename("Number of Jobs in NAICS sector 42 (Wholesale Trade)" = CNS06) %>% 
  rename("Number of Jobs in NAICS sector 44-45 (Retail Trade)" = CNS07) %>% 
  rename("Number of Jobs in NAICS sector 48-49 (Transportation and Warehousing)" = CNS08) %>% 
  rename("Number of Jobs in NAICS sector 51 (Information)" = CNS09) %>% 
  rename("Number of Jobs in NAICS sector 52 (Finance)" = CNS10) %>% 
  rename("Number of Jobs in NAICS sector 53 (Reale Estate adn Rental and Leasing)" = CNS11) %>% 
  rename("Number of Jobs in NAICS sector 54 (Professional, Scientific, and Technical Services)" = CNS12) %>% 
  rename("Number of Jobs in NAICS sector 55 (Management of Comapanies and Enterprises)" = CNS13) %>% 
  rename("Number of Jobs in NAICS sector 56 (Administrative and Support and Waste Management and Remediation Services)" = CNS14) %>% 
  rename("Number of Jobs in NAICS sector 61 (Educational Services)" = CNS15) %>% 
  rename("Number of Jobs in NAICS sector 62 (Health Care and Social Assistance)" = CNS16) %>% 
  rename("Number of Jobs in NAICS sector 71 (Arts, Entertainment, and Recreation)" = CNS17) %>% 
  rename("Number of Jobs in NAICS sector 72 (Accomodation and Food Service)" = CNS18) %>% 
  rename("Number of Jobs in NAICS sector 81 (Other Serivces, except Public Administratoin)" = CNS19) %>% 
  rename("Number of Jobs in NAICS sector 92 (Public Administration)" = CNS20)
  
wac_data <- wac_data %>% 
  rename("Total Number of Jobs" = C000) %>% 
  rename("Number of Jobs in NAICS sector 11 (Agriculture, Forestry, Fishing and Hunting)" = CNS01) %>% 
  rename("Number of Jobs in NAICS sector 21 (Mining, Quarrying, and Oil and Gas Extraction)" = CNS02) %>% 
  rename("Number of Jobs in NAICS sector 22 (Utilities)" = CNS03) %>% 
  rename("Number of Jobs in NAICS sector 23 (Construction)" = CNS04) %>% 
  rename("Number of Jobs in NAICS sector 32-33 (Manufacturing)" = CNS05) %>% 
  rename("Number of Jobs in NAICS sector 42 (Wholesale Trade)" = CNS06) %>% 
  rename("Number of Jobs in NAICS sector 44-45 (Retail Trade)" = CNS07) %>% 
  rename("Number of Jobs in NAICS sector 48-49 (Transportation and Warehousing)" = CNS08) %>% 
  rename("Number of Jobs in NAICS sector 51 (Information)" = CNS09) %>% 
  rename("Number of Jobs in NAICS sector 52 (Finance)" = CNS10) %>% 
  rename("Number of Jobs in NAICS sector 53 (Reale Estate adn Rental and Leasing)" = CNS11) %>% 
  rename("Number of Jobs in NAICS sector 54 (Professional, Scientific, and Technical Services)" = CNS12) %>% 
  rename("Number of Jobs in NAICS sector 55 (Management of Comapanies and Enterprises)" = CNS13) %>% 
  rename("Number of Jobs in NAICS sector 56 (Administrative and Support and Waste Management and Remediation Services)" = CNS14) %>% 
  rename("Number of Jobs in NAICS sector 61 (Educational Services)" = CNS15) %>% 
  rename("Number of Jobs in NAICS sector 62 (Health Care and Social Assistance)" = CNS16) %>% 
  rename("Number of Jobs in NAICS sector 71 (Arts, Entertainment, and Recreation)" = CNS17) %>% 
  rename("Number of Jobs in NAICS sector 72 (Accomodation and Food Service)" = CNS18) %>% 
  rename("Number of Jobs in NAICS sector 81 (Other Serivces, except Public Administratoin)" = CNS19) %>% 
  rename("Number of Jobs in NAICS sector 92 (Public Administration)" = CNS20)

  
##########################################################################################################

# wac and rac data need futher transforming for analysis
# should change data into percents to standardize the data and account for different population sizes

# example of transformation below
# used earlier when data was held in data frame differently

# rac c000 = total employed residents
# rac cns01 = total residents employed in ag
# wac c000 = total jobs in city
# wac cns01 = total ag jobs in city
#wac_rac <- wac_rac %>% 
#  rename(total_jobs = C000.x) %>% 
#  rename(workforce_size = C000.y) %>% 
#  rename(workforce_ag = CNS01.y) %>% 
#  rename(ag_jobs = CNS01.x)

## prc_workforce locally employed = wac c000.x / rac c000
## prc_workforce in ag = rac cns01.y / rac c000.y
## prc_jobs in ag = wac cns01.x / wac c000.x
#wac_rac <- wac_rac %>% 
#  mutate(prc_local = total_jobs/workforce_size) %>% 
#  mutate(prc_wrkf_ag = workforce_ag / workforce_size) %>% 
#  mutate(prc_ag_jobs = ag_jobs / total_jobs)

## prc_population in workforce = rac c000.y / pop
# left_joined to iowa data frame
# dividing by pop20 because wac and rac data is from 2020
#iowa <- iowa %>% 
#  mutate(prc_pop_in_wrkf = workforce_size / pop20) %>% 
#  mutate(prc_pop_employed = total_jobs / pop20)

############################################################################################################

# create a new .csv file for both wac and rac data
rac_data %>% write.csv(file = "rac_data.csv")
wac_data %>% write.csv(file = "wac_data.csv")


## Unemployment ##
##################       

# unemployment data is separated by Age and Sex in API Codes
# pull first for male employment
employment_male <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variable = c("Total Labor Force" = "B23001_001",
                 "Total Labor Force, Male" = "B23001_002",
                 "16 to 19" = "B23001_003",
                 "16 to 19, In Armed Forces" = "B23001_005",
                 "16 to 19, Employed" = "B23001_007",
                 "16 to 19, Unemployed" = "B23001_008",
                 "20 to 21" = "B23001_010",
                 "20 to 21, In Armed Forces" = "B23001_012",
                 "20 to 21, Employed" = "B23001_014",
                 "20 to 21, Unemployed" = "B23001_015",
                 "22 to 24" = "B23001_017",
                 "22 to 24, In Armed Forces" = "B23001_019",
                 "22 to 24, Employed" = "B23001_021",
                 "22 to 24, Unemployed" = "B23001_022",
                 "25 to 29" = "B23001_024",
                 "25 to 29, In Armed Forces" = "B23001_026",
                 "25 to 29, Employed" = "B23001_028",
                 "25 to 29, Unemployed" = "B23001_029",
                 "30 to 34" = "B23001_031",
                 "30 to 34, In Armed Forces" = "B23001_033",
                 "30 to 34, Employed" = "B23001_035",
                 "30 to 34, Unemployed" = "B23001_036",
                 "35 to 44" = "B23001_038",
                 "35 to 44, In Armed Forces" = "B23001_040",
                 "35 to 44, Employed" = "B23001_042",
                 "35 to 44, Unemployed" = "B23001_043",
                 "45 to 54" = "B23001_045",
                 "45 to 54, In Armed Forces" = "B23001_047",
                 "45 to 54, Employed" = "B23001_049",
                 "45 to 54, Unemployed" = "B23001_050",
                 "55 to 59" = "B23001_052",
                 "55 to 59, In Armed Forces" = "B23001_054",
                 "55 to 59, Employed" = "B23001_056",
                 "55 to 59, Unemployed" = "B23001_057",
                 "60 to 61" = "B23001_059",
                 "60 to 61, In Armed Forces" = "B23001_061",
                 "60 to 61, Employed" = "B23001_063",
                 "60 to 61, Unemployed" = "B23001_064",
                 "62 to 64" = "B23001_066",
                 "62 to 64, In Armed Forces" = "B23001_068",
                 "62 to 64, Employed" = "B23001_070",
                 "62 to 64, Unemployed" = "B23001_071",
                 "65 to 69" = "B23001_073",
                 "65 to 69, Employed" = "B23001_075",
                 "65 to 69, Unemployed" = "B23001_076",
                 "70 to 74" = "B23001_078",
                 "70 to 74, Employed" = "B23001_080",
                 "70 to 74, Unemployed" = "B23001_081",
                 "75 and Over" = "B23001_083",
                 "75 and Over, Employed" = "B23001_085",
                 "75 and Over, Unemployed" = "B23001_086"
    ),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(gender = "Male")

employment_male <- employment_male %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa| , Iowa"))

# now for female employment
employment_female <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variable = c("Total Labor Force" = "B23001_001",
                 "Total Labor Force, Female" = "B23001_088",
                 "16 to 19" = "B23001_089",
                 "16 to 19, In Armed Forces" = "B23001_091",
                 "16 to 19, Employed" = "B23001_093",
                 "16 to 19, Unemployed" = "B23001_094",
                 "20 to 21" = "B23001_096",
                 "20 to 21, In Armed Forces" = "B23001_098",
                 "20 to 21, Employed" = "B23001_100",
                 "20 to 21, Unemployed" = "B23001_101",
                 "22 to 24" = "B23001_103",
                 "22 to 24, In Armed Forces" = "B23001_105",
                 "22 to 24, Employed" = "B23001_107",
                 "22 to 24, Unemployed" = "B23001_108",
                 "25 to 29" = "B23001_110",
                 "25 to 29, In Armed Forces" = "B23001_112",
                 "25 to 29, Employed" = "B23001_114",
                 "25 to 29, Unemployed" = "B23001_115",
                 "30 to 34" = "B23001_117",
                 "30 to 34, In Armed Forces" = "B23001_119",
                 "30 to 34, Employed" = "B23001_121",
                 "30 to 34, Unemployed" = "B23001_122",
                 "35 to 44" = "B23001_124",
                 "35 to 44, In Armed Forces" = "B23001_126",
                 "35 to 44, Employed" = "B23001_128",
                 "35 to 44, Unemployed" = "B23001_129",
                 "45 to 54" = "B23001_131",
                 "45 to 54, In Armed Forces" = "B23001_133",
                 "45 to 54, Employed" = "B23001_135",
                 "45 to 54, Unemployed" = "B23001_136",
                 "55 to 59" = "B23001_138",
                 "55 to 59, In Armed Forces" = "B23001_140",
                 "55 to 59, Employed" = "B23001_142",
                 "55 to 59, Unemployed" = "B23001_143",
                 "60 to 61" = "B23001_145",
                 "60 to 61, In Armed Forces" = "B23001_147",
                 "60 to 61, Employed" = "B23001_149",
                 "60 to 61, Unemployed" = "B23001_150",
                 "62 to 64" = "B23001_152",
                 "62 to 64, In Armed Forces" = "B23001_154",
                 "62 to 64, Employed" = "B23001_156",
                 "62 to 64, Unemployed" = "B23001_157",
                 "65 to 69" = "B23001_159",
                 "65 to 69, Employed" = "B23001_161",
                 "65 to 69, Unemployed" = "B23001_162",
                 "70 to 74" = "B23001_164",
                 "70 to 74, Employed" = "B23001_166",
                 "70 to 74, Unemployed" = "B23001_167",
                 "75 and Over" = "B23001_169",
                 "75 and Over, Employed" = "B23001_171",
                 "75 and Over, Unemployed" = "B23001_172"
    ),
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(gender = "Female")

employment_female <- employment_female %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa| , Iowa"))

##########################################################################################################

employment_female
employment_male
# need to combine these data frames and do further transformations
# should change to percents to standardize and account for different population sizes

##########################################################################################################



## Commuting ##
###############

# pct population traveling outside of city for work
travel <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variable = c("total" = "B08008_001",
                 "travel" = "B08008_004"), 
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(prc_travel = travelE / totalE,
         travel_moe = (moe_ratio(travelE, totalE, travelM, totalM))) %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))


# rename variables 
travel <- travel %>% 
  rename(Year = year) %>% 
  rename("Total Workforce" = totalE) %>% 
  rename("Workforce Commuting" = travelE) %>% 
  rename("Percent Workforce Commuting" = prc_travel) %>% 
  rename("moe" = travel_moe) %>% 
  rename("Total Workforce moe" = totalM) %>% 
  rename("Workforce Commuting moe" = travelM)

# create a .csv file for travel data
travel %>% write.csv(file = "commuting_data.csv")


## Income ##
############

# median household income = B19013_001

# pct population traveling outside of city for work
income <- map_dfr(years, ~{
  get_acs(
    geography = "place",
    variable = c("median_income"="B19013_001"), 
    state = "IA",
    year = .x,
    survey = "acs5",
    output = "wide"
  )
}, .id = "year") %>% 
  mutate(NAME = str_remove(NAME, " city, Iowa|, Iowa"))


# figure out how income is changing
# calculate percent income change
income <- income %>% 
  group_by(NAME) %>% 
  mutate(prc_change = (median_incomeE - lag(median_incomeE)) / lag(median_incomeE)) %>%
  mutate(income_change_label = ifelse(prc_change > 0, "Positive", "Negative"))

# rename variables 
income <- income %>% 
  rename(Year = year) %>% 
  rename("Median Income" = median_incomeE) %>% 
  rename("Percent Median Income Change" = prc_change) %>% 
  rename(Label = income_change_label) %>% 
  rename("Median Income moe" = median_incomeM) 

# create a .csv file for income data
income %>% write.csv(file = "income_data.csv")
  
