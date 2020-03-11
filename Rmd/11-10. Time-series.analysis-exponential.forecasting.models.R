#----------------------------------------------------------------------------------
# 지수예측모델 ( Exponential forecasting models)
#----------------------------------------------------------------------------------
# 지수예측모델은, 시계열에서 미래수치를 예측하는데, 가장 널리 사용되는 접근법임.
# 다른 모델에 비해 단순하면서도, '단기미래예측'에 있어, 넓은 영역에서 많이 적용됨.
# 
#
# 시계열 성분을 분해(요소분해)하는 방법에 따라서, 지수예측모델을 아래와 같이 구분함 :
#
#   1) 단순지수모델 (simple exponential model) - '단일지수모델' 이라고도 함
#
#         Y[t] = Level[t] + Irregual
#
#       - 추세성분과 계절성분 모두 없지만, 시간[t]에서의 수준(Level = local mean)과
#         불규칙성분(Irregular Component)을 가짐
#
#   2) 이중지수모델 (double exponential model) - 'Holt 지수평활법' 이라고도 함
#         
#         Y[t] = Level[t] + Trend
#
#       - 시간[t]에서의 수준과 추세성분으로 구성된 시계열에 적합
#
#   3) 삼중지수모델 (triple exponential model) - 'Holt-Winters 지수평활법' 이라고도 함
#
#         Y[t] = Level[t] + Trend + Seasonal
#
#       - 시간[t]에서의 수준과 추세, 계절성분으로 구성된 시계열에 적합
#---------------------------------------
# R의 지수예측모델 지원 함수들
#   1) ets{forecast} function : Exponential smoothing state space model
#   2) HoltWinters{stats} function : Holt-Winters Filtering
#   3) ses{forecast} function : Exponential smoothing forecasts
#   4) holt{forecast} function : Exponential smoothing forecasts
#   5) hw{forecast} function : Exponential smoothing forecasts
#   6) tbats{forecast} function : TBATS model
#       Exponential smoothing state space model 
#       with Box-Cox transformation, ARMA errors, Trend and Seasonal components
#---------------------------------------
# 1) ets{forecast} function : Exponential smoothing state space model
#     - 'model' 인자는 '세문자'로 구성됨 (아래 참고)
#       첫문자 : 오차(error) 타입, 두번째 문자 : 추세(trend) 타입, 세번째 문자 : 계절(season) 타입
#       허용문자로는, 
#         (1) A : additive model, (2) M : multiplicative model, (3) N : none, (4) Z : 자동선택
#
#     ets(y, model = "ZZZ", damped = NULL, alpha = NULL, beta = NULL,
#         gamma = NULL, phi = NULL, additive.only = FALSE, lambda = NULL,
#         biasadj = FALSE, lower = c(rep(1e-04, 3), 0.8), 
#         upper = c(rep(0.9999, 3), 0.98), 
#         opt.crit = c("lik", "amse", "mse", "sigma", "mae"), nmse = 3,
#         bounds = c("both", "usual", "admissible"), ic = c("aicc", "aic", "bic"),
#         restrict = TRUE, allow.multiplicative.trend = FALSE,
#         use.initial.values = FALSE, na.action = c("na.contiguous", "na.interp", "na.fail"), ...)
#
#     where,
#         - y : a numeric vector or time series of class ts
#         - model : Usually a three-character string identifying method 
#                   using the framework terminology of Hyndman et al. (2002) and 
#                   Hyndman et al. (2008).
# 
#                   * The first letter  denotes  the 'error'  type   ("A", "M" or "Z").
#                   * The second letter denotes  the 'trend'  type   ("N","A","M" or "Z"). 
#                   * The third letter  denotes  the 'season' type   ("N","A","M" or "Z"). 
#
#                   In all cases, 
#                     * "N"=none, "A"=additive, "M"=multiplicative, "Z"=automatically selected.
#
#                   So, for example, 
#                       * "ANN" is simple exponential smoothing with additive errors, 
#                       * "MAM" is multiplicative Holt-Winters' method with multiplicative errors, 
#                   and so on.
#
#                   It is also possible for the model to be of class "ets", 
#                   and equal to the output from a previous call to ets. 
#                   In this case, the same model is fitted to y 
#                   without re-estimating any smoothing parameters.
#---------------------------------------
# 2) ses{forecast}, holt{forecast}, hw{forecast} functions 
#    - 위 ets() 함수를, 기본설정으로 사전에 지정한, 
#    - 편리하게 사용가능한 함수들.
#    - Returns forecasts and other information for exponential smoothing forecasts applied to y.
#    - ses{forecast}, holt{forecast} and hw{forecast} are simply convenient wrapper functions 
#      for forecast(ets(...)).
#    - An object of class "forecast".
#    - The function summary{base} is used to obtain and print a summary of the results, 
#      while the function plot{graphics} produces a plot of the forecasts and prediction intervals.
#    - The generic accessor functions fitted.values{stats} and residuals{stats}/resid{stats} extract 
#      useful features of the value returned by ets and associated functions.
#    - Usage :
#     
#       ses(y, h = 10, level = c(80, 95), fan = FALSE, initial = c("optimal", "simple"), 
#             alpha = NULL, lambda = NULL, biasadj = FALSE, x = y, ...)
#
#       holt(y, h = 10, damped = FALSE, level = c(80, 95), fan = FALSE,
#             initial = c("optimal", "simple"), exponential = FALSE, alpha = NULL,
#             beta = NULL, phi = NULL, lambda = NULL, biasadj = FALSE, x = y, ...)
#
#       hw(y, h = 2 * frequency(x), seasonal = c("additive", "multiplicative"),
#             damped = FALSE, level = c(80, 95), fan = FALSE, initial = c("optimal", "simple"), 
#             exponential = FALSE, alpha = NULL, beta = NULL, gamma = NULL, phi = NULL, 
#             lambda = NULL, biasadj = FALSE, x = y, ...)
#
#       where,
#           - y	: a numeric vector or time series of class ts
#           - h : number of periods for forecasting
#           - level : confidence level for prediction intervals
#           - lambda : Box-Cox transformation parameter. 
#                      If lambda="auto", then a transformation is automatically selected 
#                      using BoxCox.lambda. The transformation is ignored if NULL. 
#                      otherwise, data transformed before model is estimated.
#           - damped : If TRUE, use a damped trend
#           - *phi : Value of damping parameter if damped=TRUE. 
#                    If NULL, it will be estimated.
#           - exponential : If TRUE, an exponential trend is fitted. 
#                           otherwise, the trend is (locally) linear.
#           - seasonal : Type of seasonality in hw model. "additive" or "multiplicative"
#           - *alpha : Value of smoothing parameter for the level. 
#                      If NULL, it will be estimated.
#           - *beta : Value of smoothing parameter for the trend. 
#                     If NULL, it will be estimated.
#           - *gamma : Value of smoothing parameter for the seasonal component. 
#                      If NULL, it will be estimated.
#---------------------------------------
# 3) HoltWinters{stats} function
#   - Computes Holt-Winters Filtering of a given time series.
#   - Unknown parameters are determined by minimizing the squared prediction error.
#   - Usage :
#       
#       HoltWinters(x, alpha = NULL, beta = NULL, gamma = NULL,
#                   seasonal = c("additive", "multiplicative"),
#                   start.periods = 2, l.start = NULL, b.start = NULL, s.start = NULL,
#                   optim.start = c(alpha = 0.3, beta = 0.1, gamma = 0.1),
#                   optim.control = list())
#
#   - where,
#             - x : An object of class ts
#             - alpha : alpha parameter of Holt-Winters Filter
#             - beta : beta parameter of Holt-Winters Filter. 
#                      If set to FALSE, the function will do exponential smoothing.
#             - gamma : gamma parameter used for the seasonal component.
#                       If set to FALSE, an non-seasonal model is fitted.
#             - seasonal : Character string to select 
#                          an "additive" (the default) or "multiplicative" seasonal model.
#                          The first few characters are sufficient. 
#                          (Only takes effect if gamma is non-zero).
#---------------------------------------
# 4) tbats{forecast} function
#     - Fits a TBATS model applied to y, as described in De Livera, Hyndman & Snyder (2011). 
#     - Parallel processing is used by default to speed up the computations.
#     - Usage :
# 
#         tbats(y, use.box.cox = NULL, use.trend = NULL, use.damped.trend = NULL,
#               seasonal.periods = NULL, use.arma.errors = TRUE,
#               use.parallel = length(y) > 1000, num.cores = 2, bc.lower = 0,
#               bc.upper = 1, biasadj = FALSE, model = NULL, ...)
#     
#     - where,
#           - y : The time series to be forecast. 
#                 Can be numeric, msts or ts. 
#                 Only univariate time series are supported.
#           - use.box.cox : TRUE/FALSE indicates whether to use the Box-Cox transformation or not. 
#                           If NULL then both are tried and the best fit is selected by AIC.
#           - use.trend :  indicates whether to include a trend or not. 
#                          If NULL then both are tried and the best fit is selected by AIC.
#           - use.damped.trend : TRUE/FALSE indicates whether to include a damping parameter 
#                                in the trend or not. 
#                                If NULL then both are tried and the best fit is selected by AIC.
#           - use.arma.errors : TRUE/FALSE indicates whether to include ARMA errors or not. 
#                               If TRUE the best fit is selected by AIC. 
#                               If FALSE then the selection algorithm does not consider ARMA errors.
#           - use.parallel : TRUE/FALSE indicates whether or not to use parallel processing.
#           - num.cores : The number of parallel processes to be used if using parallel processing.
#                         If NULL then the number of logical cores is detected and 
#                         all available cores are used.
#           - model : Output from a previous call to tbats. 
#                     If model is passed, this same model is fitted to y 
#                     without re-estimating any parameters.
#---------------------------------------
# 지수예측모델 유형별 함수들 정리
#   1) 단순지수예측모델
#       - 적용 파라미터 : Level[t]
#       - 함수 : ets(ts, model = 'ANN') or ses(ts)
#   2) 이중지수예측모델
#       - 적용 파라미터 : Level[t], Slope(= Trend)
#       - 함수 : ets(ts, model = 'AAN') or holt(ts)
#   3) 삼중지수예측모델
#       - 적용 파라미터 : Level[t], Slope(= Trend), Seasonal
#       - 함수 : ets(ts, model = 'AAA') or hw(ts)
#----------------------------------------------------------------------------------

