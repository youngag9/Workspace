options(max.print = 99999)
options(scipen = 99)

#--------------------------------------------------------------------#
# Create a Univariate Time-series Object of zoo
#--------------------------------------------------------------------#

library(zoo)
zoo.ts <- zoo(df_grpByTS.v1['order_cnt'], order.by = df_grpByTS.v1$sess_dt)

class(zoo.ts)
str(zoo.ts)
dim(zoo.ts)
names(zoo.ts)

zoo.ts

head(zoo.ts)
tail(zoo.ts)

start(zoo.ts)
end(zoo.ts)
frequency(zoo.ts)

index(zoo.ts)
coredata(zoo.ts)

#--------------------------------------------------------------------#

class(index(zoo.ts))
index(zoo.ts)

class(coredata(zoo.ts))
coredata(zoo.ts)

start(zoo.ts)
end(zoo.ts)
end(zoo.ts) - start(zoo.ts)

frequency(zoo.ts)

#--------------------------------------------------------------------#

zoo.window.ts <- window(zoo.ts, start = as.Date('2018-05-05'), end = as.Date('2018-05-18'))
class(zoo.window.ts)
str(zoo.window.ts)
dim(zoo.window.ts)
names(zoo.window.ts)

zoo.window.ts

head(zoo.window.ts)
tail(zoo.window.ts)

start(zoo.window.ts)
end(zoo.window.ts)
frequency(zoo.window.ts)

index(zoo.window.ts)
coredata(zoo.window.ts)

#--------------------------------------------------------------------#

library(xts)
first(zoo.ts, 'week')
first(zoo.ts, '1 week')
first(zoo.ts, '1 weeks')
first(zoo.ts, '2 week')
first(zoo.ts, '2 weeks')
first(zoo.ts, 'month')
first(zoo.ts, '1 month')
first(zoo.ts, '1 months')
first(zoo.ts, '2 months')

last(zoo.ts, 'week')
last(zoo.ts, '1 week')
last(zoo.ts, '1 weeks')
last(zoo.ts, '2 week')
last(zoo.ts, '2 weeks')
last(zoo.ts, 'month')
last(zoo.ts, '1 month')
last(zoo.ts, '1 months')
last(zoo.ts, '2 months')

#--------------------------------------------------------------------#

library(xts)
xts.ts <- as.xts(zoo.ts)

class(xts.ts)
str(xts.ts)

xts.ts

head(xts.ts)
tail(xts.ts)

start(xts.ts)
end(xts.ts)
frequency(xts.ts)

index(xts.ts)
coredata(xts.ts)

first(xts.ts, 'week')
first(xts.ts, '1 week')
first(xts.ts, '1 weeks')
first(xts.ts, '2 week')
first(xts.ts, '2 weeks')
first(xts.ts, 'month')
first(xts.ts, '1 month')
first(xts.ts, '1 months')
first(xts.ts, '2 months')

last(xts.ts, 'week')
last(xts.ts, '1 week')
last(xts.ts, '1 weeks')
last(xts.ts, '2 week')
last(xts.ts, '2 weeks')
last(xts.ts, 'month')
last(xts.ts, '1 month')
last(xts.ts, '1 months')
last(xts.ts, '2 months')

xts.window.ts <- window(xts.ts, start = as.Date('2018-05-05'), end = as.Date('2018-05-18'))
class(xts.window.ts)
str(xts.window.ts)
dim(xts.window.ts)
names(xts.window.ts)

xts.window.ts

head(xts.window.ts)
tail(xts.window.ts)

start(xts.window.ts)
end(xts.window.ts)
frequency(xts.window.ts)

index(xts.window.ts)
coredata(xts.window.ts)

#--------------------------------------------------------------------#
# Create daily time-series object : zoo
#--------------------------------------------------------------------#

prices <- c(132.45, 130.85, 130.00, 129.55, 130.85)
# dates <- c('2010-01-04', '2010-01-05', '2010-01-06', '2010-01-07', '2010-01-08')
dates <- as.Date(c('2010-01-04', '2010-01-05', '2010-01-06', '2010-01-07', '2010-01-08'))

ibm.daily <- zoo(x = prices, order.by = dates)

class(ibm.daily)
str(ibm.daily)
dim(ibm.daily)
names(ibm.daily)

ibm.daily

