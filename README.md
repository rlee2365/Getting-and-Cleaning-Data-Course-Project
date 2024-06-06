# README
This repo contains a dataset created for the Getting and Cleaning Data course on
Coursera, derived from the [UC Irvine Human Activity Recognition
dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The primary components are:
* `UCI HAR Dataset`, the original dataset from which this repo is derived
* `merged_dataset.csv`, a merged version of the dataset produced by merging the
mean and standard deviation variables from the training and test datasets from the original, as well as using string activity labels in place of numerical codes
* `summarized_dataset.txt`, a summarized verison of `merged_dataset.csv` which provides
averages for the mean and standard deviation variables
* `Codebook.md`, the codebook for this dataset, containing a description of variable names
* `run_analysis.R`, the R code used to generate the dataset