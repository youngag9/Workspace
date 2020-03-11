options(max.print = 99999)
options(scipen = 99)

#---------------------------------------------------------------
# 시계열 자료 생성 :
#   - dd1.ts : Random Variation Time Series (우연변동 시계열)
#   - dd2.ts : Seasonal Variation Time Series (계절변동 시계열)
#   - dd3.ts : Trend Variation Time Series (추세변동 시계열)
#   - dd4.ts : Seasonal-Trend Variation Time Series (계절적 추세변동 시계열)
#-----------------------------------------------------
# daily ts (2018-04-01 ~ 2018-09-30, 총183일) 생성위한,
# 중요한 예1:
#   order.ts <- 
#     ts(data = vec.order_cnt, 
#        deltat = 1/365,    -> time unit for observation.
#        # 2018-04-01 -> 전체 365일중, 91번째 요일에 해당
#        # 매일 관측된 관찰값의 개수는 1
#        start = c(1, 91),  -> the time of the first observation.
#                              Either a single number(not time) or 
#                              a vector of two integers, 
#                              which specify a natural time unit 
#                              and a (1-based) number of 
#                              samples into the time unit.
#        # 2018-09-30 -> 전체 365일중, 273번째 요일에 해당
#        # 매일 관측된 관찰값의 개수는 1
#        end = c(1, 273)    -> the time of the last observation.
#     )
#--------------------------------------------------
# daily ts (2018-04-01 ~ 2018-09-30, 총183일) 생성위한, 
# 중요한 예2:
#
#   1> order.ts <- ts(data = vec.order_cnt, frequency = 7)
#   - in above case, start = c(1, 1), end = c(27, 1).
#     that means, 1 obs. in 1st week ~ 1 obs. in 27st week.
#---
#   2> order.ts <- ts(data = vec.order_cnt, frequency = 7, 
#                    start = c(1, 7),
#                    end = c(27, 7))
#   - in above case, start = c(1, 7), end = c(27, 7).
#     that means, 7 obs. in 1st week ~ 7 obs. in 27st week.
#   ------------------------------------------
#     if frequency == 1,  yearly ts
#     if frequency == 4,  quarterly ts
#     if frequency == 12, monthly ts
#     if frequency == 7,  daily ts
#   ---------------------------------------------
#   ...one could use a value of 7 for frequency 
#   when the data are sampled daily, 
#   and the natural time period is a week, 
#   or 12 when the data are sampled monthly 
#   and the natural time period is a year. 
#   Values of 4 and 12 are assumed 
#   in (e.g.) print methods to imply 
#   a quarterly and monthly series respectively.
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


#-------------------------------------------
# ARIMA(p,d,q) 모형의 차수결정: auto.arima
#-------------------------------------------
# - ARIMA 모형은, Box와 Jenkins에 의하여 개발된 시계열 분석방법으로,
#   기존의 AR(p) 모형과 MA(q) 모형을, 일관성있게 하나로 통합된 모형으로,
#   아래의 3단계로 수행
#     (1) ARIMA 모형의 구축 (Model Identification) --> 가장중요
#         - 모형차수 = (p,d,q) 를 결정하는 단계
#         - auto.arima{forecast} 함수를 사용하거나 (자동)
#           arima{stats} 함수를 사용 (수동)
#         - auto.arima{forecast} 함수 : 자동으로, ARIMA모형의 차수를
#           결정해주는 프로그램 (최소 AIC, AICc, BIC의 차수 결정)
#         - 모형차수(p,d,q)에서, p: 0 ~ 3, d: 0 ~ 1, q: 0 ~ 3 범위내에서
#           최소 AIC를 보이는 차수로 결정
#     (2) ARIMA 모형의 매개변수 추정(Parameter Estimation)
#     (3) ARIMA 모형의 적합성 검토 (Model Diagnostics)
#
# - ARIMA 모형관련, R 프로그램 목록
#   (1) arima{stats} function
#   (2) auto.arima{forecast} function
#   (3) arima.sim{stats} function


