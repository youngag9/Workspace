# 6-7 One-way ANOVA Test(para)

# 집단을 만드는 factor가 하나
# H0 : 3개이상의 집단의 평균이 같다

# 가정) 필요조건
#   1. 관측치가 독립적(종속) factor level에 의해 정의된 그룹이 무작위성을 띄어야 함.
#   2. 정규성
#   3. 등분산성  (Levene’s test can be used to check this.)

mydata <- PlantGrowth
head(mydata)
View(mydata)
str(mydata)
# 'data.frame':	30 obs. of  2 variables:
#   $ weight: num  4.17 5.58 5.18 6.11 4.5 4.61 5.17 4.53 5.33 5.14 ...
# $ group : Factor w/ 3 levels "ctrl","trt1",..: 1 1 1 1 1 1 1 1 1 1 ...
dim(mydata) # 30 2

library(prettyR)
freq(mydata$group)
# Frequencies for mydata$group 
#      ctrl trt1 trt2   NA
#        10   10   10    0
# %    33.3 33.3 33.3    0 
# %!NA 33.3 33.3 33.3        -> balanced Design


set.seed(134)

library(dplyr)
sample_n(mydata, 10)  # 원래의 df 중 10개 무작위추출
#     weight group
# 1    4.17  trt1
# 2    5.14  ctrl
# 3    5.80  trt2
# 4    4.32  trt1
# 5    4.61  ctrl
# 6    4.69  trt1
# 7    6.15  trt2
# 8    4.81  trt1
# 9    5.58  ctrl
# 10   3.83  trt1

# factor 타입 변수의 레벨 출력
levels(mydata$group)  # factor level 보여줌 : " ctrl" "trt1" "trt2"

# group은 순서형이므로 ordered로 순서를 지정해준다. 
mydata$group <- ordered(mydata$group, levels = c("ctrl", "trt1", "trt2"))
# levels : 실제값
# labels : 집단의 이름 지정

# group별 weight의 평균이 같은지 one-way ANOVA 분산분석할 것!

library(dplyr)
# 집단별 평균 기초통계량 -> 표본 
group_by(mydata, group) %>% 
  summarise(
    count = n(),
    mean = mean(weight, na.rm = T), # aggregate와 달리 결측치처리 가능
    sd = sd(weight, na.rm = T)
  )
# # A tibble: 3 x 4
#   group count  mean    sd
#   <ord> <int> <dbl> <dbl>
# 1 ctrl     10  5.03 0.583
# 2 trt1     10  4.66 0.794
# 3 trt2     10  5.53 0.443
# --> 집단별 표본의 평균은 4~5로 크게 차이나지 않음
# --> 해당 차이가 큰 것인지 판단하기 위해 sd(표준편차도 구함)
# --> 첫세번째 그룹은 가깝고, 두번째 그룹은 조금 멈

# 모집단의 집단별 평균이 있을까?
library(ggpubr, quietly = T)

# 집단별 분포를 확인할 수 있음
ggboxplot(mydata,
          x = 'group',
          y = 'weight',
          color = 'group',
          palette = c('#00AFBB', '#E7B800', '#FC4E07'),
          order = c('ctrl', 'trt1', 'trt2'), # x축에 나타나는 그룹의 순서 지정
          ylab = 'Weight',
          xlab = 'Treatment'
)
# 중위선의 차이가 trt1만 아래에 있고, ctrl과 trt2는 겹쳐있음
# 평균의 차이가 있는지 시각적으로 판단할 수 없음
# --> ggline 추가해줘야 함

ggline(mydata,
       x = 'group',
       y = 'weight',
       add = c('mean_se', 'jitter'), # 평균의 표준오차와, datapoint를 흔들어버림(jitter)
       order = c('ctrl', 'trt1', 'trt2'),
       ylab = 'Weight',
       xlab = 'Treatment'
)

boxplot(weight ~ group, 
        data = mydata,
        xlab = "Treatment", 
        ylab = "Weight",
        frame = FALSE, 
        col = c("#00AFBB", "#E7B800", "#FC4E07")
)


library("gplots", quietly = TRUE)

plotmeans(weight ~ group, 
          data = mydata, 
          frame = FALSE,
          xlab = "Treatment", 
          ylab = "Weight",
          main="Mean Plot with 95% CI"
)
# 신뢰구간이 겹치므로 모집단의 평균이 같을수도 있음
# -> 시각적으로 평균이 다르다고 판단할 수 없으므로
#     검정을 통해 평균이 같은지 확인해야 함.



# Compute the analysis of variance
# weight를 group의 집단별로 측정함 (집단 간 요인 group)
res.aov <- aov(weight ~ group, data = mydata)
res.aov
# Call:
#   aov(formula = weight ~ group, data = mydata)
# 
# Terms:
#                    group Residuals
# Sum of Squares   3.76634  10.49209
# Deg. of Freedom        2        27
# 
# Residual standard error: 0.6233746
# Estimated effects are balanced

# Summary of the analysis
summary(res.aov)
#             Df Sum Sq Mean Sq F value Pr(>F)  
# group        2  3.766  1.8832   4.846 0.0159 *
# Residuals   27 10.492  0.3886 
# -> 0.05 수준에서 유의미
# group변수가 만들어내는 여러 그룹의 평균이 모두 같지 않다



