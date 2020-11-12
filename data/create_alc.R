#Ambrin Farizah Babu
#6.11.2020
#Data wrangling: Student Performance Data (incl. Alcohol consumption) - Exercise 3

library(dplyr)
library(ggplot2)


#set working directory to data folder
setwd("C:/Users/Ambrin/Documents/IODS-project/data")

#read student-mat.csv. 
mat <- read.csv("student-mat.csv", sep= ";", header=TRUE)

por <- read.csv("student-por.csv", sep=";", header=TRUE)

#explore the structure and dimensions of student-mat.csv
str(mat)
#student-mat.csv is a dataframe with 395 observation of 33 variable. It contains math class questionaire data
dim(mat)
#dimension: 395 rows, 33 column

#explore the structure and dimensions of student-por.csv
str(por)
#dataframe with 649observation of 33 variable. It has portugese class data
dim(por)
#dimensions= 649 rows, 33 column

# Define own id for both datasets

por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- mat %>% mutate(id=2000+row_number())

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

# Save created data to folder 'data' as an Excel worksheet
library(openxlsx)

write.xlsx(pormath,file="~/IODS-project/data/pormath.xlsx")

#check dimensions
dim(pormath)
#370 rows, 51 columns
