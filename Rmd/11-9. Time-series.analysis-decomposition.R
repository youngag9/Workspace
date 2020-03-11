
#-----------------------------------------------------
# 요소분해법 (decomposition of time-series)
#    = 계절분해 (Seasonal decomposition)
#-----------------------------------------------------
# 계절성이 있는 시계열(Monthly or Quarterly 같은)은, 
#   (1) 추세(trend) 성분, (2) 계절(seasonal) 성분, 
#   (3) 불규칙(오차, irregular/error/random) 성분
# 으로 분해가능.
# ---------------------
# (1) 추세(trend) 성분
#   - 시간에 따른, 변화를 포착.
# (2) 계절(seasonal) 성분
#   - 연간 순환효과(=주기성)를 포착
# (3) 불규칙(=오차, irregular/error/random) 성분
#   - 추세(trend)나 계절(seasonality) 효과로 기술할 수 없는,
#     효과를 포착
#---------------------
# (요소)분해는, 아래의 두가지 방법 중 하나를 적용 :
#   - 가법(additive) 모델
#   - 승법(multiplicative) 모델
#---------------------
# (1) 가법 모델(Additive model)
#   - 시계열 값(관측치)을, 성분들의 합으로, 
#     아래 식으로 표현 :
#
#       (특정시점의) 관측치(Y) = (특정시점의) 추세 + 
#                                (특정시점의) 계절 +
#                                (특정시점의) 불규칙
#
#       * 주의: 위 식의 성분들이 가법(+, 덧셈)으로 구성                             
#   - 위 식에서, 시간t에서의 관측치(Y)는, 
#     시간t의 추세(trend effect)와
#     시간t에서의 계절효과(seasonal effect) 그리고 시간t에서의
#     불규칙효과(irregular effect)의 합(sum)이 됨
#   - 구성 성분들의 효과가 가법적으로 발생. 여기서, 가법적이라 함은,
#     구성 성분들의 효과가 만들어내는 변이(=변동의 크기)가, 
#     '양적으로' 증가함을 의미
#   - 예: 10년간 모터사이클의 월간 판매액에 대한 시계열 자료에서,
#         계절효과(seasonal effect)로, 모터사이클의 월별 판매대수가
#         11월 ~ 12월 사이에, 500대 증가, 다음해 1월 200대 감소
#---------------------
# (2) 승법 모델(Multiplicative model)
#   - 시계열 값(관측치)을, 성분들의 곱(x, multiply)으로, 
#     아래 식으로 표현 :
#
#       (특정시점의) 관측치(Y) = (특정시점의) 추세 x 
#                                (특정시점의) 계절 x
#                                (특정시점의) 불규칙
#
#       * 주의: 위 식의 성분들이 승법(x, 곱셈)으로 구성                             
#   - 위 식에서, 시간t에서의 관측치(Y)는, 
#     시간t의 추세(trend effect)와
#     시간t에서의 계절효과(seasonal effect) 그리고 시간t에서의
#     불규칙효과(irregular effect)의 곱(multiply)이 됨
#   - 구성 성분들의 효과가 승법적으로 발생. 여기서, 승법적이라 함은,
#     구성 성분들의 효과가 만들어내는 변이(=변동의 크기)가, 
#     '비례적으로' 증가함을 의미
#   - 예: 10년간 모터사이클의 월간 판매액에 대한 시계열 자료에서,
#         계절효과(seasonal effect)로, 모터사이클의 월별 판매대수가
#         11월 ~ 12월 사이에, 20% 증가, 다음해 1월 10% 감
#---------------------
# 따라서, 한 시계열은, 위의 3가지 성분들의 여러조합으로 구성가능.
# 예를들면,
#   - ts1 : No Trend + No Seasonal + Irregular
#   - ts2 : Trend + Irregular
#   - ts3 : Trend + Seasonal + Irregular
#---------------------
#
# 요소분해(=계절분해) 지원함수
#   (1) stl{stats} function : loess 평활법(loess smoothing)
#       - Seasonal Decomposition of Time Series by Loess
#       - Decompose a time series into 
#         seasonal, trend and irregular components using loess, 
#         acronym STL.
#       - 가법모델(additive model)만 다룰 수 있음
#       - 승법모델(multiplicative model)이 필요한 경우 -> 
#         로그변환(-> 가법모델로 관측치 변환효과, 예: log(ts) ) 후, 
#         가법모델로 요소분해 수행
#
#          log(Y[t]) = log( trend[t] * seasonal[t] * irregular[t] )
#                    = log(trend[t]) + log(seasonal[t]) + log(irregular[t])
#
#       - function prototype :
#           > stl( x = ts, s.window = , t.window = )
#             * x (필수) : 분해할 시계열 객체
#             * s.window (필수) : 시간에 따른, 계절효과의 속도조절
#                   값이 작을수록, 보다 빠른 변화 허용
#                   the span (in lags) of loess window 
#                   for seasonal extraction.
#                   보통 'periodic' 문자열 지정 -> 
#                         계절효과를 연도별로 동일하게 설정
#             * t.window (옵션) : 시간에 따른, 추세효과의 속도조절
#                   값이 작을수록, 보다 빠른 변화 허용
#                   the span (in lags) of the loess window 
#                   for trend extraction.
#                   보통 '생략'.
#
#   (2) decompose{stats} function : MA 평활법 (Moving average)
#       - Classical Seasonal Decomposition by Moving Averages
#       - Decompose a time series into seasonal, trend and irregular 
#         components using moving averages. 
#         Deals with 'additive' or 'multiplicative' seasonal component.
#       - function prototype :
#           > decompose( x = ts, type = , filter = NULL)
#             * x (필수) : 
#             * type (선택) : "additive" 또는 "multiplicative"으로 지정
#             * filter (선택) : 보통 '생략'
#---------------------
#