#---------------------------------------
# 1. arima.sim{stats} function: 
#    Simulate from an ARIMA Model
#
#    Usage:
#       arima.sim(model, n, rand.gen = rnorm, innov = rand.gen(n, ...),
#                 n.start = NA, start.innov = rand.gen(n.start, ...),
#                 ...)
#---------------------------------------


#-----------------------------------------------------
# Simulation of ARIMA(0,1,0) model with no ARs, no MAs
#-----------------------------------------------------
graphics.off()
op <- par(mfrow=c(3,1))

( 
  x.ts <- arima.sim(n = 5000, 
                    model = list(
                      order=c(0,1,0)
                    )
                )
)
class(x.ts)

# ts.plot{stats} : Plot Multiple Time Series
ts.plot(x.ts, main = 'ARIMA(0,1,0) model')
mtext('(No ARs, No MAs)', side = 3)

# plot{graphics} : Generic X-Y Plotting
# plot(x.ts, main = 'ARIMA(0,1,0) model')
# mtext('(No ar, No ma)', side = 3)

# acf{stats} : 
#   Auto- and Cross- Covariance and -Correlation Function Estimation
acf(x.ts, main = 'ARIMA(0,1,0) model')

# pacf{stats} :
#   Auto- and Cross- Covariance and -Correlation Function Estimation
pacf(x.ts, main = 'ARIMA(0,1,0) model')

par(op)

# graphics.off()
# library(forecast)
# tsdisplay(x.ts, main = 'ARIMA(0,1,0) model')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods

#-----------------------------------------------------
# Simulation of ARIMA(0,1,1) model with ma = .2
#-----------------------------------------------------
graphics.off()

x.ts <- arima.sim(n = 5000, 
                  model = list(
                    order=c(0,1,1),
                    ma = .2
                  )
              )
class(x.ts)

library(forecast)
tsdisplay(x.ts,
  main = 'ARIMA(0,1,1) model with ma = .2')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods

#-----------------------------------------------------
# Simulation of ARIMA(1,1,0) model with ar = .7
#-----------------------------------------------------
graphics.off()

x.ts <- arima.sim(n = 5000, 
                  model = list(
                    order=c(1,1,0),
                    ar = .7
                  )
              )
class(x.ts)

library(forecast)
tsdisplay(x.ts, 
  main = 'ARIMA(1,1,0) model with ar = .7')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods

#-----------------------------------------------------
# Simulation of ARIMA(1,1,1) model with ar = .7, ma = .2
#-----------------------------------------------------
graphics.off()

x.ts <- arima.sim(n = 5000, 
                  model = list(
                    order=c(1,1,1), 
                    ar = .7,
                    ma = .2
                  )
              )
class(x.ts)

library(forecast)
tsdisplay(x.ts, 
  main = 'ARIMA(1,1,1) model with ar = .7, ma = .2')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods

#---------------------------------------------------------------
# Simulation of ARIMA(1,1,2) model with ar = .7, ma = c(.2, -.1)
#---------------------------------------------------------------
graphics.off()

x.ts <- arima.sim(n = 5000, 
                  model = list(
                    order=c(1,1,2), 
                    ar = .7,
                    ma = c(.2,-.1)
                  )
              )
class(x.ts)

library(forecast)
tsdisplay(x.ts, 
  main = 'ARIMA(1,1,2) model with ar = .7, ma = c(.2, -.1)')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods

#---------------------------------------------------------------
# Simulation of ARIMA(2,1,1) model with ar = c(-.6, -.3), ma = .2
#---------------------------------------------------------------
graphics.off()

x.ts <- arima.sim(n = 5000, 
                  model = list(
                    order=c(2,1,1), 
                    ar = c(-.6, -.3),
                    ma = .2
                  )
              )
class(x.ts)

library(forecast)
tsdisplay(x.ts, 
  main = 'ARIMA(2,1,1) model with ar = c(-.6, -.3), ma = .2')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods

#---------------------------------------------------------------
# Simulation of ARIMA(2,1,2) model 
#               with ar = c(-.6, -.3), ma = c(-.2, .3)
#---------------------------------------------------------------
graphics.off()