#----------------------------------------------------------------------------------
# 1. 단순지수평활법 (simple exponential smoothing)
#----------------------------------------------------------------------------------
# 단기적 미래 예측을 위해, 기존 시계열 자료의 가중평균을 사용.
# 가중치는, 현재에서 -> 과거로 멀리 거슬러 갈수록, 지수적으로 감소하도록 선택
#
# (**주의**) 시계열에 추세(trend)와 계절(season) 성분이 없음을 가정함
#
# 시계열 자료의 관측치는 아래와 같이 기술됨 :
#
#       Y[t] = 시간수준(level) + 불규칙성분(irregular)
#
# Y[t+1]에서의, 1 단계 선행예측(1-step ahead forecasting)은 아래와 같음 :
#
#       Y[t+1] = c0*Y[t] + c1*Y[t-1] + c2*Y[t-2] + c3*Y[t-3] + ...
#
#       where,
#         - 가중치 c[i] = alpha(1 - alpha), (i=0,1,2,..., 0<= alpha <= 1)
#         - 가중치 c[i] 의 합은 1
#         - 1단계 선행 예측치는, 시계열의 현재 수치와 과거 모든 수치의 가중평균이 됨
#         - alpha 파라미터 : 가중치의 감소율을 통제.
#                            if 1에 가까울수록, 최근시점의 관측치에 보다 높은 가중치 부여.
#                            if 0에 가까울수록, 과거시점의 관측치에 보다 높은 가중치 부여.
#                            이 파라미터이 값은 자동선택됨 (적합기준의 최적화를 위해서)
#         - 최적화된 적합기준이란 ? 
#           통상 적합기준은, 실제값(시계열 관측치)과 예측값(적합시킨 모형을 통한) 간의 오차제곱의 합
#---------------------------------------
#

