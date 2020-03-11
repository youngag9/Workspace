# 시계열 자료의 검정기법들

#----------------------------------------------------------------
# 16. Stationarity Test of a subset of a Time-series object
#     시계열 자료의 {일부}에 대한 정태성(정상성) 검정
#     using kpss.test{tseries} function
#
#     Usage: Computes the {Kwiatkowski-Phillips-Schmidt-Shin} (KPSS) test 
#            for the null hypothesis that x is level or trend stationary.
#
#     kpss.test{tseries} : KPSS Test for Stationarity
#       H0 : Level / Trend Stationarity
#       H1 : NOT level / Trend stationarity
#----------------------------------------------------------------
library(TSA)
data(beersales)

beersales

class(beersales)
str(beersales)
summary(beersales)
head(beersales)
tail(beersales)

start(beersales)
end(beersales)
frequency(beersales)
cycle(beersales)
tsp(beersales)

library(zoo)
index(beersales)
coredata(beersales)

#----------------------------------------------------------------
library(forecast)
( dd <- subset(x = beersales, month = 'Jul') )

class(dd)
str(dd)
summary(dd)
head(dd)
tail(dd)

start(dd)
end(dd)
frequency(dd)
cycle(dd)
tsp(dd)

library(zoo)
index(dd)
coredata(dd)

#----------------------------------------------------------------
# H0 : Level/Trend Stationarity
# H1 : NOT level/Trend stationarity
#----------------------------------------------------------------
library(tseries)
kpss.test(x = beersales, null = 'Level')    # Test Result : H1
kpss.test(x = beersales, null = 'Trend')    # Test Result : H0

library(forecast)
tsdisplay(x = beersales, main = 'Beer Sales / Months (1975 ~ 1990)')

#----------------------------------------------------------------

library(tseries)
kpss.test(x = dd, null = 'Level')     # Test Result : H0
kpss.test(x = dd, null = 'Trend')     # Test Result : H1

library(forecast)
tsdisplay(x = dd, main = 'Beer Sales / July (1975 ~ 1990)')


#----------------------------------------------------------------
# 15. Interpolation of missing values (NA) and outliers in a ts
#----------------------------------------------------------------
rm(gold)
detach('package:TSA')

library(forecast)
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
table(is.na(gold))

for(i in 1:length(gold)) {
  ifelse(is.na(gold[i]), print(paste0('- index of NA: ',i)), next)
}

#----------------------------------------------------------------
library(forecast)
( outliers <- tsoutliers(gold) )
gold[outliers$index]

#----------------------------------------------------------------
na.interp(gold)   # Interpolate missing values in a time series
table(is.na(na.interp(gold)))
tsoutliers(na.interp(gold))

newgold <- tsclean(gold)   # identify and replace outliers and missing values in a time series
table(is.na(newgold))
tsoutliers(newgold)
length(newgold)

#----------------------------------------------------------------
grDevices::dev.list()

grDevices::dev.off()
# graphics.off()

# grDevices::dev.cur()

library(forecast)
tsdisplay(gold)

grDevices::dev.new()
tsdisplay(newgold)


#----------------------------------------------------------------
# 14. Processing NAs (Missing values) in a ts
#----------------------------------------------------------------
( x <- c(22,34,NA,36,28,35,46,42,39,25,36,25,38,NA,37) ); length(x)
( t <- 1:15 )
( mat <- matrix(data = c(x,t), ncol = 2) )

library(mice)
( zz <- mice(data = mat, m = 5) )

class(zz)
mode(zz)
names(zz)

class(complete(zz))     # Extracts the completed data from a mids object

t(complete(zz))         # Matrix transpose from imputated matrix
t(mat)                  # Matrix transpose from original matrix


#----------------------------------------------------------------
# 13. Tompson test whether observation is Outlier in a ts
#----------------------------------------------------------------
( x <- c(1,2,3,4,5,6,7,8,9,15) )

x <- coredata(beersales)
class(x)

tompson <- function(x) {
  nn = length(x)
  mu = mean(x)
  ss = sd(x, 1)
  
  # t0 = (x-mu) / ss      # scaled
  t0 = as.vector(scale(x))
  
  return( sqrt(nn-2)*t0 / sqrt(nn-1-(t0^2)) )
}


