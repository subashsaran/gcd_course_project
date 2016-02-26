## 
# Instructions for project
## 
## The purpose of this project is to demonstrate your ability to collect, work 
## with, and clean a data set. The goal is to prepare tidy data that can be used 
## for later analysis. You will be graded by your peers on a series of yes/no 
## questions related to the project. You will be required to submit: 1) a tidy 
## data set as described below, 2) a link to a Github repository with your script 
## for performing the analysis, and 3) a code book that describes the variables, 
## the data, and any transformations or work that you performed to clean up the 
## data called CodeBook.md. You should also include a README.md in the repo with 
## your scripts. This repo explains how all of the scripts work and how they are
## connected.
## 
## One of the most exciting areas in all of data science right now is wearable 
## computing - see for example this article . Companies like Fitbit, Nike, and 
## Jawbone Up are racing to develop the most advanced algorithms to attract new 
## users. The data linked to from the course website represent data collected 
## from the accelerometers from the Samsung Galaxy S smartphone. A full 
## description is available at the site where the data was obtained:
## 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition
##                                                      +Using+Smartphones
## 
## Here are the data for the project:
## 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles
##                                          %2FUCI%20HAR%20Dataset.zip
## 
# You should create one R script called run_analysis.R that does the following.
#   
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for 
#   each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
#   
#  
## Get the Data for the project
if (!dir.exists("./data"))
{
        dir.create("./data")
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp,method = "auto")
        unzip(zipfile = temp,exdir = "./data")
}
#
## Get the list of the files from the source file.
path_rf <- file.path("./data" , "UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)
print(files)
#
## Merges the training and the test sets to create one data set.
##
## Read data from the files into the variables
## 1. Read the Activity files
dataActivityTest  <-
        read.table(file.path(path_rf, "test" , "Y_test.txt"),header=FALSE)
dataActivityTrain <-
        read.table(file.path(path_rf, "train", "Y_train.txt"),header=FALSE)
## 2. Read the Subject files
dataSubjectTrain <-
        read.table(file.path(path_rf, "train","subject_train.txt"),header=FALSE)
dataSubjectTest  <-
        read.table(file.path(path_rf, "test" , "subject_test.txt"),header=FALSE)
## 3. Read Features files
dataFeaturesTest  <-
        read.table(file.path(path_rf, "test" , "X_test.txt"),header=FALSE)
dataFeaturesTrain <-
        read.table(file.path(path_rf, "train", "X_train.txt"),header=FALSE)
#
## Look at the properties of the above varibles
#
str(dataActivityTest)
#
str(dataActivityTrain)
#
str(dataSubjectTrain)
#
str(dataSubjectTest)
#
str(dataFeaturesTest)
#
str(dataFeaturesTrain)
#
## Concatenate the data tables by rows
#
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)
#
## set names to variables
#
names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <-
        read.table(file.path(path_rf, "features.txt"),head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2
#
#
## Merge columns to get the data frame Data for all data
#
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)
#
## Subset Name of Features by measurements on the mean and standard deviation
#
subdataFeaturesNames <-
        dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
#
## Subset the data frame Data by seleted names of Features
selectedNames <-
        c(as.character(subdataFeaturesNames), "subject", "activity")
sub_Data <- subset(Data,select = selectedNames)
#
## Check the structures of the data frame Data
str(sub_Data)
#
## Read descriptive activity names from "activity_labels.txt"
#
activityLabels <-
        read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
#
## factorize the Variale activity of sub_Data
sub_Data$activity <- as.factor(sub_Data$activity)
## changing sub_Data with descriptive activity names rather than numbers
for (i in activityLabels$V1)
{
        levels(sub_Data$activity)[i] = as.character(activityLabels$V2[i])
}
#
head(sub_Data$activity,30)
#
# Appropriately label the data set with descriptive variable names
##  
## prefix t is replaced by time
## Acc is replaced by Accelerometer
## Gyro is replaced by Gyroscope
## prefix f is replaced by frequency
## Mag is replaced by Magnitude
## BodyBody is replaced by Body
#
names(sub_Data) <- gsub("^t", "time", names(sub_Data))
names(sub_Data) <- gsub("^f", "frequency", names(sub_Data))
names(sub_Data) <- gsub("Acc", "Accelerometer", names(sub_Data))
names(sub_Data) <- gsub("Gyro", "Gyroscope", names(sub_Data))
names(sub_Data) <- gsub("Mag", "Magnitude", names(sub_Data))
names(sub_Data) <- gsub("BodyBody", "Body", names(sub_Data))
#
names(sub_Data)
#
## Creates a second,independent tidy data set and ouput it
#
library(plyr);
tidy_Data <- aggregate(. ~ subject + activity, sub_Data, mean)
tidy_Data <- tidy_Data[order(tidy_Data$subject,tidy_Data$activity),]
## Validate the variables
names(tidy_Data)
## Visual the tidy data
head(tidy_Data,5)
write.table(tidy_Data, file = "tidydata.txt",row.name = FALSE)
#
#write.table(Data2,file= "tidydata.csv",row.name=FALSE,col.names = TRUE,sep=",")
#
## Prouduce Codebook
#
# library(knitr)
# if (!file.exists(".codebook.Rmd"))
# {
#         file.create("codebook.Rmd",showWarnings = F)
# }
# knit2html("codebook.Rmd")