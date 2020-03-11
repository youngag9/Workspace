## t-test
data() # 현재 활용가능한 데이터셋의 모음 새 창으로 보여준다.

df <- ch7_indep

# 1. one sample t-test
#    표본의 평균과 특정값 비교
# • 귀무가설(H0) : 고기 종류와 상관없이 칼로리 평균은 140이다.
# • 대립가설(H1) : 고기 종류과 상관없이 칼로리 평균은 140이 아니다.

t.test(df$Calories, mu=140)  # {stats} / mu: 특정값 지정
# 
#   One Sample t-test
# 
# data:  df$Calories
# t = -0.65184, df = 59, p-value = 0.517
# alternative hypothesis: true mean is not equal to 140
# 95 percent confidence interval: --> 신뢰구간
#   129.7577 145.2090
# sample estimates:
#   mean of x 
# 137.4833   --> 검정통계량
# 귀무가설 채택! -> 칼로리 평균(137.4833)은 통계적으로 140과 같다!

# 2. independent test -> 두 그룹!!
#  세 개 이상의 그룹(범주)를 끌어내면 t-test 수행 못함
#  --> 분산분석에 들어가야 함.
# • 귀무가설(H0) : 1번그룹과 2번그룹은 칼로리의 평균에 차이가 없다.
# • 대립가설(H1) : 1번그룹과 2번그룹은 칼로리의 평균에 차이가 있다.

table(df$Type) # 1 2 타입 모두 30의 도수 가짐.
t.test( Calories~Type , data=df)
# Welch Two Sample t-test
# 
# data:  Calories by Type
# t = 6.2333, df = 57.713, p-value = 0.000000057
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   25.50149 49.63185
# sample estimates:
#   mean in group 1 mean in group 2 
# 156.2667        118.7000 

t.test( Calories~Type , data=df, var.equal=T) # --> 위와 pvalue가 다르다
# 
# Two Sample t-test
# 
# data:  Calories by Type
# t = 6.2333, df = 58, p-value = 0.00000005604  --> 작음: 대립가설채택
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   25.50276 49.63057
# sample estimates:
#   mean in group 1 mean in group 2 
# 156.2667        118.7000  -> 두 그룹의 평균 차이가 많음
# 대립가설채택! 두 그룹 평균 차이가 난다.


# 3. Paired t-test
df <- ch7_paired
# 사전(pre) / 사후(post) 비교
t.test(df$post - df$pre)  # 뺄셈기호를 사용.
# One Sample t-test  --> 이렇게 나와도 paired임.
# 
# data:  df$post - df$pre
# t = 0.84929, df = 41, p-value = 0.4007
# alternative hypothesis: true mean is not equal to 0
# 95 percent confidence interval:
#   -2.326071  5.702262
# sample estimates:
#   mean of x 
# 1.688095    --> 이 값이 0과 같다 : 두 그룹의 평균의 차이
# 귀무가설 채택 --> 이 정도 차이는 통계적으로 차이가 없다고 함.


t.test(df$post - df$pre, var.equal=T) # 등분산 같다
t.test(df$post - df$pre, var.equal=F) # 등분산X

# 전제인, 등분산 여부 검정
var.test(Calories ~ Type, data=ch7_indep)  # {stats} / 연속~범주
# F test to compare two variances
# 
# data:  Calories by Type
# F = 0.86825, num df = 29, denom df = 29, p-value = 0.7062 --> 귀무가설채택.
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#   0.4132571 1.8241928
# sample estimates:
#   ratio of variances 
# 0.8682515 
# 귀무가설 채택 -> 등분산성을 따른다! 


# 전제인, 정규성 검정
# 연속형 변수는 정규성을 가져야 함
# (중심극한의 정리에 따라)표본크기가 30보다 큰, 대표본이면 
#   분포를 무시할 수 있다. 즉, 정규성 검정하지 않고 모수검정 들어갈 수 있음
# 중심극한의 정리: 표본이 30보다 크면, 정규성을 가정할 수 있다.
data(ToothGrowth)
my_data <- ToothGrowth

set.seed(1234)

require(dplyr)
# 완전확률화 기반으로, 표본의 크기가 10인 표본추출, 비복원추출
sample_n(my_data, size = 10, replace = FALSE)   # {dplyr} / random sampling
# 지정된, 개수만큼 추출하는 함수 sample_n
#     len supp dose --> supp, dose는 범주형/ len->연속형
# 1  21.5   VC  2.0
# 2  17.3   VC  1.0
# 3  27.3   OJ  2.0
# 4  18.5   VC  2.0
# 5   8.2   OJ  0.5
# 6  26.4   OJ  1.0
# 7  25.8   OJ  1.0
# 8   5.2   VC  0.5
# 9   6.4   VC  0.5

# 10  9.4   OJ  0.5

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

