## Install and load needed packages

##install.packages("bibliometrix", dependencies=TRUE)
##install.packages("tidyverse")
##install.packages("splitstackshape")

library(tidyverse)
library(bibliometrix)
library(splitstackshape)

## Read in data files downloaded from Web of Science
filepathWCHRI <- dir("./data", pattern = "*.bib", recursive = TRUE, full.names = TRUE)
D <- do.call("readFiles", as.list(filepathWCHRI))
docs <- convert2df(D, dbsource = "wos", format = "bibtex")
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

write.csv()