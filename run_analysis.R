# Programming Assignment, Getting and Cleaning Data
## load and combine data
# function to split data in X
SEPVALUES <- function(CHR){
  o <- strsplit(CHR," +")
  return(o[[1]])
}
# function to transform into numeric data frame
MAKEDF <- function(MATRIX){
  M <- MATRIX[-1,]
  rM <- dim(M)[1]
  cM <- dim(M)[2]
  M <- as.numeric(M)
  M <- matrix(M, nrow = rM, ncol = cM)
  M.df <- as.data.frame(t(M))
  return(M.df)
}
### test dataset
ST <- read.delim("./UCI HAR Dataset/test/subject_test.txt", header = F)
y <- read.delim("./UCI HAR Dataset/test/y_test.txt", header = F)
X <- read.delim("./UCI HAR Dataset/test/X_test.txt", header = F)
X <- apply(X,1,SEPVALUES)
X <- MAKEDF(X)
feat.info <- read.delim("./UCI HAR Dataset/features.txt", header = F)
names(X) <- as.character(feat.info$V1)
Meta <- data.frame(set = rep("test",dim(ST)[1]))
Meta$subject <- ST$V1
Meta$activity <- y$V1
D.test <- cbind(Meta, X)
rm(Meta, X, ST, y) # clean up environment
### train dataset
ST <- read.delim("./UCI HAR Dataset/train/subject_train.txt", header = F)
y <- read.delim("./UCI HAR Dataset/train/y_train.txt", header = F)
X <- read.delim("./UCI HAR Dataset/train/X_train.txt", header = F)
X <- apply(X,1,SEPVALUES)
X <- MAKEDF(X)
names(X) <- as.character(feat.info$V1)
Meta <- data.frame(set = rep("train",dim(ST)[1]))
Meta$subject <- ST$V1
Meta$activity <- y$V1
D.train <- cbind(Meta, X)
rm(Meta, X, ST, y) # clean up environment
### combine test and train
D <- rbind(D.test, D.train)
# extract mean and sd, rename columns, transform activities to factor
D.df <- D[,c(1:3,grep("(mean\\(\\)|std\\(\\))",names(D)))]
names(D.df) <- gsub("(\\d+) (\\w+.+)","\\2",names(D.df))
names(D.df) <- gsub("\\(\\)","", names(D.df)) # remove brackets
act.factor <- factor(D.df$activity, levels = c(1:6),
                     labels = c("walking", "upstairs", "downstairs", "sitting", "standing", "laying"))
D.df$activity <- act.factor
rm(D, D.test, D.train, feat.info, act.factor) # clean up environment
## export table - intermediate dataset
write.table(D.df, file = "TidyData_mean-sd.txt", quote = F, sep = "\t", row.names = F)
# Make 2nd table with mean per activity and subject
mini.df <- D.df
mini.list <- split(mini.df[,c(4:69)], paste(mini.df$set,mini.df$subject, mini.df$activity, sep = "_"))
mini.out <- sapply(mini.list, colMeans) # needs to be transposed
mini.out <- t(mini.out) 
mini.df <- as.data.frame(mini.out)
## extract meta data from rownames
rownames(mini.out)
mini.df$set <- gsub("(t\\w+)_(\\d+)_(\\w+)", "\\1",rownames(mini.df))
mini.df$subject <- gsub("(t\\w+)_(\\d+)_(\\w+)", "\\2",rownames(mini.df))
mini.df$activity <- gsub("(t\\w+)_(\\d+)_(\\w+)", "\\3",rownames(mini.df))
row.names(mini.df) <- seq_along(row.names(mini.df))
## export table
write.table(mini.df, file = "TidyData_subjectAVG.txt", quote = F, sep = "\t", row.names = F)
rm(mini.list, mini.out) # clean up environment
