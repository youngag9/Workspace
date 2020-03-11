# 단순선형회귀분석 / 다항회귀분석

?women # {datasets} : 30대 여성 15명의 키와 몸무게 조사

# 분석목적: 
#  (1) 키와 몸무게 사이의 연관성 분석
#  (2) 키로부터 몸무게 예측 

# 1. 독립과 종속변수의 선정
#  (1) 독립변수: 키(height)
#  (2) 종속변수: 몸무게(weight)

attach(women)

table(height) # 58~72
table(weight) # 115~164
# 둘 다 연속형변수

# 산점도 - 변수 간 선형적 관계가 있는지 확인.
plot(height, weight)  # 정상관관계가 있는 것으로 보임.
# 상관분석 시, 상관의 정도를 확인 가능하다.
# 키가 몸무게에 어떤 영향을 주는지 인과관계확인하자

# ********단순선형회귀분석**************
# 선형 모델을 만드는 함수 lm() -> fitting 하는 함수 {stats}
# H0 : 모회귀계수 β=0이다.
fit <- lm(formula = weight ~ height, data = women)
fit
# Call:
#   lm(formula = weight ~ height, data = women)
# 
# Coefficients:                 : 회귀계수
#   (Intercept)       height    : Intercept(절편) / height(독립변수)
#        -87.52         3.45    : α               / β (회귀계수)
# 
# 표본에서 얻는, 추정회귀방정식: 
#   weight = -87.52 + 3.45height  (yi^ = a + bxi) 
#   사람의 몸무게는 0이 될 수 없음.
#   이와같이 독립변수가 0을 가질 수 없을 때, intercept는 설명하지 않는다.
#   - b : =X가 한 단위씩 변화될 때만큼, Y값이 변하는 양을 나타낸/결정하는 것
#   키가 한 단위씩 증가할 때마다, 몸무게는 "평균적으로" 3.45lbs정도 증가한다.

names(fit)
# [1] "coefficients"  "residuals"     "effects"       "rank"          "fitted.values"
# [6] "assign"        "qr"            "df.residual"   "xlevels"       "call"         
# [11] "terms"         "model"  


summary(fit)
# 
# Call:
#   lm(formula = weight ~ height, data = women)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -1.7333 -1.1333 -0.3833  0.7417  3.1167 
# 
# Coefficients:  ****회귀계수에 대한 유의성 검정****
#               Estimate Std. Error t value           Pr(>|t|)    
# (Intercept) -87.51667    5.93694  -14.74 0.0000000017110819 ***
# height        3.45000    0.09114   37.85 0.0000000000000109 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.525 on 13 degrees of freedom
# Multiple R-squared:  0.991,	Adjusted R-squared:  0.9903 
#         ****회귀분석에 대한 유의성 검정****
# F-statistic:  1433 on 1 and 13 DF,  p-value: 0.00000000000001091

# 1. 회귀분석에 대한 유의성 검정
#   - 회귀분석 결과는 통계적으로 유의미하다.
# 2. 회귀계수에 대한 유의성 검정
#   - 고도로 유의하므로 대립가설 채택: 모회귀계수는 0이 아니다.
#   - 추정된, 절편과 기울기가 통계적으로 유의미하다.
# - R제곱: R은 상관계수, R제곱은 "결정계수"
#   -  Multiple R-squared : 회귀선이 x-y의 데이터의 분산을 99.1% 정도로
#                           설명가능할 정도로 정확하게 나왔다.
#   - Adjusted R-squared : 상관계수의 제곱인, 결정계수(상관강도를 보여줌)! 
#                           상관계수로부터 얻어진 값! 
#                           99.03이므로, 거의 완전한 정상관 관계임.
#   - 분산의 설명정도가 클수록, 좋은 모형이 만들어졌다.
#   - 분산의 설명정도가 작다면, 회귀모형을 바꾸는 것이 좋음.
#             독립변수 추가하거나 polynomial로 바꾸거나.. 
#           -> 반복적인 과정


