# Pacakge Management

rm(list = ls())
cat('\f')


# 1st. To install new pacakge.
# install.packages('ggplot2')
# install.packages('ggplot2', dependencies = TRUE)
# install.packages('ggplot2', dependencies = T, type = 'source')

# install.packages(c('ggplot2', 'ggplot2movies'))


# 2nd. Update packages
# update.packages()
# update.packages('nlme')
# update.packages(c('devtools', 'DT'))
# update.packages(c('devtools', 'DT'), type = 'source')


# 3rd. Remove specified packages
# remove.packages('ggplot2')
# remove.packages(c('ggplot2', 'ggplot2movies'))


# 4th. Loading a package
# library(ggplot2)

# library(c(ggplot2, ggplot2movies))    # XXX: 'package' must be of length 1


# 5th. Unloading a package.
# detach('package:ggplot2')
# detach('package:ggplot2', unload = T)

