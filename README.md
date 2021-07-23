# TidyData
Programming Assignment - "Getting and Cleaning Data" course, Coursera

The data have been download from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. The run_analysis.R script contains all operations on the data that are needed to fulfill the assignment. The following steps are carried out in particular:

First, the data is loaded from the downloaded folder "/UCI HAR Dataset/". The original data structure has not been altered. Test and train data are loaded subsequently. In the very beginning of the script, 2 functions are defined to allow data processing into data frames containing numeric values. Information on metadata (subject ID, type of activity, test or train set) is stored in the object "Meta", measurement values are loaded into the object "X" and transformed into a data frame with numeric values. Columnnames are assigned based on the features.txt file.

Second, test and train data are combined, columns with information on mean() and std() are extracted with the grep() function, and activities are transformed into a factor with informative labels. This intermediate dataset is exported as a txt file "TidyData_mean-sd.txt".

Finally, the data is splitted based on the metadata "set", "subject", and "activity", and the ColumnMeans are calculated. The resulting matrix is tranformed into a data frame and the metadata (which have been concatenated by the data transformations) are extracted into single columns again using gsub(). The resulting final dataframe "mini.df" is exported as txt file "TidyData_subjectAVG.txt.