# 요소분해 사례1 : AirPassengers{datasets}
#                  Monthly Airline Passenger Numbers 1949-1960.
graphics.off()

library(forecast)

# 시간변화(=수준)에 따른, 변동폭이 증가 -> 승법모델 시사
# 따라서, stl{stats} 함수(가법모델만 지원)를 이용한 요소분해를 위해,
# 시계열 자료에 대하여, 로그변환(log함수적용)을 통해, 
# 승법모델에 맞게 자료변환 후, 요소분해 수행
ts.plot(AirPassengers)
# plot(AirPassengers)

# 로그변환 후, 분산이 안정적이며, 가법모델 기반의 요소분해가
# 적합한 방법임을 시사
( logAP.ts <- log(AirPassengers) )
ts.plot(logAP.ts)
# plot(logAP.ts)

# 가법모델(additive model)기반의 요소분해(=계절분해) 수행
( sfit <- stl(x = logAP.ts, s.window = 'periodic') )
class(sfit); mode(sfit); str(sfit);
names(sfit)

# 가법모델 객체안의 $time.series 에, 
# 요소분해 결과 시계열이 들어있음
head(sfit$time.series)

# 로그변환(=가법모델위해) -> 다시 원래단위값으로 역변환(승법모델)
# 정리: log(ts) -> 요소분해 -> exp(ts) -> 원래단위값으로 역변환
# 요소분해결과를 변수로 저장
( mul.ts <- exp(sfit$time.series) )

# 요소분해(=계절분해) 결과의 시각화
plot(mul.ts)
plot(sfit)

#------------------------------------
# 요소분해 결과분석
#------------------------------------
# 1. 추세(trend)는 감소없이 증가
# 2. 계절효과(seasonal)는, 여름에 승객이 훨씬 많음 시사
#------------------------------------

#------------------------------------
# 기타 유용한 시계열 플롯 함수
#   1) monthplot{stats}
#   2) seasonPlot{forecast}
#------------------------------------

# 월별 평균과 함께, 월별 하위 계열 보여줌
# 분석결과: 추세는, 대체로 매월 유사한 패턴으로 증가
monthplot(x = AirPassengers)

# 팔레트 목록 중 하나를 직접 선택하여, 팔레트객체 생성
library(colorspace)
pal <- choose_palette()

# 연도의 하위계열을 보여줌
# 분석결과: 해마다 승객 증가, 연도별로 동일한 패턴을 따름
seasonplot(x = AirPassengers, year.labels = TRUE, col = pal(12))

#---------------------------
# 지정된 모델(additive/multiplicative model)기반의 
# 요소분해(=계절분해) 수행
( dfit <- decompose(x = USAccDeaths, type = 'multiplicative') )

class(dfit); mode(dfit); str(dfit);
names(dfit)

# 요소분해(=계절분해) 결과의 시각화
plot(dfit)

plot(dfit$seasonal)
plot(dfit$trend)
plot(dfit$random)
#------------------------
# 월별평균과 함께, 월별 하위계열 보여줌
# 분석결과: 추세는, 대체로 7월에 사고로 인한 죽음이 가장 높음
# The monthly totals of accidental deaths in the USA
# The values for the first six months of 1979
monthplot(x = USAccDeaths)

# 팔레트 목록 중 하나를 직접 선택하여, 팔레트객체 생성
library(colorspace)
pal <- choose_palette()

# 연도의 하위계열을 보여줌
# 분석결과: 1973년도 7월에 가장 높은 사고사를 보임. 또한,
#           대체로 매해, 7월 여름에 가장 높은 사고사를 보임
#           매해 연초가 가장 사고사가 낮음
seasonplot(x = USAccDeaths, year.labels = TRUE, col = pal(12))
