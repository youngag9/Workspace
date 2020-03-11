#----------------------------------------------------------
# Machine Learning : Classification 
#
# (1) Logistic Regression Analysis
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
# Classification method - 1) Logistic Regression Analysis
# using glm{stats}
#----------------------------------------------------------
(
  logit.m <- glm(formula = class ~ ., 
                 data = df.train, 
                 family = binomial())
)

# Choose a model by AIC in a Stepwise Algorithm
( logit.m <-
    step(object = logit.m,
         direction = 'both',
         steps = 1000,
         scale = 0,
         trace = +1) )
#------------------
class(logit.m)
mode(logit.m)
names(logit.m)

logit.m$coefficients
logit.m$residuals
logit.m$fitted.values
logit.m$effects
logit.m$R
logit.m$rank

class(logit.m$qr)
mode(logit.m$qr)
names(logit.m$qr)
logit.m$qr

logit.m$family
logit.m$linear.predictors
logit.m$deviance
logit.m$aic
logit.m$null.deviance
logit.m$iter
logit.m$weights
logit.m$prior.weights
logit.m$df.residual
logit.m$df.null
logit.m$y
logit.m$converged
logit.m$boundary
logit.m$model
logit.m$na.action
logit.m$call
logit.m$formula
logit.m$terms
logit.m$data
logit.m$offset

class(logit.m$control)
mode(logit.m$control)
names(logit.m$control)
logit.m$control

logit.m$method
logit.m$contrasts
logit.m$xlevels
#------------------
logit.m
summary(logit.m)
#------------------
graphics.off()
op <- par(mfrow=c(2,2))

plot(logit.m)

par(op)
#------------------
( 
  probs <- predict(object = logit.m,
                  newdata = df.validate,
                  type = 'response')
)

(
  logit.pred <- factor(x = probs > .5, 
                       levels = c(FALSE, TRUE), 
                       labels = c('benign', 'malignant'))
)

#---------------------------
# Create a logit model predictive preformance table 
#    using table{base}
#---------------------------
freq(df.validate$class)
freq(logit.pred)

(
  logit.pref <- 
    table(df.validate$class, 
          logit.pred, 
          dnn = c('Actual', 'Predicted'))
)

View(
  data.frame(
    probs=probs, 
    predicted=logit.pred,
    actual=df.validate$class
  )
)


#-----------------------------------------------
# Compute Predictive Accuracy Indices 
#    using classifier.perf{.Global}
#-----------------------------------------------
source("./Analysis/12-0. Machine.Learning_Classification-0.Predictive.Accuracy.Indices.R")

classifier.perf(logit.pref)