###
# time-series data : nhtemp{datasets}
# 1912 ~ 1971, Conneticut State, New Haven Region's annual mean temperatures (by Farenheit)
# No obvious trend since yearly time-series data doesn't have seasons.
# So, simple exponential model sets fit to this time-series.
#
# 1-step ahead forecasting using ets{forecast} function

library(forecast)
data("nhtemp")

nhtemp

class(nhtemp)
start(nhtemp)
end(nhtemp)
cycle(nhtemp)
tsp(nhtemp)
frequency(nhtemp)
findfrequency(nhtemp)

library(zoo)
index(nhtemp)
coredata(nhtemp)
summary(nhtemp)

#-------------------
graphics.off()

plot(nhtemp, main = 'nhtemp time-series')
ts.plot(nhtemp, main = 'nhtemp time-series')
tsdisplay(nhtemp,
          main = 'nhtemp{datasets}\ntime-series', 
          points = FALSE,
          xlab = 'Year',
          ylab = 'Temperature (Farenheit)',
          col = 'red',
          lty = 1,
          lwd = .5,
          ci.type = c('white'), # 'white' or 'ma'
          na.action = na.interp)  # useful options : na.pass or na.interp

monthplot(x = nhtemp,
          ylab = 'Temperature (Farenheit)', 
          main = 'nhtemp{datasets}\ntime-series',
          col = 'red',
          labels = 'Yearly',
          lty = 1,
          lwd = .5)

