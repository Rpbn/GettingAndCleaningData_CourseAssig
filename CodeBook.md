This code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.


Variables
col = sets a vector with the number of columns from the main data set 1:561
y_train, y_test, X_train, X_test, subject_train, subject_test = were variables created to receive the information from the data files
activity, col_names = were created to receive the information from the activity description and column names (features.txt file)
train = merges the information from 3 different train files
test = merges the information from 3 different test files
means = is the mean vector calculated using the only_measurements variable, and than set as a data.fram
std_dev = is the standard deviation vector calculated using the only_measurements variable, and than set as a data.fram
col_names_vector = is the vector with the column names from the actual measured data.


Datasets / transformations
all = merge both information train and test data
only_measurements = merges the information from 2 files X_train and X_test
means = is the mean vector calculated using the only_measurements variable, and than set as a data.fram
std_dev = is the standard deviation vector calculated using the only_measurements variable, and than set as a data.fram
all_named = is the all data set with one additional column describing the activity.
IndependetTidyDataSet = Is the data set summarized by subject and activity aggregating the 561 columns using the mean
df_IndependetTidyDataSet = its the IndependetTidyDataSet as a Data Frame






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