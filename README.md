# Getting-and-Cleaning-Data---Peer-Assessment-Project

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

In the run_analysis.R,

feat was used for tagging the features.txt
FeatMark was used for selecting the variables with mean and std in their variable names.
FeatMark was also used for indexing the Trn and test files.

Trn, TrnAct, and TrnSubj were used for tagging the loaded X_train.txt, Y_train.txt, 
and subject_train.txt respectively.

The same method was applied to test, testAct, and testSubj.

cbind was used for combining Trn, TrnAct, and TrnSubj; the same for test, testAct,
and testSubj. 

rbind was used for combining the two data sets of Trn and test, then assigned to myData

colnames was introduced to rename the variables with the corresponding names: "subject",
"activity", and FeatMark.names

To tidy the myData data set, ActL was implemented as factors in the myData, replacing
number values of activity column with categorical data; the same for subject column

To find the mean, we need the reshape2 package. 

melt() was used for melting myData into subject, activity, and all the variables.

dcast() was used for recasting the myData, passing an argument mean, so that it will
return mean values once it goes back to myData format. This recasted data set was
assigned to myData.mean

Final_Data_Set_of_Means.txt is the tidy data set showing the mean for each activity
for each subject per variable.


