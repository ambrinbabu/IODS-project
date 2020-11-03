#Ambrin Farizah Babu
#3.11.2020
#Data wrangling

library(dplyr)

#Read data into memory
x <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",sep="\t", header=TRUE )
x

#dimensions of data
dim(x)
#dimensions: 183rows, 60columns

#structure of data
str(x)
#structure: dataframe with 180observations of 60 variables

# wrangling the data into a format that is easy to analyze

# questions related to deep, surface and strategic learning
deep <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(x, one_of(deep))
x$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(x, one_of(surf))
x$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(x, one_of(stra))
x$stra <- rowMeans(strategic_columns)


##Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")


# select the 'keep_columns' to create a new dataset
learning2014 <- select(x, one_of(keep_columns))

#Exclude observations where the exam points variable is zero.
# select rows where points is greater than zero
learning2014 <- filter(learning2014, Points > "0")

# see the stucture of the new dataset
str(learning2014)

setwd("C:/Users/Ambrin/Documents/IODS-project")

write.csv(learning2014, file = "Data/learning2014.csv")

# Demonstrate that you can also read the data again
p= read.csv("Data/learning2014.csv")
p

#make sure that the structure of the data is correct
str(p)
head(p)
