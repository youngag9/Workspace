#----------------------------------------------------------
# Machine Learning : Classification 
#
# (4) Support Vector Machines (SVMs)
#     Support Vector Machines are an excellent tool 
#     for classification, novelty detection, and regression.
#
#     - using ksvm{kernlab} : Support Vector Machines
#     - using svm{e1071} : Support Vector Machines
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
# Classification method : 4) Support Vector Machines (SVMs)
# using svm{e1071} : Support Vector Machines
#     This is used to train a support vector machine. 
#     It can be used to carry out general regression and 
#     classification.
#----------------------------------------------------------
set.seed(1234)

#---------------------------
# 4-1-1) fitting SVM model using svm{e1071}
#---------------------------
library(e1071)

(
  svm.m <- svm(formula = class ~ ., 
               data = df.train, 
               scale = TRUE, # default
               na.action = na.omit, # default
               # gamma = 0.25,  # default gamma = (1 / n of predictors)
               cost = 1       # default cost = 1
            )
)
summary(svm.m)
fitted(svm.m)

library(prettyR)
freq(fitted(svm.m))
#---------------------------
class(svm.m)
mode(svm.m)
names(svm.m)

svm.m$call
svm.m$type
svm.m$kernel
svm.m$degree
svm.m$gamma
svm.m$coef0
svm.m$nu
svm.m$epsilon
svm.m$sparse
svm.m$scaled

class(svm.m$x.scale)
names(svm.m$x.scale)
svm.m$x.scale

svm.m$y.scale
svm.m$nclasses
svm.m$levels
svm.m$tot.nSV
svm.m$nSV
svm.m$labels

str(svm.m$SV)
svm.m$SV

svm.m$index
svm.m$rho
svm.m$compprob
svm.m$probA
svm.m$probB
svm.m$sigma
svm.m$coefs
svm.m$na.action
class(svm.m$fitted)

library(prettyR)
freq(svm.m$fitted)

head( svm.m$decision.values )

class(svm.m$terms)
mode(svm.m$terms)
attributes(svm.m$terms)

#---------------------------
# 4-1-2) predict new classes using predict{stats} through SVM model 
#---------------------------
(
  # SVM cannot accept NA's when predicting.
  # So na.omit{stats} needed to new validating data
  svm.pred <- 
      predict(object = svm.m, 
              newdata = na.omit(df.validate),
              # type="probabilities"  # output : factor
              # type="response"       # output : factor
              # type="votes"          # output : factor
              # type="decision"       # output : factor
          )
)
class(svm.pred)
summary(svm.pred)
table(svm.pred)

#---------------------------
# 4-1-3) create a SVM model preformance cross-tabulation 
#    using table{base}
#---------------------------
library(prettyR)
freq(na.omit(df.validate)$class)
freq(svm.pred)

(
  svm.perf <- 
      table(na.omit(df.validate)$class, # caution: na.omit{stats}
            svm.pred, 
            dnn = c('Actual','Predicted'))
)


#---------------------------
# 4-2-1) fitting SVM model using ksvm{kernlab}
#---------------------------
data(iris)
str(iris)

set.seed(1234)
#---------------------------
# create a kernel function 
# using the built-in rbfdot{kernlab} :
#       Radial Basis kernel "Gaussian"
#---------------------------
library(kernlab)

( rbf <- rbfdot(sigma=0.1) )
class(rbf); mode(rbf); attributes(rbf)
#---------------------------
# create a SVM model using the ksvm{kernlab}
#---------------------------
library(kernlab)
(
  ksvm.m <- 
      ksvm(Species~.,      # formula
           data=iris,
           type="C-bsvc",  # bound-constraint classification
           kernel=rbf,     # set a kernel function
           C=10,           # cost of constraints violation (default: 1)
           prob.model=TRUE # if set to TRUE, 
                           # builds a model 
                           # for calculating class probabilities
        )
)
summary(ksvm.m)
fitted(ksvm.m)
#---------------------------
class(ksvm.m); mode(ksvm.m); attributes(ksvm.m)
attributes(ksvm.m)