head(ibm.daily)
tail(ibm.daily)

start(ibm.daily)
end(ibm.daily)
frequency(ibm.daily)

index(ibm.daily)
coredata(ibm.daily)

#--------------------------------------------------------------------#
# Create secondly time-series object : zoo
# 1 second = 0.0002778 hour
#--------------------------------------------------------------------#

prices <- c(131.18, 131.20, 131.17, 131.15, 131.17)
seconds <- c(9.5, 9.500278, 9.500556, 9.500833, 9.501111)

ibm.sec <- zoo(prices, order.by = seconds)

class(ibm.sec)
str(ibm.sec)
dim(ibm.sec)
names(ibm.sec)

ibm.sec

head(ibm.sec)
tail(ibm.sec)

start(ibm.sec)
end(ibm.sec)
frequency(ibm.sec)

index(ibm.sec)
coredata(ibm.sec)

#--------------------------------------------------------------------#
# Create a Multivariate Time-series Object of zoo
#--------------------------------------------------------------------#

mv.zoo.ts <- zoo(df_grpByTS.v1[-1], order.by = df_grpByTS.v1$sess_dt)

class(mv.zoo.ts)
str(mv.zoo.ts)
dim(mv.zoo.ts)
names(mv.zoo.ts)

mv.zoo.ts

head(mv.zoo.ts)
tail(mv.zoo.ts)

start(mv.zoo.ts)
end(mv.zoo.ts)
frequency(mv.zoo.ts)

class(index(mv.zoo.ts))
index(mv.zoo.ts)

class(coredata(mv.zoo.ts))
coredata(mv.zoo.ts)

first(mv.zoo.ts, 'week')
first(mv.zoo.ts, '1 week')
first(mv.zoo.ts, '1 weeks')
first(mv.zoo.ts, '2 week')
first(mv.zoo.ts, '2 weeks')
first(mv.zoo.ts, 'month')
first(mv.zoo.ts, '1 month')
first(mv.zoo.ts, '1 months')
first(mv.zoo.ts, '2 months')

last(mv.zoo.ts, 'week')
last(mv.zoo.ts, '1 week')
last(mv.zoo.ts, '1 weeks')
last(mv.zoo.ts, '2 week')
last(mv.zoo.ts, '2 weeks')
last(mv.zoo.ts, 'month')
last(mv.zoo.ts, '1 month')
last(mv.zoo.ts, '1 months')
last(mv.zoo.ts, '2 months')

#--------------------------------------------------------------------#

mv.zoo.window.ts <- window(mv.zoo.ts, start = as.Date('2018-05-05'), end = as.Date('2018-05-18'))

class(mv.zoo.window.ts)
str(mv.zoo.window.ts)
dim(mv.zoo.window.ts)
names(mv.zoo.window.ts)

mv.zoo.window.ts

head(mv.zoo.window.ts)
tail(mv.zoo.window.ts)

start(mv.zoo.window.ts)
end(mv.zoo.window.ts)
frequency(mv.zoo.window.ts)

class(index(mv.zoo.window.ts))
index(mv.zoo.window.ts)

class(coredata(mv.zoo.window.ts))
coredata(mv.zoo.window.ts)

#--------------------------------------------------------------------#

vignette('zoo')
vignette('xts')

#--------------------------------------------------------------------#
# Visualize a Time-series Object of ts, zoo, xts
#--------------------------------------------------------------------#
str(zoo.ts)

plot(
  zoo.ts,
  plot.type = 'single',
  screens = seq_len(ncol(zoo.ts)),
  col = seq_len(ncol(zoo.ts)),
  lty = c('dotted'),
  xlab = 'Index',
  ylab = 'order_cnt',
  main = 'A univariate zoo time-series object')

legend(
  'bottomleft',
  legend = seq_len(ncol(zoo.ts)),
  lty = seq_len(ncol(zoo.ts)))


str(mv.zoo.ts)

plot(
  mv.zoo.ts,
  plot.type = 'multiple',
  screens = seq_len(ncol(mv.zoo.ts)),
  col = seq_len(ncol(mv.zoo.ts)),
  lty = c('dotted','solid','dashed'),
  xlab = 'Index',
  ylab = names(mv.zoo.ts),
  main = 'A multivariate zoo time-series object')

legend(
  'bottomright',
  legend = seq_len(ncol(mv.zoo.ts)),
  lty = seq_len(ncol(mv.zoo.ts)))

