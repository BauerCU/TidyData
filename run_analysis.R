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
#### main files
ST <- read.delim("./UCI HAR Dataset/test/subject_test.txt", header = F)
y <- read.delim("./UCI HAR Dataset/test/y_test.txt", header = F)
X <- read.delim("./UCI HAR Dataset/test/X_test.txt", header = F)
X <- apply(X,1,SEPVALUES)
X <- MAKEDF(X)
Meta <- data.frame(set = rep("test",dim(ST)[1]))
Meta$subject <- ST$V1
Meta$activity <- y$V1
rm(ST, y) # clean up environment
#### inertial signals
import.list <- list()
for (i in seq_along(list.files("./UCI HAR Dataset/test/Inertial Signals"))){
  filename <- list.files("./UCI HAR Dataset/test/Inertial Signals")[i]
  import.list[[i]] <- read.delim(paste0("./UCI HAR Dataset/test/Inertial Signals/",filename), header = F)
  names(import.list[[i]])[1] <- "values"
  import.list[[i]] <- apply(import.list[[i]],1,SEPVALUES)
  print(dim(import.list[[i]]))
}
DF.list <- lapply(import.list, MAKEDF)
names(DF.list) <- gsub("_t\\w+\\.txt",""
                       ,list.files("./UCI HAR Dataset/test/Inertial Signals"))
names(DF.list)
test.list <- list(meta = Meta, TimeFreq = X)
test.list <- c(test.list, DF.list)
rm(DF.list, import.list, Meta, X, filename, i) # clean up environment
### train dataset
#### main files
list.files("./UCI HAR Dataset/train/")
ST <- read.delim("./UCI HAR Dataset/train/subject_train.txt", header = F)
y <- read.delim("./UCI HAR Dataset/train/y_train.txt", header = F)
X <- read.delim("./UCI HAR Dataset/train/X_train.txt", header = F)
X <- apply(X,1,SEPVALUES)
X <- MAKEDF(X)
Meta <- data.frame(set = rep("train",dim(ST)[1]))
Meta$subject <- ST$V1
Meta$activity <- y$V1
rm(ST, y) # clean up environment
#### inertial signals
import.list <- list()
for (i in seq_along(list.files("./UCI HAR Dataset/train/Inertial Signals"))){
  filename <- list.files("./UCI HAR Dataset/train/Inertial Signals")[i]
  import.list[[i]] <- read.delim(paste0("./UCI HAR Dataset/train/Inertial Signals/",filename), header = F)
  names(import.list[[i]])[1] <- "values"
  import.list[[i]] <- apply(import.list[[i]],1,SEPVALUES)
  print(dim(import.list[[i]]))
}
DF.list <- lapply(import.list, MAKEDF)
names(DF.list) <- gsub("_t\\w+\\.txt",""
                       ,list.files("./UCI HAR Dataset/train/Inertial Signals"))
names(DF.list)
train.list <- list(meta = Meta, TimeFreq = X)
train.list <- c(train.list, DF.list)
rm(DF.list, import.list, Meta, X, filename, i) # clean up environment
### combine test and train
D <- list()
for (i in seq_along(names(test.list))){
  if(names(test.list)[i] != names(train.list)[i]){
    message("names do not agree")
    break
  }
  N <- names(test.list)[i]
  D[[N]] <- rbind(test.list[[i]],train.list[[i]])
}
rm(i, N) # clean up environment
# Calculate mean and sd
## function
MEANSD <- function(DF){
  O <- data.frame(mean = apply(DF,1,mean), sd = apply(DF,1,sd))
  return(O)
}
D.ms <- lapply(D[c(2:11)],MEANSD)
## bind into dataframe and shorten column names
D.df <- do.call(cbind, D.ms)
## combine with meta data, rename activities
D.df <- cbind(D[["meta"]], D.df)
act.factor <- factor(D.df$activity, levels = c(1:6),
                     labels = c("walking", "upstairs", "downstairs", "sitting", "standing", "laying"))
D.df$activity <- act.factor
rm(D.ms, test.list, train.list, act.factor) # clean up environment
## export table
write.table(D.df, file = "TidyData_mean-sd.txt", quote = F, sep = "\t", row.names = F)
# Make 2nd table with mean per activity and subject
mini.df <- D.df[,c(1:3,grep("mean",names(D.df)))]
mini.list <- split(mini.df[,c(4:13)], paste(mini.df$set,mini.df$subject, mini.df$activity, sep = "_"))
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
