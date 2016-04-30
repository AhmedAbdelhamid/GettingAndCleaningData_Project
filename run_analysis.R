library("data.table")
library("dplyr")
library("Hmisc")
library("reshape2")

# Download and Unzip the data
if (!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileUrl,"getdata-projectfiles-UCI HAR Dataset.zip",method="curl")
  unzip("getdata-projectfiles-UCI HAR Dataset.zip") 
}  

# Read training dataset
train_features <- fread("UCI HAR Dataset/train/X_train.txt")
train_activity <- fread("UCI HAR Dataset/train/y_train.txt")
train_voluID <- fread("UCI HAR Dataset/train/subject_train.txt")
# Read test dataset
test_features <- fread("UCI HAR Dataset/test/X_test.txt")
test_activity <- fread("UCI HAR Dataset/test/y_test.txt")
test_voluID <- fread("UCI HAR Dataset/test/subject_test.txt")

# Merging the training and the test sets to create one data set
train_data <- cbind(train_voluID,train_activity,train_features)
test_data <- cbind(test_voluID,test_activity,test_features)
data <- rbind(train_data,test_data)
names(data)[1:2] <- c("subject","activity")

# Clean memory
rm(train_features,train_activity,train_voluID)
rm(test_features,test_activity,test_voluID)
rm(train_data,test_data)

# Extracts only the measurements on the mean and standard deviation
features_ls <- fread("UCI HAR Dataset/features.txt")
Mean_STD_Index <- grep(".*mean.*|.*std.*",features_ls$V2) + 2
data_selected <- select(data,c(1,2,Mean_STD_Index))
rm(data)

# Using descriptive activity names to name the activities in the data set
activity_names <- fread("UCI HAR Dataset/activity_labels.txt")
activity_factor <- factor(data_selected$activity,levels = activity_names$V1,labels = activity_names$V2)
data_selected[,activity := activity_factor]
data_selected[,subject := as.factor(subject)]

# Label the data set with descriptive variable names. 
selected_features_names <- features_ls[Mean_STD_Index - 2,]$V2
selected_features_names <- gsub("[-]"," ",selected_features_names)
selected_features_names <- gsub("[()]","",selected_features_names)
selected_features_names <- gsub("std","Std",selected_features_names)
selected_features_names <- gsub("mean","Mean",selected_features_names)
selected_features_names <- gsub(" ","_",selected_features_names)
names(data_selected)[3:ncol(data_selected)] <- selected_features_names

# Make tidy data set with the average of each variable for each activity and each subject.
data_molten <- melt(data_selected,id.vars = names(data_selected)[1:2])
data_tidy <- dcast(data_molten,subject + activity ~ variable,mean)
rm(data_selected,data_molten)

# write the tidy data set to "tidy.csv" file
write.table(data_tidy,"tidydata.txt",row.names = F)