# 어떤 그룹이 다른지 확인하기 위해 사후분석 수행
# Tukey 알고리즘 활용한 평균의 다중비교
TukeyHSD(res.aov) 
# Tukey multiple comparisons of means
# 95% family-wise confidence level
# 
# Fit: aov(formula = weight ~ group, data = mydata)
# 
# $group
#             diff        lwr       upr     p adj
# trt1-ctrl -0.371 -1.0622161 0.3202161 0.3908711  유의X(차이나더라도 인정되지X)
# trt2-ctrl  0.494 -0.1972161 1.1852161 0.1979960  유의X
# trt2-trt1  0.865  0.1737839 1.5562161 0.0120064  0.05수준에서 유의미.

# 평균의 차이와, 차이에 대한 신뢰구간값. pvalue를 보여줌
# trt2와 trt1이 평균의 차이가 발생하며, 그 차이값은 0.865이다.


# 평균의 다중비교2
library(multcomp, quietly = TRUE)

summary( glht(res.aov, linfct = mcp(group = "Tukey")) )
# mcp : 평균을 비교하여, 선형가설 스펙을 만들어주는 함수
# 
# Simultaneous Tests for General Linear Hypotheses
# 
# Multiple Comparisons of Means: Tukey Contrasts
# 
# 
# Fit: aov(formula = weight ~ group, data = mydata)
# 
# Linear Hypotheses:
#                  Estimate Std. Error t value Pr(>|t|)  
# trt1 - ctrl == 0  -0.3710     0.2788  -1.331   0.3908  
# trt2 - ctrl == 0   0.4940     0.2788   1.772   0.1979  
# trt2 - trt1 == 0   0.8650     0.2788   3.103   0.0121 *
# Estimate: 평균차이 추정량 / Std. Error: 추정량 오차 / tvalue : 검정통계량 -> t분포를 이용

# pairwise.t.test{stats}
# 평균의 다중비교3 : 짝끼리 잡아서 t-test하는 방식
pairwise.t.test(mydata$weight, mydata$group, p.adjust.method = "BH")
# BH: Benjamini-Hochberg method.
# Pairwise comparisons using t tests with pooled SD 
# 
# data:  mydata$weight and mydata$group 
# 
#       ctrl  trt1 
# trt1 0.194  -      <- 이 표안의 값이 p-value --> trt1-trt2의 차이만이 유의.
# trt2 0.132  0.013
# 
# P value adjustment method: BH 


# ***********
# 가정체크
# The residuals versus fits plot can be used to check the homogeneity of variances.
# 잔차(모델추정값 - 원래종속변수의값)의 정규성/등분산성을 검증해야 함.

# ******************************
# 잔차란?
res.aov <- aov(weight ~ group, data=mydata) 
# aov의 결과로 나온 적합된 모델이 res.aov이다.
# group(x)에 의해 결정된 weight(y, 정답) 값을 주어서, 모델 res.aov를 만듦.
# res.aov는 근소하게라도 항상 y값이 차이

# 예측값을 찾는 함수
# fitted{stats}
y_hat <- fitted(res.aov)  # res.aov의 fitted.values를 가져온 것과 같음.
# 예측값을 y_hat에 담음
#     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15 
# 5.032 5.032 5.032 5.032 5.032 5.032 5.032 5.032 5.032 5.032 4.661 4.661 4.661 4.661 4.661 
#    16    17    18    19    20    21    22    23    24    25    26    27    28    29    30 
# 4.661 4.661 4.661 4.661 4.661 5.526 5.526 5.526 5.526 5.526 5.526 5.526 5.526 5.526 5.526 
# 위와 같다.
res.aov$fitted.values

# 잔차구하기
y <- mydata$weight  # 실제값
#잔차 = 오차
( myresiduals <- y - y_hat ) # 실제값 - 예측값
#      1      2      3      4      5      6      7      8      9     10     11     12     13 
# -0.862  0.548  0.148  1.078 -0.532 -0.422  0.138 -0.502  0.298  0.108  0.149 -0.491 -0.251 
#     14     15     16     17     18     19     20     21     22     23     24     25     26 
# -1.071  1.209 -0.831  1.369  0.229 -0.341  0.029  0.784 -0.406  0.014 -0.026 -0.156 -0.236 
#     27     28     29     30 
# -0.606  0.624  0.274 -0.266 

# myresiduals도 res.aov안에 있음
res.aov$residuals

# *****************************
# 1. Homogeneity of variances : 등분산성체크
plot(res.aov, 1)
# x축: 적합된값(aov(weight~group)) / y축: 잔차

#install.packages('car', dependencies = TRUE, quiet = TRUE)
library(car, quietly = TRUE)

leveneTest(weight ~ group, data = mydata)

oneway.test(weight ~ group, data = mydata)

pairwise.t.test(mydata$weight, mydata$group, p.adjust.method = "BH", pool.sd = FALSE)

# 2. Normality
plot(res.aov, 2)
# Extract the residuals
( aov_residuals <- residuals(object = res.aov ) )

# Run Shapiro-Wilk test
shapiro.test(x = aov_residuals )

kruskal.test(weight ~ group, data = mydata)