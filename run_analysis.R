##  Course project on Getting and Cleaning Data
##  Step 1
##  Merge the training and the test sets to create one data set
###########################################################################

library(plyr)

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")


xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt")

xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subdata <- rbind(subtrain, subtest)


##  Step 2
##  Extract only the measurements on the mean and standard deviation
##  for each measurement.
############################################################################

features <- read.table("UCI HAR Dataset/features.txt")

mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

xdata <- xdata[, mean_std_features]

##  Step 3
##  Use descriptive activity names to name the activities in the data set
#############################################################################

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

ydata[, 1] <- activities[ydata[, 1], 2]


##  Step 4
##  Appropriately label the data set with descriptive variable names
##############################################################################

names(xdata) <- features[mean_std_features, 2]
names(ydata) <- "activity"
names(subdata) <- "subject"

alldata <- cbind(xdata, ydata, subdata)


##  Step 5
##  From the data set in step 4, independent tidy data set with the
##  average of each variable for each activity and each subject created
##############################################################################

tidy_data <- ddply(alldata, .(activity, subject), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)



