# How to create a data frame or tibble(simple data frame) object

rm(list = ls())
cat('\f')



( eng <- c(90, 80, 60, 70) )
( math <- c(50, 60, 100, 20) )
( class <- c(1, 1, 2, 2))


# To create a data frame
# ( df_midterm <- data.frame(eng, math) )
# ( df_midterm <- data.frame(eng, math, class) )


rm(list = c('eng', 'math', 'class'))

( df_midterm <- data.frame(
    eng = c(90, 80, 60, 70),
    math = c(50, 60, 100, 20),
    class = c(1, 1, 2, 2)
) )

class(df_midterm)
mode(df_midterm)
str(df_midterm)
head(df_midterm)
head(df_midterm, 10)
tail(df_midterm)
tail(df_midterm, 10)
dim(df_midterm)
summary(df_midterm)

View(df_midterm)



# To create a tibble
library(tibble)
# ( tb_midterm <- tibble(eng, math) ) 


rm(list = c('eng', 'math', 'class'))

( tb_midterm <- tibble(
    eng = c(90, 80, 60, 70),
    math = c(50, 60, 100, 20),
    class = c(1, 1, 2, 2)
) )


class(tb_midterm)
mode(tb_midterm)
str(tb_midterm)
head(tb_midterm)
head(tb_midterm, 10)
tail(tb_midterm)
tail(tb_midterm, 10)
dim(df_midterm)
summary(df_midterm)

View(tb_midterm)