# 추정회귀방정식 통해 예측된 값.
fitted(fit)         # 1st method
fitted.values(fit)  # 2nd method
fit$fitted.values   # 3rd method
# 1        2        3        4        5        6        7        8        9 
# 112.5833 116.0333 119.4833 122.9333 126.3833 129.8333 133.2833 136.7333 140.1833 
# 10       11       12       13       14       15 
# 143.6333 147.0833 150.5333 153.9833 157.4333 160.8833 
# 실제값과 예측값의 차이를 "잔차"라고 함.
# 설명력이 99%이므로 비슷함. 잔차가 작은값을 가짐

# 추정(예측)값은, 항상 오차를 포함할 수 있기 때문에,
# 이 오차를 "잔차(residual values)"라 한다.
# 이를 얻어내는 함수는 아래와 같음
residuals(fit)
fit$residuals
#          1           2           3           4           5           6           7 
# 2.41666667  0.96666667  0.51666667  0.06666667 -0.38333333 -0.83333333 -1.28333333 
#          8           9          10          11          12          13          14 
# -1.73333333 -1.18333333 -1.63333333 -1.08333333 -0.53333333  0.01666667  1.56666667 
#         15 
# 3.11666667 

# 회귀계수를 얻어내는 방법
coef(fit)
coefficients(fit)
fit$coefficients
# (Intercept)    height 
# -87.51667     3.45000 

# 원본데이터 
fit$model


# 시각화를 통해, 분석데이터를 얼마나 잘 설명하고 있는지 비교해보자
plot(height, weight)
abline(fit, col='red') # 회귀직선을 그어줌: 회귀선이 데이터를 이정도로 표현하고 있다.


# ------------------------------------------------------
# 약간 벗어났으니까, 곡선적 관계를 가지지 않을까?
# 변량을 더 잘 설명해주는 곡선을 그려보자  <<튜닝>>
#   cf) 1차방정식 => 직선
#   곡선을 그리려면, 차원을 높여야한다.
# *******다항회귀분석(Polynomial Regression)**********


# 다차원 회귀선그리려면 car package 필요
library(car)

dev.off()
# 회귀분석 전에라도, 두 변수간에 가장 적합한
# 회귀선의 모양이 어떤 것이 가장 적합한지 힌트를 제공하는 용도
# 단순 / 다중 / 다항 중 어떤 것 할지 판별해줌.

# 내부적으로 다항회귀분석을 해 적합한 회귀분석을 그려주는 함수
scatterplot(weight ~ height, 
            data=women,
            smoother.args = list(lty=1),  # 평활적합선(smoothing line)
                                            # lty: linetype
            spread = F,
            pch = 19
)
# 실선은, 회귀직선 / 점선은, 다항회귀선 -> 점선 2개이니까 3차다항까지
# -> 적합은, 회귀곡선이 낫고, 제일 왼쪽에 위치한 3차다항회귀선이 가장 적합한다.
# marginal plot: 각 변수의 분포를 보여주는 boxplot을 여백에 그려줌.

# 유의성 검정은 못함. -> 따로 해야 함.
# 회귀계수 알지못하므로, 예측을 못함.
# 직선/곡선이 적합할지 빠르게 판단할 수 있도록 해줌!




# I() : 괄호 안의 표현식을 산술적으로 계산한다는 의미
fit2 <- lm(weight ~ height + I(height^2), data=women)  # I(height^2) : height의 제곱
fit2

# Call:
#   lm(formula = weight ~ height + I(height^2), data = women)
# 
# Coefficients:
# (Intercept)     height    I(height^2)  
# 261.87818     -7.34832      0.08306  
# [추정회귀방정식] weight = 261.87818 - 7.34832*height + 0.08306*height^2

# 유의성검정
summary(fit2)
# 
# Call:
#   lm(formula = weight ~ height + I(height^2), data = women)
# 
# Residuals:  -> 잔차 크기의 범위
#      Min       1Q   Median       3Q      Max 
# -0.50941 -0.29611 -0.00941  0.28615  0.59706 
# 
# Coefficients:
#             Estimate Std. Error t value      Pr(>|t|)    
# (Intercept) 261.87818   25.19677  10.393 0.00000023569 ***
# height       -7.34832    0.77769  -9.449 0.00000065845 ***
# I(height^2)   0.08306    0.00598  13.891 0.00000000932 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.3841 on 12 degrees of freedom
# Multiple R-squared:  0.9995,	Adjusted R-squared:  0.9994 
# F-statistic: 1.139e+04 on 2 and 12 DF,  p-value: < 0.00000000000000022

