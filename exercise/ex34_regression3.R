# 상호작용이 있는 다중선형회귀
# format symbol, : => interaction

# 분석데이터셋: mtcars{datasets}

# 분석대상변수
#   - 종속변수: mpg(연비)
#   - 독립변수: hp(마력수, 엔진의 힘), wt(차의 중량)

# hp와 wt가 연비에 인과관계가 있을까? 예측할 수 있을까?
# hp와 wt의 상호작용에 의해서도 연비가 영향을 받을 수 있을까?
fit <- lm(mpg ~ hp + wt + hp:wt, data = mtcars)
fit
# Call:
#   lm(formula = mpg ~ hp + wt + hp:wt, data = mtcars)
# 
# Coefficients:
# (Intercept)           hp           wt        hp:wt  
#    49.80842     -0.12010     -8.21662      0.02785  
# 절편과, 주항목, 상호작용항목 보여줌

# 유의성 검정
summary(fit)
# Call:
#   lm(formula = mpg ~ hp + wt + hp:wt, data = mtcars)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -3.0632 -1.6491 -0.7362  1.4211  4.5513 
# 
# Coefficients:
#             Estimate Std. Error t value           Pr(>|t|)    
# (Intercept) 49.80842    3.60516  13.816 0.0000000000000501 ***
# hp          -0.12010    0.02470  -4.863 0.0000403624302068 ***
# wt          -8.21662    1.26971  -6.471 0.0000005199287280 ***
# hp:wt        0.02785    0.00742   3.753           0.000811 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.153 on 28 degrees of freedom
# Multiple R-squared:  0.8848,	Adjusted R-squared:  0.8724 
# F-statistic: 71.66 on 3 and 28 DF,  p-value: 0.0000000000002981

# 회귀모형 유의성O
# 회귀계수 유의성 전부 인정.
#   - 상호작용도, 연비에 영향을 줌.
# 종속변수 변량의 설명력(결정계수)은 88.48%, 상관강도는 0.8724

# 차의 엔진마력수와 차의 중량의 상호작용 유의미하다
# -> 마력수가 변화할 때, 중량도 영향을 받는다. 마력수는 차의 중량에 따라 변할 수 있다.
#   - 다만, 0.02785 정도로, 큰 영향을 받지 않아 괜찮다?
# ""하나의 독립변수가 다른 독립변수의 수준에 달려있다.""

coef(fit)
# 추정회귀방정식: yHat = a + bx
#   mpg^ = 49.8042343 - 0.12010*hp - 8.21662430*wt
#         + 0.02784815* hp *wt  
# -> 상호작용효과는, hp*wt와 같이 곱해서 표현

# 추정회귀방정식에 값을 대입해보자
# if wt = 2.2 일 때,
#   mpg^ = 49.8042343 - (0.12010 *hp)  -8.21662430*2.2
#         + (0.02784815* 2.2 * hp) 
#        = 31.41 - 0.06 * hp
# -> 식이 해석하기 좋게 단순화됨.
#  -> 무게가 무거워질수록, hp와 상관없이 느려진다

# -> 계산보다, 시각화하는 것이 좋음
# 시각화
library(effects)
# effect{ettects}: 상호작용효과의 영향도 보여줌
plot(effect("hp:wt", fit), multiline = T) # multiline: 여러개의선 한번에 그려라
# 차의 중량wt(범례)가 ~일 때, hp에 따른, mpg값 볼 수 있음.
# 차의 마력이 증가될수록, 연비가 감소추세에 있는데, 감소정도가 중량마다 다름 (중량이 5.4제외)
# 차의 중량이 가벼워도, 마력수가 증가해도 연비가 감소함.
# -> 차의 중량이 증가할수록, hp와 mpg관계가 약화된다.
#   산점도를 그려볼 때, 이상치 값이 있어, 중량이 5.4일때 혼자 hp증가시 mpg감소
# hp:wt -> 마력은 차의 중량수준에 영향받는다

# dev.off() # 오른쪽 plot창 초기화
dev.new() # 새로운 plot창 생성
plot(mtcars$wt, mtcars$mpg)
# wt가 5.4인 것 중 특이한 차량이 있음
identify(mtcars$wt, mtcars$mpg) # outlier값 확인할 수 있음: 17

dev.off()

library(effects)
plot( effect("hp:wt", fit), multiline = T )


dev.new()
plot(mtcars$wt, mtcars$mpg )

dev.new()
boxplot(mtcars$mpg)
#   mpg^ = 49.8042343 - 0.12010*hp - 8.21662430*wt
#         + 0.02784815* hp *wt  
# 마력이 좋으면, 기름 많이먹으니까 연비감소됨.
# 마력수와 중량은 연비와 분명한 상관성이 있으며,
# 연비를 감소시키는 효과가 있다
# 마력수와 중량의 상호작용은, 오히려 연비를 미묘하게 증가시키는 효과가 있다

# 값을 예측할 떄, """독립변수 범위 내에서""" 예측해야 함.
# 단순선형회귀로 살펴본다면,
fit2 <- lm(formula = weight ~ height, data = women)
plot(women$height, women$weight)
abline(fit2, col='red')
# 회귀선은, 58~72 내에서만, 유효한 방정식이다.
# 새로운 값 예측하기 위해, 90이라는 height값을 넣어 얻어낸 weight값은 
#     ""신뢰할 수 없는"" 값이다. -> 추정값이라고 할 수 없다
# 표본에 없는 58.3의 height값을 넣어 얻은 weight값은 추정값이 맞음. 
#   데이터가 없으므로, 확인할 수 없는 값.