#---------------------------
# 4-2-2) test on the training set with probabilities as output
#        using predict{stats}
#---------------------------
(
  ksvm.pred <- 
    predict(ksvm.m, 
            na.omit(iris[,-5]), 
            # type="probabilities"  # output : matrix with probabilities
            type="response"       # output : factor
            # type="votes"          # output : matrix with vote result
            # type="decision"       # output : matrix with 
          )
)
class(ksvm.pred)

summary(ksvm.pred)
table(ksvm.pred)

#---------------------------
# 4-2-3) create a SVM model preformance cross-tabulation 
#    using table{base}
#---------------------------
library(prettyR)
freq(na.omit(iris)$Species)
freq(ksvm.pred)

(
  ksvm.perf <- 
    table(na.omit(iris)$Species, # caution: na.omit{stats}
          ksvm.pred, 
          dnn = c('Actual','Predicted'))
)


#----------------------------------------------------------
# SVM model tunning using tune.svm{e1071} :
#     Convenience Tuning Wrapper Functions
#
# Search & Determine the best 'gamma', 'cost' parameter values
# using 'grid search'
#
# ref. : tune.wrapper{e1071}
#----------------------------------------------------------
library(e1071)

set.seed(1234)

(
  # creates total 168 models (8 x 21) and compare all models
  # according to the range of gamma, cost values
  #
  # set range for a best 'gamma' parameter
  #      8-values : 0.000001 ~ 10.000000  
  #
  # set range for a best 'cost' parameter
  #      21-values : 0.0000000001 ~ 10000000000.0000000000
  svm.tuned.m <- 
          tune.svm(class ~ ., 
                   data = df.train, 
                   gamma = 10^(-6:1),
                   cost = 10^(-10:10))
)
#----------------------------
class(svm.tuned.m)
mode(svm.tuned.m)
names(svm.tuned.m)

svm.tuned.m$best.parameters   # *****
svm.tuned.m$best.performance  # ****
svm.tuned.m$method
svm.tuned.m$nparcomb          # **
class(svm.tuned.m$train.ind)
svm.tuned.m$sampling          # ***

svm.tuned.m$performances      # *****
class(svm.tuned.m$performances)
str(svm.tuned.m$performances)

svm.tuned.m$best.model        # ***
class(svm.tuned.m$best.model) 
mode(svm.tuned.m$best.model)
names(svm.tuned.m$best.model)

#----------------------------
# Re-fitting the best model 
# depending on determined gamma, cost parameters
#----------------------------
(
  svm.best.m <- 
          svm(formula = class ~ ., 
              data = df.train,
              scale = TRUE,        # default
              na.action = na.omit, # default
              gamma = 0.01, 
              cost = 1)
)
summary(svm.best.m)
fitted(svm.best.m)

library(prettyR)
freq(df.train$class)
freq(fitted(svm.best.m))

#---------------------------
# Predict new classes using predict{stats} 
# through new best SVM model 
#---------------------------
(
  # SVM cannot accept NA's when predicting.
  # So na.omit{stats} needed to new validating data
  svm.best.pred <- 
          predict(object = svm.best.m, 
                  newdata = na.omit(df.validate),
                  # type="probabilities"  # output : factor
                  type="response"       # output : factor
                  # type="votes"          # output : factor
                  # type="decision"       # output : factor
          )
)
class(svm.best.pred)
summary(svm.best.pred)
table(svm.best.pred)


#-----------------------------------------------
# Create a SVM model predictive preformance table 
#    using table{base}
#-----------------------------------------------
library(prettyR)
freq(na.omit(df.validate)$class)
freq(svm.best.pred)

(
  svm.best.perf <- 
    table(na.omit(df.validate)$class, # caution: na.omit{stats}
          svm.best.pred, 
          dnn = c('Actual','Predicted'))
)


#-----------------------------------------------
# Compute Predictive Accuracy Indices 
#    using classifier.perf{.Global}
#-----------------------------------------------
source("./Analysis/12-0. Machine.Learning_Classification-0.Predictive.Accuracy.Indices.R")

classifier.perf(svm.perf)
classifier.perf(svm.best.perf)

#Error in classifier.perf(ksvm.perf) : 
#  'ksvm.perf' dimension should be (2x2).
classifier.perf(ksvm.perf)   # (3x3) dimension