x.ts <- arima.sim(n = 5000, 
                  model = list(
                    order=c(2,1,2),
                    ar = c(-.6, -.3),
                    ma = c(-.2, .3)
                  )
              )
class(x.ts)

library(forecast)
tsdisplay(x.ts, 
  main = 'ARIMA(2,1,2) model with ar = c(-.6, -.3), ma = c(-.2, .3)')

# plot(decompose(x.ts))
# Error in decompose(x.ts) : time series has no or less than 2 periods


#---------------------------------------------------------------
# 2. auto.arima{forecast} function: 
#    Fit best ARIMA model to univariate time series
#
#    Usage:
#       auto.arima(
#         y, 
#         d = NA, 
#         D = NA, 
#         max.p = 5, 
#         max.q = 5, 
#         max.P = 2,
#         max.Q = 2, 
#         max.order = 5, 
#         max.d = 2, 
#         max.D = 1, 
#         start.p = 2,
#         start.q = 2, 
#         start.P = 1, 
#         start.Q = 1, 
#         stationary = FALSE,
#         seasonal = TRUE, 
#         ic = c("aicc", "aic", "bic"), 
#         stepwise = TRUE,
#         trace = FALSE, 
#         approximation = (length(x) > 150 | frequency(x) > 12),
#         truncate = NULL, 
#         xreg = NULL, 
#         test = c("kpss", "adf", "pp"),
#         seasonal.test = c("seas", "ocsb", "hegy", "ch"), 
#         allowdrift = TRUE,
#         allowmean = TRUE,
#         lambda = NULL, 
#         biasadj = FALSE, 
#         parallel = FALSE,
#         num.cores = 2, 
#         x = y, 
#         ...
#       )
#
#--------------
#    arima{stats} function: ARIMA Modelling of Time Series
#
#    Usage:
#       arima(
#           x,
#           order = c(0L, 0L, 0L),
#           seasonal = list(order = c(0L, 0L, 0L), period = NA),
#           xreg = NULL,
#           include.mean = TRUE,
#           transform.pars = TRUE,
#           fixed = NULL, init = NULL,
#           method = c("CSS-ML", "ML", "CSS"),
#           n.cond,
#           SSinit = c("Gardner1980", "Rossignol2011"),
#           optim.method = "BFGS",
#           optim.control = list(),
#           kappa = 1e6
#       )
#

#---------------------------------------------------------------
# ARIMA 모형 분석사례 1 : Random Walk ARIMA(0,1,0)
#                         ( No ARs, No MAs )
#---------------------------------------------------------------
# 분석요구 : Random Walk 시계열 자료에 대한, 
#            auto.arima 분석을 수행하시오
#---------------------------------------------------------------
rw.ts <- arima.sim(n = 500, 
                model = list(
                  order = c(0,1,0)
                )
            )
class(rw.ts)

graphics.off()

library(forecast)
tsdisplay(rw.ts, 
          main = 'Random Walk\nARIMA(0,1,0) model without ar, ma')

# plot(decompose(rw.ts))
# Error in decompose(rw.ts) : time series has no or less than 2 periods

#---------------------------------------------------------------
auto.arima(y = rw.ts, allowdrift = FALSE)  # allowdrift = TRUE (default)
# recommended model order by auto.arima: ARIMA(0,1,1)

( arima.m <- arima(x = rw.ts, order = c(1,1,0)) )
# class(arima.m)
# names(arima.m)
# summary(arima.m)
# accuracy(arima.m)
confint(arima.m)    # ma1 -0.1746618 0.006586308

( arima.m <- arima(x = rw.ts, order = c(1,1,0), fixed = c(0)) )
class(arima.m)
mode(arima.m)
names(arima.m)
arima.m$residuals
summary(arima.m)
accuracy(arima.m)
confint(arima.m)    # ma1    NA     NA --> removed

dev.new()

tsdiag(arima.m)
title('- ARIMA(1,1,0) -')

