# To manipulate a data frame (or tibble)

rm(list = ls())
cat('\f')


# mpg{ggplot2}
library(ggplot2)


# for a tibble
( tb_mpg <- mpg )
# ( tb_mpg <- ggplot2::mpg )

class(tb_mpg)
mode(tb_mpg)
str(tb_mpg)
head(tb_mpg)
head(tb_mpg, 10)
tail(tb_mpg)
tail(tb_mpg, 10)
dim(tb_mpg)
summary(tb_mpg)

View(tb_mpg)
View(tb_mpg, 'tibble mpg')
View(head(tb_mpg, 100))


tb_mpg$manufacturer
tb_mpg$model
tb_mpg$displ
tb_mpg$year
tb_mpg$cyl
tb_mpg$trans
tb_mpg$drv
tb_mpg$cty
tb_mpg$hwy
tb_mpg$fl
tb_mpg$class

class(tb_mpg$class)
mode(tb_mpg$class)
str(tb_mpg$class)
head(tb_mpg$class)
head(tb_mpg$class, 10)
tail(tb_mpg$class)
tail(tb_mpg$class, 10)
dim(tb_mpg$class)
summary(tb_mpg$class)

View(tb_mpg$class)
View(head(tb_mpg$class, 100))


# for a data frame.
# ( df_mpg <- as.data.frame(ggplot2::mpg) )
( df_mpg <- as.data.frame(tb_mpg) )

class(df_mpg)
mode(df_mpg)
str(df_mpg)
head(df_mpg)
head(df_mpg, 10)
tail(df_mpg)
tail(df_mpg, 10)
dim(df_mpg)
summary(df_mpg)

View(df_mpg)
View(head(df_mpg, 100))


df_mpg$manufacturer
df_mpg$model
df_mpg$displ
df_mpg$year
df_mpg$cyl
df_mpg$trans
df_mpg$drv
df_mpg$cty
df_mpg$hwy
df_mpg$fl
df_mpg$class
