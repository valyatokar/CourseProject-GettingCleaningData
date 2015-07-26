#reading activity labels and adding descriptive activity names column to the train and test sets:
ac_labels_char<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
ac_labels_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
for(i in 1:nrow(ac_labels_train)) { #decodes activity labels for train set
        for(j in 1:6){
                if(ac_labels_train$V1[i]==j) {ac_labels_train$V2[i]<-ac_labels_char$V2[j]}
        }
}

ac_labels_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
for(i in 1:nrow(ac_labels_test)) { #decodes activity labels for test set
        for(j in 1:6){
                if(ac_labels_test$V1[i]==j) {ac_labels_test$V2[i]<-ac_labels_char$V2[j]}
        }
}
#reading data about subject for train and test data sets:
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#reading feature names which will be given as column names for train and test data sets:
feature_names<-read.table("./UCI HAR Dataset/features.txt")

measurement_train<-read.table("./UCI HAR Dataset/train/X_train.txt",col.names=feature_names$V2) #While reading the file
#gives names to the columns which correspond to the respective feature in the measurement vector.
measurement_train<-measurement_train[,grepl("mean|std", names(measurement_train))] #Extracts only the measurements
        #on the mean and standard deviation for each measurement.
measurement_train<-cbind("subject"=subject_train$V1,"activity"=ac_labels_train$V2,measurement_train) #attaches two new
#columns at the beginning carrying data about: 1)the person who participated and 2)type of activity respectively

measurement_test<-read.table("./UCI HAR Dataset/test/X_test.txt",col.names=feature_names$V2) #While reading the file gives names 
        #to the columns which correspond to the respective feature in the measurement vector.
measurement_test<-measurement_test[,grepl("mean|std", names(measurement_test))] #Extracts only the measurements
        #on the mean and standard deviation for each measurement.
measurement_test<-cbind("subject"=subject_test$V1,"activity"=ac_labels_test$V2,measurement_test) #attaches two new
#columns at the beginning carrying data about: 1)the person who participated and 2)type of activity respectively

data_all<-merge(measurement_train, measurement_test,all=TRUE,sort=FALSE) #merges train and test data sets without sorting

library(dplyr)
data_final <- matrix('', 0, dim(data_all)[2], dimnames=list(NULL, names(data_all))) #creates empty matrix 'data_final'
for(i in 1:30) { #subsets merged data frame into data frames for each subject and activity, calculates average of each
        #measurement and writes it as new row into "data_final"
        for(j in 1:6) {
                data_sub<-data_all[(data_all$subject==i & data_all$activity==ac_labels_char$V2[j]),]
                col_means<-colMeans(select(data_sub, 3:dim(data_sub)[2]),na.rm=TRUE)
                col_means<-c("subject"=i, "activity"=ac_labels_char$V2[j], col_means)
                data_final<-rbind(data_final,col_means)
        }
}
data_final<-as.data.frame(data_final, stringsAsFactors=FALSE) #converts matrix into data frame

#writing final data frame into the file:
write.table(data_final,file="./UCI HAR Dataset/data_final.txt",row.names=FALSE)
