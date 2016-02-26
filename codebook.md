#Getting and Cleaning Data Course Project
========================================
##This file describes how run_analysis.R script works.
  
1. Download the data from the [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Merge "Y_train.txt" and "Y_test.txt" as dataActivity to hold both traning and test values from 
   sensor signals (accelerometer or gyroscope).
3. Merge the subject name values as dataSubject using "subject_train.txt" and subject_test.txt"
4. Merge the features values from "X_train.txt" and "X_test.txt" as dataFeatures.
5. Get the names of Varibles from "features.txt" to dataFeauturesNames.
6. Finally when we combine the dataActivity,dataSubject and dataFeatures to get a clean data.
7. Subset only the measurements of mean and standard deviation columns by selecting names coloumn 
   of dataFeauturesNames from data.This data will be called as sub_Data.
8. Get the name values from "activity_labels.txt" and apply them as names for the column  
   activity of sub_Data.
9. Correct the descriptive names for the sub_Data rather than short notes.(ie, t- time,f- 
   frequency and like vice).
10. Write a tidy_data set from above sub set data with the average of each variable for each  
    activity and each subject.