The script "run_analysis.R" is working on initial data sets assuming that they were downloaded and unzipped as "UCI HAR Dataset" folder (with 'train' and 'test' folders in it) in the R working directory.

There are the following steps:

1.Reading activity labels meanings; reading activity labels for train and test sets and adding descriptive activity names column. The result is two data frames 'ac_labels_train', 'ac_labels_test' with two columns in each of them: 1 - integer code, 2 - descriptive name for it.

2.Reading data about subject(person who performed the experiment) for train and test data sets: 'subject_train', 'subject_test'.

3.Reading feature names which will be given as column names for train and test data sets later. Result - data frame 'feature_names' with two columns, where column 2 (auto named V2) contains the names for all variables measured.

4.While reading the files with train and test X data gives names to the columns which correspond to the respective feature in the measurement vector.

5.For both train and test sets extracting only the measurements on the mean and standard deviation for each measurement using grepl() function with condition that there is "mean" or "std" present in the variable name.

6.At the beginning of test and train data frames attaching two new columns carrying data about: 1)the person who participated (named "subject") and 2)type of activity (named "activity") respectively.

7.Merging train and test data frames using merge() function without sorting. Both merging data frames have all common column names. The result is a data frame 'data_all' with the same number of columns as train/test data frames, same column names.

8.Subsets merged data frame 'data_all' into data frames 'data_sub' for each subject and activity using two for() loops. Using colMeans() function calculates average of each measurement for 'data_sub' (each column except column1 and column2 which are "subject" and "activity"), adds "subject" and "activity" values at the beginning of the resulting vector 'col_means'. Writes vector 'col_means' as a row using rbind() function into new matrix "data_final" which is converted into data frame later. 

9.The last step of the script writes final data frame 'data_final' into the file named 'data_final.txt' in the "UCI HAR Dataset" directory (assuming that "UCI HAR Dataset" directory is located in the R working directory). It can be read into R and viewd using the following script:
        df<-read.table("./UCI HAR Dataset/data_final.txt",header=TRUE)
        View(df)