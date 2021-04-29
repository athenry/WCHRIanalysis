## Install and load needed packages

##install.packages("bibliometrix", dependencies=TRUE)
##install.packages("tidyverse")
##install.packages("splitstackshape")

library(tidyverse)
library(bibliometrix)
library(splitstackshape)

## Read in data files downloaded from Web of Science
filepathWCHRI <- dir("./data", pattern = "*.bib", recursive = TRUE, full.names = TRUE)
docs <- convert2df(filepathWCHRI, dbsource = "wos", format = "bibtex")
tidydocs <- cSplit(docs, "AU", sep = ";", direction = "long") %>%
    separate(as.character("AU"), into = c("last_name", "initials"), remove = FALSE, extra = "merge")


## Read in Author names by Themes
authors <- read.csv(file = "./data/WCHRI_Theme_surnames.csv", header = TRUE, col.names = c("CYD", "PPBEB", "WH"))

CYD <- as.character(str_trim(str_to_lower(authors$CYD)))
PPBEB <- as.character(str_trim(str_to_lower(authors$PPBEB)))
WH <- as.character(str_trim(str_to_lower(authors$WH)))

CYD_docs <- filter(tidydocs, as.character(str_trim(str_to_lower(last_name))) %in% CYD)

PPBEB_docs <- filter(tidydocs, as.character(str_trim(str_to_lower(last_name))) %in% PPBEB)

WH_docs <- filter(tidydocs, as.character(str_trim(str_to_lower(last_name))) %in% WH)

write.csv(CYD_docs, file = "CYD.csv", na = "NA")
write.csv(PPBEB_docs, file = "PPBEB.csv", na = "NA")
write.csv(WH_docs, file = "WH.csv", na = "NA")

authorList <- read_csv(file = "./data/WCHRI_Surnames.csv", col_names = c("Surname")) 
authorList$Surname <- as.character(str_trim(str_to_lower(authorList$Surname)))
tidydocs$last_name <- as.character(str_trim(str_to_lower(tidydocs$last_name)))

flaggeddocs<- tidydocs %>% 
     mutate(member=(last_name %in% authorList$Surname)*1)

collaboration <- flaggeddocs %>%
    group_by(UT) %>%
    summarise(n=sum(member))


