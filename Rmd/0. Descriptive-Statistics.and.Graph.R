# Descriptive Statistics and Graph


# --------------------------------------------------------------
# 1. To load a sample data set named 'iris'
# --------------------------------------------------------------
data(iris)



# --------------------------------------------------------------
# 2. To explore sample data set
# --------------------------------------------------------------
class(iris)
str(iris)
head(iris, 10)
tail(iris, 10)
View(iris)
summary(iris)



# --------------------------------------------------------------
# 3. R functions for computing descriptive statistics
# --------------------------------------------------------------



# --------------------------------------------------------------
# 3-1. Measure of central tendency: mean, median, mode
# --------------------------------------------------------------
# Roughly speaking, the central tendency measures the “average” or the “middle” of your data. 
# The most commonly used measures include:
#   (1) the mean  : the average value. It’s sensitive to outliers.
#   (2) the median: the middle value. It’s a robust alternative to mean.
#   (3) the mode  : the most frequent value
# --------------------------------------------------------------

mean(iris$Sepal.Length)
median(iris$Sepal.Length)

require(modeest)
mfv(iris$Sepal.Length)



# --------------------------------------------------------------
# 3-2. Measure of variablity: min, max, range, quantile, IQR
# --------------------------------------------------------------
# Measures of variability gives how “spread out” the data are.
#   (1) the min   : the minimum value
#   (2) the max   : the maximum value
#   (3) the range : corresponds to biggest value minus the smallest value. 
#                   It gives you the full spread of the data.
#   (4) the quantile: Interquartile range(IQR).
#       Recall that, quartiles divide the data into 4 parts. 
#       Note that, the interquartile range (IQR):
#         - corresponding to the difference between the first and third quartiles.
#         - is sometimes used as a robust alternative to the standard deviation.
# --------------------------------------------------------------

min(iris$Sepal.Length)
max(iris$Sepal.Length)
range(iris$Sepal.Length)

# x: numeric vector whose sample quantiles are wanted.
# probs: numeric vector of probabilities with values in [0,1].
# By default, the function returns the minimum, the maximum and 
# three quartiles (the 0.25, 0.50 and 0.75 quartiles).
quantile(x = iris$Sepal.Length)
quantile(iris$Sepal.Length)

quantile(x = iris$Sepal.Length, probs = seq(0, 1, .25))
quantile(iris$Sepal.Length, seq(0, 1, .25))

# To compute deciles (0.1, 0.2, 0.3, …., 0.9), use this:
quantile(x = iris$Sepal.Length, probs = seq(0, 1, .1))
quantile(iris$Sepal.Length, seq(0, 1, .1))

# To compute the interquartile range, type this:
IQR(iris$Sepal.Length)



# --------------------------------------------------------------
# 3-3. Variance and standard deviation: var, sd
# --------------------------------------------------------------
# The variance represents the average squared deviation from the mean.
# The standard deviation is the square root of the variance. 
# It measures the average deviation of the values, in the data, from the mean value.
# --------------------------------------------------------------

# Compute the variance
var(iris$Sepal.Length)

# Compute the standard deviation = square root of th variance
sd(iris$Sepal.Length)



# --------------------------------------------------------------
# 3-4. Median absolute deviation (MAD): mad
# --------------------------------------------------------------
# To measures the deviation of the values, in the data, from the median value.
# --------------------------------------------------------------

# Compute the median
median(iris$Sepal.Length)

# Compute the median absolute deviation
mad(iris$Sepal.Length)



# --------------------------------------------------------------
# 3-5. Computing an overall summary of a variable and an entire data frame: summary
# --------------------------------------------------------------
# The function summary() can be used to display several statistic summaries of 
# either one variable or an entire data frame.
#
# (1) Summary of a single variable : 
#     Five values are returned: the mean, median, 25th and 75th quartiles, min and max
# 
# (2) Summary of a data frame :
#     In this case, the function summary() is automatically applied to each column. 
#     The format of the result depends on the type of the data contained in the column. 
#
#     For example:
#       - If the column is a numeric variable, mean, median, min, max and quartiles are returned.
#       - If the column is a factor variable, the number of observations in each group is returned.
# --------------------------------------------------------------

# Summary of a single variable.
summary(iris$Sepal.Length)

# Summary of a data frame.
summary(iris)


# --------------------------------------------------------------
# 4. Which measure to use?
# --------------------------------------------------------------
# (1) Range
#     It’s not often used because it’s very sensitive to outliers.
# (2) Interquartile range(IQR).
#     It’s pretty robust to outliers. It’s used a lot in combination with the median.
# (3) Variance. 
#     It’s completely uninterpretable because it doesn’t use the same units as the data.
#     It’s almost never used except as a mathematical tool
# (4) Standard deviation.
#     This is the square root of the variance. It’s expressed in the same units as the data.
#     The standard deviation is often used in the situation where the mean is the measure of central tendency.
# (5) Median absolute deviation(MAD). 
#     It’s a robust way to estimate the standard deviation, for data with outliers.
#     It’s not used very often.
#
# *Note* In summary, the IQR and the standard deviation are the two most common measures 
#         used to report the variability of the data.
# --------------------------------------------------------------