plot(
  mv.zoo.ts,
  plot.type = 'single',
  screens = 1,
  col = seq_len(ncol(mv.zoo.ts)),
  lty = c('dotted','solid','dashed'),
  xlab = 'Index',
  ylab = names(mv.zoo.ts),
  main = 'A multivariate zoo time-series object')


names(mv.zoo.ts)
v2.zoo.ts <- mv.zoo.ts[, c('order_cnt','act_order')]
plot(
  v2.zoo.ts,
  plot.type = 'multiple',
  screens = seq_len(ncol(v2.zoo.ts)),
  lty = c('dotted','dotted'),
  col = seq_len(ncol(v2.zoo.ts)) )

plot(
  v2.zoo.ts,
  plot.type = 'multiple',
  screens = 1,
  lty = c('dotted','solid'),
  col = seq_len(ncol(v2.zoo.ts)) )

plot(
  v2.zoo.ts,
  plot.type = 'single',
  screens = 1,
  lty = c('dotted','solid'),
  col = seq_len(ncol(v2.zoo.ts)) )

#--------------------------------------------------------------------#
# Create a subset of time-series object
#--------------------------------------------------------------------#
window(mv.zoo.ts, start = as.Date('2018-07-17'), end = as.Date('2018-07-28'))

mv.zoo.ts[1]
mv.zoo.ts[2]
mv.zoo.ts[1:10]
mv.zoo.ts[as.Date('2018-07-17')]

( dates <- seq(as.Date('2018-07-17'), as.Date('2018-07-28'), by = 1) )
# ( dates <- seq(as.Date('2018-07-17'), as.Date('2018-07-28'), by = 2) )
# ( dates <- seq(as.Date('2018-07-17'), as.Date('2018-07-28'), by = 3) )
mv.zoo.ts[dates]

ibm.daily
ibm.daily[1]
ibm.daily[2:4]
ibm.daily[as.Date('2010-01-05')]

( dates <- seq(as.Date('2010-01-01'), as.Date('2010-01-07'), by = 1) )
( dates <- seq(as.Date('2010-01-01'), as.Date('2010-01-07'), by = 2) )
( dates <- seq(as.Date('2010-01-01'), as.Date('2010-01-07'), by = 3) )
ibm.daily[dates]

#--------------------------------------------------------------------#
# Merge two time-series objects
#--------------------------------------------------------------------#

( zoo.ts1 <- zoo(1:9,   order.by = seq(as.Date('1970-01-02'), as.Date('1970-01-10'), by = 1)) )
( zoo.ts2 <- zoo(10:16, order.by = seq(as.Date('1970-01-01'), as.Date('1970-01-07'), by = 1)) )

merge(zoo.ts1, zoo.ts2, all = TRUE)   # union all
merge(zoo.ts1, zoo.ts2, all = FALSE)  # intersection

library(zoo)
# locf : last observation carried forward
na.locf(merge(zoo.ts1, zoo.ts2, all = TRUE))

#--------------------------------------------------------------------#
# Padding or Filling Dates
#--------------------------------------------------------------------#

( dates <- seq(as.Date('1970-01-11'), as.Date('1970-01-15'), by = 1) )
( empty.zoo.ts <- zoo( , dates) )

( ts <- merge(zoo.ts1, zoo.ts2) )
( ts <- merge(ts, empty.zoo.ts, all = TRUE) )
na.locf(ts)

#--------------------------------------------------------------------#
# Lag a time-series using lag{stats}
#--------------------------------------------------------------------#

ibm.daily

# from tomorrow data to today data    --> +k
lag(ibm.daily, k = +1)
lag(ibm.daily, k = +1, na.pad = FALSE)
lag(ibm.daily, k = +1, na.pad = TRUE)

lag(ibm.daily, k = +2, na.pad = TRUE)
lag(ibm.daily, k = +2, na.pad = FALSE)
lag(ibm.daily, k = +2)

# from yesterday data to today data   --> -k
lag(ibm.daily, k = -1)
lag(ibm.daily, k = -1, na.pad = FALSE)
lag(ibm.daily, k = -1, na.pad = TRUE)

lag(ibm.daily, k = -2, na.pad = TRUE)
lag(ibm.daily, k = -2, na.pad = FALSE)
lag(ibm.daily, k = -2)

