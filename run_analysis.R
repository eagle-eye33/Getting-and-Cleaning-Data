## To create one R script called run_analysis.R that does the following. 
## 1.) Merges the training and the test sets to create one data set.
## 2.) Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.) Uses descriptive activity names to name the activities in the data set
## 4.) Appropriately labels the data set with descriptive variable names. 
## 5.) From the data set in step 4, creates a second, independent tidy data set with the average 
##     of each variable for each activity and each subject.

## Loading the required packages data.table & dplyr library
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

require("data.table")
require("dplyr")

# Preliminary: manual steps: 
# Data for this project is in a zip file, so download contents
# from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Then, extracted the file to folder "UCI HAR Dataset" in the working directory

# Loading features name
features_name <- read.table("./UCI HAR Dataset/features.txt")

# Loading activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

# Loading training data.
subject_train  <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
features_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Loading test data.
subject_test  <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
features_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

## 1.) Merges the training and the test sets to create one data set.
subject  <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
features <- rbind(features_train, features_test)

# Naming the columns & Merge the data
colnames(features) <- t(features_name[2])
colnames(activity) <- "Activity"
colnames(subject)  <- "Subject"
complete_data <- cbind(features,activity,subject)

## 2.) Extracts only the measurements on the mean and standard deviation for each measurement. 
col_mean_std <- grep(".*Mean.*|.*Std.*", names(tidy_dataset), ignore.case=TRUE)
required_col <- c(col_mean_std, 562, 563)
extracted_data <- complete_data[,required_col]

## 3.) Uses descriptive activity names to name the activities in the data set
## Changing type from numeric to character type in order to accept activity names
extracted_data$Activity <- as.character(extracted_data$Activity)
for (i in 1:6){
  extracted_data$Activity[extracted_data$Activity == i] <- as.character(activity_labels[i,2])
}
extracted_data$Activity <- as.factor(extracted_data$Activity)

## 4.) Appropriately labels the data set with descriptive variable names. 
names(extracted_data)<-gsub("Acc", "Accelerometer", names(extracted_data))
names(extracted_data)<-gsub("Gyro", "Gyroscope", names(extracted_data))
names(extracted_data)<-gsub("BodyBody", "Body", names(extracted_data))
names(extracted_data)<-gsub("Mag", "Magnitude", names(extracted_data))
names(extracted_data)<-gsub("^t", "Time", names(extracted_data))
names(extracted_data)<-gsub("^f", "Frequency", names(extracted_data))
names(extracted_data)<-gsub("tBody", "TimeBody", names(extracted_data))
names(extracted_data)<-gsub("-mean()", "Mean", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("-std()", "STD", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("-freq()", "Frequency", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("angle", "Angle", names(extracted_data))
names(extracted_data)<-gsub("gravity", "Gravity", names(extracted_data))

#extracted_data$Subject <- as.factor(extracted_data$Subject)
extracted_data <- data.table(extracted_data)

## 5.) From the data set in step 4, creates a second, independent tidy data set with the average 
##     of each variable for each activity and each subject.
tidy_data <- aggregate(. ~Subject + Activity, extracted_data, mean)
tidy_data <- tidy_data[order(tidy_data$Subject,tidy_data$Activity),]
write.table(tidy_data, file = "./tidy.txt", row.names = FALSE)