# --------------------------------------------------------------
# 5. sapply() function : sapply{base}
# --------------------------------------------------------------
# It’s also possible to use the function sapply() to apply a particular function over a list or vector.
# For instance, we can use it, to compute for each column in a data frame:
#   the mean, sd, var, min, quantile, …
# --------------------------------------------------------------

# Compute the mean of each column
sapply(iris[ , -5], mean)
sapply(iris[-5], median)
sapply(iris[-5], sd)
sapply(iris[-5], var)
sapply(iris[-5], summary)

# Compute quartiles
sapply(iris[-5], quantile)
sapply(iris[-5], quantile, probs = seq(0, 1, .1))
sapply(iris[-5], quantile, probs = seq(0, 1, .05))



# --------------------------------------------------------------
# 6. stat.desc() function : stat.desc{pastecs}
# --------------------------------------------------------------
# To provides other useful statistics including:
#  
#   (1) the median
#   (2) the mean
#   (3) the standard error on the mean (SE.mean)
#   (4) the confidence interval of the mean (CI.mean) at the p level (default is 0.95)
#   (5) the variance (var)
#   (6) the standard deviation (std.dev)
#   (7) the variation coefficient (coef.var) defined as the standard deviation divided by the mean
# --------------------------------------------------------------

# Compute descriptive statistics
require(pastecs)
stat.desc(iris[-5])



# --------------------------------------------------------------
# 7. Case of missing values
# --------------------------------------------------------------
# * Note* that, when the data contains missing values, 
#   some R functions will return errors or NA even if just a single value is missing.
#
# For example, the mean() function will return NA if even only one value is missing in a vector. 
# This can be avoided using the argument na.rm = TRUE, 
# which tells to the function to remove any NAs before calculations.
# -------------------------------------------------------------- 

# An example using the mean function is as follow:
mean(iris$Sepal.Length, na.rm = TRUE)



# -------------------------------------------------------------- 
# 8. Graphical display of distributions using {ggpubr} package.
# -------------------------------------------------------------- 


# -------------------------------------------------------------- 
# 8-1. Installation and loading ggpubr
# -------------------------------------------------------------- 

# (1) Install the latest version from GitHub as follow:
# if(!require(devtools)) install.packages("devtools")
# devtools::install_github("kassambara/ggpubr")

# (2) Or, install from CRAN as follow:
# install.packages("ggpubr")

# Load ggpubr as follow:
require(ggpubr)



# -------------------------------------------------------------- 
# 8-2. Box plots
# --------------------------------------------------------------

ggboxplot(iris, y = "Sepal.Length", width = 0.5)



# -------------------------------------------------------------- 
# 8-3. Histogram
# --------------------------------------------------------------
# Histograms show the number of observations that fall within specified divisions (i.e., bins)
# --------------------------------------------------------------

# Histogram plot of Sepal.Length with mean line (dashed line).
# should be one of “none”, “mean”, “median”
gghistogram(iris, x = "Sepal.Length", bins = 9, add = "mean")
gghistogram(iris, x = "Sepal.Length", bins = 20, add = "mean", color='red')
gghistogram(iris, x = "Sepal.Length", bins = 30, add = "mean", fill = 'lightgray')
gghistogram(iris, x = "Sepal.Length", bins = 50, add = "none")
gghistogram(iris, x = "Sepal.Length", bins = 50, add = "median", rug = T)
gghistogram(iris, x = "Sepal.Length", bins = 10, rug = T, add_density = T)



# --------------------------------------------------------------
# 8-4. Empirical cumulative distribution function (ECDF)
# --------------------------------------------------------------
# ECDF is the fraction of data smaller than or equal to x. 
# --------------------------------------------------------------

ggecdf(iris, x = "Sepal.Length")



# --------------------------------------------------------------
# 8-5. Q-Q plots
# --------------------------------------------------------------
# QQ plots is used to check whether the data is normally distributed. 
# --------------------------------------------------------------

ggqqplot(iris, x = "Sepal.Length")


# Shapiro-Wilk normality test
shapiro.test(iris$Sepal.Length)


# --------------------------------------------------------------
# 9. Descriptive statistics by groups 
# --------------------------------------------------------------
# To compute summary statistics by groups, 
# the functions group_by() and summarise() [in dplyr package] can be used.
#
# We want to group the data by Species and then:
#   compute the number of element in each group.
#   R function: n() compute the mean.
#   R function mean() and the standard deviation. R function sd()
# --------------------------------------------------------------
# The function %>% is used to chaine operations.
# --------------------------------------------------------------

# install.packages("dplyr")
require(dplyr)

# Descriptive statistics by groups:
group_by(iris, Species) %>% 
  summarise(
    count = n(), 
    mean = mean(Sepal.Length, na.rm = TRUE),
    sd = sd(Sepal.Length, na.rm = TRUE)
  )



