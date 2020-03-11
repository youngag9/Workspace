# 정규성 검정 위해
# QQ(Quantile-Quantile)plot / histogram+lines
install.packages("ggpubr", dependencies=T)
require(ggpubr)

# 정규성 확인 위해 밀도 그래프 그려주는 함수 호출함
# {ggpubr} 
ggdensity(my_data$len, 
          add = 'mean',   # add에, 추가할 기초통계량 지정. -> 확률밀도 그래프그리고, 평균의 위치표시해줌
          color = 'red', 
          fill = 'lightblue', 
          alpha = .5, 
          title = 'Density plot of Tooth Length', 
          xlab = 'Tooth length')

# 평균을 중심으로 좌우대칭 그리는 것이 정규분포임.

require(ggpubr)
# Q-Q plot
ggqqplot(my_data$len, color = 'red') # {ggpubr} / 연속형 변수가 정규성 따르는지
# 중간의 선이, 이론적으로 정규성을 따르는 선
# 데이터 분포가 선을 따라 위에 있으면 이상적인 정규분포
# ggqqplot()은 "신뢰구간"을 함께 보여줌 : 정규분포에 속하려면 해당 영역 안에!
# 해당 라인 위에 있는 것이 가장 좋음
# 선에서 벗어났지만, 신뢰구간안에 속하므로 검정 시, 정규성을 따르는 결과 나올 수 있음

ggqqplot(mpg$cty) # 신뢰구간을 많이 벗어나므로, 정규성을 따르지 않음

# install.packages("car", dependencies=T)
require(car)
car::qqPlot(my_data$len) # {car} / qqPlot은 다른 패키지 안에도 있음
# [1] 23  1
# 특정 데이터에 번호가 붙어있음
# --> 이 번호 붙어있는 데이터는 이상치일 가능성이 높음
# 정규성 검정 시 car::qqPlot()이 더 좋을 수 있음.


# 기본 패키지의 정규성 검정
stats::qqnorm(my_data$len) # 신뢰구간X 이상치표시X / 점의 분포
stats::qqline(my_data$len, col=2) # 정규성을 따르는 선 보여줌
# 여기까지 qqplot으로 시각적으로 확인

# 연속형변수 정규성 검정 함수
# ks(Kolmogorov-Smirnov)normality test
# shapiro wilk test(많이 추천: KS보다 정규하고 강력)
# --> 정규성 값과 실제 값의 "상관관계"를 구해서 정규성을 판단한다.
# H0: 정규성을 갖는다

# **주의: 정규성검정은, 표본의 크기에 민감
# 작은표본의 경우, 정규성 검정 시, 만족하지 않음에도 통과해버릴 수 있음.
# 따라서, 정규성 검정 + 시각적 검증을 병행해서 판단해야 한다.
stats::shapiro.test(my_data$len) # 하나의 연속형 변수에 정규성 검정
# 
# Shapiro-Wilk normality test
# 
# data:  my_data$len
# W = 0.96743, p-value = 0.1091
# pvalue > 0.05 : 귀무가설채택하므로, 정규성을 갖는다.

data("mtcars")
# 표본의 개수 확인
dim(mtcars) # 32 11
ggqqplot(mtcars$mpg, col='red') # 대부분의 점이 신뢰구간 안에 있음
ggqqplot(mtcars$hp, col='red') # 대부분의 점이 신뢰구간 안에 있음
shapiro.test(mtcars$hp) # 정규성 따르지 않음
shapiro.test(mtcars$mpg) # 정규성을 따름 0.1229


require(ggplot2)
data(mpg)

my_data <- as.data.frame(mpg, stringAsFactors = FALSE) # stringAsFactors를 F로 주지 않으면, 문자열을 모두 factor타입으로 받음
# factor 타입으로 지정 시, 쓸 수 있는 연산이 별로 없음 
# --> stringAsFactors를 FALSE로 준다 / 매번 붙이기 싫으면, 시작 지점에 붙이면 된다(나중에 알려줌)
# cf) factor에서는, 범주의 개수를 level이라 한다

str(my_data)
dim(my_data)
summary(my_data)

set.seed(1234)

require(dplyr) # for sample_n()
require(DT) # for datatable()

(datatable(sample_n(my_data, size=10, replace=FALSE))) # random sampling -> datatable에 담음
# DT::datatable(my_data) # 많은 양의 데이터 출력 시 데이터테이블 사용하는 것이 좋음.
# 표본의 크기가 30미만이므로, 소표본

require(ggpubr)
# 확률밀도(분포)
ggdensity(my_data$cty,
          add= 'mean', # mean을 표시해줌
          color = 'red',
          fill= 'lightgray',
          alpha= .5,
          title='Density plot of City Milege',
          xlab= 'City Milege')  
# 오른쪽 꼬리 분포(연비가 많은 경우가 꼬리로 나타남)
# 평균을 기준으로 이상적인 대칭 아님

require(ggpubr)
ggqqplot(my_data$cty, color='red') # 계단처럼 걸쳐있음 
# 계단으로 그려진 경우, 대부분 정규성을 따르지 않는다고 함.

require(car)
qqPlot(my_data$cty)  # 이상치 숫자 달아서 보여줌
# 이상치가 적어도, 이상치가 극단치 역할을 한다면, 
# 좌나 우로 꼬리를 끌어내므로 정규성을 따르지 않을 수 있음

# 이상치가 boxplot에도 동일한지 그려보는 것이 좋음
boxplot(my_data$cty)

qqnorm(my_data$cty)
qqline(my_data$cty, col = 2)

shapiro.test(my_data$cty)
## 
##  Shapiro-Wilk normality test
## 
## data:  my_data$cty
## W = 0.95679, p-value = 0.000001744
# 대립가설 채택 -> 정규성을 따르지 않음