# TidyData
Programming Assignment - "Getting and Cleaning Data" course, Coursera

The data have been download from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. The run_analysis.R script contains all operations on the data that are needed to fulfill the assignment. The following steps are carried out in particular:

First, the data is loaded from the downloaded folder "/UCI HAR Dataset/". The original data structure has not been altered. Test and train data are loaded subsequently. In the very beginning of the script, 2 functions are defined to allow data processing into data frames containing numeric values. Information of metadata (subject ID, type of activity, test or train set) is stored in the object "Meta". 
