# MANOVA: 다변량 분산분석
# Multivariate ANOVA
#
# formula에서, 종속변수가 2개 이상인 경우 (y1, y2, ... ~)

# 분석 데이터 셋: UScereal {MASS}

library(MASS)
data(UScereal, "MASS")

head(UScereal)
View(UScereal)
rownames(UScereal) <- c()  # 행의 이름 설정
row.names(UScereal)
colnames(UScereal) <- c()  # 변수의 이름 설정: 변수와 벡터 내 원소 개수가 같아야 함.
# [1] "mfr"       "calories"  "protein"   "fat"       "sodium"    "fibre"     "carbo"    
# [8] "sugars"    "shelf"     "potassium" "vitamins" 


# 범주형변수: shelf, vitamins (선반별로 배치된 시리얼)
table(UScereal$shelf)
# 1  2  3 
# 18 18 29  -> 비균형설계(Unbalanced Design) -> formula 구성 시 주의
library(prettyR)
freq(UScereal$shelf)
# Frequencies for UScereal$shelf 
#         3    1    2   NA
#        29   18   18    0
# %    44.6 27.7 27.7    0 
# %!NA 44.6 27.7 27.7 


# 요인설계:
#   (1) 집단 간 요인: shelf
#   (2) 분석변수(종속변수): calories, fat, sugars

attach(UScereal)

# 분산분석에서, 요인역할을 하는 변수는 factor 타입으로 변환하라!
str(UScereal)
# 'data.frame':	65 obs. of  11 variables:
# $ mfr      : Factor w/ 6 levels "G","K","N","P",..: 3 2 2 1 2 1 6 4 5 1 ...
# $ calories : num  212 212 100 147 110 ...
# $ protein  : num  12.12 12.12 8 2.67 2 ...
# $ fat      : num  3.03 3.03 0 2.67 0 ...
# $ sodium   : num  394 788 280 240 125 ...
# $ fibre    : num  30.3 27.3 28 2 1 ...
# $ carbo    : num  15.2 21.2 16 14 11 ...
# $ sugars   : num  18.2 15.2 0 13.3 14 ...
# $ shelf    : int  3 3 3 1 2 3 1 3 2 1 ...
# $ potassium: num  848.5 969.7 660 93.3 30 ...
# $ vitamins : Factor w/ 3 levels "100%","en

UScereal$shelf <- factor(shelf)

# *************************************** #
# 종속변수가 여러개 일때에는, 이들을 묶어서
# 행렬이나 데이터프레임으로 만들어준다
(y <- cbind(calories, fat, sugars))
class(y)  # "matrix"

# 각 집단별 평균을 구하자! -> 표본평균 (not 모집단)
aggregate(y, by = list(shelf), mean)  
# 평균적용대상인 y가 특정하나의 변수가 아니어도 됨. 행렬이어도 됨.
#   Group.1 calories       fat    sugars
# 1       1 119.4774 0.6621338  6.295493
# 2       2 129.8162 1.3413488 12.507670
# 3       3 180.1466 1.9449071 10.856821
#  shelf별로 y의 각 변수별 평균이 나옴.

# *************************************** #
# 모집단 검정 위해 분산분석!
# MANOVA 수행
# manova {stats}
?manova
fit.mov <- manova(y ~ shelf)
fit.mov
# Call:
#   manova(y ~ shelf)
# 
# Terms:
#                    shelf Residuals
# calories         45313.4  203982.1
# fat                18.42    155.24
# sugars            183.34   1995.87
# Deg. of Freedom        1        63
# 
# Residual standard errors: 56.90177 1.569734 5.628535
# Estimated effects may be unbalanced
# -> 검정통계량 안나옴

# 분산분석의 유의성 검정
# summary : generic function이므로,
#           manova 모델을 넣으면, summary.manova가 호출됨.
summary(fit.mov)
#           Df  Pillai approx F num Df den Df  Pr(>F)   
# shelf      1 0.19594    4.955      3     61 0.00383 **
# Residuals 63 
# shelf가 만들어낸 집단 별 평균의 차이가 있다

summary.manova(fit.mov) # <- summary(fit.mov) 와 같음
#           Df  Pillai approx F num Df den Df  Pr(>F)   
# shelf      1 0.19594    4.955      3     61 0.00383 **
# Residuals 63 

# *************************************** #
# 각 종속변수별, 유의성 검정
# summary.aov{stats}
summary.aov(fit.mov)  # **반드시 수행**
# Response calories :  # 반응변수
#             Df Sum Sq Mean Sq F value    Pr(>F)    
# shelf        1  45313   45313  13.995 0.0003983 ***
# Residuals   63 203982    3238                      
# ---
# 
# Response fat :
#             Df  Sum Sq Mean Sq F value   Pr(>F)   
# shelf        1  18.421 18.4214   7.476 0.008108 **
# Residuals   63 155.236  2.4641                    
# ---
# 
# Response sugars :
#             Df  Sum Sq Mean Sq F value  Pr(>F)  
# shelf        1  183.34  183.34   5.787 0.01909 *
# Residuals   63 1995.87   31.68                  
# ---
# 각 종속변수 별, 평균의 차이가 있음을 확인가능.



