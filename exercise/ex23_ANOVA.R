# ANOVA

# Data/sa/ch8_onewayanova.csv
# factor: age : 집단 "간" 요인
#   score는 요인이 아닐 것 같음

str(test) # tibble 혼합타입
# age -> chr로 나옴 -> 분산분석을 위해 factor 타입으로 변환해야 함

test <- as.data.frame(test)
str(test)

# 그룹별 크기 확인
table(test$age)
# 20대 30대 40대 
# 12   15   15   --> Unbalanced Design 비균형설계
library(prettyR)
?freq  # 빈도와 비율을 함께 보여줌
freq(test$age)
# Frequencies for test$age 
#      30대 40대 20대   NA
#        15   15   12    0
# %    35.7 35.7 28.6    0 
# %!NA 35.7 35.7 28.6 

# chr -> factor
test$age <- as.factor(test$age) # ANOVA위해 factor타입으로 변환
# "20대","30대",..
test$age <- factor(test$age, levels=c('20대', '30대', '40대'),
                    labels=c('20s', '30s', '40s'))
# levels : factor level 그룹지정
# labels : factor group의 이름 지정
# # "20s","30s",..

str(test) # Factor w/ 3 levels


# 각 그룹의 평균구하기
# 다양한 집계함수 -> 결측치 고려가 안된 함수! (위험)
# ⓐ tapply
?tapply
tapply(test$score, test$age, mean)
# 20대     30대     40대 
# 28.33333 39.73333 35.40000 

# $기호 사용하지 않도록, global environment에 df를 붙임
# --> $ 없이 변수명만 기재해도 됨
attach(test)
tapply(score, age, mean)
# 20대     30대     40대 
# 28.33333 39.73333 35.40000  
# --> 수치차이는 확인할 수 있지만, 이것이 통계적으로 유의한 차이라고 할 수 없음
# --> 이는 표본의 평균인데, 통계적으로 유의한 것은 모집단의 차이를 보려고 하기 때문에
# --> 해당 집계통계량으로 비교하는 것이 아님.

detach(test)  # df 떼줌 -> global environment에서 없어짐

# ⓑ aggregate
?aggregate
aggregate(test$score, by=list(test$age), FUN=mean)
# aggregate(평균구할대상, by=그룹, FUN=구하는통계량)
# by는 list 요구
# FUNction: 그룹에 적용할 함수

#   Group.1        x
# 1    20대 28.33333
# 2    30대 39.73333
# 3    40대 35.40000



# 일원분산분석One-way ANOVA 수행 by aov()--------------------------
# 가정) ⓐ등분산,  ⓑ대표본

?aov # {stats}
# Fit an analysis of variance model by a call to lm for each stratum.
# 분산분석모델을 적합시키는 역할하는 함수
# --> anova(적합)는 여러 설계모델 중 연구자에게 가정 적합한 연구설계모델[모형]을 찾는 것!

# 분산분석도, 모델을 만듦. 적합시킴(fit)
fit.aov <- aov(formula = score ~ age , data=test) # 분산분석표 리턴
# formula안에서 ~ 의 오른쪽에는 독립/설명/예측변수 (->factor),
#                    왼쪽에는   종속/반응/결과변수 지정
# --> 집단 간 점수가 같느냐? or 적어도 하나 같지 않냐?

fit.aov
# Call:
#   aov(formula = score ~ age, data = test)
# 
# Terms:
#                       age Residuals  --> Residual : 잔차(오차)
# Sum of Squares  871.5857  453.2000   --> 편차제곱합(SS)
#                              => 변동량(변이의 크기) ==> 집단의 분산!!
# Deg. of Freedom        2        39   --> 자유도
# 
# Residual standard error: 3.408887    --> 잔차에 대한 표준오차
# Estimated effects may be unbalanced  : "비균형설계"이다 : 그룹의 빈도가 다르다


# 집단 간 평균의 차이 검정 by F-검정
## 1st <- 더 자세하게 보여줌 / 대부분 모델은 summary 활용
summary(fit.aov)
#               Df Sum Sq Mean Sq   F value         Pr(>F)    
#   age          2  871.6   435.8    37.5   0.000000000824 *** 
#   Residuals   39  453.2    11.6                           
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# F검정에 의한 검정통계량과 유의확률도 나옴
# --> pvalue로 보아 고도로 유의하고 대립가설 채택 -> 통계적 유의성이 있다
# -> 연령대 별 평균의 차이는 모두 다 같지 않다! 집단 간 평균의 차이가 있다!
# (어느 집단 사이에서 차이가 일어나는지는 알지 못한다
#    -> "평균의 다중비교"이용하면 알 수 있음)


