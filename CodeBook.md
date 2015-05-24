# Introduction

The code book explains all the steps that were taken to transform the initial data into a tidy data and the variables used.

# Program Description

* The script first reads the activity label and feature vector text files

aclabdf <- read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ")
featuredf <- read.table("./UCI HAR Dataset/features.txt", sep = " ")

* After this it extracts test data sets (named after test), ydf=test label, subdf=subject label, xdf=test data

testydf <- read.table("./UCI HAR Dataset/test//y_test.txt", sep = " ")
testsubdf <- read.table("./UCI HAR Dataset/test//subject_test.txt", sep = " ")
testxdf <- read.table("./UCI HAR Dataset/test/X_test.txt")

* And then it extracts training data sets (named after train), ydf=training label, subdf=subject label, xdf=training data

trainydf <- read.table("./UCI HAR Dataset/train//y_train.txt", sep = " ")
trainsubdf <- read.table("./UCI HAR Dataset/train//subject_train.txt", sep = " ")
trainxdf <- read.table("./UCI HAR Dataset/train/X_train.txt")

* Step 1: merge all similar data sets and replace numbers by appropriate names. testtrainx is now the complete data set
although without column names which will be added later. Similarly, testtrainy and testtrainsub merge the all activity
and subject together.

testtrainx <- rbind(trainxdf, testxdf)
testtrainy <- rbind(trainydf, testydf)
names(testtrainy) <- "activity"
testtrainsub <- rbind(trainsubdf, testsubdf)
names(testtrainsub) <- "subject"

* Step 2: Generates the indices from columns related to mean and stdev only and subsets the merged data set generated in step 1

findex <- grep("-(mean|std)\\(\\)", featuredf[, 2])
testtrainx <- testtrainx[,findex]

* Step 3: Provides descriptive names from the activity set

* Step 4: Combines the data with activity and subject

finaldata <- cbind(testtrainx, testtrainy, testtrainsub)

* Step 5: Transformation is done on final data so that an average can be taken for a group per subject per activity. So for each 30 subjects
and 6 activities in all there are 180 cases and thus the tidy data set is of 180 obs. and 66 variables.
