# -- 최적의 회귀모딜 선택 방법 ---
#
# 시도하여 만들어낸, 많은 회귀모형 중에, 선택을 해야 하는 상황에 직면하게 됨.
# 
# 최소한의 선택기준:
#   가. 예측정확성 - 예측의 정확도를 높일 수 있는 모델
#   나. 검약성     - 단순하고 반복가능한 모델
#                     비슷한 설명력을 갖는다면 변수가 적은 것이 더 좋음.
#   다. 최종적인 결정은, 분석가의 결정임

#---------------------------
# (1) 회귀모형의 비교방법- 1 (ANOVA)
#---------------------------
# 회귀분석의 가정을 충족시키고, 회귀모형을 통계적 유의성까지 충족된
# 여러 모형이 있을 때, 이들 모형을 비교.
#
# 두 개의 모델을 비교: 분산분석(ANOVA)을 통해.
#     비교시 제약(조건):
#   가. 두 회귀모델이 소위 "NESTED" 되어야 함.(같은 변수를 포함해야 함.)
#   나. 비교할 두 모델이 Nested되지 않다면, AIC사용.
#       AIC에서는 이러한 제약이 없음!! - 중첩되지 않았다면 AIC 사용

df_states <- 
  as.data.frame(
    state.x77[, c('Murder', 'Population', 'Illiteracy', 'Income', 'Frost')]
  )

fit1 <- lm(
  Murder ~ Population + Illiteracy + Income + Frost, 
  data = df_states
)

fit2 <- lm(  # 유의성이 없는 예측변수 2개를 뺀 모델
  Murder ~ Population + Illiteracy,
  data = df_states
)

fit3 <- lm(  # 영향력이 가장 높은 문맹력만 남김
  Murder ~ Illiteracy,
  data = df_states
)
# 회귀분석 가정 충족, 다중공선성 고려, 이상치 관리 등은 모두 만족시켰다고 가정.

# 설명력확인

summary(fit1)
# Multiple R-squared:  0.567,	Adjusted R-squared:  0.5285 
# F-statistic: 14.73 on 4 and 45 DF,  p-value: 0.00000009133

summary(fit2)
# Multiple R-squared:  0.5668,	Adjusted R-squared:  0.5484
# F-statistic: 30.75 on 2 and 47 DF,  p-value: 0.000000002893

summary(fit3)
# Multiple R-squared:  0.4942,	Adjusted R-squared:  0.4836 
# F-statistic: 46.89 on 1 and 48 DF,  p-value: 0.00000001258
# 결정계수와 설명력은 떨어짐.


# 설명력 거의 동일

# 두 fitted model 비교 수행 by ANOVA
anova(fit1, fit2)
# Analysis of Variance Table
# 
# Model 1: Murder ~ Population + Illiteracy + Income + Frost
# Model 2: Murder ~ Population + Illiteracy
# Res.Df    RSS     Df  Sum of Sq      F   Pr(>F)
# 1     45  289.17                           
# 2     47  289.25  -2  -0.078505  0.0061 0.9939 (귀무, 통계적으로 유의X)
# -> 귀무 -> 두 그룹이 같다. 차이가 없음.

# 두 회귀모델의 차이가 없는 경우 --> 두번째 기준인 검약성으로 선택
# -> 즉, 예측변수가 적은 2번째 모델을 선택.


# anova 3개 비교가능할까?
anova(fit1, fit2, fit3)
# Model 1: Murder ~ Population + Illiteracy + Income + Frost
# Model 2: Murder ~ Population + Illiteracy
# Model 3: Murder ~ Illiteracy
#   Res.Df    RSS Df Sum of Sq      F   Pr(>F)   
# 1     45 289.17                                
# 2     47 289.25 -2    -0.079 0.0061 0.993911   
# 3     48 337.76 -1   -48.517 7.5503 0.008602 ** (가장좋은모델X: 설명력이 떨어짐)
#                                                   - 예측변수 너무 줄임
#  유의 -> 대립 -> 모든 모델이 같지 않음.
# -> 어떤 모델이 다른지 알려면, 평균의 다중비교?? NO -> 모델결과를 확인 

# 여러 모델 비교 시, p-value값은 모델의 개수 -1 개.


#---------------------------
# (1) 회귀모형의 비교방법- 2
#     (AIC: Akaike Information Criterion)
#              Criterion: 값 판정 기준
#---------------------------
# AIC 값이 작을수록
# --> 보다 "적은 개수의 모회귀계수가 적합하다"란 의미(좋은모델이라고 생각)
# --> 검약성과 같다고 생각.

# AIC{stats} 함수를 사용하여, AIC값 추출
AIC(fit1, fit2)
#      df      AIC
# fit1  6 241.6429
# fit2  4 237.6565
# AIC값 작을수록 좋다고 생각. -> fit2가 더 좋다
# Income, Frost 예측변수를 뺀 모델이 더 좋은 모델임을 알려줌.

# *** 다중비교
# 3개 모델 비교도 가능
AIC(fit1, fit2, fit3) 
# nested에 상관없이, AIC값이 가장 적은것이 좋다고 나옴
# df      AIC
# fit1  6 241.6429
# fit2  4 237.6565 -> 가장 좋은 모델
# fit3  3 243.4099


# 근소한 차이의 설명력이나, AIC차이가 난다면
# -> 이 기준보다 "검약성"을 기준으로 채택하는 것이 좋음.


# 모델의 개수에 상관없이 자동화하고
#  + 모델을 여러개 만들어낼 때, 후보가 될 모델을 알아서 예측변수를 추가/삭제하여
# 최선의 모델을 만들 수 있지 않을까?
# -> 다음파일