# library(colorspace)
# pal = choose_palette()

# seasonplot(x = nhtemp, 
#            s = findfrequency(nhtemp), 
#            year.labels = TRUE, 
#            year.labels.left = TRUE, 
#            main = 'nhtemp time-series', 
#            xlab = 'Year', 
#            ylab = 'Temperature (Farenheit)', 
#            col = pal(60))

#-------------------
graphics.off()
op <- par(mfrow = c(4,1))

plot(nhtemp, 
     col = 'black',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Temperature (Farenheight)',
     main = 'Original nhtemp{datasets} time-series')

library(forecast)
plot(ma(x = nhtemp, order = 3), 
     col = 'red',
     lty = 1,
     lwd = .7,
     xlab = 'Year',
     ylab = 'Temperature (Farenheight)',
     main = 'nhtemp{datasets} time-series\nMA{forecast} with order = 3')

library(TTR)
plot(SMA(x = nhtemp, n = 7), 
     col = 'blue',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Temperature (Farenheight)',
     main = 'nhtemp{datasets} time-series\nSMA{TTR} with n = 7')

library(zoo)
plot(rollmean(x = nhtemp, k = 9), 
     col = 'red',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Temperature (Farenheight)',
     main = 'nhtemp{datasets} time-series\nrollmean{zoo} with k = 9')

par(op)

#-------------------
# Model('ANN') : Auto Irregular + None Trend + None Seasonality
(
  ets.m <- ets(y = nhtemp, 
             model = 'ANN', 
             additive.only = FALSE,  # FALSE(default), TRUE(additive model only) 
             lambda = NULL,          # NULL(default), 'auto' 
             opt.crit = 'lik',
             biasadj = TRUE,
             na.action = na.pass)
)

summary(ets.m)

class(ets.m)
mode(ets.m)
names(ets.m)

accuracy(ets.m)


graphics.off()

plot(resid(ets.m),
     col = 'blue',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Residuals',
     main = 'resid(ets.m) of\nnhtemp{datasets} ETS model')

plot(resid(ets.m),
     col = 'red',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Residuals',
     main = 'residuals(ets.m) of\nnhtemp{datasets} ETS model')

plot(fitted(ets.m),
     col = 'purple',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'fitted',
     main = 'fitted(ets.m) of\nnhtemp{datasets} ETS model')

plot(fitted.values(ets.m),
     col = 'purple',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'fitted.values',
     main = 'fitted.values(ets.m)\nof nhtemp{datasets} ETS model')

plot(ets.m$states,
     col = 'red',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'l',
     main = 'ets.m$states of\nnhtemp{datasets} ETS model')

ets.m$components
ets.m$series
ets.m$method
ets.m$states

plot(ets.m$initstate)

ets.m$fit

#-------------------
( ets.fcst <- forecast(object = ets.m, h = 1) ) # 1-step ahead forecasting

class(ets.fcst)
mode(ets.fcst)
names(ets.fcst)

ets.fcst$model
ets.fcst$mean
ets.fcst$level
ets.fcst$x
ets.fcst$upper
ets.fcst$lower
ets.fcst$fitted
ets.fcst$method
ets.fcst$series
ets.fcst$residuals

#-------------------
graphics.off()

plot(ets.fcst,
     col = 'purple',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Temperature (Farenheit)',
     main = 'Forecasts of\nnhtemp{datasets} ETS model')


