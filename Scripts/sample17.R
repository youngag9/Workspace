# Conditional Statement: ifelse{base} function

rm(list = ls())
cat('\f')


df_mpg <- ggplot2::mpg

df_mpg$total <- (df_mpg$cty + df_mpg$hwy) / 2
head(df_mpg)
View(df_mpg)

?boxplot
( boxplot(df_mpg$total) )

mean(df_mpg$total)


df_mpg$total
logical_vec <- ifelse(df_mpg$total >= 20, T, F)

class(logical_vec)
str(logical_vec)

table(logical_vec)

df_mpg$test <- logical_vec
df_mpg


df_mpg$test <- ifelse(df_mpg$total >= 20, 'P', 'F')
df_mpg

table(df_mpg$test)
