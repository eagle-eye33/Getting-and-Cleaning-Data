# Getting-and-Cleaning-Data
Getting and Cleaning Data Course Project
##Getting and Cleaning Data

This README.md explains how all of the scripts work and how they are connected. 

##Course Project

You should create one R script called run_analysis.R that does the following.
1.) Merges the training and the test sets to create one data set.
2.) Extracts only the measurements on the mean and standard deviation for each measurement.
3.) Uses descriptive activity names to name the activities in the data set
4.) Appropriately labels the data set with descriptive activity names.
5.) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Required Scripts

The Data Set has been stored in UCI HAR Dataset of the working directory.
The CodeBook.md describes the variables, the data, and the work that has been performed to clean up the data.
The run_analysis.R is the script that has been used for this work. It can be loaded in Rstudio and executed without any parameters.
The result of the execution is that a tidy.txt file is being created, that stores the tranformation result.


##Steps to work on this course project

Preliminary manual steps: 
1) Data for this project is in a zip file, so download contents from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   Then, extracted the file to folder "UCI HAR Dataset" in the working directory. 

2) Copy run_analysis.R in the parent folder of UCI HAR Dataset, then set it as your working directory using setwd() function in RStudio.
   For eg. setwd("C:/Users/KTHTAG/Desktop/Big Data MOOC")

3) In Rstudio, execute source("run_analysis.R"), then it will generate a new file as per required on Step 5 named tiny.txt in your working directory.

##Dependencies

run_analysis.R use data.table and dplyr packages. It will help you to install the dependencies automatically if not already installed.
