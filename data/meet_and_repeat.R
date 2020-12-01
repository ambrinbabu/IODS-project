# Load the data sets (BPRS and RATS) into R using as the source the GitHub repository of MABS
#Data source:
#RATS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt
#BPRS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt

rats <- 
  read.table(
    "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
    sep="",header=T)

bprs <- 
  read.table(
    "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
    sep="",header=T)

str(rats)
dim(rats)
str(bprs)
dim(bprs)

summary(rats)
summary(bprs)

#Convert the categorical variables of both data sets to factors
rats$ID <- as.factor(rats$ID)
rats$Group <- as.factor(rats$Group)

bprs$treatment <- as.factor(bprs$treatment)
bprs$subject <- as.factor(bprs$subject)

library(janitor)

rats <- rats %>% clean_names()
bprs <- bprs %>% clean_names()
#Lower case nicer to handle

#Convert from wide to long
#(Weekly observations from variables to repeated observations by individual)

library(tidyverse)

#Pivot_longer is the new function which replaces gather()

rats_l <- 
  rats %>% 
  pivot_longer(
    cols=starts_with("wd"),
    names_to="time",
    names_prefix="wd",
    values_to="weight")

bprs_l <- 
  bprs %>% 
  pivot_longer(
    cols=starts_with("week"),
    names_to="week",
    names_prefix="week",
    values_to="bprs")

summary(rats_l)
summary(bprs_l)
str(rats_l)
str(bprs_l)
dim(rats_l)
dim(bprs_l)

#Factors seem correct, as do the number of rows:
#BPRS data, 2 classvars,9 time points, 20 individual ids in both treatment groups =40 individuals
#RATS data: 11 observations from 16 rats=176 obs of weight

#Save data

library(openxlsx)
setwd("~/IODS-project/data")
write.xlsx(rats_l, "rats.xlsx")
write.xlsx(bprs_l, "bprs.xlsx")

#Wide, or unstacked data is presented with each different data variable in a separate column.
#Narrow, stacked, or long data is presented with one column containing all the values and another column listing the context of the value
