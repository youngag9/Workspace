options(max.print = 99999)
options(scipen = 99)

#---------------------------------------------------------------
# 시계열 자료 생성 :
#   - dd1.ts : Random Variation Time Series (우연변동 시계열)
#   - dd2.ts : Seasonal Variation Time Series (계절변동 시계열)
#   - dd3.ts : Trend Variation Time Series (추세변동 시계열)
#   - dd4.ts : Seasonal-Trend Variation Time Series (계절적 추세변동 시계열)
#---------------------------------------------------------------
rm(dd1.mat)
rm(dd2.mat)
rm(dd3.mat)
rm(dd4.mat)

rm(dd1.ts)
rm(dd2.ts)
rm(dd3.ts)
rm(dd4.ts)

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

( dd1.ts <- ts(data = dd1.mat, start = c(2006, 1), frequency = 4) )

class(dd1.ts)
str(dd1.ts)
#summary(dd1.ts)
head(dd1.ts)
tail(dd1.ts)

start(dd1.ts)
end(dd1.ts)
frequency(dd1.ts)
cycle(dd1.ts)
tsp(dd1.ts)

library(zoo)
index(dd1.ts)
coredata(dd1.ts)

#--------------
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

( dd2.ts <- ts(data = dd2.mat, start = c(2006, 1), frequency = 4) )

class(dd2.ts)
str(dd2.ts)
#summary(dd2.ts)
head(dd2.ts)
tail(dd2.ts)

start(dd2.ts)
end(dd2.ts)
frequency(dd2.ts)
cycle(dd2.ts)
tsp(dd2.ts)

library(zoo)
index(dd2.ts)
coredata(dd2.ts)

#--------------
dd3.mat <- matrix(c(
  1142, 1242, 1252, 1343,
  1225, 1562, 1356, 1572,
  1343, 1459, 1412, 1453,
  1401, 1478, 1322, 1606,
  1554, 1589, 1597, 1408
))
dd3.mat

class(dd3.mat)
str(dd3.mat)

( dd3.ts <- ts(data = dd3.mat, start = c(2006, 1), frequency = 4) )

class(dd3.ts)
str(dd3.ts)
#summary(dd3.ts)
head(dd3.ts)
tail(dd3.ts)

start(dd3.ts)
end(dd3.ts)
frequency(dd3.ts)
cycle(dd3.ts)
tsp(dd3.ts)

library(zoo)
index(dd3.ts)
coredata(dd3.ts)

#--------------
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

( dd4.ts <- ts(data = dd4.mat, start = c(2006, 1), frequency = 4) )

class(dd4.ts)
str(dd4.ts)
#summary(dd4.ts)
head(dd4.ts)
tail(dd4.ts)

start(dd4.ts)
end(dd4.ts)
frequency(dd4.ts)
cycle(dd4.ts)
tsp(dd4.ts)

library(zoo)
index(dd4.ts)
coredata(dd4.ts)


#-------------------------------------------------------------
# 1. 계절성(= 주기성) 계산 사례 : findfrequency{forecast}
#    USAccDeaths{datasets} 시계열 자료 사용
#-------------------------------------------------------------
data("USAccDeaths")

USAccDeaths

class(USAccDeaths)
str(USAccDeaths)
start(USAccDeaths)
end(USAccDeaths)
frequency(USAccDeaths)
cycle(USAccDeaths)
tsp(USAccDeaths)

#----------------------
graphics.off()

library(forecast)

plot(decompose(USAccDeaths))
title(main = '\n- USAccDeaths -')

tsdisplay(USAccDeaths, main = 'US Accidential Deaths / Month (1973-1978')

#----------------------
findfrequency(USAccDeaths)


#---------------------------------------------------------------
# SARIMA 모형 분석사례 1 : auto.arima{forecast}
#---------------------------------------------------------------
# 분석요구 : dd4.ts 시계열 자료에 대하여, SARIMA 모형을 이용하여
#            최적의 모형을 적합시키고, 2011년 자료를 예측하시오
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1) 시계열 탐색 : dd4.ts
#---------------------------------------------------------------
library(forecast)

graphics.off()

tsdisplay(dd4.ts, main = '\n- dd4.ts -')

