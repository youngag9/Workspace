# ex03_dataloading.R

install.packages('readxl', dependencies=TRUE)
library(readxl)
df_exam <- read_excel("Data/excel_exam.xlsx", sheet = "Sheet1")

install.packages('readr', dependencies=TRUE)
library(readr)
df_exam <- read_csv('Data/csv_exam.csv', locale= locale(), trim_ws=TRUE)

df_excel_exam_novar <- read_excel("Data/excel_exam_novar.xlsx",  col_names = FALSE)

View(df_exam)
head(df_exam)
head(df_exam, 10)
tail(df_exam)
tail(df_exam, 10)
View( head(df_exam, 100) )

mean(df_exam$english)
mean(df_exam$science)

write.csv(df_exam, file="Data/df_exam2.csv", fileEncoding='UTF-8')

save(df_exam, file='Data/df_exam2.rda')
load('Data/df_exam2.rda')