## 2nd 
anova(fit.aov)
# Analysis of Variance Table
# 
# Response: score
#           Df Sum Sq Mean Sq F value          Pr(>F)    
# age        2 871.59  435.79  37.502 0.0000000008238 ***
# Residuals 39 453.20   11.62                            
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


#
names(fit.aov)
# [1] "coefficients"  "residuals"     "effects"       "rank"         
# [5] "fitted.values" "assign"        "qr"            "df.residual"  
# [9] "contrasts"     "xlevels"       "call"          "terms"        
# [13] "model"

# summary는 fit.aov의 변수 중, 검정통계량을 꺼내오는 것

fit.aov$coefficients
fit.aov$residuals
fit.aov$fitted.values




# <사후분석> 평균의 다중비교
#   - 어떤 집단의 평균이 다른지 확인 가능
library(multcomp)

?glht  # {multcomp}
# general linear hypotheses : 일반화 선형 가설함수
fit.glht <- glht(fit.aov, linfct = mcp(age = 'Tukey'))
# linfct: linear function: test할 선형(직선)가설의 스펙내용 지정. 이는, mcp객체.
# mcp ( factor, ‘분석방법’) : multiple comparison 다중비교. linfct에 줄 스펙을 만들어줌.


# General Linear Hypotheses
# 
# Multiple Comparisons of Means: Tukey Contrasts
# 
#  
# Linear Hypotheses: --> 그룹 순서쌍을 2개씩 잡음
#                   Estimate
# 30대 - 20대 == 0   11.400
# 40대 - 20대 == 0    7.067
# 40대 - 30대 == 0   -4.333

# --> summary로 봐야함
summary(fit.glht)
# Simultaneous Tests for General Linear Hypotheses
# 
# Multiple Comparisons of Means: Tukey Contrasts
# 
# 
# Fit: aov(formula = score ~ age, data = test)
# 
# Linear Hypotheses:
#   (귀무가설)        Estimate Std. Error t value Pr(>|t|)    
#   30대 - 20대 == 0   11.400      1.320   8.635  < 0.001 ***
#   40대 - 20대 == 0    7.067      1.320   5.352  < 0.001 ***
#   40대 - 30대 == 0   -4.333      1.245  -3.481  0.00345 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# (Adjusted p values reported -- single-step method)

# 각 그룹순서쌍 별로, 평균의 차이가 통계적 유의함. (모두 대립가설 채택)
# 모집단의 모든 그룹의 평균이 차이가 있음.
# 모든 연령의 평균이 다 다르다.
# 평균크기비교 by Estimate: 30대 > 40대 > 20대


# 
names(fit.glht)


cholesterol # 콜레스테롤 낮추는 약물 투여방법에 따른, 콜레스테롤 감소수치
#       trt response 
# 1   1time   3.8612
# 2   1time  10.3868
# 3   1time   5.9059

str(cholesterol)
# 'data.frame':	50 obs. of  2 variables:
#   $ trt     : Factor w/ 5 levels "1time","2times",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ response: num  3.86 10.39 5.91 3.06 7.72 ...

freq(cholesterol$trt)
# Frequencies for cholesterol$trt 
#      1time 2times 4times  drugD  drugE     NA
#        10   10   10   10   10    0
# %      20   20   20   20   20    0 
# %!NA   20   20   20   20   20 
# ~time: 내가 발명한 약물의 복용방법, drugD/E : 새로운 약물

# 그룹 별 평균 구하기
aggregate(cholesterol$response, by=list(cholesterol$trt), FUN=mean) 

# $사용안하기
attach(cholesterol)
aggregate(response, by=list(trt), FUN=mean)
#   Group.1        x --> by에 지정된 변수가 여러개면 Group.2, .3, ...
# 1   1time  5.78197
# 2  2times  9.22497
# 3  4times 12.37478
# 4   drugD 15.36117
# 5   drugE 20.94752

# 표본의 감소수치평균: drugE > drugD > 4times > 2times > 1times
# -> 기술통계량일 뿐, 이로 모수를 추정해야 함.

# 모집단의 그룹별 평균 차이가 진짜 있을까? -> 분산분석
# 집단 간 요인이고, trt변수 하나이므로 <one-way ANOVA>
fit.aov2 <- aov(response ~ trt, data=cholesterol)
# fit.aov2 <- aov(response ~ ., data=cholesterol)
fit.aov2 <- aov(response ~ trt) # cholesterol attach해놔서 가능. 적는것이 좋음