# 적합화시킨 모델의 다양한 속성을,
# 아래와 같이, 알든/모르든 자주 보려고 하라!
names(fit.mov)
# [1] "coefficients"  "residuals"     "effects"       "rank"          "fitted.values"
# [6] "assign"        "qr"            "df.residual"   "xlevels"       "call"         
# [11] "terms"         "model"
fit.mov$fitted.values # 적합된 모델에 표본을 넣었을 때의 값.


# **********************************
# 분산분석의 가정(assumptions) 평가
# (1) 지정된 모든 종속변수는 정규성을 가져야 한다.
# (2) 집단 간 요인이 만들어 내는, 각 집단의 분산이 등분산성을 가진다

# **********************************
# 다변량 데이터(y)의 정규성 검정(***)
# "막간의 이론" (A theory interlude)

#-------------------------------------------------
# 다변량 데이터의 정규성 검정
#-------------------------------------------------
# 기존의 shapiro-Wilk test 는 단변량(1개연속형변수)
# 정규성 검정방법.

# 만일, 데이터프레임안에 있는 많은 수의 연속형변수에
# 대한 정규성 검정이 필요하다면?
# Shapiro-Wilk Test를 모든 변수에 대해 반복검정수행?

# 다변량 연속형 데이터셋에 대한 동시정규성 검정은
# "막간의 이론" 적용

#-------------------------------------------------
# 막간의 이론 (A theory interlude)
#-------------------------------------------------
# (1) 평균 μ이고 공분산행렬 Σ 인, 
# (2) p(변수개수) x 1의 정규성을 따르는 다변량 벡터(여러값갖는다는 의미) x가 있다면, 
# (3) 이 다변량 벡터 x와 평균 μ 사이의 Mahalanobis 거리의 제곱은,
# (4) p(변수개수) 자유도(df)를 가지는 χ2 분포를 따릅니다. 
# (5) 이때, Q-Q 플롯은, Mahalanobis D-제곱값에 대한, 
# (6) 표본의 χ2 분포의 Quantiles을 그래프로 표시합니다. 
# (7) 이때 데이터 포인트는, 기울기 1과 절편 0인 선을 따라,
#     분포되어있으면, 데이터가 다변량 정규성을 가지는 증거가 됩니다.
#-------------------------------------------------

( x <- mtcars )            # 양적변수로 구성된 다변량 데이터 확보

library(MASS)
UScereal

x <- UScereal[, c('calories', 'fat', 'sugars')]

( center <- colMeans(x) )  # 각 변수별 평균(μ) 벡터
# calories        fat     sugars 
# 149.408258   1.422538  10.050842 
( n <- nrow(x) )           # 표본크기(n)   65
( p <- ncol(x) )           # 변수개수(p)   3
( cov <- cov(x) )          # 공분산행렬(Σ)구함
#             calories       fat     sugars
# calories 3895.24210 60.674383 180.380317
# fat        60.67438  2.713399   3.995474
# sugars    180.38032  3.995474  34.050018


# Mahalanobis 거리
( d <- mahalanobis(x, center = center, cov = cov) )

# ppoints{stats} : Generates the sequence of probability points
ppoints(n)  # 표본의 크기 개수만큼 ppvalue

# qchisq{stats}  : Quantile function for the chi-squared (chi^2) distribution with df degrees of freedom.
qchisq(ppoints(n), df = p)  # 사분위수를 만들어줌
# 표본의 개수 n개만큼, 카이제곱 분포표에서 사분위수를 구함.

coord <- qqplot(
  qchisq(ppoints(n), df = p),
  d,  # 거리값
  main='Q-Q plot assessing multivariate normality',
  xlab='qchisq(ppoints(n), df = p)',
  ylab='Mahalanobis Distance^2'
)

# qqplot에 정규선을 그어줌
abline(a=0, b=1) # 기울기 1과 절편 0인 직선추가

# 마우스로 점을 찍고 finish 누르면 어떤 시리얼이 outlier인지 알 수 있음.
identify(coord$x, coord$y, labels = row.names(x))


# 다변량 데이터의 이상치(outliers) 확인
library(mvoutlier)
# aq.plot {mvoutlier} 
( outliers <- aq.plot(x) ) # 시리얼 이름 플롯에 보여줌
# 거리가 가까운 것은 동질성이 있다는 뜻
# 먼 것은 동질성이 떨어진다는 뜻. 즉, outlier이다.
# 여기서 빨간 것들이 이상치일 가능성이 높음.


detach(UScereal)


# 분산분석은 F분포통해 검정통계량 계산...
