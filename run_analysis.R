data_folder = 'UCI HAR Dataset'
if (!file.exists(data_folder)) {
  stop('could not find data folder')
}

train_folder = file.path(data_folder, 'train')
test_folder = file.path(data_folder, 'test')
activity_labels_file = file.path(data_folder, 'activity_labels.txt')
feature_labels_file = file.path(data_folder, 'features.txt')
activity_col_labels = substring(readLines(activity_labels_file), 3)
feature_labels_lines = readLines(feature_labels_file)

feature_col_labels = sapply(regmatches(feature_labels_lines,
  regexec('\\d+\\s(.+)', feature_labels_lines)), function(x){x[2]})

library(dplyr)
df_list <- list()
for (folder in c(train_folder, test_folder)) {
  subject_labels_file <- list.files(path=folder, pattern='^subject_\\w+.txt')[1]
  activity_labels_file <- list.files(path=folder, pattern='^y_\\w+.txt')[1]
  feature_labels_file <- list.files(path=folder, pattern='^X_\\w+.txt')[1]
  
  subject_labels = tibble::as_tibble(
    read.table(file.path(folder, subject_labels_file), col.names='subject'))
  activity_labels = tibble::as_tibble(
    read.table(file.path(folder, activity_labels_file), col.names='activity'))
  features = tibble::as_tibble(
    read.table(file.path(folder, feature_labels_file),
      col.names=feature_col_labels))
  
  # Use descriptive activity names to name the activities in the data set
  activity_labels <- mutate(activity_labels,
      activity = activity_col_labels[activity])
  
  # Extract only measurements on mean and std
  desired_col_index = grep('mean\\(\\)|std\\(\\)', feature_col_labels)
  features <- select(features, all_of(desired_col_index))
  
  dataset <- cbind(subject_labels, activity_labels, features)
  df_list[[folder]] = dataset
}

# Merge training and test sets to create one data set
merged_dataset <- do.call(rbind, df_list)
merged_dataset <- tibble::as_tibble(merged_dataset)
merged_dataset <- rename_with(merged_dataset, function(x){ tolower(gsub('\\.','',x)) })
merged_dataset_file <- 'merged_dataset.csv'
write.csv(merged_dataset, merged_dataset_file)

# Create a dataset with the average of each variable for each activity and 
# subject
# Do they mean grouped by activity and grouped by subject, or grouped by both???
grouped_dataset <- group_by(merged_dataset, subject, activity)
summarized_dataset <- summarize(grouped_dataset, across(tbodyaccmeanx:last_col(), mean))
summarized_dataset_file <- 'summarized_dataset.csv'
write.csv(summarized_dataset, summarized_dataset_file)