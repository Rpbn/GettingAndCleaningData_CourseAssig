README.md in the repo describing how the script works


The script works in a logical way which is described as follows


1 - The first part the libraries used in the script were loaded
2 - The files in the different directories were loaded into R, with the following observations
* The data file is a tabular with 561 columns and 16 spaces per colums
* The other files were loaded simply using a space as a separator as they were simpler
3 - The files were merged following
* first by colunms for each train and test sets
* second by rows merging the train on top of the test data set
4 - The names for the new data set was changed to be easier to work with. NOTE: these are not the final colunm names
5 - The row means and row standard deviations were calculated in 2 different vectors, noting:
* The mean could be directly calculated
* The standard deviation had to be calculated after the transpose of the data file, so the APPLY function could be used.
6 - The standard deviation vector and mean vector was binded in the large dataset as 2 new colunms.
7 - The Activity names were merged to the large data set in a new column and than its  columns were re-ordered to be more organized.
8 - The summarization by Subject and activity was done and the means for the columns were calculated using the summarize_each function and than set as a data.set
9 - The column names were adjusted following the features.txt information.




SCRIPT - run_analysis.R


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