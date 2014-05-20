## Read Tables for activities
ActivityMapping <- read.delim("./data/UCI HAR Dataset/activity_labels.txt", 
                              header=FALSE, sep=" ")
names(ActivityMapping)<-c("activityno","activity")

## Read Colume Value Descriptions and make a colume to be used for the colume name
Feature<-read.delim("./data/UCI HAR Dataset/features.txt", header=FALSE, 
                    col.names = c("colnumber", "colnames"), sep=" ")
Feature[,3]<-gsub("-","",Feature[,2])
Feature[,3]<-gsub("\\(|\\)","",Feature[,3])
Feature[,3]<-gsub(",","",Feature[,3])
Feature[,3] <-tolower(Feature[,3])

## Read Subject ID
SubjectTable <- function(TrainTest = "test"){
  if (TrainTest == "test"){
    Subject<-read.table("./data/UCI HAR Dataset/test/subject_test.txt", 
                        header=FALSE, col.names = c("subjectid"), sep=" ")                    
  }
  else if (TrainTest == "train"){
    Subject<-read.table("./data/UCI HAR Dataset/train/subject_train.txt", 
                        header=FALSE, col.names = c("subjectid"), sep=" ")                         
  }    
}
  
## Compose a list that contains both train and test subject ID
Subject <- list(TestSubject = SubjectTable("test"), 
                TrainSubject = SubjectTable("train"))  

## Map activity numbers with activity descriptions
ActivityTable <- function(TrainTest = "test"){
  if (TrainTest == "test"){    
    DataRows<-read.table("./data/UCI HAR Dataset/test/y_test.txt", 
                         header=FALSE, sep=" ")                       
  }
  else if (TrainTest == "train"){
    DataRows<-read.table("./data/UCI HAR Dataset/train/y_train.txt", 
                         header=FALSE, sep=" ")                      
  }
  
  norows <- nrow(DataRows)
  DataRows[,2]<-(1:norows)
  names(DataRows)<-c("activityno","ID")
  
  DataRowName <- merge(DataRows, ActivityMapping, by ="activityno")
  DataRowName <- DataRowName[order(DataRowName[,"ID"]),]
  
}

## Make a list that contains both test and train activities
Activity <- list(TestActivity = ActivityTable("test"),
                 TrainActivity = ActivityTable("train"))

## Read and combine data of (x_texst and y_test) and (x_train and y_train)
## (#1)
ReadMainData <- function(TrainTest="test"){
  if (TrainTest == "test"){
    TempData<-read.table("./data/UCI HAR Dataset/test/X_test.txt", 
                         header=FALSE, sep="")                       
  }
  else if (TrainTest == "train"){
    TempData<-read.table("./data/UCI HAR Dataset/train/X_train.txt", 
                         header=FALSE, sep="")                       
  }
## Add colume Names (#3) and combine with the subject ID and activities (#3, #4)    
  colnames(TempData)<-Feature[,3]

  if (TrainTest == "test"){
    TempData <- cbind(Subject$TestSubject,
                      "activity" = Activity$TestActivity[,"activity"],
                      TempData)
  }
  else if (TrainTest == "train"){
    TempData <- cbind(Subject$TrainSubject,
                      "activity" = Activity$TrainActivity[,"activity"],
                      TempData)
  }
}

## Make a list that includes both test and train data 
## (x_test, y_test, x_train, and y_train) (#1)
MainData <- list(MainTestData = ReadMainData("test"),
                 MainTrainData = ReadMainData("train"))

write.table(x=MainData$MainTestData, file="./data/MainTestData.txt")
write.table(x=MainData$MainTrainData, file="./data/MainTrainData.txt")

