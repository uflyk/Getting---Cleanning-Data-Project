## Getting & Cleanning Data course project

library(dplyr)
# set wd
wd <- getwd()
wd_target <- "/Users/k/R course/Getting and Cleaning data/Project_1221"
if (!wd == wd_target)
    setwd(wd_target)

# dowload files and extract them
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "sensor_data.zip"
if (!file.exists(filename)){
    download.file(fileUrl, filename, method="curl")
}
if(!file.exists("./USI HAR Dataset"))
unzip(zipfile="./sensor_data.zip")

## read data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt",header=FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt",header=FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

## merge training & test
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)
rm(x_train,x_test,y_train,y_test,subject_train,subject_test)

## Extract only measurements on mean and standard deviation for each measurament
# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

x <- x[,mean_and_std_features]

## 
names(x) <- features[mean_and_std_features, 2]

## Uses descriptive activity names to name the activities in the data set

# update values with correct activity names
y[, 1] <- activities[y[, 1], 2]

# correct column name
names(y) <- "activity"

## Appropriately label the data set with descriptive variable names
# correct column name
names(subject) <- "subject"

# bind all the data in a single data set
All <- cbind(x, y, subject)
rm(x,y,subject)
##
# Creat a tidy dataset with subject & activity column and averages of the other values.
tidy <- ddply(All, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy, file = "tidy.txt", row.name=FALSE)