#----------------------------------------------------------------------------------
# 2. Holt, Holt-Winters 지수평활법 (Holt & Holt-Winters exponential smoothing)
#----------------------------------------------------------------------------------
# (1) Holt exponential smoothing
#     - 전체시간수준(Level)과 추세(Trend)가 있는 시계열에 적합
#     - 시간 t 에서의 모델은, 아래와 같음 :
#         
#         Y[t] = 수준(level)[t] + 기울기(slope)[t]*t + 불규칙(irregular)[t]
#
# (2) Holt-Winters exponential smoothing
#     - 전체시간수준(Level), 추세(Trend), 계절성분(Seasonality)이 있는 시계열에 적합
#     - 시간 t 에서의 모델은, 아래와 같음 :
#
#         Y[t] = 수준(level)[t] + 기울기(slope)[t] * t + 계절(seasonal)[t] + 불규칙(irregular)[t]
#
#       where,
#             - season[t] : 시간 t 에서의, 계절효과(seasoanl effect)
#             - alpha, beta parameters 외에, 
#               gamma parameter가 계절성분(seasonal component)의 지수효과(exponential effect)를 통제
#             - alpha, beta, gamma parameters : 0<= parameter <= 1
#               이 파라미터의 값이 클수록, 계절효과(seasonal effect)의 계산시, 
#               최근 시점의 관측치에 큰 가중치를 부여.
#---------------------------------------
#

###
# time-series data : AirPassengers{datasets}
# 1949 ~ 1960, Monthly Airline Passenger Numbers
#
# The classic Box & Jenkins (ARIMA) airline data. 
# Monthly totals of international airline passengers, 1949 to 1960.
#
# Yes Trend, Yes Seasonal, Yes Irregular components
#
# 12-step ahead forecasting using ets{forecast} function

data("AirPassengers")

AirPassengers

class(AirPassengers)

start(AirPassengers)
end(AirPassengers)
frequency(AirPassengers)
findfrequency(AirPassengers)

cycle(AirPassengers)
tsp(AirPassengers)

library(zoo)
index(AirPassengers)
coredata(AirPassengers)

#-------------------
graphics.off()

plot(AirPassengers, 
     col = 'red',
     lty = 1,
     lwd = 3,
     xlab = 'Month',
     ylab = 'Passengers',
     main = 'AirPassengers{datasets} time-series')

ts.plot(AirPassengers, 
        col = 'blue',
        lty = 1,
        lwd = 3,
        xlab = 'Month',
        ylab = 'Passengers',
        main = 'AirPassengers{datasets} time-series')

tsdisplay(AirPassengers,
          main = 'AirPassengers{datasets}\ntime-series', 
          points = FALSE,
          xlab = 'Year',
          ylab = 'Passengers',
          col = 'red',
          lty = 1,
          lwd = .5,
          ci.type = c('white'), # 'white' or 'ma'
          na.action = na.interp)  # useful options : na.pass or na.interp

monthplot(x = AirPassengers,
          ylab = 'Passengers', 
          main = 'AirPassengers{datasets}\ntime-series',
          col = 'blue',
          # labels = c(),
          lty = 1,
          lwd = 3)

library(colorspace)
( pal = choose_palette() )
pal(20)

seasonplot(x = AirPassengers,
           s = findfrequency(AirPassengers),
           year.labels = TRUE,
           year.labels.left = FALSE,
           main = 'AirPassengers{datasets}\ntime-series',
           xlab = 'Month',
           ylab = 'Passengers',
           col = pal(12), lty = 3, lwd = 2)

#-------------------
library(forecast)

# Model('AAA') : Auto Irregular + Auto Trend + Auto Seasonality
(
  ets.m <- ets(log(AirPassengers), model = 'AAA')
  
  # ets.m <- ets(log(AirPassengers), model = 'AAA', additive.only = TRUE)
  
  # ets.m <- ets(y = log(AirPassengers), 
  #              model = 'AAA', 
  #              additive.only = TRUE,  # FALSE(default), TRUE(additive model only)
  #              na.action = na.pass)
)

accuracy(ets.m)

#-------------------
( ets.fcst <- forecast(ets.m, h = 12) ) # 12-steps ahead forecasting
names(ets.fcst)
#-------------------
graphics.off()
op <- par(mfrow = c(2,1))

plot(ets.fcst,
     col = 'blue',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'log(Passengers)',
     main = 'Forecasts of\nAirPassengers{datasets} ETS model')
#-------
( ets.fcst$x <- exp(ets.fcst$x) )
( ets.fcst$mean <- exp(ets.fcst$mean) )
( ets.fcst$lower <- exp(ets.fcst$lower) )
( ets.fcst$upper <- exp(ets.fcst$upper) )
( ets.fcst$fitted <- exp(ets.fcst$fitted) )

