library(dplyr)
library(tidyr)

## downloading dataset

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip", mode = "wb")
unzip("dataset.zip")


## Merging the training and the test sets to create one data set.
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

f_name <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
a_label <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

## 1. Merging data
names <- c("subject_id", f_name$V2, "activity_id")
merge_train <- cbind(s_train, x_train, y_train)
merge_test <- cbind(s_test, x_test, y_test)
mergedata <- rbind(merge_train, merge_test)
str(mergeddata)

## 3. Descriptive names
colnames(mergedata) <- names
colnames(a_label) <- c("activity_id", "activity_name")
str(mergedata)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
f_mean_std <- mergedata[, grepl("subject_id|activity_id|mean|std", names)]

## 4. Uses descriptive activity names to name the activities in the data set
fnamed_act <- merge(f_mean_std, a_label, by = "activity_id")
fnamed_act$"activity_id" = NULL

## 5. From the data set in step 4, creates a second, independent 
## tidy data set with the average of each variable for each activity 
## and each subject.
tidyData <- aggregate(. ~ subject_id + activity_name, fnamed_act, FUN = mean)
tidyData <- arrange(tidyData, subject_id, activity_name)
write.table(tidyData, "tidyData", row.names = FALSE)