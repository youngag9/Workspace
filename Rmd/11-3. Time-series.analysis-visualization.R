#----------------------------------------------------------------
# 1. Cumulative Periodogram (cpgram : 구간누적그래프)
#----------------------------------------------------------------
dd1.mat <- matrix(c(
    1342, 1442, 1252, 1343,
    1425, 1362, 1456, 1272,
    1243, 1359, 1412, 1253,
    1201, 1478, 1322, 1406,
    1254, 1289, 1497, 1208
  ))
dd1.mat

class(dd1.mat)
str(dd1.mat)

( dd1 <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )
rm(dd1.mat)
class(dd1)
str(dd1)
summary(dd1)
head(dd1)
tail(dd1)

start(dd1)
end(dd1)
frequency(dd1)
cycle(dd1)
tsp(dd1)

library(zoo)
index(dd1)
coredata(dd1)

#----------------------------------------------------------------
dd2.mat <- matrix(c(
    1142, 1242, 1452, 1543,
    1125, 1262, 1456, 1572,
    1143, 1259, 1462, 1553,
    1121, 1258, 1472, 1546,
    1154, 1249, 1477, 1548
  ))
dd2.mat

class(dd2.mat)
str(dd2.mat)

( dd2 <- ts(data = dd2.mat, start = c(2006, 1), frequency = 4) )
rm(dd2.mat)
class(dd2)
str(dd2)
summary(dd2)
head(dd2)
tail(dd2)

start(dd2)
end(dd2)
frequency(dd2)
cycle(dd2)
tsp(dd2)

library(zoo)
index(dd2)
coredata(dd2)

#----------------------------------------------------------------
graphics.off()
op <- par(mfrow=c(2,2))

ts.plot(dd1, main = 'Random Variation Time Series (dd1)')
ts.plot(dd2, main = 'Seasonal Variation Time Series (dd2)')

cpgram(ts = dd1, main = 'Cumulative Periodogram (dd1)')
cpgram(ts = dd2, main = 'Cumulative Periodogram (dd2)')

par(op)

#----------------------------------------------------------------
# 2. Month plot (monthplot)
#----------------------------------------------------------------
dd4.mat <- matrix(c(
  1142, 1242, 1452, 1543,
  1225, 1362, 1556, 1672,
  1343, 1459, 1662, 1753,
  1421, 1558, 1772, 1846,
  1554, 1649, 1877, 1948
))
dd4.mat

class(dd4.mat)
str(dd4.mat)

( dd4 <- ts(data = dd4.mat, start = c(2006, 1), frequency = 4) )
rm(dd4.mat)

class(dd4)
str(dd4)
summary(dd4)
head(dd4)
tail(dd4)

start(dd4)
end(dd4)
frequency(dd4)
cycle(dd4)
tsp(dd4)

library(zoo)
index(dd4)
coredata(dd4)

#----------------------------------------------------------------
graphics.off()
op <- par(mfrow=c(2,2))

ts.plot(dd1, main = 'Random Variation Time Series (dd1)')
ts.plot(dd4, main = 'Seasonal Trend Variation Time Series (dd4)')

monthplot(x = dd1, main = 'Month plot (dd1)', xlab = 'Quarter : 2006 ~ 2010', ylab = 'Sales')
monthplot(x = dd4, main = 'Month plot (dd4)', xlab = 'Quarter : 2006 ~ 2010', ylab = 'Sales')

par(op)

#----------------------------------------------------------------
# 3. Cosine Taper : Using consine bell function
#    cos bell equation = ( 1 - cos(x) / 2)
#----------------------------------------------------------------
graphics.off()
op <- par(mfrow=c(2,2))

ts.plot(dd1, main = 'Random Variation Time Series (dd1)')
ts.plot(dd4, main = 'Seasonal Trend Variation Time Series (dd4)')

( dd1.ct <- spec.taper(dd1, p = .1) )

class(dd1.ct)
str(dd1.ct)
summary(dd1.ct)
head(dd1.ct)
tail(dd1.ct)