( p <- cbind(ets.fcst$mean, ets.fcst$lower, ets.fcst$upper) )
class(p)      # ts/mts/matrix
dimnames(p)   # for ts/mts/matrix

dimnames(p)[[2]] <- c('mean','Lo 80','Lo 95','Hi 80','Hi 95')
p
#-------
plot(ets.fcst,
     col = 'blue',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     ylab = 'Passengers',
     main = 'Forecasts of\nAirPassengers{datasets} ETS model')

par(op)


#----------------------------------------------------------------------------------
# 3. ets{forecast} function & 자동예측 (automated forecasting)
#----------------------------------------------------------------------------------
# (1) ets{forecast} 함수의 부가적 기능들
#     - 지수모델(exponential model)을 승법모델로 적합화
#       가법모델(additive model)을 위해, 필요시 시계열 자료에 로그변환(log함수적용) 부과하고,
#       모델 적합 수행. 대안으로, 원 시계열 자료를 승법모델(multiplicative)로 적합화 가능.
#       따라서, 원 시계열 자료의 수치단위로, 정확도 통계와 예측치들을 표시가능.
#     - 시계열 자료에서, 
#       추세(trend)성분은 가법적(addtive)이지만, 
#       계절(season)과 불규칙(irregular) 성분은 승법적(multiplicative)임을,
#       가정함
#     - 완화성분의 첨가 :
#       시계열 예측은, 추세(trend)가 영원히 지속될 것으로 가정.
#       완화성분은, 추세(trend)를 일정기간, 수평점근선에 부과함.
#       따라서, 많은 경우에, 완화된 모델은, 보다 현실적인 예측을 가능하게 함.
#     - 자동예측 수행 :
#       시계열 자료에 가장 적합한 모델을, 자동으로 선택가능.
#---------------------------------------
#

###
# time-series data : JohnsonJohnson{datasets}
# 1960 ~ 1980, Quarterly earnings (dollars) per Johnson & Johnson share
#
# Yes Trend, Yes Seasonal, Yes Irregular components
#
# 12-step ahead forecasting using ets{forecast} function

data(JohnsonJohnson)

#-------
graphics.off()
plot(decompose(JohnsonJohnson), col = 'red', lty = 1, lwd = .6)
title(main = '\n- JohnsonJohnson{datasets} -')

#-------
library(forecast)
( ets.m <- ets(JohnsonJohnson) )    # ETS(M,A,A) 

# 어떤 모델도 지정하기 않았기 때문에, 적합한 기준을 찾기위해,
# 광범위한 모형배열의 검색작업 수행.
#
# 선택된 모형은, 1) 추세(Trend)  2) 계절(Seasonal)  3) 불규칙(Irregular) 성분의
# 승법모델(Multiplicative model) 임
#
#   - ETS(M,A,A) : 불규칙(irregular)성분 유형이, 'M'(Multiplicative, 승법모델)으로 
#                  결정됨

#-------
graphics.off()
plot(forecast(ets.m, h = 12),
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} ETS model')


#---------------------------------------------
# Forecasting using ses{forecast} function
# suitable for Y[t] = Irrregular[t] + Trend[t] (No Seasonal)
#---------------------------------------------
data("nhtemp")
nhtemp

(
  # ses.m <- ses(y = nhtemp,
  #              h = 12,
  #              level = c(80, 95),
  #              initial = 'optimal')
  
  # Automated model fitting & forecasting with h = 10
  ses.m <- ses(nhtemp, h = 12)   # h = 10 automatically
)

accuracy(ses.m)

class(ses.m)
mode(ses.m)
names(ses.m)

ses.m$model
ses.m$series
ses.m$level
ses.m$method

ses.m$x
ses.m$fitted
ses.m$residuals

ses.m$mean
ses.m$lower
ses.m$upper

#-------
graphics.off()
plot(ses.m,
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Temperature (Farenheit)',
     main = 'Forecasts of\nnhtemp{datasets} ETS model')

#-------
plot(forecast(ses.m, h = 12),
     col = 'red',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Temperature (Farenheit)',
     main = 'Forecasts of\nnhtemp{datasets} ETS model')

# Error in forecast.forecast(ses.m, h = 12) : 
# Please select a longer horizon when the forecasts are first computed
# solution: 이 오류가 발생하는 이유는, 모형에서 예측된 개수(h인자)보다
#           많은 예측값을 플롯하려고 시도할 때 발생. 따라서,
#           플롯 함수에서, 예측된 개수 지정시, 모형에서는 몇개의 예측값이
#           발생햇는지 확인해서 맞추어 줄것!!!

