# cleanData
## run_activity.R
### Overview
We start by extracting the column names and the activity mapping, and store the column names as vector c
We then load the data sets for the test data and the training data
The code then merge the data sets as x,y, and subject, where x is the feature data, y is the activiy and subject is the subject data.
We find the indexes of the columns that matches the keyword 'mean()' and 'std()', and use the relevant indexes 
We then remap the data according activity mapping and merge the data, activity and subject and rename the columns accordingly
We finally use the aggregate function to aggregate the data by activity and subject, using the mean as the aggregating function and rename the columns accordingly and finally output the dataFrame tidyGroup into a text file tidyTable

### Code
```{r}
#Extract the column names and the activity mapping, and store the column names as vector c
setwd("~/UCI HAR Dataset")
features=read.csv("features.txt",sep=" ",header=FALSE)
activities=read.csv("activity_labels.txt",sep=" ",header=FALSE)
c=features[,2]

#Load the data sets for the test data and the training data
setwd("~/UCI HAR Dataset/train")
x_train=read.table(file="X_train.txt",sep="",header=FALSE,col.names = c)
subject_train=read.table(file="subject_train.txt",sep="",header=FALSE)
y_train=read.table(file="y_train.txt",sep="",header=FALSE)
setwd("~/UCI HAR Dataset/test")
x_test=read.table(file="X_test.txt",sep="",header=FALSE,col.names = c)
subject_test=read.table(file="subject_test.txt",sep="",header=FALSE)
y_test=read.table(file="y_test.txt",sep="",header=FALSE)
#merge the data sets as x,y, and subject, where x is the feature data, y is the activiy and subject is the subject data
x=rbind(x_train,x_test)
y=rbind(y_train,y_test)
subject=rbind(subject_train,subject_test)

#grep the column index for the means and the stdDeviations and extract only the relevant columns and bind them as dataFrame tidy
meanIdx=features[grep('mean\\(\\)',features$V2),1]
stdIdx=features[grep('std\\(\\)',features$V2),1]
means=x[,meanIdx]
stds=x[,stdIdx]
tidy=cbind(means,stds)

#Load library plyr to rename the columns for later use
library(plyr)

#remap y according the the values in activities, (as a string)
for(n in activities$V1) {level=as.character(activities[activities$V1==n,2]); y$V2[y$V1==n]=level}
#merge the data, activity and subject and rename the columns accordingly
merged=cbind(tidy,y$V2,subject)
tidyMerged=rename(merged,c('y$V2'='activity','V1'='subject'))

#use the aggregate function to aggregate the data by columns activity and subject, using the mean as the aggregating function and rename the columns into the dataFrame tidyGrouped
grouped=aggregate(tidyMerged[,1:66],by = list(tidyMerged$activity,tidyMerged$subject),FUN =mean)
tidyGrouped=rename(grouped,c('Group.1'='activity','Group.2'='subject'))
#output the dataFrame tidyGroup into a text file tidyTable
setwd("~/UCI HAR Dataset")
write.table(tidyGrouped,file='tidyTable.txt',row.names = FALSE)
```

## Code book
The variables are taken from features.txt and these are the description according to features_info.txt

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

with the suffix -mean() to denote the mean values and -std() to denote the standard deviation of the measurement: 
