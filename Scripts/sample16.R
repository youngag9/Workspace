# Data Munging

rm(list = ls())
cat('\f')



library(ggplot2)

?mpg

df_mpg <- mpg
df_mpg <- ggplot2::mpg

class(df_mpg)
mode(df_mpg)
str(df_mpg)
dim(df_mpg)
summary(df_mpg)

head(df_mpg)
head(df_mpg, 10)

tail(df_mpg)
tail(df_mpg, 10)

# View(head(df_mpg, 50), title = 'df_mpg_50')


( attrs <- attributes(df_mpg) )   # list - Python's dictionary-like
class(attrs)
str(attrs)

attrs$names
attrs$row.names
attrs$class


# (1) To rename variables

# install.packages('dplyr')
# install.packages('dplyr', dependencies = T)

library(dplyr)

# df_mpg <- rename(df_mpg, cylinder = cyl)

df_mpg <- rename(
  df_mpg,
  cylinder = cyl,
  fuel = fl,
  city = cty,
  highway = hwy,
  transmission = trans,
  displacement = displ,
  drivewheel = drv
)

head(df_mpg, 5)
str(df_mpg)


# (2) To create derived variables

df_mpg$total_avg <- (df_mpg$city + df_mpg$highway) / 2

head(df_mpg, 5)
str(df_mpg)

mean(df_mpg$total_avg)
summary(df_mpg$total_avg)

# hist(x = df_mpg$total_avg)     # hist{graphics}
hist(df_mpg$total_avg)
hist(df_mpg$total_avg, freq = T)  # if freq = T -> Frequency, F -> Density
hist(df_mpg$total_avg, freq = F)  # if freq = T -> Frequency, F -> Density
hist(df_mpg$total_avg, main = 'The histogram of total average', xlab = 'total_avg', ylab = 'frequency')