start(dd1.ct)
end(dd1.ct)
frequency(dd1.ct)
cycle(dd1.ct)
tsp(dd1.ct)

library(zoo)
index(dd1.ct)
coredata(dd1.ct)

plot(dd1.ct, main = 'Taper a time series by a Cosine Bell (dd1.ct)')

( dd4.ct <- spec.taper(dd4, p = .1) )

class(dd4.ct)
str(dd4.ct)
summary(dd4.ct)
head(dd4.ct)
tail(dd4.ct)

start(dd4.ct)
end(dd4.ct)
frequency(dd4.ct)
cycle(dd4.ct)
tsp(dd4.ct)

library(zoo)
index(dd4.ct)
coredata(dd4.ct)

plot(dd4.ct, main = 'Taper a time series by a Cosine Bell (dd4.ct)')

par(op)

#----------------------------------------------------------------
# 4. Decomposition (요소분해법) and ACF(자동/기상관함수), 
#     PACF (부분 자동/자기상관함수 )
#----------------------------------------------------------------
dd1

acf(dd1)
pacf(dd1)

class(dd1)
str(dd1)
summary(dd1)
head(dd1)
tail(dd1)

start(dd1)
end(dd1)
frequency(dd1)
cycle(dd1)
tsp(dd1)

library(zoo)
index(dd1)
coredata(dd1)

#----------------------------------------------------------------
( dd1.components <- decompose(dd1) )
class(dd1.components)
mode(dd1.components)
names(dd1.components)

class(dd1.components$x)
dd1.components$x
class(dd1.components$trend)
dd1.components$trend
class(dd1.components$seasonal)
dd1.components$seasonal
class(dd1.components$random)
dd1.components$random

class(dd1.components$type)
dd1.components$type
class(dd1.components$figure)
dd1.components$figure

#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(4,1))

plot(dd1.components$x, main = 'dd1.components$x', xlab = 'Time', ylab = 'Observed')
plot(dd1.components$trend, main = 'dd1.components$trend', xlab = 'Time', ylab = 'Trend')
plot(dd1.components$seasonal, main = 'dd1.components$seasonal', xlab = 'Time', ylab = 'Seasonal')
plot(dd1.components$random, main = 'dd1.components$random', xlab = 'Time', ylab = 'Random')

par(op)

library(forecast)
tsdisplay(dd1, main = 'Time series plot: dd1')

#----------------------------------------------------------------
# 5. Time Lag plot : lag.plot{TSA}
#----------------------------------------------------------------
library(TSA)
data(milk)

milk

class(milk)
str(milk)
summary(milk)
head(milk)
tail(milk)

start(milk)
end(milk)
frequency(milk)
cycle(milk)
tsp(milk)

library(zoo)
index(milk)
coredata(milk)

#----------------------------------------------------------------
graphics.off()

lag.plot(
  x = milk,
  lags = 12,
  # set.lags = 1:10,
  pch = '.',
  main = 'milk{TSA} - Time Lag plot',
  diag.col = 'red',
  do.lines = TRUE)



#----------------------------------------------------------------
# 6. Wapply Plot by Local Mean
#----------------------------------------------------------------
( x <- 1:1000 )
( y <- rnorm(n = 1000, mean = 1, sd = 1 + x/1000) )

library(gplots)
( ww <- wapply(x, y, fun = mean) )  # 20개씩 x 총 50개 = 1000개

wapply(x, y, fun = function(value) {
  cat('class:', class(value), '\n')
  cat('value:', length(value), '\n-----------------------------\n')
})

class(ww)
str(ww)
str(ww$x)
str(ww$y)
ww$x
ww$y
#----------------------------------------------------------------
graphics.off()

plot(x, y, main = 'Wapply plot by Local Mean')
lines(ww, col = 'red', lwd = 2)

CL <- function(x, sd) { mean(x)+sd*sqrt(var(x)) }

lines(wapply(x, y, CL, sd = 1), col = 'blue', lwd = 2)
lines(wapply(x, y, CL, sd = -1), col = 'blue', lwd = 2)
lines(wapply(x, y, CL, sd = 2), col = 'green', lwd = 2)
lines(wapply(x, y, CL, sd = -2), col = 'green', lwd = 2)