# plot(decompose(dd4.ts, type = 'additive'))
autoplot(decompose(dd4.ts, type = 'additive'), 
         main = 'Decomposition of dd4.ts (additive)')

dev.new()
autoplot(decompose(dd4.ts, type = 'multiplicative'), 
         main = 'Decomposition of dd4.ts (multiplicative)')

( dc <- decompose(dd4.ts, type = 'multiplicative') )
dc$seasonal
dc$trend

dev.new() 

#********#
autoplot(dd4.ts/dc$seasonal, main = '- dd4.ts removing seasonality -')
autoplot(dd4.ts/dc$trend, main = '- dd4.ts removing trend -')

#---------------------------------------------------------------
# 2) 정상성 검정 : dd4.ts
#---------------------------------------------------------------
library(tseries)
kpss.test(dd4.ts)
kpss.test(dd4.ts, null = 'Trend')

#---------------------------------------------------------------
# 3) 주기성(계절주기) 계산 : findfrequency{forecast}
#---------------------------------------------------------------
library(forecast)
findfrequency(dd4.ts)

#---------------------------------------------------------------
# 4) 추세, 계정변동 시계열 모형 최적화 : auto.arima{forecast}
#     - Drift 고려
#---------------------------------------------------------------
library(forecast)

( dd4.sm <- auto.arima(dd4.ts) )  # ARIMA(0,0,0)(1,1,0)[4]

class(dd4.sm)
mode(dd4.sm)
names(dd4.sm)
dd4.sm

confint(dd4.sm)
accuracy(dd4.sm)

graphics.off()

# Error: 'data' must be of a vector type, was 'NULL'
# plot(dd4.sm)

tsdiag(dd4.sm)
title(main = '- dd4.ts -')


dd4.sm$fitted

#---------------------------------------------------------------
# 5) 추세, 계정변동 시계열 예측 : forecast{forecast}
#     - Drift 고려
#---------------------------------------------------------------
library(forecast)

( dd4.fc <- forecast(dd4.sm, h = 8) )

graphics.off()

plot(dd4.fc)
title(main = '\n\n- dd4.ts -')
lines(dd4.sm$fitted, col = 'red', lty = 3, lwd = 2)

tsdisplay(dd4.sm$fitted, main = '- fitted values : dd4.ts -')
tsdisplay(dd4.sm$residuals, main = '- residuals : dd4.ts -')

#---------------------------------------------------------------
# 6) 추세, 계정변동 시계열 모형 최적화 : auto.arima{forecast}
#     - Drift 미고려
#---------------------------------------------------------------
library(forecast)

( dd4.sm <- auto.arima(dd4.ts, allowdrift = FALSE) )  # ARIMA(0,0,1)(0,1,1)[4]

confint(dd4.sm)

accuracy(dd4.sm)

graphics.off()

# plot(dd4.sm)

tsdiag(dd4.sm)
title(main = '- dd4.ts without drift -')

dd4.sm$fitted

#---------------------------------------------------------------
# 7) 추세, 계정변동 시계열 예측 : forecast{forecast}
#     - Drift 미고려
#---------------------------------------------------------------
library(forecast)

( dd4.fc <- forecast(dd4.sm, h = 8) )

graphics.off()

plot(dd4.fc, xlab = 'Time', ylab = 'Series')
title(main = '\n\n- dd4.ts without drift -')
lines(dd4.sm$fitted, col = 'red', lty = 3, lwd = 2)

tsdisplay(dd4.sm$fitted, main = '- fitted values : dd4.ts without drift -')
tsdisplay(dd4.sm$residuals, main = '- residuals : dd4.ts without drift -')


#---------------------------------------------------------------
# SARIMA 모형 분석사례 2 : auto.arima{forecast}
#---------------------------------------------------------------
# 분석요구 : tempdub{TSA} 시계열 자료에 대하여, 최적의 ARIMA 
#            시계열 모형을 적합시키고, 미래의 기온을 예측하시오
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1) 시계열 탐색 : tempdub{TSA}
#---------------------------------------------------------------
library(TSA)
data(tempdub)

# Monthly average temperature (in degrees Fahrenheit) recorded in Dubuque 1/1964 - 12/1975.
tempdub

