## Link to get the data for the course project:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## installing the libraries
    install.packages("reshape")
    library(reshape)

    install.packages("reshape2")
    library(reshape2)

    install.packages("plyr")
    library(plyr)
    
    install.packages("dplyr")
    library(dplyr)
    
# Merges the training and the test sets to create one data set.

##### Getting the files that need to be merged which are:
# subject_test.txt
# X_test.txt
# y_test.txt

col <- rep(16,561)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = " ")
X_test <- read.fwf("./UCI HAR Dataset/test/X_test.txt", header = FALSE, widths=col)
y_test <-read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = " ")
subject_train  <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = " ")
X_train <- read.fwf("./UCI HAR Dataset/train/X_train.txt", header = FALSE, widths=col)
y_train <-read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = " ")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")
col_names <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ", col.names = c("id","var_names"))


##### Merging the data from files
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
all <- rbind(train, test)
only_measurements <- rbind(X_train, X_test) ## this is done to perform the means and standard deviation calculation easily 


##### Appropriately labels the data set with descriptive variable names.
colnames(activity) <- c("id_activity","activity")
colnames(all) <- c("subject","id_activity", 1:561)

##### Extracts only the measurements on the mean and standard deviation for each measurement.
means <- rowMeans(only_measurements)  ## This will show a VECTOR with the row means of each row.
means <- as.data.frame(means)

trans_only_measurements <- t(only_measurements) 
std_dev <- sapply(as.data.frame(trans_only_measurements), sd)
std_dev <- as.data.frame(std_dev)

# Bind both calculations (means and standard deviation) in the data set before merging because it SORTs the data frame.
all <- cbind(all,means,std_dev)

##### Uses descriptive ACTIVITY names to name the activities in the data set
all_named <- merge(all, activity, by = "id_activity")                               ## agregate the descriptive names
all_named <- all_named[c("subject","activity","means","std_dev",1:561)]  ## Reorder the colunms e deletes the ïd_activity" colunm.

###### I MOVED THE STEP 4 - NAMING VARIABLES - TO THE END BECAUSE IT HAD DUPLICATED NAMES IN THE COLUNMS
    # THUS THE SUMMARISE_EACH FUNCTION WAS NOT EXECUTING
    
#####  From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

IndependetTidyDataSet <- all_named %>% group_by(subject, activity) %>% summarise_each(funs(mean))
df_IndependetTidyDataSet <- as.data.frame(IndependetTidyDataSet)

##### Appropriately labels the data set with descriptive variable names.
col_names_vector <- as.vector(col_names$var_names)
names(df_IndependetTidyDataSet) <- c("subject","activity","means","std_dev",col_names_vector)
names(all_named) <- c("subject","activity","means","std_dev", col_names_vector)

write.table(df_IndependetTidyDataSet, file = "IndependetTidyDataSet.txt", row.name=FALSE)
    