legend('bottomleft', c('m +/- 2d','m +/- 1d', 'Local Mean'), col = c(3,4,2), lwd = c(2,2,2), cex = .6)

#----------------------------------------------------------------
# 7. Band Plot by Fractal Mean (****)
#----------------------------------------------------------------
x <- 1:1000
y <- rnorm(1000, mean = 1, sd = 1 + x/1000)

graphics.off()

library(gplots)
bandplot(x = x, y = y, main = 'Band plot by Fractal mean')

legend('bottomleft', c('m +/- 2d','m +/- 1d', 'Fractal Mean'), col = c('magenta', 'blue', 'red'), lwd = c(2,2,2), cex = .6)

#----------------------------------------------------------------
# 8. Bivariate Time Series Plot
#----------------------------------------------------------------
library(tsDyn)
data(lynx)

( xx <- lynx )

class(xx)
str(xx)
summary(xx)
head(xx)
tail(xx)

start(xx)
end(xx)
frequency(xx)
cycle(xx)
tsp(xx)

library(zoo)
index(xx)
coredata(xx)

#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,3))

library(tsDyn)
autopairs(lynx, type = 'levels')
autopairs(x = xx, type = 'persp')
autopairs(x = xx, type = 'image')
autopairs(x = xx, type = 'lines')
autopairs(x = xx, type = 'points')
autopairs(x = xx, type = 'regression')

par(op)

#----------------------------------------------------------------
# 9. Trivariate Time Series Plot
#----------------------------------------------------------------
library(tsDyn)
data(lynx)

head(lynx, 5)

#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,3))

autotriples(x = log(lynx), lags = 0:1, type = 'levels')
autotriples(x = log(lynx), lags = 0:2, type = 'levels')
autotriples(x = log(lynx), lags = 1:2, type = 'levels')
autotriples(x = log(lynx), type = 'persp')
autotriples(x = log(lynx), type = 'image')
autotriples(x = log(lynx), type = 'points')

par(op)

#----------------------------------------------------------------
# 10. Time Series Plot using package {forecast}, {ggplot2} (****)
#----------------------------------------------------------------
library(forecast)
data("AirPassengers")

AirPassengers

class(AirPassengers)
str(AirPassengers)
summary(AirPassengers)
head(AirPassengers)
tail(AirPassengers)

start(AirPassengers)
end(AirPassengers)
frequency(AirPassengers)
cycle(AirPassengers)
tsp(AirPassengers)

library(zoo)
index(AirPassengers)
coredata(AirPassengers)

#----------------------------------------------------------------
data(gold)

gold

class(gold)
str(gold)
summary(gold)
head(gold)
tail(gold)

start(gold)
end(gold)
frequency(gold)
cycle(gold)
tsp(gold)

library(zoo)
index(gold)
coredata(gold)

#----------------------------------------------------------------
data(hours)

hours

class(hours)
str(hours)
summary(hours)
head(hours)
tail(hours)

start(hours)
end(hours)
frequency(hours)
cycle(hours)
tsp(hours)

library(zoo)
index(hours)
coredata(hours)

#----------------------------------------------------------------
data(wineind)

wineind

class(wineind)
str(wineind)
summary(wineind)
head(wineind)
tail(wineind)

start(wineind)
end(wineind)
frequency(wineind)
cycle(wineind)
tsp(wineind)

library(zoo)
index(wineind)
coredata(wineind)

#----------------------------------------------------------------
graphics.off()
# op = par(mfrow=c(2,2))

library(ggplot2)
p <- autoplot(object = AirPassengers, main = 'AirPassengers / Loess line')
p <- p + geom_ribbon(aes(ymin = AirPassengers - 50, ymax = AirPassengers + 50), fill = 'lightblue')
p <- p + geom_line(aes(y = AirPassengers))
p <- p + stat_smooth(method = 'loess', se = FALSE, col = 'red')
p