#---------------------------------------------------------------
# 분석결과: auto.arima 에 의한, Random Walk의 best fit model은,
#           ARIMA(1,1,0) 으로 분석됨.
#          잔차(residuals)는 정상 시계열로 판단됨(acf, box test)
#---------------------------------------------------------------


#---------------------------------------------------------------
# ARIMA 모형 분석사례 2 : auto.arima
#---------------------------------------------------------------
# 분석요구 : dd1.ts, dd3.ts 에 대하여, auto.arima 를 이용하여,
#            최적의 시계열 모형을 구성하고,
#            미래의 추정값을 예측하시오.
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1) 시계열 탐색 : dd1.ts, dd3.ts
#---------------------------------------------------------------
library(forecast)

graphics.off()
tsdisplay(dd1.ts, 
          main = 'dd1.ts with acf, pacf\nby tsdisplay')  # for dd1.ts

dev.new()
tsdisplay(dd3.ts, 
          main = 'dd3.ts with acf, pacf\nby tsdisplay')  # for dd3.ts
#-----------------------
graphics.off()

plot(decompose(dd1.ts))   # Decomposition of dd1.ts
title(main = '\n- dd1.ts -')

dev.new()
plot(decompose(dd3.ts))   # Decomposition of dd3.ts
title(main = '\n- dd3.ts -')

library(forecast)
findfrequency(dd1.ts)
findfrequency(dd3.ts)

#---------------------------------------------------------------
# 2) 정상성(stationarity) 검정 : dd1.ts, dd3.ts
#---------------------------------------------------------------
# kpss.test{tseries} hypothesis :
#   H0 - level or trend stationary, H1 - NOT H0
library(tseries)

# for dd1.ts
kpss.test(dd1.ts)
kpss.test(dd1.ts, null = 'Trend')

# for dd3.ts
kpss.test(dd3.ts)
kpss.test(dd3.ts, null = 'Trend')

#---------------------------------------------------------------
# 3) 모형구축(fitting) 및 진단(diagnostics) : dd1.ts, dd3.ts
#---------------------------------------------------------------
( dd1.am <- auto.arima(dd1.ts) )   # ARIMA(0,0,1) model

confint(dd1.am)

tsdiag(dd1.am)
title('- ARIMA(0,0,1) model for dd1.ts -')

# kpss.test{tseries} hypothesis :
#   H0 - level or trend stationary, H1 - NOT H0
# kpss.test(dd1.am$residuals)
# kpss.test(dd1.am$residuals, null = 'Trend')
# acf(dd1.am$residuals)
# pacf(dd1.am$residuals)

accuracy(dd1.am)

names(dd1.am)
dd1.am$x        # original ts
dd1.am$fitted   # fitted ts
#--------------
( dd3.am <- auto.arima(dd3.ts) )   # ARIMA(1,1,0) model

confint(dd3.am)

tsdiag(dd3.am)
title('- ARIMA(1,1,0) model for dd3.ts -')

# kpss.test{tseries} hypothesis :
#   H0 - level or trend stationary, H1 - NOT H0
# kpss.test(dd3.am$residuals)
# kpss.test(dd3.am$residuals, null = 'Trend')
# acf(dd3.am$residuals)
# pacf(dd3.am$residuals)

accuracy(dd3.am)

names(dd3.am)
dd3.am$x        # original ts
dd3.am$fitted   # fitted ts

#---------------------------------------------------------------
# 4) 시각화 및 진단 : dd1.ts, dd3.ts
#---------------------------------------------------------------
graphics.off()
tsdisplay(dd1.ts, main = '- dd1.ts -')

dev.new()
tsdisplay(dd1.am$fitted, 
          main = '- dd1.am$fitted with ARIMA(0,0,1) -')

graphics.off()
plot(decompose(dd1.ts))
title(main = '\n- dd1.ts -')

dev.new()
plot(decompose(dd1.am$fitted))
title(main = '\n- dd1.am$fitted with ARIMA(0,0,1) -')
#-------------------
graphics.off()
tsdisplay(dd3.ts, main = '- dd3.ts -')

