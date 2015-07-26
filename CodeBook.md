#CodeBook for run_analysis.R
This is a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.

##The data source

Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##The data

The dataset includes the following files:

'README.md'

'features_info.txt': Shows information about the variables used on the feature vector.

'features.txt': List of all features.

'activity_labels.txt': Links the class labels with their activity name.

'train/X_train.txt': Training set.

'train/y_train.txt': Training labels.

'test/X_test.txt': Test set.

'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent.

'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.

'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.

'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

##Transformation details

There are 5 main parts:

* 1.) Merges the training and the test sets to create one data set.
* 2.) Extracts only the measurements on the mean and standard deviation for each measurement. 
* 3.) Uses descriptive activity names to name the activities in the data set
* 4.) Appropriately labels the data set with descriptive variable names. 
* 5.) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#Detail steps as below:

##run_analysis.R use data.table and dplyr packages. It will help you to install the dependencies automatically if not already installed.
##Installing the required packages data.table & dplyr library if not already done.

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

require("data.table")
require("dplyr")

##Preparation: Supporting metadata (name of the features and name of the activities) are loaded into variables features_name & activity_labels

features_name <- read.table("./UCI HAR Dataset/features.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

##Read Training data where they are split up into subject, activity and features

subject_train  <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

features_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

##Read Test data where they are split up into subject, activity and features

subject_test  <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

features_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

##Main Action 1.) Merges the training and the test sets to create one data set.
subject  <- rbind(subject_train, subject_test)

activity <- rbind(activity_train, activity_test)

features <- rbind(features_train, features_test)

##Naming the columns & Merge the data

colnames(features) <- t(features_name[2])

colnames(activity) <- "Activity"

colnames(subject)  <- "Subject"

complete_data <- cbind(features,activity,subject)

##Main Action 2.) Extracts only the measurements on the mean and standard deviation for each measurement. 

col_mean_std <- grep(".*Mean.*|.*Std.*", names(tidy_dataset), ignore.case=TRUE)

required_col <- c(col_mean_std, 562, 563)

extracted_data <- complete_data[,required_col]

##Main Action 3.) Uses descriptive activity names to name the activities in the data set

Changing type from numeric to character type in order to accept activity names

extracted_data$Activity <- as.character(extracted_data$Activity)

for (i in 1:6){

  extracted_data$Activity[extracted_data$Activity == i] <- as.character(activity_labels[i,2])
  
}

extracted_data$Activity <- as.factor(extracted_data$Activity)

##Main Action 4.) Appropriately labels the data set with descriptive variable names. 

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

extracted_data$Subject <- as.factor(extracted_data$Subject)

extracted_data <- data.table(extracted_data)

##Main Action 5.) From the data set in step 4, creates a second, independent tidy data set with the average 

of each variable for each activity and each subject.

tidy_data <- aggregate(. ~Subject + Activity, extracted_data, mean)

tidy_data <- tidy_data[order(tidy_data$Subject,tidy_data$Activity),]

write.table(tidy_data, file = "./tidy.txt", row.names = FALSE)