#---------------------------------------------
# Forecasting using holt{forecast} function
# suitable for Y[t] = Irrregular[t] + Trend[t] (No Seasonal)
#---------------------------------------------
data(nhtemp)

(
  # holt.m <- holt(y = nhtemp, 
  #                h = 12, 
  #                level = c(80, 95), 
  #                # exponential = TRUE 
  #                exponential = FALSE
  #             )
  
  # Automated model fitting & forecasting with h = 10
  holt.m <- holt(nhtemp)   # h = 10 automatically
)

accuracy(holt.m)

class(holt.m)
mode(holt.m)
names(holt.m)

holt.m$model
holt.m$series
holt.m$level
holt.m$method

holt.m$x
holt.m$fitted
holt.m$residuals

holt.m$mean
holt.m$lower
holt.m$upper

#-------
graphics.off()
plot(holt.m,
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Temperature (Farenheit)',
     main = 'Forecasts of\nnhtemp{datasets} ETS model')

#-------
plot(forecast(holt.m, h = 10),
     col = 'red',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Temperature (Farenheit)',
     main = 'Forecasts of\nnhtemp{datasets} ETS model')

# Error in forecast.forecast(holt.m, h = 12) : 
# Please select a longer horizon when the forecasts are first computed
# solution: 이 오류가 발생하는 이유는, 모형에서 예측된 개수(h인자)보다
#           많은 예측값을 플롯하려고 시도할 때 발생. 따라서,
#           플롯 함수에서, 예측된 개수 지정시, 모형에서는 몇개의 예측값이
#           발생햇는지 확인해서 맞추어 줄것!!!

#---------------------------------------------
# Forecasting using hw{forecast} function
# suitable for Y[t] = Irregular[t] + Trend[t] + Seasonal[t] ( All components )
#---------------------------------------------
data(JohnsonJohnson)

( 
  # hw.m <- hw(y = JohnsonJohnson, 
  #            h = 12, 
  #            # seasonal = 'multiplicative',
  #            seasonal = 'additive', 
  #            level = c(80, 95), 
  #            # exponential = FALSE
  #            exponential = TRUE
  #           )
  
  # Automated model fitting & forecasting with h = 8
  hw.m <- hw(JohnsonJohnson)
)

accuracy(hw.m)

class(hw.m)
mode(hw.m)
names(hw.m)

hw.m$model
hw.m$series
hw.m$level
hw.m$method

hw.m$x
hw.m$fitted
hw.m$residuals

hw.m$mean
hw.m$lower
hw.m$upper

#-------
graphics.off()
plot(hw.m,
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} ETS model')

#-------
plot(forecast(hw.m, h = 8),
     col = 'red',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} ETS model')

# Error in forecast.forecast(holt.m, h = 12) : 
# Please select a longer horizon when the forecasts are first computed
# solution: 이 오류가 발생하는 이유는, 모형에서 예측된 개수(h인자)보다
#           많은 예측값을 플롯하려고 시도할 때 발생. 따라서,
#           플롯 함수에서, 예측된 개수 지정시, 모형에서는 몇개의 예측값이
#           발생햇는지 확인해서 맞추어 줄것!!!

#---------------------------------------------
# Forecasting using HoltWinters{forecast} function
# suitable for Y[t] = Irregular[t] + Trend[t] + Seasonal[t] ( All components )
#---------------------------------------------
data(JohnsonJohnson)

( 
  HoltWinters.m <- HoltWinters(x = JohnsonJohnson,
                               seasonal = 'multiplicative')
                               # seasonal = 'additive')
  
  # Automated model fitting & forecasting with h = 8
  # HoltWinters.m <- HoltWinters(JohnsonJohnson)
)
#-----------------

class(HoltWinters.m)
mode(HoltWinters.m)
names(HoltWinters.m)

HoltWinters.m$x
HoltWinters.m$fitted

HoltWinters.m$alpha
HoltWinters.m$beta
HoltWinters.m$gamma

HoltWinters.m$coefficients
HoltWinters.m$seasonal
HoltWinters.m$SSE
HoltWinters.m$call

#-------
graphics.off()
plot(HoltWinters.m,
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} ETS model')

#-------
( HoltWinters.fcst <- forecast(object = HoltWinters.m, h = 8) )

