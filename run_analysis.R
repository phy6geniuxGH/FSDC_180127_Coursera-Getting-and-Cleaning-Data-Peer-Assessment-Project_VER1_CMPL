
filename <- "D:/Research/Data Science/francisdata/getdata_dataset.zip"

if (!file.exists(filename)){
        download.file(url = paste("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", sep = ""), destfile = filename, mode = 'wb',cacheOK = FALSE)
}

if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}
#Load the activity_labels.txt for the observation labels.
ActL <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/activity_labels.txt")
ActL[,2] <- as.character(ActL[,2])

#Load the features - the variables of our data set.
feat<- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/features.txt")

#second column values of feat are now in a character vector.
feat[,2] <- as.character(feat[,2])

#find elements in the second column ->  one character, then * (possibly large 
#number of characters), followed by the word "mean", then character and * 
#(possibly large number of characters again). | matches lines with .*mean.* and .*std.* 
#and disregard others. value = TRUE will return the item number and its value. 
FeatMark <- grep(".*mean.*|.*std.*", feat[,2])

#To rename the column names, we select all the values of the second column, 
#according to the number of rows where FeatMark is satisfied in the feat object
#The FeatMark characters will be substituted in the second column of feat.
FeatMark.names <- feat[FeatMark,2]

#We started to change the names by using the gsub(). All -mean will be replaced 
#with the word Mean. 
FeatMark.names = gsub('-mean', 'Mean', FeatMark.names)

#We started to change the names by using the gsub(). After all -mean were replaced 
#with the word Mean, next is that all -std will be replaced with Std.  
FeatMark.names = gsub('-std', 'Std', FeatMark.names)

##Finally, we replace () and - with ''. e.g. tBodyAccMeanX rather 
#than tBodyAcc-mean()-X
FeatMark.names <- gsub('[-()]', '', FeatMark.names)

##loads all the observations (but here, the FeatMark acts as our index, that we 
#only need the values of the chosen variables - 79 columns)
Trn <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/train/X_train.txt")[featuresWanted]

#loads the label for the activity
TrnAct <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/train/Y_train.txt")

#loads the label for the subjects
TrnSubj <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/train/subject_train.txt")

#using cbind, all the data from TrnSubj, TrnAct,
#and Trn dataset will be one.
Trn <- cbind(TrnSubj, TrnAct, Trn)

#loads all the observations (but here, the FeatMark acts as our index, 
#that we only need the values of the chosen variables - 79 columns)
test <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testAct <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/test/Y_test.txt")
testSubj <- read.table("D:/Research/Data Science/francisdata/UCI HAR Dataset/test/subject_test.txt")

#using cbind, all the data from testSubj, 
#testAct, and train dataset will be one.
test <- cbind(testSubj, testAct, test)

#Combines the Trn and test datasets into one and assign it to myData
myData <- rbind(Trn, test)

#note that when we used the read.table, 
#there's already a slot for rownames and column names.
colnames(myData) <- c("subject", "activity", FeatMark.names)

#the levels are the numbers, which has an equivalent labels.
#using CombinedData$activity, we replaced the 1-6 numbers with 
#the labels: e.g. Walking, Standing, etc.
myData$activity <- factor(myData$activity, 
                          levels = ActL[,1], 
                          labels = ActL[,2])

#we coerced the subject column to be factors.
#Note: We used factors because we have categorical data.
myData$subject <- as.factor(myData$subject)

#We already have a Tidy Data Set!


# To Find the mean for each activity, for each subject, 
#we need to melt this myData!
library(reshape2)

#We selected all the variables, so no need to put measure.vars
myData.melt <- melt(myData, id = c("subject", "activity"))

# Here, we created a Data Set named "myData.mean"
# We casted our melted CombinedData, then we get the mean.
myData.mean <- dcast(myData.melt, 
                     subject + activity ~ variable, mean)

#Then the complete data set can be created using write.table.
write.table(myData.mean, file = "Final_Data_Set_of_Means.txt", 
            row.names = FALSE, quote = FALSE)
