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