dev.new()
tsdisplay(dd3.am$fitted, 
          main = '- dd3.am$fitted with ARIMA(1,1,0) -')


graphics.off()
plot(decompose(dd3.ts))
title(main = '\n- dd3.ts -')

dev.new()
plot(decompose(dd3.am$fitted))
title(main = '\ndd3.am$fitted by ARIMA(1,1,0) model')

#---------------------------------------------------------------
# 5) 분석결과(dd1.ts) :
#   1. auto.arima 에 의한 최적화 모형은, ARIMA(0,0,1) -> MA(1)모형
#      으로 구성됨
#   2. 잔차(residuals) 분석은, 검정결과 정상시계열로 판단됨
#   3. 모형 평가지수는 아래와 같음
#       ME     RMSE      MAE         MPE     MAPE      MASE     ACF1
#     3.80    76.71     62.31     -0.035     4.67      0.58     0.05
#
# 5) 분석결과(dd3.ts) :
#   1. auto.arima 에 의한 최적화 모형은, ARIMA(1,1,0) -> AR(1) 모형
#      으로 구성됨
#   2. 잔차(residuals) 분석은, 검정결과 정상시계열로 판단됨
#   3. 모형 평가지수는 아래와 같음
#       ME     RMSE      MAE     MPE    MAPE    MASE    ACF1
#    28.69   100.21    76.62    1.82    5.33    0.56  -0.083

#---------------------------------------------------------------
# 6) 예측 : dd1.am, dd3.am
#---------------------------------------------------------------
library(forecast)

( dd1.fc <- forecast(dd1.am) )
class(dd1.fc)
mode(dd1.fc)
names(dd1.fc)

graphics.off()
op = par(mfrow=c(2,1))

plot(dd1.fc)
title('\n\n- forecast of dd1.ts through dd1.am -')

plot(dd1.ts, main = 'dd3: fitted ts', col = 'green')
lines(dd1.fc$fitted, col = 2)
legend('bottomright', legend = paste('h =',1:2), col = 3:2, lty = 1)

par(op)
#---------------
( dd3.fc <- forecast(dd3.am) )
# class(dd3.fc)
# mode(dd3.fc)
# names(dd3.fc)

graphics.off()
op = par(mfrow=c(2,1))

plot(dd3.fc)
title('\n\n- forecast of dd3.ts through dd3.am -')

plot(dd3.ts, main = 'dd3: fitted ts', col = 'green')
lines(dd3.fc$fitted, col = 2)
legend('bottomright', legend = paste('h =',1:2), col = 3:2, lty = 1)

par(op)

#---------------------------------------------------------------
# 7) 시뮬레이션 : dd1.am, dd3.am
#---------------------------------------------------------------
graphics.off()
op = par(mfrow=c(2,1))

( dd1.sm1 <- simulate(object = dd1.am, nsim = 8) )
( dd1.sm2 <- simulate(object = dd1.am, nsim = 8, bootstrap = TRUE) )

plot(dd1.ts, xlim=c(2006, 2012), main = 'dd1.ts : simulation')

lines(dd1.sm1, col = 'red', lwd = 2)
lines(dd1.sm2, col = 'blue', lwd = 2)

legend('topleft', 
       legend = c('simulation', 'bootstrap'), 
       col=c('red','blue'), lty=1)
#------------------
( dd3.sm1 <- simulate(object = dd3.am, nsim = 8) )
( dd3.sm2 <- simulate(object = dd3.am, nsim = 8, bootstrap = TRUE) )

plot(dd3.ts, xlim=c(2006, 2012), main = 'dd1.ts : simulation')

lines(dd3.sm1, col = 'red', lwd = 2)
lines(dd3.sm2, col = 'blue', lwd = 2)

legend('bottomright', 
       legend = c('simulation', 'bootstrap'), 
       col=c('red','blue'), lty=1)

par(op)


