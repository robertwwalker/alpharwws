rm(list=ls())
library(rvest); library(htmltools); library(tidyverse); library(rlang); library(here); library(stringr)
load(paste0(here(),"/content/R/COVID/data/OregonCOVID",Sys.Date()-2,".RData")) # 1
# A function to remove commas from numbers.
comma.rm.to.numeric <- function(variable) {
  as.numeric(str_remove_all( {{variable}}, ",")) 
}
dash.rm.to.numeric <- function(variable) {
  as.numeric(str_remove_all( {{variable}}, "-")) 
}
# A function to parse the tables currently
OHA.Corona <- function(website, date) {
  webpage <- read_html(website) # 1
  COVID.Head <- webpage %>%
    html_nodes("table") %>% # 2
    .[1] %>%  # Grab the first table
    html_table(fill = TRUE) %>%  # 3
    data.frame()  # 4 
  # Acquire the scraped date from the heading on the page.  The rest is 5
  Scraped.date <- names(COVID.Head)[1] %>% 
    str_remove(.,"X.Data.current.as.of.") %>% 
    str_remove(., "..12.01.a.m..Updated.Monday...Friday..")
  names(COVID.Head) <- c("Category","Outcome") # Change the names
  COVID.Head <- COVID.Head %>% 
    mutate(Outcome = str_replace(Outcome, "Pending*", "NA")) %>%
    mutate(Outcome = parse_number(Outcome), 
           date=as.Date(date), 
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y")) # Create a few variables including the date for checking
  COVID.Head$Category[COVID.Head$Category=="Total tested"] <- "Total persons tested"
  COVID.Head$Category[COVID.Head$Category=="Positive tests"] <- "Positive"
  COVID.Head$Category[COVID.Head$Category=="Negative tests"] <- "Negative"
  # Extract the county data
  COVID.County <- webpage %>%
    html_nodes("table") %>% # 2
    .[2] %>%
    html_table(fill = TRUE) %>% # 3 
    data.frame() %>%  # 4
#    mutate(Negative = as.integer(str_replace(Negative, "Pending*", "NA"))) %>%
    mutate(date=as.Date(date), # 5
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y"), 
           Negatives3 = comma.rm.to.numeric(Negatives3),
           Negative.test.results = Negatives3,
           Deaths = Deaths2,
           Number.of.cases = Cases1)
  # Extract the age data
  COVID.Age <- webpage %>%
    html_nodes("table") %>% #2
    .[3] %>%
    html_table(fill = TRUE) %>% # 3 
    data.frame()  %>%   # 4
    mutate(Cases = dash.rm.to.numeric(Cases1)) %>%
    mutate(date=as.Date(date), 
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y"), 
           Hospitalized = dash.rm.to.numeric(Ever.hospitalized4), 
           Deaths = dash.rm.to.numeric(Deaths2),
           Number.of.cases = Cases) %>% 
    select(-c(Ever.hospitalized4,Deaths2,Cases1)) # 5
  # Extract the age data
  COVID.Gender <- webpage %>%
    html_nodes("table") %>% #2
    .[4] %>%
    html_table(fill = TRUE) %>% # 3 
    data.frame()  %>%   # 4
    mutate(date=as.Date(date), 
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y"), 
           Deaths = dash.rm.to.numeric(Deaths2),
           Cases = Cases1) %>% 
    select(-Deaths2) # 5
  # Extract the hospitalization data
  COVID.Hospitalized <- webpage %>%
    html_nodes("table") %>% # 2
    .[5] %>%
    html_table(fill = TRUE) %>% # 3
    data.frame()  %>%  # 4
    mutate(Hospitalized = Hospitalized4,
           date=as.Date(date), 
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y"),
           Number.of.cases = Cases1) # 5
  # Extract the hospital capacity data
  COVID.Hospital.Cap <- webpage %>%
    html_nodes("table") %>% # 2
    .[6] %>%
    html_table(fill = TRUE) %>% # 3
    data.frame()  %>%  # 4
    mutate(date=as.Date(date), 
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y"),
           Available = comma.rm.to.numeric(na_if(Available, "pending")),
           Total = comma.rm.to.numeric(na_if(Total.staffed, "pending"))) %>% 
           pivot_longer(c(Available, Total), names_to = "Type", values_to = "Number") %>% 
    mutate(Hospital.Capacity = Hospital.capacity.and.usage5) %>% select(-Hospital.capacity.and.usage5) # 5
  # Extract the COVID data
  COVID.Strain <- webpage %>%
    html_nodes("table") %>% # 2
    .[7] %>%
    html_table(fill = TRUE) %>% # 3
    data.frame() %>% filter(row_number() < 4) %>% 
    mutate(COVID.19.Details = COVID.19.details5,
           date=as.Date(date),  
           Scraped.date = as.Date(Scraped.date,"%m.%d.%y"),
           COVID19.Patients = Patients.with.suspected.or.confirmed.COVID.19, 
           COVID19.Positives = Only.patients.with.confirmed.COVID.19) %>% 
    select(COVID.19.Details,date,Scraped.date,COVID19.Patients,COVID19.Positives) %>% 
    mutate(COVID.19.Details = str_replace(COVID.19.Details, "Current hospitalized patients", "COVID-19 admissions")) %>%
    mutate(COVID.19.Details = str_replace(COVID.19.Details, "Current patients", "COVID-19 patients"))
  return(list(Header=COVID.Head, Counties = COVID.County, Gender = COVID.Gender, Ages = COVID.Age, Hospitalized = COVID.Hospitalized, Hospital.Cap=COVID.Hospital.Cap, COVID.Strain = COVID.Strain))
}
Today <- OHA.Corona(website="https://web.archive.org/web/20200723160651/https://govstatus.egov.com/OR-OHA-COVID-19", date=as.character(Sys.Date()-1)) # 2
if(max(Oregon.COVID$Scraped.date) < as.Date(Today$Header$Scraped.date[[1]],"%m.%d.%y")) { # 3
  # Store Today
  eval(parse_expr(paste(months(Sys.Date()),format(Sys.Date()-1, "%d")," <- Today", sep=""))) # 4
  # Create test data
  Oregon.Tests.All <- bind_rows(Today$Header,Oregon.Tests.All) %>% distinct(.) # 5
  # Drop the row of totals and other things.
  Oregon.Tests <- Oregon.Tests.All[!str_detect(Oregon.Tests.All$Category, "Total"),]  # 6
  # Create a summary table
  OR.Testing <- Oregon.Tests %>% group_by(date) %>% summarise(Total = sum(Outcome)) # 6
  # Create county data
  Oregon.COVID.All <- bind_rows(Today$Counties,Oregon.COVID.All) %>% distinct(.) # 5
  Oregon.COVID.All <- Oregon.COVID.All %>% mutate(Positive = Positive.)
  # Split the county data into one that is exclusively totals and one without the totals
  Oregon.COVID.Total <- Oregon.COVID.All %>% filter(County=="Total") # 6
  Oregon.COVID <- Oregon.COVID.All %>% filter(County!="Total")  # 6
  # Create the data by age
  OR.Ages <- bind_rows(Today$Ages,OR.Ages)  %>% filter(Age.group!="Total") %>% distinct(.) # 5
  # Create a summary table by age
  OR.AgeT <- OR.Ages %>% group_by(date) %>% summarise(Total=sum(Number.of.cases)) # 6
  # Create the hospitalization data
  OR.Hosp <- bind_rows(Today$Hospitalized,OR.Hosp) %>% distinct(.) # 5
  # Create the gender data
#  OR.Gender <- Today$Gender
  OR.Gender <- bind_rows(Today$Gender, OR.Gender) %>% distinct(.) # 5
# Create the hospital capacity data
#  OR.Hospital.Caps <- Today$Hospital.Cap
  OR.Hospital.Caps <- bind_rows(Today$Hospital.Cap, OR.Hospital.Caps) %>% distinct(.) # 5 
# Integrate the COVID Strain on Hospitals
#  OR.COVID.Strain$COVID19.Patients <- as.numeric(OR.COVID.Strain$COVID19.Patients)
#  OR.COVID.Strain$COVID19.Positives <- as.numeric(OR.COVID.Strain$COVID19.Positives)
#  OR.COVID.Strain <- OR.COVID.Strain %>% mutate(date = as.Date(as.character(date), format = "%Y-%m-%d"), Scraped.date = as.Date(as.character(Scraped.date), format = "%Y-%m-%d"))
  OR.COVID.Strain <- bind_rows(Today$COVID.Strain, OR.COVID.Strain) %>% distinct(.) # 5 
# Save the imageformat(Sys.Date(), "%d")
  rm(OHA.Corona)
  save.image(paste0(here(),"/content/R/COVID/data/OregonCOVID",Sys.Date()-1,".RData")) # Save the data with a date flag in the name.
#  save.image(paste0("content/R/COVID/data/OregonCOVID",Sys.Date(),".RData")) # Save the data with a date flag in the name.
  cat(paste0("Added new data... \n",Sys.time())) # Report the updates
} else {
  cat(paste0("Nothing new to add; have a nice day! \n",Sys.time())) # Report no updates.
}
paste0(Sys.time()) # Show when we were updated.
