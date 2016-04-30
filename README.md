Getting and Cleaning Data Course - Coursera 
-------------------------------------------
Course Project
-------------------------------------------
In this project we prepared tidy data that can be used for later analysis using R language
You can find the original data here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Now lets see how the "run_analysis.R" script works : 

First, we download the original data and unzip it.
Second, we the read the training & test sets and merge thier columns then merge both of them to one data set
after that, we read the features and select the features that reflect Mean or Std
then, we extract only the measurements of the selected features
then, we read the activity labels and convert "subject","activity" columns to factors
then, we appropriately labels the data set with descriptive variable names
then, we create tidy data set with the average of each variable for each activity and each subject.
Finally, Save the tidy data set to "tidydata.csv" file.




