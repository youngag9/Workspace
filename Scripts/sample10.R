# How to use a function in the specified package

rm(list = ls())
cat('\f')


library(ggplot2)

?qplot


( vec <- c(1,1,1,2,3,3,4,4,4,4,7,8,9,0,0) )
table(vec)     # table{base}
qplot(vec, bins = 8)     # qplot{ggplot2}


( vec <- c('a','a','b','c','c','c'))
table(vec)    # table{base}
qplot(vec)    # qplot{ggplot2}


( mtcars <- datasets::mtcars )

qplot(data = mtcars, x = mpg, y = wt)  # default, scatterplot

qplot(data = mtcars, x = mpg, y = wt, color = cyl)
qplot(data = mtcars, x = mpg, y = wt, color = I('red'))

qplot(data = mtcars, x = mpg, y = wt, size = wt)
qplot(data = mtcars, x = mpg, y = wt, color = cyl, size = wt)
qplot(data = mtcars, x = mpg, y = wt, color = I('red'), size = wt)
qplot(data = mtcars, x = mpg, y = wt, color = cyl, size = wt, xlab = 'mpg', ylab = 'weight' )

# just x supplied = histogram
qplot(data = mtcars, x = mpg)
qplot(data = mtcars, x = cyl)

# just y supplied = scatterplot, with x = seq_along(y)
qplot(data = mtcars, y = mpg)

# Use different geoms
qplot(data = mtcars, x = mpg, y = wt)
qplot(data = mtcars, x = mpg, y = wt, geom = 'path')
qplot(data = mtcars, x = cyl, y = wt, geom = c('boxplot', 'jitter'))
qplot(data = mtcars, x = cyl, y = wt, geom = c('boxplot', 'jitter'), color = cyl)
qplot(data = mtcars, x = cyl, y = wt, geom = c('boxplot', 'jitter'), color = cyl, size = wt)
qplot(data = mtcars, x = mpg, geom = 'dotplot')




detach('package:ggplot2', unload = TRUE)
