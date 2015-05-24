### analysis.R to merge the datasets

## Extracting activity labels and feature vector

aclabdf <- read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ")
featuredf <- read.table("./UCI HAR Dataset/features.txt", sep = " ")

## Extracting test data sets (ydf=test label, subdf=subject label, xdf=test data)

testydf <- read.table("./UCI HAR Dataset/test//y_test.txt", sep = " ")
testsubdf <- read.table("./UCI HAR Dataset/test//subject_test.txt", sep = " ")
testxdf <- read.table("./UCI HAR Dataset/test/X_test.txt")

## Extracting training data sets (ydf=training label, subdf=subject label, xdf=training data)

trainydf <- read.table("./UCI HAR Dataset/train//y_train.txt", sep = " ")
trainsubdf <- read.table("./UCI HAR Dataset/train//subject_train.txt", sep = " ")
trainxdf <- read.table("./UCI HAR Dataset/train/X_train.txt")

## 1.Merges the training and the test sets to create one data set.
## Merge x data set, y data set and subject data set one-by-one

testtrainx <- rbind(trainxdf, testxdf)
testtrainy <- rbind(trainydf, testydf)
names(testtrainy) <- "activity"
testtrainsub <- rbind(trainsubdf, testsubdf)
names(testtrainsub) <- "subject"

## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
## From feature vector get indices for mean and std columns by pattern matching

findex <- grep("-(mean|std)\\(\\)", featuredf[, 2])

## Subset the merged data set with the above indices
testtrainx <- testtrainx[,findex]

## Assign column names to above data set by subsetting feature vector
names(testtrainx) <- featuredf[findex,2]

## 3.Uses descriptive activity names to name the activities in the data set
## Replacing numbers by activity names in merged y data set

testtrainy[,1] <- aclabdf[testtrainy[,1],2]

## 4.Appropriately labels the data set with descriptive variable names. 
## Already done in step 1 after merging by giving proper names
## Combine all the data in a single data set
finaldata <- cbind(testtrainx, testtrainy, testtrainsub)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## Using ddply function from plyr library 
## Averaging all columns but the last two which are activity and subject thus 2 subtracted

library(plyr)
colindex <- ncol(finaldata)-2
tidydata <- ddply(finaldata, .(subject, activity), function(x) colMeans(x[, 1:colindex]))

write.table(tidydata, "./tidydata.txt", row.name=FALSE)