## Read files under Inertial Signals (Combine all of them; #1)
ReadInertialData <- function(TrainTest="test"){  
  
  ## File Names to read
  Inertial <- c(paste("body_acc_x_", TrainTest, ".txt", sep=""),
                    paste("body_acc_y_", TrainTest, ".txt", sep=""),
                    paste("body_acc_z_", TrainTest, ".txt", sep=""),
                    paste("body_gyro_x_", TrainTest, ".txt", sep=""),
                    paste("body_gyro_y_", TrainTest, ".txt", sep=""),
                    paste("body_gyro_z_", TrainTest, ".txt", sep=""),
                    paste("total_acc_x_", TrainTest, ".txt", sep=""),
                    paste("total_acc_y_", TrainTest, ".txt", sep=""),
                    paste("total_acc_z_", TrainTest, ".txt", sep=""))
  
  ## Perpare colume Names for each table
  ColumeInertial<-c("bodyaccelsigx","bodyaccelsigy","bodyaccelsigz",
                    "angularvelocx", 
                    "angularvelocy","angularvelocz", 
                    "phoneaccelsigx", "phoneaccelsigx", "phoneaccelsigx")
  
  ## Dataset Names
  InertialActivities <- c(paste("bodyaccelsigx", TrainTest, sep=""),
                          paste("bodyaccelsigy", TrainTest, sep=""),
                          paste("bodyaccelsigz", TrainTest, sep=""),
                          paste("angularvelocx", TrainTest, sep=""),
                          paste("angularvelocy", TrainTest, sep=""),
                          paste("angularvelocz", TrainTest, sep=""),
                          paste("phoneaccelsigx", TrainTest, sep=""),
                          paste("phoneaccelsigy", TrainTest, sep=""),
                          paste("phoneaccelsigz", TrainTest, sep=""))
  TempInertial = list()
  
  TempInertial.names <- InertialActivities
  
  TempInertial <- NULL
  TempInertial[TempInertial.names] <- list(NULL)
  
  ## Read the data
  for (j in 1:9){
      Columes <- vector(mode="character", length=128)
      
      for (i in 1:128){
        ## Set Colume Names
        Columes[i]<-paste(ColumeInertial[j],"ele",as.character(i),sep="")  
      }
    SourceLoc <- paste("./data/UCI HAR Dataset/", TrainTest, "/Inertial Signals/", 
                         Inertial[j], sep="")
    
    ## Read the data
    TempData<-read.table(SourceLoc,header=FALSE, col.names = Columes, sep="")         
  
  ## Combine the data with subject ID and activity descriptions (#3, #4)  
  if (TrainTest == "test"){
    TempData <- cbind(Subject$TestSubject,
                      "activity" = Activity$TestActivity[,"activity"],
                      TempData)
  }
  else if (TrainTest == "train"){
    TempData <- cbind(Subject$TrainSubject,
                      "activity" = Activity$TrainActivity[,"activity"],
                      TempData)
  }
  
  ## Add the data to the list (labelled for each activity (#4))
  TempInertial[[j]] <- TempData
  
  } 
  TempInertial<-TempInertial
}

## create a list that includes inertial data sets (#1)
InertialData <- list(InertialTestData = ReadInertialData("test"), 
                     InertialTrainData = ReadInertialData("train"))

write.table(x=InertialData$InertialTestData, file="./data/InertialTestData.txt")
write.table(x=InertialData$InertialTrainData, file="./data/InertialTrainData.txt")


## Create a list that consolidates all data (#1)
AllData<-list(testdata = list(testmaindata = MainData$MainTestData, 
                              testinertialdata = InertialData$InertialTestData),
              traindata = list(trainmaindata = MainData$MainTrainData, 
                              traininertialdata = InertialData$InertialTrainData))
write.table(x=AllData$testdata, file="./data/alltestdata.txt")
write.table(x=AllData$traindata, file="./data/alltraindata.txt")


## Extract the columes that have means adn standard deviations (#2)
meancolumes <- grep("mean", Feature[,3])
stdcolumes <- grep("std", Feature[,3])

## Extract the means and standard deviation data from the whole data (#2)
MeanStdData <- list(TestMeanStd = 
                      MainData$MainTestData[,c(meancolumes, stdcolumes)],
                    TrainMeanStd =
                      MainData$MainTrainData[,c(meancolumes, stdcolumes)])

write.table(x=MeanStdData$TestMeanStd, file="./data/extract_meanstd_data_test.txt")
write.table(x=MeanStdData$TrainMeanStd, file="./data/extract_meanstd_data_train.txt")

## Create an independent data with averages of each activity and subject (#5)
MeanData <- function(){
  for (i in c("test", "train")){
    InertialActivities <- c(paste("bodyaccelsigx", i, sep=""),
                            paste("bodyaccelsigy", i, sep=""),
                            paste("bodyaccelsigz", i, sep=""),
                            paste("angularvelocx", i, sep=""),
                            paste("angularvelocy", i, sep=""),
                            paste("angularvelocz", i, sep=""),
                            paste("phoneaccelsigx", i, sep=""),
                            paste("phoneaccelsigy", i, sep=""),
                            paste("phoneaccelsigz", i, sep=""))
    ListNames <- paste(InertialActivities,"mean", sep="")
    if (i == "test") {
      TempTestMean = list()
      TempTestMean.names <- ListNames
      TempTestMean <- NULL
      TempTestMean[TempTestMean.names] <- list(NULL)
    }
    else if (i == "train"){
      TempTrainMean = list()
      TempTrainMean.names <- ListNames
      TempTrainMean <- NULL
      TempTrainMean[TempTrainMean.names] <- list(NULL)
    }     
    for (j in 1:9){
      if (i == "test") {
        x <- InertialData$InertialTestData[[j]]
      }
      else if (i == "train"){
        x <- InertialData$InertialTrainData[[j]]
      }
      y <- cbind(x[,1:2],"means" = rowMeans(x[,3:130]))
      y <- aggregate(x=y[,3], 
                     by = list("subjectid" = y[,1], "activitiy" = y[,2]),
                     FUN = mean)
      if (i == "test") {
        TempTestMean[[j]] <- y
      }
      else if (i == "train"){
        TempTrainMean[[j]] <- y
      }
      
      }
   
  }
   ## Combin the mean data (#5) 
    MeanDataSet <- list(TestMean = TempTestMean, 
                        TrainMean = TempTrainMean)
  }

Means <- MeanData()

write.table(x=Means$TestMean, file="./data/average_sub_act_test.txt")
write.table(x=Means$TrainMean, file="./data/average_sub_act_train.txt")
