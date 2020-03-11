#----------------------------------------------------------
# Machine Learning : Classification 
#
# (2) Decision Tree (의사결정나무)
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
# Classification method : 2-1) Classical Decision Tree
# using rpart{rpart} and prune{rpart}
# - rpart{rpart}  : Recursive Partitioning and Regression Trees
# - prune{rpart}  : Cost-complexity Pruning of an Rpart Object 
# - plotcp{rpart} : Plot a Complexity Parameter Table for an Rpart Fit
#----------------------------------------------------------
library(rpart)

set.seed(1234)

#--------------------
# 1. grows the tree
#--------------------
str(df.train)
(
  dtree.m <- rpart(formula = class ~ ., 
                 data = df.train, 
                 method = 'class', 
                 parms = list(split='informative'))
)
class(dtree.m)
mode(dtree.m)
names(dtree.m)

dtree.m$frame
dtree.m$where
dtree.m$call
dtree.m$terms
dtree.m$cptable
dtree.m$method
dtree.m$parms
dtree.m$control
dtree.m$functions
dtree.m$numresp
dtree.m$splits
dtree.m$variable.importance
dtree.m$y
dtree.m$ordered

summary(dtree.m)

#--------------------
# 2. plot cp (complexity parameters)
#--------------------
graphics.off()

plotcp(dtree.m)

#--------------------
# 3. prune the tree (for selecting a best tree)
#--------------------
(
  pruned.dtree.m <- prune(tree = dtree.m, cp = 0.01000)
)
class(pruned.dtree.m)
mode(pruned.dtree.m)
names(pruned.dtree.m)

pruned.dtree.m$cptable

plotcp(pruned.dtree.m)  # No complex parameter changed

#--------------------
# 4. plotting the selected best tree using rpart.plot{rpart}
#   - rpart.plot{rpart} : Plot an rpart model. 
#             A simplified interface to the prp{rpart.plot}
#   - prp{rpart.plot} : Plot an rpart model.
#--------------------
graphics.off()

library(rpart.plot)

#####
# type - Type of plot. 
# Possible values:
#   0 Default. Draw a split label 
#              at each split and a node label at each leaf.
#   1 Label all nodes, not just leaves. 
#     Similar to text.rpart's all=TRUE.
#   2 Like 1 but draw the split labels below the node labels.
#     Similar to the plots in the CART book.
#   3 Draw separate split labels for the left and right directions.
#   4 Like 3 but label all nodes, not just leaves. 
#     Similar to text.rpart's fancy=TRUE. See also clip.right.labs.
#   5 New in version 2.2.0. 
#     Show the split variable name in the interior nodes.
#
# extra - Display extra information at the nodes. 
#   Possible values:
#     "auto" (case insensitive) -
#       Automatically select a value based on the model type, 
#       as follows:
#         extra=106 - class model with a binary response
#         extra=104 - class model with a response having more than 
#                     two levels
#         extra=100 other models
prp(x = pruned.dtree.m, 
    # type = 0,
    # type = 1,
    # type = 2,  
    # type = 3,
    type = 4,
    # type = 5, 
    extra = 104,
    # extra = 106,
    # extra = 100,
    fallen.leaves = TRUE, 
    main = '- The Best Classical Decision Tree -')
#------------
rpart.plot(x = pruned.dtree.m,  
           # type = 0,  
           # type = 1,  
           type = 2,  
           # type = 3,  
           # type = 4,  
           # type = 5, 
           extra = 104,
           # extra = 106,
           # extra = 100,
           fallen.leaves = TRUE, 
           box.palette = 'auto',
           main = '- The Best Classical Decision Tree -',
           snip = TRUE)

#--------------------
# 5. predict new values using validation set
#--------------------
(
  dtree.pred <- 
    predict(object = pruned.dtree.m, 
            newdata = df.validate, 
            type = 'class')
)
class(dtree.pred)
mode(dtree.pred)

dtree.pred
summary(dtree.pred)

#--------------------
# 6. create a cross-validation table
#--------------------
freq(df.validate$class)
freq(dtree.pred)

(
  dtree.pred.perf 
        <- table(df.validate$class, 
                 dtree.pred, 
                 dnn = c('Actual','Predicted'))
)


#----------------------------------------------------------
# Classification method : 2-2) Conditional Inference Tree
# using ctree{party}
#   - ctree{party}        : Conditional Inference Trees
#   - as.party{partykit}
#----------------------------------------------------------
library(party)

#--------------
# 1) grow a conditional inference tree
#--------------
(
  ctree.m <- ctree(formula = class ~ ., data = df.train)
)
class(ctree.m)
mode(ctree.m)
names(ctree.m)

ctree.m$`1`
ctree.m$`2`
ctree.m$`3`
ctree.m$`4`
ctree.m$`5`
ctree.m$`6`
ctree.m$`7`
ctree.m$`8`
ctree.m$`9`

ctree.m
summary(ctree.m)

#--------------
# 2) plot a conditional inference tree
#--------------
# graphics.off()

plot(ctree.m, 
     main = '- Conditional Inference Tree -')

plot(ctree.m, 
     main = '- Conditional Inference Tree -',
     type='simple')
#--------------
library(partykit)

as.party(pruned.dtree.m)
plot(as.party(pruned.dtree.m), 
     main = '- The conditional inference tree\nof a classical decision tree -')

#--------------
# 3) predict new values using validation set (df.validate)
#--------------
(
  ctree.pred
        <- predict(object = ctree.m, 
                   newdata = df.validate, 
                   type = 'response')
)
class(ctree.pred)

#--------------
# 4) create a performance table for prediction
#--------------
freq(df.validate$class)
freq(ctree.pred)

(
  ctree.pred.perf <- 
    table(df.validate$class, 
          ctree.pred, 
          dnn = c('Actual','Predicted'))
)


#-----------------------------------------------
# Compute Predictive Accuracy Indices 
#    using classifier.perf{.Global}
#-----------------------------------------------
source("./Analysis/12-0. Machine.Learning_Classification-0.Predictive.Accuracy.Indices.R")

classifier.perf(dtree.pred.perf)
classifier.perf(ctree.pred.perf)