class(tempdub)
str(tempdub)
start(tempdub)
end(tempdub)
frequency(tempdub)
cycle(tempdub)
tsp(tempdub)

#-----------------------
graphics.off()

tsdisplay(tempdub, main = '\n- tempdub -')

autoplot(decompose(tempdub, type = 'additive'), 
         main = 'Decomposition of tempdub (additive)')
autoplot(decompose(tempdub, type = 'multiplicative'), 
         main = 'Decomposition of tempdub (multiplicative)')

( dc <- decompose(tempdub, type = 'multiplicative') )
autoplot(tempdub/dc$seasonal, main = '- tempdub removing seasonality -')
autoplot(tempdub/dc$trend, main = '- tempdub removing trend -')

#---------------------------------------------------------------
# 2) 정상성 검정 : tempdub
#---------------------------------------------------------------
library(tseries)
kpss.test(tempdub)
kpss.test(tempdub, null = 'Trend')

#---------------------------------------------------------------
# 3) 주기성(계절주기) 계산 : findfrequency{forecast}
#---------------------------------------------------------------
library(forecast)
findfrequency(tempdub)

#---------------------------------------------------------------
# 4) 추세, 계정변동 시계열 모형 최적화 : auto.arima{forecast}
#     - Drift 고려
#---------------------------------------------------------------
library(forecast)

( tempdub.sm1 <- auto.arima(tempdub) )  # ARIMA(0,0,0)(2,1,0)[12]

confint(tempdub.sm1)
accuracy(tempdub.sm1)

graphics.off()

# plot(tempdub.sm1)
# Error in attr(x, "tsp") <- c(1, NROW(x), 1) : 
#   invalid time series parameters specified

tsdiag(tempdub.sm1)
title(main = '- tempdub -')

tempdub.sm1$fitted

#--------------------
( tempdub.sm2 <- auto.arima(tempdub, allowdrift = FALSE) )  # ARIMA(0,0,0)(2,1,0)[12]

confint(tempdub.sm2)
accuracy(tempdub.sm2)

graphics.off()

# plot(tempdub.sm2)
# Error in attr(x, "tsp") <- c(1, NROW(x), 1) : 
#   invalid time series parameters specified

tsdiag(tempdub.sm2)
title(main = '- tempdub -')

tempdub.sm2$fitted

#--------------------
( tempdub.sm3 <- Arima(
  tempdub, 
  order = c(1,0,3), 
  seasonal = list(order = c(0,0,2), period = 12)) 
)  # ARIMA(1,0,3)(0,0,2)[12]

confint(tempdub.sm3)
accuracy(tempdub.sm3)

graphics.off()

# plot(tempdub.sm3)
# Error in attr(x, "tsp") <- c(1, NROW(x), 1) : 
#   invalid time series parameters specified

tsdiag(tempdub.sm3)
title(main = '- tempdub -')

tempdub.sm3$fitted

#--------------------
( tempdub.sm4 <- Arima(
  tempdub, 
  order = c(0,0,0), 
  seasonal = c(0,0,2)) )  # ARIMA(0,0,0)(0,0,2)[12]
# ARIMA(0,0,0)(2,1,0)[12]
confint(tempdub.sm4)
accuracy(tempdub.sm4)

graphics.off()

# plot(tempdub.sm4)
# Error in attr(x, "tsp") <- c(1, NROW(x), 1) : 
#   invalid time series parameters specified

tsdiag(tempdub.sm4)
title(main = '- tempdub -')

tempdub.sm4$fitted

#-----------------
accuracy(tempdub.sm1)
accuracy(tempdub.sm2)
accuracy(tempdub.sm3)
accuracy(tempdub.sm4)

#---------------------------------------------------------------
# 5) 추세, 계정변동 시계열 예측 : forecast{forecast}
#     - Drift 미고려
#---------------------------------------------------------------
library(forecast)

( tempdub.fc <- forecast(tempdub.sm2, h = 24) )

graphics.off()

plot(tempdub.fc)
title(main = '\n\n- tempdub -')
lines(tempdub.fc$fitted, col = 'red', lty = 3, lwd = 2)

tsdisplay(tempdub.fc$fitted, main = '- fitted values : tempdub -')
tsdisplay(tempdub.fc$residuals, main = '- residuals : tempdub -')