#--------------------------------------------------------------------#
# Continuous Differencing
#--------------------------------------------------------------------#

ibm.daily

# Method : (X2 - X1), (X3 - X2), (X4 - X3), ...
diff(ibm.daily)
diff(ibm.daily, na.pad = FALSE)
diff(ibm.daily, na.pad = TRUE)

diff(ibm.daily, lag = 1)
diff(ibm.daily, lag = 1, na.pad = FALSE)
diff(ibm.daily, lag = 1, na.pad = TRUE)

diff(ibm.daily, lag = 2)
diff(ibm.daily, lag = 2, na.pad = FALSE)
diff(ibm.daily, lag = 2, na.pad = TRUE)

#--------------------------------------------------------------------#
# Applying arithmatic operations and general functions to time-series
#--------------------------------------------------------------------#

ibm.daily

diff(ibm.daily)               # differencing : daily variation

diff(ibm.daily) / ibm.daily   # ratio of daily variation of ibm
100 * ( diff(ibm.daily) / ibm.daily ) # % of daily variation of ibm

log(ibm.daily)
class(log(ibm.daily))
str(log(ibm.daily))

# apply log() -> exp() = original data
exp(log(ibm.daily))

# apply log() -> diffing
diff(log(ibm.daily))

#--------------------------------------------------------------------#
# Moving average by k-period
#--------------------------------------------------------------------#

ibm.daily

library(zoo)
( ma <- rollmean(ibm.daily, k = 1) )
( ma <- rollmean(ibm.daily, k = 1, na.pad = FALSE) )
( ma <- rollmean(ibm.daily, k = 1, fill = FALSE) )
( ma <- rollmean(ibm.daily, k = 1, fill = TRUE) )

( ma <- rollmean(ibm.daily, k = 1, align = 'right') )
( ma <- rollmean(ibm.daily, k = 1, align = 'right', fill = FALSE) )
( ma <- rollmean(ibm.daily, k = 1, align = 'right', fill = TRUE) )

( ma <- rollmean(ibm.daily, k = 2) )
( ma <- rollmean(ibm.daily, k = 2, fill = FALSE) )
( ma <- rollmean(ibm.daily, k = 2, fill = TRUE) )

( ma <- rollmean(ibm.daily, k = 2, align = 'right') )
( ma <- rollmean(ibm.daily, k = 2, align = 'right', fill = FALSE) )
( ma <- rollmean(ibm.daily, k = 2, align = 'right', fill = TRUE) )

#--------------------------------------------------------------------#
# apply functions by calendar
#--------------------------------------------------------------------#
zoo.ts <- zoo(df_grpByTS.v1[-1], order.by = df_grpByTS.v1$sess_dt)
index(zoo.ts)
coredata(zoo.ts)

apply.daily(zoo.ts, mean)
apply.weekly(zoo.ts, mean)
apply.monthly(zoo.ts, mean)
apply.quarterly(zoo.ts, mean)
apply.yearly(zoo.ts, mean)

# apply.daily(
# apply.weekly(
# apply.monthly(
apply.quarterly(
# apply.yearly(
  x = zoo.ts,
  FUN = function(value) {
    cat('1. class: ', class(value), '\n')
    cat('2. names: ', names(value), '\n')
    cat('3. dim: ', dim(value), '\n')
    cat('4. str: ', str(value), '\n')
    cat('\n--------------------\n')
  })

# Daily ROI ( Return On Investment )
diff(log(zoo.ts$buy_price))
apply.monthly(diff(log(zoo.ts$buy_price)), sd)
sqrt(251)*apply.monthly(diff(log(zoo.ts$buy_price)), sd)
plot(sqrt(251)*apply.monthly(diff(log(zoo.ts$buy_price)), sd))

#--------------------------------------------------------------------#
# apply rolling functions to a time-series
#--------------------------------------------------------------------#

library(zoo)

ibm.daily

rollapply(
  # data = ibm.daily,
  data = zoo.ts$order_cnt,
  width = 7,
  by = 30,
  align = 'right',
  FUN = function(value) {
    cat('1. class: ', class(value), '\n')
    cat('2. length: ', length(value), '\n')
    cat('3. value: ', value, '\n')
    # cat('4. str: ', str(value), '\n')
    cat('\n--------------------\n')
  })