p <- autoplot(object = gold, main = 'gold / Loess line')
p <- p + geom_ribbon(aes(ymin = gold - 50, ymax = gold + 50), fill = 'lightblue')
p <- p + geom_line(aes(y = gold))
p <- p + stat_smooth(method = 'loess', se = FALSE, col = 'red')
p

p <- autoplot(object = hours, main = 'hours / Loess line')
p <- p + geom_ribbon(aes(ymin = hours - 50, ymax = hours + 50), fill = 'lightblue')
p <- p + geom_line(aes(y = hours))
p <- p + stat_smooth(method = 'loess', se = FALSE, col = 'red')
p

p <- autoplot(object = wineind, main = 'wineind / Loess line')
p <- p + geom_ribbon(aes(ymin = wineind - 50, ymax = wineind + 50), fill = 'lightblue')
p <- p + geom_line(aes(y = wineind))
p <- p + stat_smooth(method = 'loess', se = FALSE, col = 'red')
p

# par(op)

#----------------------------------------------------------------
# 11. Plotting a Time Series object except Seasonal Components (****)
#----------------------------------------------------------------
library(forecast)
data("AirPassengers")

AirPassengers

class(AirPassengers)
str(AirPassengers)
summary(AirPassengers)
head(AirPassengers)
tail(AirPassengers)

start(AirPassengers)
end(AirPassengers)
frequency(AirPassengers)
cycle(AirPassengers)
tsp(AirPassengers)

library(zoo)
index(AirPassengers)
coredata(AirPassengers)

#----------------------------------------------------------------
data(gold)

gold

class(gold)
str(gold)
summary(gold)
head(gold)
tail(gold)

start(gold)
end(gold)
frequency(gold)
cycle(gold)
tsp(gold)

library(zoo)
index(gold)
coredata(gold)

#----------------------------------------------------------------
data(hours)

hours

class(hours)
str(hours)
summary(hours)
head(hours)
tail(hours)

start(hours)
end(hours)
frequency(hours)
cycle(hours)
tsp(hours)

library(zoo)
index(hours)
coredata(hours)

#----------------------------------------------------------------
data(wineind)

wineind

class(wineind)
str(wineind)
summary(wineind)
head(wineind)
tail(wineind)

start(wineind)
end(wineind)
frequency(wineind)
cycle(wineind)
tsp(wineind)

library(zoo)
index(wineind)
coredata(wineind)

#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,2))

plot(x = AirPassengers, main = 'AirPassengers / Seasonal Adjustment')
lines( seasadj(decompose(AirPassengers)), col = 2, lwd = 2)

plot(x = gold, main = 'gold / Seasonal Adjustment')
lines( seasadj(decompose(gold)), col = 2, lwd = 2)

plot(x = hours, main = 'hours / Seasonal Adjustment')
lines( seasadj(decompose(hours)), col = 2, lwd = 2)

plot(x = wineind, main = 'wineind / Seasonal Adjustment')
lines( seasadj(decompose(wineind)), col = 2, lwd = 2)

par(op)

#----------------------------------------------------------------
# 12. Seasonal Plot (**********)
#----------------------------------------------------------------
library(TSA)
data("AirPassengers")
data("milk")

AirPassengers

class(AirPassengers)
str(AirPassengers)
summary(AirPassengers)
head(AirPassengers)
tail(AirPassengers)

start(AirPassengers)
end(AirPassengers)
frequency(AirPassengers)
cycle(AirPassengers)
tsp(AirPassengers)

library(zoo)
index(AirPassengers)
coredata(AirPassengers)


milk

class(milk)
str(milk)
summary(milk)
head(milk)
tail(milk)

start(milk)
end(milk)
frequency(milk)
cycle(milk)
tsp(milk)

library(zoo)
index(AirPassengers)
coredata(AirPassengers)

#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,2))

library(forecast)
seasonplot(x = AirPassengers, col = rainbow(12), year.labels = TRUE)
ggseasonplot(x = AirPassengers, year.labels = TRUE, continuous = TRUE)

seasonplot(x = milk, col = rainbow(12), year.labels = TRUE)
ggseasonplot(x = milk, year.labels = TRUE, continuous = TRUE)

par(op)