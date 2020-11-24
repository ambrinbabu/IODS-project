human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep  =",", header = T)
dim(human)
str(human)
names(human)
# we can see 195 observations and 19 variables, including the country name, HD index, maternal mortality rate,.... 

# GNI to numeric
library(tidyr)
library(stringr)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()

# columns to keep
library(dplyr)
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- dplyr::select(human, one_of(keep))
complete.cases(human)

# Removing rows with missing values (NA)
comp <- complete.cases(human)
human_new<- filter(human, comp == TRUE)

# Remove observations relating to regions (the last 7 rows)

last <- nrow(human_new) - 7
human_new <- human_new[1:last, ]

# Countries as row names
rownames(human_new) <- human_new$Country
human_new <- dplyr::select(human_new, -Country)


dim(human_new)


# new table sheet
write.csv(human_new,file="~/IODS-project/data/human_new.csv")