fit.aov2
# Call:
#   aov(formula = response ~ trt, data = cholesterol)
# 
# Terms:
#   trt Residuals
# Sum of Squares  1351.3690  468.7504
# Deg. of Freedom         4        45
# 
# Residual standard error: 3.227488
# Estimated effects may be unbalanced

anova(fit.aov2)
# Analysis of Variance Table
# 
# Response: response
#           Df  Sum Sq Mean Sq F value             Pr(>F)    
# trt        4 1351.37  337.84  32.433 0.0000000000009819 ***
# Residuals 45  468.75   10.42                               
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

summary(fit.aov2)
#             Df Sum Sq Mean Sq F value            Pr(>F)    
# trt          4 1351.4   337.8   32.43 0.000000000000982 ***
# Residuals   45  468.8    10.4                              
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# 통계적으로 유의! 집단별 response의 평균 차이가 있음!
# 어느 집단이 어느정도 차이가 있는지 알지 못함

# install.packages("gplots", dependencies = T)
library(gplots)  # 그룹 별 플롯그려줌
plotmeans(formula= response~trt, data=cholesterol, main='title') # {gplots}
# 각 집단의 크기(n)이 나옴 -> Balanced Design(균형된 설계)
# . 으로 평균이 나오고, 선으로 평균의 신뢰구간(CI, Confidence Interval)이 나옴
# 평균의 다중비교하지 않아도, 어떤 그룹의 평균이 가장 큰지 확인 가능하다.


# 다중비교
# ⓐ multcomp::glht
fit.glht2 <- glht(fit.aov2, linfct=mcp(trt='Tukey'))
fit.glht2

# -> 그림으로
?cld # {multcomp} compact letter display
plot(cld(fit.glht2, level=.05))

# ⓑ  stats::TukeyHSD
fit.mcp <- TukeyHSD(fit.aov2) 

names(fit.mcp)
# [1] "trt"

fit.mcp
# Tukey multiple comparisons of means
#     95% family-wise confidence level : family-wise:그룹별 쌍
# 
# Fit: aov(formula = response ~ trt, data = cholesterol)
# 
# $trt
#                   diff        lwr       upr     p adj α=0.001일 때
# 2times-1time   3.44300 -0.6582817  7.544282 0.1380949
# 4times-1time   6.59281  2.4915283 10.694092 0.0003542   *
# drugD-1time    9.57920  5.4779183 13.680482 0.0000003   *
# drugE-1time   15.16555 11.0642683 19.266832 0.0000000   *
# 4times-2times  3.14981 -0.9514717  7.251092 0.2050382
# drugD-2times   6.13620  2.0349183 10.237482 0.0009611   *
# drugE-2times  11.72255  7.6212683 15.823832 0.0000000   *
# drugD-4times   2.98639 -1.1148917  7.087672 0.2512446
# drugE-4times   8.57274  4.4714583 12.674022 0.0000037   *
# drugE-drugD    5.58635  1.4850683  9.687632 0.0030633

# *로 유의정도 보여주지 않음
# 그룹별 2개씩 쌍으로 묶어서 평균비교
# 95% CI 신뢰구간:  (lwr, upr) (하한추정량, 상한추정량)
# 0.001로 유의수준 잡을 경우, 유의한 그룹쌍은, 6개
# 유의하지 않은 그룹쌍은 4개

# 유의미한 것 중, 평균의 차이(diff)가 가장 큰 쌍은, drugE-1time
# 내가 만든 것 중, 유의한 차이가 있는 것  중, 평균의 차이가 가장 큰 쌍은,
#     4times-1time


dev.off() # 그림영역 설정 초기화
# plot의 그림영역 조정해주는 par() method
par(las=2) # 눈금의 라벨명을 회전시킴(x축과 평행하게/ 1이면, y축과 평행)
par(mar=c(5,8,4,2)) # 그림영역에 여백margin 줌
plot(fit.mcp) # 점선(0)을 걸치는 경우 통계적으로 유의미하지 않음
# 평균의 차이와 신뢰구간 확인할 수 있다.

par(las=1)
par(mar=c(5,8,4,2))
??level
plot(cld(fit.glht2, level=.05), col='lightgray') # 95% 신뢰구간
# 중위수는 이상치에 덜 민감하므로, 통계적으로 유의한 두 집단의 차이

detach(cholesterol)







