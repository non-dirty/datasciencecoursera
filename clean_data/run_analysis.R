#run_analysis.R
cleanUpX<-function(){
  
  # Setup
  #install.packages("dplyr")
  library(dplyr)
  #install.packages("data.table")
  library(data.table)
  
  
  # 1. Merges the training and the test sets to create one data set.
  
  
  
  x_train<-read.fwf("train/X_train.txt",widths=rep.int(16,561), header=FALSE, n=7352)
  x_test<-read.fwf("test/X_test.txt",widths=rep.int(16,561), header=FALSE, n=2947)
  x<-rbind(x_train,x_test)
  
  # 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  f<-fread("features.txt",header=FALSE,nrows=561)
  columns<-filter(f,grepl("mean()|std()",V2))
  x<-x[,columns[[1]]]

  # 4. Appropriately labels the data set with descriptive variable names. 
  colnames(x)<-columns[[2]]

  # 3. Uses descriptive activity names to name the activities in the data set
  y_train<-fread("train/y_train.txt",header=FALSE)
  y_test<-fread("test/y_test.txt",header=FALSE)
  y<-rbind(y_train,y_test)
  activity_labels<-fread("activity_labels.txt",header=FALSE)[[2]]
  y<-select(mutate(y,Activity=activity_labels[V1]),Activity)

  x<-cbind(x,y)
  
  # From the data set in step 4, creates a second, independent tidy data set with the 
  # average of each variable for each activity and each subject.
  subject_train<-fread("train/subject_train.txt",header=FALSE)
  subject_test<-fread("test/subject_test.txt",header=FALSE)
  subject<-rbind(subject_train,subject_test)
  colnames(subject)<-c("Subject")
  x<-cbind(x,subject)
  

  # Group the variables into a new set bt activity and subject
  groupedX<-group_by(x,Activity,Subject)
  
  # Summarize the grouped values
  
  summaryX<-summarise_each(groupedX,funs(mean),1:79)
  summaryX
}

