# 분산분석결과의 신뢰성 확보를 위한, 분산분석 가정(Assumptions) 평가
# 분산분석의 가정을 보면,
#   (1) 종속변수(y)는 정규성을 가져야 함
#   (2) 요인이 만들어내는, 모든 집단의 분산은 동일해야 함(등분산성)


#---------------------------------------------
#   (1) 종속변수(y)의 정규성 검정
#---------------------------------------------
# 정규성검정 대상 변수의 표본크기가 대표본 이상이라면,
# CLT(Central Limit Theorem, 중심극한의 정리)와 대수의 법칙에 따라,
# 정규성을 가정할 수 있다!!(명심)
#--------------------------------------------
# 종속변수(y)는 연속형 변수이므로
#   -1 Shapiro wilks 검정: 검정통계량으로 정규성 검정
#   -2 Q-Q plot: 시각적으로 검정

#   -2 : ⓐ qqnorm{stats}, qqline{stats}
qqnorm(cholesterol$response)
qqline(cholesterol$response)  
# -> 정규선을 벗어난 데이터가 있을 때 정규성 판정이 애매


#   -2 : ⓑ qqPlot{car} function 이용
library(car)

dev.off()  # 그림영역 지우기
# lm() 함수는 선형회귀분석함수
qqPlot(
  lm(response~trt, data=cholesterol),
  main = 'Q-Q Plot', labels = F, # xy축 라벨 그리지 말아라
  simulate = T # bootstraping과 관련. 
              # 많은 subset을 뽑아 각 lm모델을 만들어 그 중 하나를 고를 때 사용
  ) # -> 신뢰구간을 보여줌


#   -1 Shapiro wilks 검정 : 검정통계량으로 정규성 검정
shapiro.test(cholesterol$response)
# Shapiro-Wilk normality test
# 
# data:  cholesterol$response
# W = 0.97722, p-value = 0.4417
# 귀무가설 채택 -> 정규성 있다!!



#---------------------------------------------
#   (1) 요인(facotr)의 수준별, 집단의 등분산성(homogeneity) 검정
#---------------------------------------------
# 등분산성 검정 기법은 대표적으로 3가지가 있다.
#   -1. Bartlet test - bartlett.test{stats}
#   -2. Flinger test - flinger.test{stats}
#   -3. Brown Forshy test - hov{HH} 
#                       bf.test{onewaytests}
#--------------------------------------------
# 통계적 가설 :
#   H0: 모든 집단은 등분산성을 갖는다
#   H1: not H0

bartlett.test(response~trt, data=cholesterol)
# Bartlett test of homogeneity of variances
# 
# data:  response by trt
# Bartlett's K-squared = 0.57975, df = 4, p-value = 0.9653
#   -> 귀무가설(등분산성을 갖는다)채택