( tt1 = qt(p = .99, df = 8) )    # The Student t Distribution : qt gives the quantile function
( tt2 = qt(p = .95, df = 8) )

tompson(x); tt1; tt2

if( tompson(x)[tompson(x) > tt1] > tt1 ) {
  cat('p-value < a = 0.01, so H1 accepted. (H0: NOT outlier, H1: Outlier)')
} else if (tompson(x)[tompson(x) > tt2] > tt2) {
  cat('p-value < a = 0.05, so H1 accepted. (H0: NOT outlier, H1: Outlier)')
} else {
  cat('p-value > a = 0.05/0.01, so H0 accepted. (H0: NOT outlier, H1: Outlier)')
}

#----------------------------------------------------------------
# 12. Find Frequency of a ts : findfrequency{forecast}
#     Find dominant frequency of a time series
#----------------------------------------------------------------
library(forecast)
data(lynx)

lynx

class(lynx)
str(lynx)
summary(lynx)
head(lynx)
tail(lynx)

start(lynx)
end(lynx)
frequency(lynx)
cycle(lynx)
tsp(lynx)

library(zoo)
index(lynx)
coredata(lynx)

#----------------------------------------------------------------
graphics.off()

tsdisplay(x = lynx, main = 'Lynx / Year (1821-1934')
findfrequency(x = lynx)


#----------------------------------------------------------------
# 11. Test for superiority of fitted model for a ts
#     Diebold-Mariano Test
#----------------------------------------------------------------
data("WWWusage", package = "datasets")

WWWusage

class(WWWusage)
str(WWWusage)
summary(WWWusage)
head(WWWusage)
tail(WWWusage)

start(WWWusage)
end(WWWusage)
frequency(WWWusage)
cycle(WWWusage)
tsp(WWWusage)

library(zoo)
index(WWWusage)
coredata(WWWusage)


#----------------------------------------------------------------
WWWusage <- Nile
tsdisplay(WWWusage)

#----------------------------------------------------------------


( f1 <- ets(WWWusage) )
( f2 <- auto.arima(WWWusage) )

summary(f1)
accuracy(f1)
accuracy(f2)

dm.test(residuals(f1), residuals(f2), alternative = 'two.sided')
dm.test(resid(f1), resid(f2), alternative = 'less')


#----------------------------------------------------------------
# 10. I.I.D. Random Variable Test : bds test
#     Computes and prints the BDS test statistic 
#     for the null that x is a series of i.i.d. random variables.
#----------------------------------------------------------------
library(tseries)
data("lynx")

lynx

class(lynx)
str(lynx)
summary(lynx)
head(lynx)
tail(lynx)

start(lynx)
end(lynx)
frequency(lynx)
cycle(lynx)
tsp(lynx)

library(zoo)
index(lynx)
coredata(lynx)

#----------------------------------------------------------------
# a = 0.05, H1 accepted (NOT I.I.D. Random Variable)
bds.test(lynx)

graphics.off()
tsdisplay(lynx, main = 'lynx')

#----------------------------------------------------------------
# 9. Stationarity Test : Unit Root Test by adf.test{tseries}
#----------------------------------------------------------------
dd1.mat <- matrix(c(
  1342, 1442, 1252, 1343,
  1425, 1362, 1456, 1272,
  1243, 1359, 1412, 1253,
  1201, 1478, 1322, 1406,
  1254, 1289, 1497, 1208
))
dd1.mat

( dd1 <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )
rm(dd1.mat)

dd1

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
# ts.plot(dd1, main = 'Random Variable : dd1')
tsdisplay(dd1, main = 'Random Variable : dd1')

#----------------------------------------------------------------
# H0 : NOT stationary ( Unit Root exists )
# H1 : ! H0, Stationary ( Unit Root NOT exist )
adf.test(dd1)   # p-value > a = .005, H0 accepted (Not Stationary)
kpss.test(dd1)  # Level test
kpss.test(dd1, null = 'Trend')  # Trend test


( ddd1 <- diff(dd1) )
adf.test(ddd1)  # p-value < a = .005, H1 accepted (Stationary)

graphics.off()

tsdisplay(dd1, main= 'dd1')

dev.new()
tsdisplay(ddd1, main= 'ddd1 after diffing')