#---------------------------------------------------------------
# ARIMA 모형 분석사례 3 : auto.arima{forecast} (No drift)
#---------------------------------------------------------------
# 분석요구 : 위 분석사례2의 시계열 자료 dd3.ts에 대하여,
#            Drift를 고려하지 않은, 최적의 ARIMA 시계열 모형을
#           구성하고, 2011년 자료를 예측하시오
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1) ARIMA(p,d,q) Model fitting without allowing drift of a ts
#---------------------------------------------------------------
( dd3.am <- auto.arima(dd3.ts, allowdrift = FALSE) )
confint(dd3.am)

graphics.off()

tsdiag(dd3.am)
title('- dd3.ts -')

accuracy(dd3.am)

fitted(dd3.am)

plot(dd3.am)
title(main = '\n\n- dd3.am -')

#---------------------------------------------------------------
# 2) forecasting next one year through ARIMA(1,1,0) with ar1
#---------------------------------------------------------------
library(forecast)
( dd3.fc <- forecast(dd3.am, h = 8) )

graphics.off()
op = par(mfrow=c(3,1))

plot(dd3.fc)
title(main = '\n\n- dd3.ts without allowing drift -')
lines(fitted(dd3.am), col = 'red', lty = 2, lwd = 2)

plot(dd3.ts, main = '- dd3.ts : fitted values -')
lines(fitted(dd3.fc, h = 2), col = 2)
legend('bottomright', legend = c('ts','fc$fitted'), col = c('black', 'red'), lty = 1)

( dd3.sm1 <- simulate(dd3.am, nsim = 8) )
( dd3.sm2 <- simulate(dd3.am, nsim = 8, bootstrap = TRUE) )

plot(dd3.ts, xlim=c(2006,2012), main = '- dd3.ts : simulation -')
lines(dd3.sm1, col = 'red', lwd = 2)
lines(dd3.sm2, col = 'blue', lwd = 2)
legend('bottomright', legend = c('simulation','bootstrap'), col = c('red','blue'), lty = 1)

par(op)


#---------------------------------------------------------------
# ARIMA 모형 분석사례 4 : auto.arima{forecast} with drift
#---------------------------------------------------------------
# 분석요구 : Nile{datasets} 시계열 자료에 대하여, 최적의
#            ARIMA 모형을 구성하고, 미래의 유량을 예측하시오
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1) Stationarity Test
#---------------------------------------------------------------
data(Nile)

Nile

class(Nile)
start(Nile)
end(Nile)
frequency(Nile)
cycle(Nile)
tsp(Nile)
index(Nile)
coredata(Nile)

#----------------------
library(forecast)
tsdisplay(Nile, main = '- Nile time series -')

# plot(decompose(Nile))
# Error in decompose(Nile) : time series has no or less than 2 periods

#----------------------
kpss.test(Nile)
kpss.test(Nile, null = 'Trend')

#---------------------------------------------------------------
# 2) ARIMA(p,d,q) Model fitting
#---------------------------------------------------------------
( Nile.am1 <- auto.arima(Nile, allowdrift = TRUE) )

summary(Nile.am1)
confint(Nile.am1)
accuracy(Nile.am1)

graphics.off()

tsdiag(Nile.am1)
title(main = '- Nile with drift -')

plot(Nile.am1)
title(main = '\n\n- ARIMA(1,1,1) model of Nile with drift -')

#----------------------
( Nile.am2 <- auto.arima(Nile, allowdrift = FALSE) )

summary(Nile.am2)
confint(Nile.am2)
accuracy(Nile.am2)

graphics.off()

tsdiag(Nile.am2)
title(main = '- Nile with no drift -')

plot(Nile.am2)
title(main = '\n\n- ARIMA(1,1,1) model\nof Nile with no drift -')

#---------------------------------------------------------------
# 3) forecasting through ARIMA(1,1,1) with ar1, ma1
#---------------------------------------------------------------
library(forecast)
( Nile.fc <- forecast(Nile.am1) )

graphics.off()
op = par(mfrow=c(3,1))

plot(Nile.fc)
title(main = '\n\n- Nile with drift -')
lines(fitted(Nile.am1), col = 'red', lty = 2, lwd = 2)

