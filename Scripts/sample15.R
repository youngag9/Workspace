# To explore a data frame

rm(list = ls())
cat('\f')



library(readxl)
( df_exam <- read_excel("data/excel_exam.xlsx") )

class(df_exam)
mode(df_exam)
str(df_exam)
dim(df_exam)
summary(df_exam)

head(df_exam)
head(df_exam, 10)

tail(df_exam)
tail(df_exam, 10)

# View(head(df_exam, 50), title = 'df_exam_50')


( attrs <- attributes(df_exam) )   # list - Python's dictionary-like
class(attrs)
str(attrs)

attrs$names
attrs$row.names
attrs$class