#----------------------------------------------------------------
# 8. Stationarity Test : Unit Root Test by pp.test{tseries}
#----------------------------------------------------------------
dd1.mat <- matrix(c(
  1342, 1442, 1252, 1343,
  1425, 1362, 1456, 1272,
  1243, 1359, 1412, 1253,
  1201, 1478, 1322, 1406,
  1254, 1289, 1497, 1208
))
dd1.mat

( dd1 <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )
rm(dd1.mat)

dd1

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
# ts.plot(dd1, main = 'Random Variable : dd1')
tsdisplay(dd1, main = 'Random Variable : dd1')

#----------------------------------------------------------------
# H0 : NOT stationary ( Unit Root exists )
# H1 : ! H0, Stationary ( Unit Root NOT exist )
pp.test(dd1)   # p-value < a = .005, H1 accepted (Stationary)


#----------------------------------------------------------------
# 7. Normality Test of a ts data and a ts fitted model's residuals 
#----------------------------------------------------------------
dd1.mat <- matrix(c(
  1342, 1442, 1252, 1343,
  1425, 1362, 1456, 1272,
  1243, 1359, 1412, 1253,
  1201, 1478, 1322, 1406,
  1254, 1289, 1497, 1208
))
dd1.mat

( dd1 <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )
(dd1.mat)

dd1

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
# H0 : Normal, H1 : Not normal
library(tseries)
jarque.bera.test(dd1)   # > a=.05, H0 accepted (Normal)
shapiro.test(coredata(dd1))

( rwf.m <- rwf(dd1) )
class(rwf.m)
str(rwf.m)
names(rwf.m)

( re <- matrix(resid(rwf.m)[-1]) )
resid(rwf.m)

jarque.bera.test(re)   # > .05, H0 accepted (Normal)

graphics.off()
forecast(object = rwf.m, )
plot(rwf.m)

#----------------------------------------------------------------
# 6. Stationarity Test : Kwiatkowski-Phillips-Schmidt-Shin Test 
#                        by kpss.test{tseries}
#----------------------------------------------------------------
dd1.mat <- matrix(c(
  1342, 1442, 1252, 1343,
  1425, 1362, 1456, 1272,
  1243, 1359, 1412, 1253,
  1201, 1478, 1322, 1406,
  1254, 1289, 1497, 1208
))
dd1.mat

( dd1 <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )
(dd1.mat)

dd1

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


dd4.mat <- matrix(c(
  1142, 1242, 1452, 1543,
  1225, 1362, 1556, 1672,
  1343, 1459, 1662, 1753,
  1421, 1558, 1772, 1846,
  1554, 1649, 1877, 1948
))
dd4.mat

( dd4 <- ts(data = dd4.mat, start = c(2006, 1), frequency = 4) )
(dd4.mat)

dd4

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
# dev.off()

op = par(mfrow=c(2,1))

ts.plot(dd1, main = 'Random Variable Time Series (dd1)')
ts.plot(dd4, main = 'Seasonal Trend Time Series (dd4)')

par(op)

#----------------------------------------------------------------
# H0 : Stationary of Level / Trend
# H1 : NOT stationary of Level / Trend
library(tseries)
kpss.test(dd1, null = 'Level')   # default null parameter
kpss.test(dd1, null = 'Trend')   # H0 accepted for Level and Trend : Stationary

kpss.test(dd4, null = 'Level')   # default null parameter
kpss.test(dd4, null = 'Trend')   # H0 accepted for Level and Trend : Stationary


plot(decompose(dd1))
plot(decompose(dd4))

#----------------------------------------------------------------
# 5. Independence Test : Box Test by 'Box-Pierce','Ljung-Box'
#                        So called, 'Portmanteau Test'
#----------------------------------------------------------------
dd1.mat <- matrix(c(
  1342, 1442, 1252, 1343,
  1425, 1362, 1456, 1272,
  1243, 1359, 1412, 1253,
  1201, 1478, 1322, 1406,
  1254, 1289, 1497, 1208
))
dd1.mat

( dd1 <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )
(dd1.mat)

dd1

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