plot(Nile, main = '- Nile : fitted values -')
lines(fitted(Nile.fc, h = 1), col = 2)
legend('bottomleft', legend = c('ts','fc$fitted'), col = c('black', 'red'), lty = 1)

#-----------------------
( Nile.sm1 <- simulate(Nile.am1, nsim = 10) )
( Nile.sm2 <- simulate(Nile.am1, nsim = 10, bootstrap = TRUE) )

plot(Nile, xlim=c(1870,1980), main = '- Nile : Simulation -')
lines(Nile.sm1, col = 'red', lwd = 2)
lines(Nile.sm2, col = 'blue', lwd = 2)
legend('bottomleft', legend = c('simulation','bootstrap'), col = c('red','blue'), lty = 1)

par(op)


#---------------------------------------------------------------
# ARIMA 모형 분석사례 5 : 
#               auto.arima{forecast} with BoxCox Transformation
#---------------------------------------------------------------
# 분석요구 : winnebago{TSA} 시계열 자료에 대하여, 최적의
#            ARIMA 모형을 BoxCox 변환을 토대로 분석하시오
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1) Stationarity Test
#---------------------------------------------------------------
library(TSA)
data(winnebago)

winnebago

class(winnebago)
str(winnebago)
start(winnebago)
end(winnebago)
frequency(winnebago)
cycle(winnebago)
tsp(winnebago)

library(forecast)
findfrequency(winnebago)

#---------------------
kpss.test(winnebago, null = 'Level')
kpss.test(winnebago, null = 'Trend')

#---------------------
graphics.off()

plot(decompose(winnebago))
title('\n- winnebago -')

dev.new()

library(forecast)
tsdisplay(winnebago, main = '- winnebago{TSA} -')

#---------------------------------------------------------------
# 2) ARIMA(p,d,q) Model fitting with BoxCox Transformation
#---------------------------------------------------------------
( winnebago.am1 <- auto.arima(winnebago) ) # ARIMA(0,1,1)(1,0,0)[12]
winnebago.am1
# summary(winnebago.am1)
confint(winnebago.am1)
accuracy(winnebago.am1)

graphics.off()

tsdiag(winnebago.am1)
title(main = '- winnebago.am1 -')

#--------------------
( lambda <- BoxCox.lambda(winnebago) )

#--------------------
( winnebago.am2 <- auto.arima(BoxCox(winnebago, lambda = lambda)) ) # ARIMA(1,0,0)(1,1,0)[12]
winnebago.am2
# summary(winnebago.am2)
confint(winnebago.am2)
accuracy(winnebago.am2)

graphics.off()

tsdiag(winnebago.am2)
title(main = '- winnebago.am2 with BoxCox transformation -')

#---------------------------------------------------------------
# 3) forecasting with ARIMA Model with BoxCox Transformation
#---------------------------------------------------------------
( winnebago.fc <- forecast(winnebago.am2, h = 20, lambda = lambda) )

class(winnebago.fc)
mode(winnebago.fc)
names(winnebago.fc)

graphics.off()
op = par(mfrow=c(3,1))

plot(winnebago.fc)
title(main = '\n\n- winnebago -')
lines(winnebago, col = 'red', lty = 1, lwd = 2)

plot(winnebago, main = '- winnebago : fitted values -')

library(bimixt)
lines(boxcox.inv(winnebago.fc$fitted, lambda = lambda), col = 2)
legend('topleft', legend = c('ts','fc$fitted'), col = c('black', 'red'), lty = 1)

#-----------------------
( winnebago.sm1 <- simulate(winnebago.am2, nsim = 20) )
( winnebago.sm2 <- simulate(winnebago.am2, nsim = 20, bootstrap = TRUE) )

plot(winnebago, xlim=c(1967,1973), ylim=c(0, 4500), main = '- winnebago : Simulation -')
lines(boxcox.inv(winnebago.sm1, lambda = lambda), col = 'red', lwd = 2)
lines(boxcox.inv(winnebago.sm2, lambda = lambda), col = 'blue', lwd = 2)
legend('topleft', legend = c('simulation','bootstrap'), col = c('red','blue'), lty = 1)

par(op)







