# Data Frame 의 기초통계량 구하기

rm(list = ls())
cat('\f')


( tb_mpg <- ggplot2::mpg ) # tibble
( df_mpg <- as.data.frame(tb_mpg) ) # dataframe


# (1) 요약통계량 구하기
summary(tb_mpg)
summary(df_mpg)


# (2) 특정 변수의 기초통계량 구하기
mean(tb_mpg$cty)
mean(tb_mpg$hwy)
mean(tb_mpg$hwy, na.rm = TRUE)

mean(df_mpg$cty)
mean(df_mpg$hwy, na.rm = TRUE)

var(tb_mpg$cty)
var(tb_mpg$hwy, na.rm = TRUE)

var(df_mpg$cty)
var(df_mpg$hwy, na.rm = TRUE)

sd(tb_mpg$cty)
sd(tb_mpg$hwy)

sd(df_mpg$cty)
sd(df_mpg$hwy)

median(tb_mpg$cty)
median(tb_mpg$hwy)

median(df_mpg$cty)
median(df_mpg$hwy)

min(tb_mpg$cty)
min(tb_mpg$hwy)

min(df_mpg$cty)
min(df_mpg$hwy)

max(tb_mpg$cty)
max(tb_mpg$hwy)

max(df_mpg$cty)
max(df_mpg$hwy)

quantile(tb_mpg$cty)
quantile(tb_mpg$hwy, na.rm = TRUE)
quantile(tb_mpg$hwy, na.rm = TRUE, probs = c(.1, .2, .3, .4, .5, .6, .7, .8, .9, .10))

quantile(df_mpg$cty)
quantile(df_mpg$hwy, na.rm = TRUE)
quantile(df_mpg$hwy, na.rm = TRUE, probs = c(.3, .6, .9))

IQR(tb_mpg$cty)
IQR(tb_mpg$hwy, na.rm = TRUE)

IQR(df_mpg$cty)
IQR(df_mpg$hwy, na.rm = TRUE)


library(e1071)
kurtosis(df_mpg$hwy)  # kurtosis{e1071}
skewness(df_mpg$hwy)  # skewness{e1071}