dd4.mat <- matrix(c(
  1142, 1242, 1452, 1543,
  1225, 1362, 1556, 1672,
  1343, 1459, 1662, 1753,
  1421, 1558, 1772, 1846,
  1554, 1649, 1877, 1948
))
dd4.mat

( dd4 <- ts(data = dd4.mat, start = c(2006, 1), frequency = 4) )
(dd4.mat)

dd4

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
# dev.off()

op = par(mfrow=c(2,1))

ts.plot(dd1, main = 'Random Variable Time Series (dd1)')
ts.plot(dd4, main = 'Seasonal Trend Time Series (dd4)')

par(op)

#----------------------------------------------------------------
# H0 : Independent, No! Auto-Correlation
# H1 : NOT independent, Yes! Auto-Correlation
Box.test(x = dd1, type = c('B'))  # Box-Pierce test, p-value = 0.1402 > a = .05 (H0)
Box.test(x = dd1, type = c('L'))  # Ljung-Box test, p-value = 0.1125 > a = .05 (H0)

Box.test(x = dd4, type = c('B'))  # Box-Pierce test, p-value = 0.0453 < a = .05 (H1)
Box.test(x = dd4, type = c('L'))  # Ljung-Box test, p-value = 0.03123 < a = .05 (H1)

tsdisplay(dd4)

#----------------------------------------------------------------
# 4. Trend Test : Kendall ㅜ Test
#----------------------------------------------------------------
( ddd1 <- rep(0, 20) )

for(i in 1:20) {
  pp = qq = 0
  kk = dd1[i]
  
  for(j in i+1:20) {
    ifelse(kk <= dd1[j], pp <- pp+1, qq <- qq+1)
  }
  
  ddd1[i] = pp
}

ddd1


( ddd4 = rep(0, 20) )

for(i in 1:20) {
  pp = qq = 0
  kk = dd4[i]
  for(j in i+1:20) {
    ifelse(kk <= dd4[j], pp<-pp+1, qq<-qq+1)
  }
  
  ddd4[i] = pp
}

ddd4

#----------------------------------------------------------------
# H0 : Independent, No Trend !!!
# H1 : NOT independent, Yes, Trend!!!
( tt <- seq(1:20) )

# p-value < a = .05, H1 acceptable 
cor.test(tt, ddd1, method = c('kendall'), exact = FALSE)

# p-value < a = .05, H1 acceptable
cor.test(tt, ddd4, method = c('kendall'), exact = FALSE)


#----------------------------------------------------------------
# 3. Trend Test : Spearman p Test
#----------------------------------------------------------------
( tt <- seq(1:20) )
( rr1 <- rank(dd1) )
( rr2 <- rank(dd4) )

( cbind(tt, rr1, rr2) )

#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,1))

plot(dd1, main = 'Random Variation Time Series (dd1)')
plot(dd4, main = 'Seasonal Trend Variation Time Series (dd4)')

par(op)

#----------------------------------------------------------------
# H0 : Indepedent between time and rank -> No Trend -> Stationary
# H1 : Dependent between time and rank -> Yes Trend -> No Stationary
cor.test(tt, rr1, method = c('spearman'))   # > a=.05, H0 (dd1)
cor.test(tt, rr2, method = c('spearman'))   # < a=.05, H1 (dd4)


#----------------------------------------------------------------
# 2. Randomness Test : Runs Test
#----------------------------------------------------------------
( xx1 <- factor(ifelse(dd1 >= median(dd1), 1, 0)) )
( xx4 <- factor(ifelse(dd4 >= median(dd4), 1, 0)) )
( xx7 <- factor(ifelse(AirPassengers >= median(AirPassengers), 1, 0)) )
AirPassengers
tsdisplay(AirPassengers)
plot(decompose(AirPassengers))
plot(decompose(dd1))
#----------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,1))

plot(dd1, main = 'Random Variation Time Series (dd1)')
plot(dd4, main = 'Seasonal Trend Variation Time Series (dd4)')

par(op)

#----------------------------------------------------------------
# H0 : No skewness -> Yes Randomness
# H1 : Skewness -> No Randomness
library(tseries)
runs.test(xx1, alternative = 'less')  # > a=.05 --> H0
runs.test(xx4, alternative = 'less')  # > a=.05 --> H0
runs.test(xx7, alternative = 'less')  # > a=.05 --> H0
