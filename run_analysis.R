#Getting and Cleaning Data - Course Project

#create URL to download zip file
zipLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download supporting files into data frames
# supporting data data frames
activities <- read.table("../../Data/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE) # download activities file
features <- read.table("../../Data/UCI HAR Dataset/features.txt", sep = "", header = FALSE ) # download features file

# test data frames
testX <- read.table("../../Data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE) # test X file
testY <- read.table("../../Data/UCI HAR Dataset/test/Y_test.txt", sep = "") # test Y file
testSub <- read.table("../../Data/UCI HAR Dataset/test/subject_test.txt", sep = "") # test subject numbers

# train data frames
trainX <- read.table("../../Data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE) # train X file
trainY <- read.table("../../Data/UCI HAR Dataset/train//y_train.txt", sep = "") # train Y file
trainSub <- read.table("../../Data/UCI HAR Dataset/train/subject_train.txt", sep = "") # train subject numbers

# manipulate data frames - including renaming
# features data frame
featuresNew <- features %>% 
  select(featureName = V2) # select only column V2; rename to featureName

featuresNew <- t(featuresNew) # transpose and create a matrix of column names for test X and train X data frames

varNames <- tocamel(as.matrix(featuresNew)) # create a matrix to rename columns; transform to tidy camelCase

# activities data frame
colnames(activities) <- c("activityNumber","activityName") # change names of activities variables

# combine and rename columns for X train and test data
rbindX <- rbind(trainX,testX) # merge x train and test data sets
colnames(rbindX) <- varNames # apply varNames from features data to column names in merged data set
dim(rbindX)

# combine and merge Y train and test data with activitity names
rbindY <- rbind(trainY, testY) # merge y train and test data sets
colnames(rbindY) <- "activityNumber" # rename V1 to activityNumber for merging with activity names
rbindY_Merged <- merge(x = rbindY, y = activities, by = "activityNumber",sort = FALSE) # merge test Y data

# rbind subject data; assign names to subject numbers
rbindSub <- rbind(testSub,trainSub)
colnames(rbindSub) <- "subjectNumber" # rename V1 to activityNumber for merging with activity names

# bind totals for merged data set
mergedFrames <- cbind(rbindSub,rbindY_Merged,rbindX) #bind all data frames together by columns

# 4 Extracts only the measurements on the mean and standard deviation for each measurement. 

measuredColumns <- mergedFrames %>%
  select(subjectNumber, activityNumber, activityName, contains("[Mm]ean"), contains("[Ss]td")) # using dplyr; retains subjectNumber, activityNumber, activityName

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

#this is where it all fell apart

finalTidy <- ddply(measuredColumns, .(subjectNumber,activityName), numcolwise(mean))
write.table(finalTidy,file = "finalActivityPerSubject.txt",sep=";" ,row.name=FALSE)

        