# 1. 회귀분석에 대한 유의성 검정
#   - 회귀분석 결과는 통계적으로 유의미하다.
# 2. 회귀계수에 대한 유의성 검정
#   - 고도로 유의하므로 대립가설 채택: 모회귀계수는 0이 아니다.
#   - 절편과 모든 회귀계수가 통계적으로 유의미하다.
# 결정계수로 보아 회귀모형으로 보아 설명력 good 0.9995
# 


# 시각화를 통해서, 좀 더 튜닝된 회귀모형(즉, 추정회귀방정식)이
# 얼마나 더 좋아졌는지 확인해보자.
plot(height, weight)
# abline(fit2) # XX : 직선만드는 함수니까 곡선은 못그림
# 곡선그리는 함수 lines(x,y){graphics}
lines(height, fitted(fit2), col='red') # y에 모델로부터 추정된 값을 넣음
# -> 적합화가 더 잘 됨.

# 여기서 튜닝을 마무리하면
# 최종 [추정회귀방정식] 
#     weight = 261.87818 + 
#             (-7.34832) * height + 
#             (0.08306) * height^2
# 키가 한단위씩 증가할 때마다, 몸무게가 평균적으로 -7.34832씩 감소하고
#     한단위씩 제곱단위로 증가할 때마다, 몸무게가 평균적으로 0.08306만큼 증가한다.


#--------------------------------------
# 차원을 하나 더 높인다면?
fit3 <- lm(
  weight ~ height + I(height^2) + I(height^3), 
  data=women
)

fit3
# Call:
#   lm(formula = weight ~ height + I(height^2) + I(height^3), data = women)
# 
# Coefficients:
#   (Intercept)       height  I(height^2)  I(height^3)  
# -896.747633    46.410789    -0.746184     0.004253  

summary(fit3)
# Call:
#   lm(formula = weight ~ height + I(height^2) + I(height^3), data = women)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -0.40677 -0.17391  0.03091  0.12051  0.42191 
# 
# Coefficients:
#   ```````````  Estimate  Std. Error t value Pr(>|t|)   
# (Intercept) -896.747633  294.574545  -3.044  0.01116 * 
# height        46.410789   13.655353   3.399  0.00594 **
# I(height^2)   -0.746184    0.210521  -3.544  0.00460 **
# I(height^3)    0.004253    0.001079   3.940  0.00231 **
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.2583 on 11 degrees of freedom
# Multiple R-squared:  0.9998,	Adjusted R-squared:  0.9997 
# F-statistic: 1.679e+04 on 3 and 11 DF,  p-value: < 0.00000000000000022

# 모형적합, 회귀계수유의성 인정. 설명력 99.98%(-> 마냥 좋은  것아님)


# 다차원 회귀선그리려면 car package 필요
library(car)

dev.off()
# 회귀분석 전에라도, 두 변수간에 가장 적합한
# 회귀선의 모양이 어떤 것이 가장 적합한지 힌트를 제공하는 용도
# 단순 / 다중 / 다항 중 어떤 것 할지 판별해줌.

# 내부적으로 다항회귀분석을 해 적합한 회귀분석을 그려주는 함수
scatterplot(weight ~ height, 
            data=women,
            smoother.args = list(lty=1),  # lty: linetype
            spread = F,
            pch = 19
)
# 실선은, 회귀직선 / 점선은, 다항회귀선 -> 점선 2개이니까 3차다항까지
# -> 적합은, 회귀곡선이 낫고, 제일 왼쪽에 위치한 3차다항회귀선이 가장 적합한다.
# marginal plot: 각 변수의 분포를 보여주는 boxplot을 여백에 그려줌.

# 유의성 검정은 못함. -> 따로 해야 함.
# 회귀계수 알지못하므로, 예측을 못함.
# 직선/곡선이 적합할지 빠르게 판단할 수 있도록 해줌!

detach(women)
