## 1. Read both test and train data sets & merge them 
tt.labels <- read.table("test/y_test.txt", col.names="label")
tt.subjects <- read.table("test/subject_test.txt", col.names="subject")
tt.data <- read.table("test/X_test.txt")
tr.labels <- read.table("train/y_train.txt", col.names="label")
tr.subjects <- read.table("train/subject_train.txt", col.names="subject")
tr.data <- read.table("train/X_train.txt")
data <- rbind(cbind(tt.subjects, tt.labels, tt.data), cbind(tr.subjects, tr.labels, tr.data))

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

# 3. Uses descriptive activity names to name the activities in the data set 
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
data.mean.std$label <- labels[data.mean.std$label, 2]

# 4. Appropriately labels the data set with descriptive variable names. 
colnames(data.mean.std) <- c("subject", "label", features.mean.std$V2)

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
new.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],by=list(subject = data.mean.std$subject, label = data.mean.std$label),mean)
write.table(new.data, "tidy.txt",row.name=FALSE)

