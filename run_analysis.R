if (!file.exists("./dataset.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "dataset.zip", method="curl") 
}

unzip("dataset.zip")

#Load training data
x <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
y <- read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
subject <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
training<-cbind(x, y, subject)

#Load testing data
x <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
y <- read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
subject <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
testing<-cbind(x, y, subject)

#Merge training with testing data
data<-rbind(training,testing)

#Load activities
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", stringsAsFactors=FALSE, header=FALSE)[[2]]

#Load features
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE, stringsAsFactors=FALSE)[[2]]

#Remove () from the name
features<- gsub('()', '', features)

#Assign names to columns
colnames(data) <- c(features, "activity", "subject")

#Select columns corresponding to means or stds
selected<-c(grep(".*-mean.*|.*-std.*", features),562,563)
data$activity <- activities[data$activity]
data<-data[,selected]

#Creates a data set with the average of each variable for each activity and each subject.
aggregatedData<-aggregate(.~activity+subject, data=data, mean, na.rm=TRUE)

#Write File
write.table(aggregatedData, "tidy.txt",row.name=FALSE) 
