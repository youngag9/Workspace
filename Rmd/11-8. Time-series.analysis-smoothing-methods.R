
#-----------------------------------------------------
# 평활화 기법(Smoothing Methods)
#-----------------------------------------------------
# 데이터 셋를 모델링 하기전에, 기술통계와 시각화로, 
# 데이터 셋을 탐색하는 과정이 있듯이, 
# 시계열(time-series)에서도, 복잡한 모델 구성에 앞서,
# 수치나 시각화로, 시계열을 기술하는 일이, 
# 분석작업의 출발점.
#
# 평활화(smoothing)는, 일반적인 시계열의 복잡한 
# 추세(trend)를 명확하게 파악하기 위한 방법임.
#
# 평활화 방법(smoothing methods) : 
#   단순이동평균(simple moving average)
#
# 시계열은 전형적으로, 명백한 불규칙(or 오차)성분을 포함.
# 시계열 자료의 특정 패턴을 파악하기 위해, 이같은 급격한 
# 파동을 줄이는 평활화(smoothing) 곡선 플롯(curve-plot) 필요.
# 시계열을 평활화하는 가장 단순한 방법은, 
#   '이동평균'(moving average)을 사용하는 방법임.
# 예: 시계열 자료의 각 점은,
#      - 특정시점(a time point) 관측치와
#      - 위 관측치의 이전과 이후 관측치의 평균으로 대체
#      - 이 방법을, '중심이동평균'(centered moving average)라고 함
#
# R에서는, 위의 단순이동평균을 지원하는 아래와 같은 함수들 제공:
#     (1) SMA{TTR}
#     (2) rollmean{ZOO} -> 이전 R 파일에서 실습했었음.
#     (3) ma{forecast}  -> 가장 직관적이고 사용하기 쉬움.
# 이때, 소위 평활수준(평균화한 관측치의 개수)는, 
# 보통 홀수로 선택. (k=3,7,15,..)
#
graphics.off()
op = par(mfrow=c(2,3))  # plot window divied into 2x3 grids


#---------------
# (1) ma{forecast} function : Moving-average smoothing
#---------------
library(forecast)
data(Nile)

plot(Nile, main = '1. Raw Nile time series')
plot(ma(x = Nile, order = 3), 
     main = '2. Simple Moving Average (k=3)')
plot(ma(x = Nile, order = 7), 
     main = '3. Simple Moving Average (k=7)')
plot(ma(x = Nile, order = 15), 
     main = '4. Simple Moving Average (k=15)')
plot(ma(x = Nile, order = 21), 
     main = '5. Simple Moving Average (k=21)')
plot(ma(x = Nile, order = 33), 
     main = '6. Simple Moving Average (k=33)')

#---------------
# (2) SMA{TTR} function : Moving Averages
# >library(TTR)
# >SMA(x = ts, n = 평활수준)
#---------------
library(TTR)
data("AirPassengers")

plot(AirPassengers, 
     main = '1. Raw AirPassengers time series')
plot(SMA(x = AirPassengers, n = 3), 
     main = '2. Simple Moving Average (n=3)')
plot(SMA(x = AirPassengers, n = 7), 
     main = '3. Simple Moving Average (n=7)')
plot(SMA(x = AirPassengers, n = 15), 
     main = '4. Simple Moving Average (n=15)')
plot(SMA(x = AirPassengers, n = 21), 
     main = '5. Simple Moving Average (n=21)')
plot(SMA(x = AirPassengers, n = 33), 
     main = '6. Simple Moving Average (n=33)')

#---------------
# (3) rollmean{zoo} function : Rolling Means
# >library(zoo)
# >rollmean(x = ts, k = 평활수준)
#---------------
library(zoo)
library(TTR)
data("USAccDeaths")

plot(USAccDeaths, 
     main = '1. Raw USAccDeaths time series')
plot(rollmean(x = USAccDeaths, k = 3), 
     main = '2. Simple Moving Average (k=3)')
plot(rollmean(x = USAccDeaths, k = 7), 
     main = '3. Simple Moving Average (k=7)')
plot(rollmean(x = USAccDeaths, k = 15), 
     main = '4. Simple Moving Average (k=15)')
plot(rollmean(x = USAccDeaths, k = 21), 
     main = '5. Simple Moving Average (k=21)')
plot(rollmean(x = USAccDeaths, k = 33), 
     main = '6. Simple Moving Average (k=33)')

par(op)

#-----------------------------------------------------
# 중요 포인트 :
#-----------------------------------------------------
# '평활수준'(k값)이 증가하면서, 시계열 플롯은 ,
# 지속적으로 평활화됨. 
# 주의) 따라서, 이때 과소/과대 평활하지 않고, 
# 자료의 주요 패턴을 분명하게 확인할 수 있는 
# k값('평활수준')을 찾는 것이 중요
#-----------------------------------------------------
