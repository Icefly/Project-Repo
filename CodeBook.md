The functions are listed below;
•	SubjectTable – make a subject ID table
•	ActivityTable – map activity descriptions to the activity codes written on the data
•	ReadMainData – read test_x, test_y, train_x and train_y data, and combine with subject ID and activity descriptions
•	ReadInertialData – read the data under /Inertial Signals folder, and combine with subject ID and activity descriptions
•	MeanData – create  an independent tidy data set with the average of each variable for each activity and each subject

The project program file “run_analysis.R” contains all commands and functions, including the commands that run functions in the file. Run the run_analysis.R can complete the project #1~#5 and exports the output to the main work directory.

First the program read files that are commonly used for all data files - activity_labels.txt and features.txt
SubjectTable function can read subject id files from both train and test folders.  Following command let the program 
read both train and test sibject id files and store in "Subject" list.

ActivityTable function maps the activty descriptions to the corresponding activity codes in the dataset (y_test and y_train).
A list "Activity" is created to run the ActivityTable function for both test and train and store the activity description
files to combine with the actual data later.
                   
ReadMainData function reads x_test and x_train, give colume names (from Feature table (read from features.txt), and
combine with appropriate subject ID and activity descriptions.  Following command runs the function twice for test and train 
data and store the data set in the lsit "MainData" and export the test and train tables to the work directory in text format.
Because test data and train data have different number of rows, they data could not be stored in one file.

ReadInertialData function reads the data files under test/inertial signals/ and train/inertial signals, and make a tidy data set.
Each test and train data set is composed of 9 separate files, so the program reads the files separately and the
nine files are grouped together in a list with proper lables.  Also the program adds colume names, subject ID, 
and activity descriptions to each data.
Following commands run the ReadInertialData function for test and train, store the data in "InertialData" list and export
the result to the work directory in text format.  Again due to the different number of rows for test and train, they
are exported separately in two text files.


AllData list is additionally created to combine all the data which is stored in MainData list and InertialData list. 
Again this comprehensive dataset is exported in two files for test and train dataset each.  alltextdata.txt and 
alltraindata.txt are the names of the files exported.

The program then recognizes the mean and standard deviation columnes in the main dataset (originated by x_test and x_train)
and store them only separately in MeanStdData list. Also the following commands export the data to the work directory.

The last function of this program is MeanData which calculates the averages of each dataset by subject ID and activities.  
They are stored in MeanDataset list in the function and Means list in the program.  Also the program exports the dataset.


  
