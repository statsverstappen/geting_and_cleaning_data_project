library(dplyr)
library(tidyr)


##downloading file
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest_file <- paste(getwd(), "UCI HAR Dataset.zip", sep = "")
if(!file.exists(dest_file)) {
        
        download.file(file_url, destfile = dest_file, mode = "wb")
}

##unzipping file
dtpath <- "UCI HAR Dataset"

if(!file.exists(dtpath)) {
        unzip(dest_file)
}



## importing labels
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")
activity_labels_names <- c("Label", "Activity")

colnames(activity_labels) <- activity_labels_names

##importing features
features <- read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = " ")


##Importing test data
subjects_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
colnames(subjects) <- "subject"

test_labels <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_labels$V1 <- factor(test_labels$V1, levels = c(1:6), labels = activity_labels$Activity)
colnames(test_labels) <- "activity"

test_data <- read.csv("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
colnames(test_data) <- features$V2

test_data_complete <- cbind(subjects_test, test_labels, test_data)


##importing training data
subjects_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
colnames(subjects_train) <- "subject"

train_labels <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_labels$V1 <- factor(train_labels$V1, levels = c(1:6), labels = activity_labels$Activity)
colnames(train_labels) <- "activity"

train_data <- read.csv("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
colnames(train_data) <- features$V2

train_data_complete <- cbind(subjects_train, train_labels, train_data)

##creating dataset with training and test data combined
data_complete <- rbind(train_data_complete,test_data_complete)

##selecting mean and standard deviations of measurements
data_slim <- select(data_complete, contains(c("subject", "activity", "mean()", "std()")))

##creating independent tidy data set
dt1 <- data_slim %>% 
        group_by(subject, activity) %>%
        summarise(across(.fns = mean))



