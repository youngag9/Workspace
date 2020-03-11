# 단순선형회귀분석

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

# 회귀분석
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
#   - b : =X가 한 단위씩 변화될 때만큼, Y값이 변하는 양을 나타낸/결정하는 것

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

fit$residuals
#          1           2           3           4           5           6           7 
# 2.41666667  0.96666667  0.51666667  0.06666667 -0.38333333 -0.83333333 -1.28333333 
#          8           9          10          11          12          13          14 
# -1.73333333 -1.18333333 -1.63333333 -1.08333333 -0.53333333  0.01666667  1.56666667 
#         15 
# 3.11666667 



detach(women)