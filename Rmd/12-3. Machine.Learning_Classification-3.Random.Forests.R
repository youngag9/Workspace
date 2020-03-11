#----------------------------------------------------------
# Machine Learning : Classification 
#
# (3) Random Forests
#     - using randomForest{randomForest}
#     - using importance{randomForest}
#----------------------------------------------------------
url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data'

breast <- read.table(file = url, 
                     header = FALSE, 
                     sep = ',', 
                     na.strings = '?')
rm(url)

str(breast)

library(tidyverse)
sample_n(tbl = breast, size = 10, replace = FALSE)

summary(breast)

names(breast)
names(breast) <- c(
  'ID', 'clumpThickness', 'sizeUniformity','shapeUniformity',
  'maginalAdhesion', 'singleEpithelialCellSize', 'bareNuclei',
  'blandChromatin', 'normalNucleoli', 'mitosis', 'class'
)
names(breast)

table(is.na(breast))

library(prettyR)
freq(is.na(breast))

df <- breast[-1]
str(df)

rm(breast)

df$class <- factor(x = df$class, 
                   levels = c(2,4), 
                   labels = c('benign', 'malignant'))

freq(df$class)

df[is.na(df$bareNuclei), ]    # obs. having NA's

#----------------------------------------------------------
set.seed(1234)
( 
  train.set <- sample(x = nrow(df), 
                      size = nrow(df)*0.7, 
                      replace = FALSE) 
)
length(train.set) # 70% of all

( df.train <- df[train.set, ] )
( df.validate <- df[-train.set, ] )

rm(train.set)

str(df.train)
str(df.validate)

freq(df.train$class)
freq(df.validate$class)

#----------------------------------------------------------
# Classification method : 3) Random Forests
# using randomForest{randomForest}
#
# 1) grows the forests
#     - randomForest{randomForest} : 
#           Classification and Regression with Random Forest
#----------------------------------------------------------
library(randomForest)

set.seed(1234)

(
  rforest.m <- 
      randomForest(formula = class ~ ., 
                   data = df.train, 
                   na.action = na.roughfix, 
                   importance = TRUE)
)
#---------------------------
class(rforest.m)
mode(rforest.m)
names(rforest.m)
#---------------------------
library(prettyR)

rforest.m$call
rforest.m$type

freq( rforest.m$predicted )

head( rforest.m$err.rate )
tail( rforest.m$err.rate )

rforest.m$confusion

head( rforest.m$votes )
tail( rforest.m$votes )

rforest.m$oob.times
rforest.m$classes
rforest.m$importance
rforest.m$importanceSD
rforest.m$localImportance
rforest.m$proximity
rforest.m$ntree
rforest.m$mtry

names( rforest.m$forest )

freq( rforest.m$y )

rforest.m$test
rforest.m$inbag

names(attributes(rforest.m$terms))

rforest.m$call
#---------------------------
graphics.off()

plot(rforest.m)


#---------------------------
# 2) Determines variable importance
#     - importance{randomForest} : 
#           Extract variable importance measure
#---------------------------
library(randomForest)

####
# type : either 1 or 2, 
#        specifying the type of importance measure.
#         1 = mean decrease in accuracy, 
#         2 = mean decrease in node impurity
importance(x = rforest.m, type = 2)


#---------------------------
# 3) Classifies new cases
#     - predict{stats} : Model Predictions
#---------------------------
(
  rforest.pred <- 
        predict(object = rforest.m, 
                newdata = df.validate, 
                type = 'response')
)
#---------------------------
class(rforest.pred)
mode(rforest.pred)

freq(rforest.pred)

#---------------------------
# 4) creates a model performance table (cross-tabulation)
#---------------------------
freq(df.validate$class)
freq(rforest.pred)

(
  rforest.pred.perf <- 
          table(df.validate$class, 
                rforest.pred, 
                dnn = c('Actual', 'Predicted'))
)


#-----------------------------------------------
# Compute Predictive Accuracy Indices 
#    using classifier.perf{.Global}
#-----------------------------------------------
source("./Analysis/12-0. Machine.Learning_Classification-0.Predictive.Accuracy.Indices.R")

classifier.perf(rforest.pred.perf)