class(HoltWinters.fcst)
mode(HoltWinters.fcst)
names(HoltWinters.fcst)

HoltWinters.fcst$method
HoltWinters.fcst$model
HoltWinters.fcst$level
HoltWinters.fcst$series

HoltWinters.fcst$x
HoltWinters.fcst$fitted
HoltWinters.fcst$residuals

HoltWinters.fcst$mean
HoltWinters.fcst$lower
HoltWinters.fcst$upper

#-------
graphics.off()
plot(HoltWinters.fcst,
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} ETS model')

#-------
plot(forecast(HoltWinters.m, h = 8),
     col = 'red',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} ETS model')

# Error in forecast.forecast(HoltWinters.m, h = 12) : 
# Please select a longer horizon when the forecasts are first computed
# solution: 이 오류가 발생하는 이유는, 모형에서 예측된 개수(h인자)보다
#           많은 예측값을 플롯하려고 시도할 때 발생. 따라서,
#           플롯 함수에서, 예측된 개수 지정시, 모형에서는 몇개의 예측값이
#           발생햇는지 확인해서 맞추어 줄것!!!



#---------------------------------------------
# Forecasting using tbats{forecast} function
# suitable for Y[t] = Irregular[t] + Trend[t] + Seasonal[t] ( All components )
#---------------------------------------------
data(JohnsonJohnson)

# system.time(expr = {
#   tbats.m <- tbats(y = JohnsonJohnson,
#                    use.box.cox = TRUE,            # TRUE, FALSE, NULL (tried and selected)
#                    use.trend = TRUE,              # TRUE, FALSE, NULL (tried and selected)
#                    use.arma.errors = TRUE,        # TRUE, FALSE
#                    use.parallel = TRUE,           # TRUE, FALSE
#                    # use.parallel = FALSE,        # TRUE, FALSE
#                    num.cores = NULL)
#   
#   print(tbats.m)
# }, gcFirst = TRUE)
  
# Automated model fitting & forecasting with h = 8
system.time(expr = {
  tbats.m <- tbats(JohnsonJohnson)

  print(tbats.m)
}, gcFirst = TRUE)

#-----------------
class(tbats.m)
mode(tbats.m)
names(tbats.m)

tbats.m$x
tbats.m$y
tbats.m$fitted
tbats.m$fitted.values
tbats.m$errors

tbats.m$alpha
tbats.m$beta
tbats.m$gamma.one.values
tbats.m$gamma.two.values
tbats.m$lambda
tbats.m$damping.parameter

tbats.m$ar.coefficients
tbats.m$ma.coefficients
tbats.m$likelihood
tbats.m$optim.return.code

tbats.m$variance
tbats.m$AIC
tbats.m$parameters
tbats.m$seed.states

tbats.m$seasonal.periods
tbats.m$k.vector
tbats.m$p
tbats.m$q

tbats.m$call
tbats.m$series
tbats.m$method

#-------
graphics.off()
plot(tbats.m,
     col = 'red',
     lty = 1,
     lwd = .5,
     xlab = 'Year',
     main = 'Forecasts of JohnsonJohnson{datasets}\nTBATS model')

#-------
( tbats.fcst <- forecast(object = tbats.m, h = 12) )

class(tbats.fcst)
mode(tbats.fcst)
names(tbats.fcst)

tbats.fcst$method
tbats.fcst$model
tbats.fcst$level
tbats.fcst$series

tbats.fcst$x
tbats.fcst$fitted
tbats.fcst$residuals

tbats.fcst$mean
tbats.fcst$lower
tbats.fcst$upper

#-------
graphics.off()
plot(tbats.fcst,
     col = 'blue',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} TBATS model')

#-------
plot(forecast(tbats.fcst, h = 12),
     col = 'red',
     lty = 1,
     lwd = .6,
     xlab = 'Year',
     ylab = 'Quarterly earninings (dollar)',
     main = 'Forecasts of\nJohnsonJohnson{datasets} TBATS model')

# Error in forecast.forecast(tbats.m, h = 12) : 
# Please select a longer horizon when the forecasts are first computed
# solution: 이 오류가 발생하는 이유는, 모형에서 예측된 개수(h인자)보다
#           많은 예측값을 플롯하려고 시도할 때 발생. 따라서,
#           플롯 함수에서, 예측된 개수 지정시, 모형에서는 몇개의 예측값이
#           발생햇는지 확인해서 맞추어 줄것!!!