# --------------------------------------------------------------
# 9-1. Graphics for grouped data:
# --------------------------------------------------------------

require(ggpubr)

# Box plot colored by groups: Species
ggboxplot(
  iris, x = "Species", y = "Sepal.Length", 
  color = "Species", palette = c("#00AFBB", "#E7B800", "#FC4E07")
)

# Stripchart colored by groups: Species
# * Note * that, when the number of observations per groups is small, 
# it’s recommended to use strip chart compared to box plots.
ggstripchart(
  iris, x = "Species", y = "Sepal.Length",
  color = "Species", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
  # add = "none"
  # add = "dotplot"
  # add = "jitter"
  # add = "boxplot"
  # add = "point"
  # add = "mean"
  # add = "mean_se"
  add = "mean_sd"
  # add = "mean_ci"
  # add = "mean_range"
  # add = "median"
  # add = "median_iqr"
  # add = "median_mad"
  # add = "median_range"
)



# --------------------------------------------------------------
# 10. Frequency tables
# --------------------------------------------------------------
# A frequency table (or contingency table) is used to describe categorical variables.
# It contains the counts at each combination of factor levels.
#
# R function to generate tables: table()
# --------------------------------------------------------------

data(HairEyeColor)

str(HairEyeColor)
View(HairEyeColor)

# Hair/eye color data
df <- as.data.frame(HairEyeColor)
View(df)

row.names(df)
df$Freq
rep(row.names(df), df$Freq)


hair_eye_col <- df[rep(row.names(df), df$Freq), 1:3]
rownames(hair_eye_col) <- 1:nrow(hair_eye_col)

str(hair_eye_col)
View(hair_eye_col)


# hair/eye variables
( Hair <- hair_eye_col$Hair )
( Eye <- hair_eye_col$Eye )



# --------------------------------------------------------------
# 10-1. Simple frequency distribution: one categorical variable
# --------------------------------------------------------------

# Table of counts

# Frequency distribution of hair color
table(Hair)

# Frequency distribution of eye color
table(Eye)


# Graphics: to create the graphics, 
# we start by converting the table as a data frame.

# Compute table and convert as data frame
( df <- as.data.frame(table(Hair)) )

# Visualize using bar plot
require(ggpubr)

ggbarplot(df, x = "Hair", y = "Freq")



# --------------------------------------------------------------
# 10-2. Two-way contingency table: Two categorical variables
# --------------------------------------------------------------

# (1) Compute table
( tbl2 <- table(Hair , Eye) )

# It’s also possible to use the function xtabs{stats}, 
# which will create cross tabulation of data frames with a formula interface.
# tbl2 <- xtabs(~Hair + Eye, data = hair_eye_col)

# (2) for testing independence ... chisq-square test
summary(tbl2)

# (3) to create the graphics,
# we start by converting the table as a data frame.
df <- as.data.frame(tbl2)
View(df)

# (4) Graphics: Visualize using bar plot
require(ggpubr)

ggbarplot(df, x = "Hair", y = "Freq", 
          color = "Eye", palette = c("brown", "blue", "gold", "green"))

# position dodge
ggbarplot(df, x = "Hair", y = "Freq", 
          color = "Eye", palette = c("brown", "blue", "gold", "green"),
          position = position_dodge())


# --------------------------------------------------------------
# 10-3. Multiway tables: More than two categorical variables
# --------------------------------------------------------------

# (1) Hair and Eye color distributions by sex using xtabs():

xtabs( ~Hair + Eye + Sex, data = hair_eye_col )


# (2) You can also use the function ftable() [for flat contingency tables].
#     It returns a nice output compared to xtabs() 
#     when you have more than two variables:

ftable(Sex + Hair ~ Eye, data = hair_eye_col)



# --------------------------------------------------------------
# 10-4. Compute table margins and relative frequency
# --------------------------------------------------------------
# Table margins correspond to the sums of counts along rows or columns of the table.
# Relative frequencies express table entries as proportions of table margins (i.e., row or column totals).
# --------------------------------------------------------------
# The function margin.table() and prop.table() can be used 
# to compute table margins and relative frequencies, respectively.
#
# Format of the functions:
#  
#   margin.table(x, margin = NULL)
#   prop.table(x, margin = NULL)
#
#   x: table
#   margin: index number (1 for rows and 2 for columns)
# --------------------------------------------------------------

( Hair <- hair_eye_col$Hair )
( Eye <- hair_eye_col$Eye )

# Hair/Eye color table
( he.tbl <- table(Hair, Eye) )


# (1) compute table margins:

# Margin of rows
margin.table(he.tbl, 1)

# Margin of columns
margin.table(he.tbl, 2)


# (2) Compute relative frequencies:

# Frequencies relative to row total
prop.table(he.tbl, 1)

# Table of percentages
round(prop.table(he.tbl, 1), 2) * 100


# (3) To express the frequencies relative to the grand total,
# use this:
sum(he.tbl)

he.tbl/sum(he.tbl)


