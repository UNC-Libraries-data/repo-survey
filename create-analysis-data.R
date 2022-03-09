library(tidyverse)
library(readxl)
setwd("C:\\Users\\mhayslet\\OneDrive - University of North Carolina at Chapel Hill\\articles\\2021-Recruiting Data Deposits into Repositories\\Data Analysis\\R-files\\Data")
raw <- read_excel("InitialData-standzd-n-unformatted-deided.xlsx",sheet="InitialData-standardized")

analysis_data <- raw %>%
  filter(`Does your repository accept deposits of data?`=="Yes") %>% 
  rename(Depositors='From how many unique depositors did your repository ingest data in the most recent full fiscal year of your repository being open?',
    Staff=`Please note the total staff time devoted to your repository in full-time equivalent (FTE) units.  Please include full time and part time staff, curators, developers, students/interns (everyone!), rounding your estimate to one decimal point.`,
         `Data Staff`=`Please note the staff time devoted to data deposits in your repository in full-time equivalent (FTE) units.  Please include full time and part time staff, curators, developers, students/interns (everyone!), rounding your estimate to one decimal point.`,
    SocialMedia=`Over the last year, how has your repository been promoted to potential depositors? Select all tha... - Please note if your repository has used these methods in the last twelve months. - Social media`,
    ReccDataDep=`Which of the following does your larger organization or institution require or recommend (if either)? - Deposit of data in a repository`,
    FacRefs=`Please indicate any of the following from which you know the repository has received referrals in the last twelve months. - Selected Choice`,
    Encryption=`IctvEncryp`,
    ELNlinked=`Is your ingest process integrated with electronic lab notebooks (ELNs) or other scholarly workflow apps?`
         ) %>% 
  rowwise() %>% 
  mutate(`AdvancedDC/Inctvs`=max(IctvIDC,Encryption,IctvPIDID)) %>% 
  ungroup() %>% 
  mutate(`Age in Yrs`=2019-`Please enter the year your repository began accepting data deposits.  (If you don't know precisely when, please estimate a year.)`,
         `AdvancedDC/Inctvs`=ifelse(!is.na(`Please note any features/services your repository has offered in the last twelve months that might encourage data deposits (whether or not you have evidence of their actual effect): - Other (Please specify) - Text`)&`Please note any features/services your repository has offered in the last twelve months that might encourage data deposits (whether or not you have evidence of their actual effect): - Other (Please specify) - Text`=="Support with metadata development, particularly for batch items which require export of technical metadata",1,`AdvancedDC/Inctvs`),
         `Data Staff`=ifelse(`Does your repository accept only data (as opposed to publications)? - Selected Choice`=="Yes",Staff,`Data Staff`)) %>%
  select(`#`,Depositors,Staff,`Data Staff`,SocialMedia,`AdvancedDC/Inctvs`,`ELNlinked`,Encryption,`Age in Yrs`)
write_csv(analysis_data,"analysis-data.csv")
