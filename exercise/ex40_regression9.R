# -- 회귀모델의 변수선택 --
# 많은 예측변수 중에서, 최종 예측변수를 선택하는 자동화된 방법
# -> 참고할 것, 지나친 의존은X (최종선택은 분석가가 해야함.)

# ------------------------------------
# (1) 단계적 회귀(Step-wise Regression)
# ------------------------------------
# 가. 예측변수들을 어떤 기준에 이를 때까지,
#     회귀모델에 예측변수를 가감한다.
# 나. 두가지 종류(=알고리즘): 
#   a. Forward Stepwise(=전진선택법)
#     - 예측변수를 더이상 더해도, 모델의 설명력이 더 이상 향상되지 않을 때까지
#       모델에 예측변수를 하나하나씩, 차례로 첨가해 나감.
#   b. Backward Stepwise(=후진제거법)
#     - 모든 예측변수들을 포함한 모델로부터 시작해서,
#           (-> 설명력이 좋을 수 있으나 검약성 위배)
#       더 이상 모델의 설명력이 감소되지 않을 때까지 
#       모델에 예측변수를 하나하나씩, 차례로 제거해 나감. 
# 다. 사용패키지와 함수: stepAIC{MASS} 함수 이용
#     이 함수는, 정확한 AIC 기준을 사용하여, 모델을 단계적으로 선택해나감.
# 라. 단계적 방법의 주의사항:
#     - 이 방법이 좋은 모델을 발견하기는 하나,
#     - 발견한 모델이 가장 좋은 모델은 아님
#       (이유: 모든 가능한 모델을 평가하지 않기 때문)

# 후진제거법(Backward Stepwise) 예제
library(MASS)

df_states <- 
  as.data.frame(
    state.x77[, c('Murder', 'Population', 'Illiteracy', 'Income', 'Frost')]
  )

fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=df_states)
stepAIC(fit, direction = 'backward')
# none위의 것들을 비교

# Start:  AIC=97.75
# Murder ~ Population + Illiteracy + Income + Frost
# 
#              Df Sum of Sq    RSS     AIC
# - Frost       1     0.021 289.19  95.753
# - Income      1     0.057 289.22  95.759
# <none>                    289.17  97.749  (최초모델: Murder~.)
# - Population  1    39.238 328.41 102.111
# - Illiteracy  1   144.264 433.43 115.986
#     -> 변수 빼면서, AIC값 작아짐.
#     -> Frost빼는 것이 AIC가장 작아 이를 빼는 것이 가장 좋다.
# ----------------------------------------
# Step:  AIC=95.75  (-Frost값과 같음)
# Murder ~ Population + Illiteracy + Income
# 
# Df Sum of Sq    RSS     AIC
# - Income      1     0.057 289.25  93.763
# <none>                    289.19  95.753
# - Population  1    43.658 332.85 100.783
# - Illiteracy  1   236.196 525.38 123.605
#     -> Income 빼자
# ----------------------------------------
# Step:  AIC=93.76
# Murder ~ Population + Illiteracy
# 
# Df Sum of Sq    RSS     AIC
# <none>                    289.25  93.763
# - Population  1    48.517 337.76  99.516
# - Illiteracy  1   299.646 588.89 127.311
#     -> none이 가장 좋음! (AIC가장 작음) => step끝!
# ----------------------------------------
# Call:
#   -> 후진으로 AIC 가장 좋은 모델.
#   lm(formula = Murder ~ Population + Illiteracy, data = df_states)
# 
# Coefficients:
# (Intercept)   Population   Illiteracy  
# 1.6515497    0.0002242    4.0807366  

# 가정검정과, 통계적유의성검정을 확인안했으므로, 가장 좋은 모델이라할 수 없지만
# 후보모델을 제시해준 것.


# 이제 검정해야 함
fit.candidate <- lm(formula = Murder ~ Population + Illiteracy, data = df_states)
summary(fit.candidate)
# .. 가설검정도 해야함.

# ------------------------------------
# (2) 모든 변수를 입력하는 방법
#   (모든 부분집합 회귀, All subjects regression)
# ------------------------------------
# 가. 모든 부분집합 회귀로, 모든 가능한 모델을 탐색 수행.
# 나. 분석가는, 이를 수행할 때, 모든 가능한 결과의 제시나
#     소위 nbest 모델을 선택하여 수행한다.
#     (예: nbest = 2 -> 최대 후보모델의 개수
#                       1개의 예측변수를 가진 2개의 최선의 예측모델 + 
#                       2개의 예측변수를 가진 2개의 최선의 예측모델 등
#                       모든 예측변수가 포함될 때까지의 결과)
# 다. 사용패키지: regsubsets{leaps} 함수 이용
#                 -> 최선의 모델만을 내놓음.
#               : -> plot{graphics}/subsets{car} 함수로 시각화
# 라. nbest개수만큼의, 최선의 후보모델을 선택할 때에,
#     지정가능한 최선의 모델기준으로는 아래와 같음:
#     (1) Multiple R^2 (결정계수 - 종속변수 변량의 설명력)
#     (2) Adjusted R^2 (결정계수 - 상관강도)
#     (3) Mallow CP statistic 

library(leaps)
leaps <- regsubsets(
  Murder ~ Population + Illiteracy + Income + Frost, 
  data=df_states, 
  nbest=4  # 뽑을 "최선"의 후보모델의 개수 지정.
)

leaps
# Subset selection object
# Call: regsubsets.formula(Murder ~ Population + Illiteracy + Income + 
#                            Frost, data = df_states, nbest = 4)
# 4 Variables  (and intercept)
#             Forced in Forced out
# Population     FALSE      FALSE
# Illiteracy     FALSE      FALSE
# Income         FALSE      FALSE
# Frost          FALSE      FALSE
# 4 subsets of each size up to 4
# Selection Algorithm: exhaustive

plot(leaps, scale='adjr2')
# 각자의 색이 최선의 모델의미 / y축은 설명력(어떤 값이 나올지 모르겠음)
# intercept, Income
# / intercept, population, 
# / intercept, population, income, frost
# / intercept, population, illiteracy, income, frost
# 정확한 판정이 어려움.

#------------------------------------
library(car)
dev.off()
par(mfrow=c(2,2))

# 지정된 nbest 개수의 최선의 후보모델 선택 시,
# 아래와 같은 통계량의 특서은 다음과 같음.
#   (1) Unadjusted R^2(rsq) - 예측변수에 의해서, 설명되는 종속변수의 변량의 크기.(설명력)
#                   단, 예측변수가 많아지면, 이 수치는 항상 증가한다.
#                   이로인해, 표본크기에 비해, 모회귀계수가 많아지면,
#                   소위 "과적합(overfitting)" 발생
#                   -> 새로운 데이터에 대해서는 설명력이 떨어짐.
#   (2) Adjusted R^2(adjr2) - R제곱(rsq)에 비해서, 보다 정직함 / 상관강도
#   (3) Mallow CP - 주의할 것은 별로 없지만, 
#                   단계적 회귀분석(Stepwise Regression)의 종료기준으로 사용됨.
#                     AIC와 MallowCP와 관련?
#                   좋은 모델은 CP 통계량이 모델의 모회귀계수에 근접하는 경향을 보임.
#  -> CP 기준이 가장 좋음. / 그다음 rsq / 그다음 adjr2 

subsets(leaps, statistic = "cp") # mallow cp statistic을 기준으로.
subsets(leaps, statistic = "bic") # 베이지안 통계학(존재하는 데이터로만! 가정X)과 관련
subsets(leaps, statistic = "adjr2")
subsets(leaps, statistic = "rsq")
subsets(leaps, statistic = "rss")
#      statistic: 최선의 모델 선택 "기준" 
#       ('bic(Bayes Information)'/'cp(mallow cp)'/
#       'adjr2(AdjustedR^2)'/ 'rsq(R^2)'/ 'rss(잔차제곱합)')
# 진하게 표시된 것이 최선의 모델
# 클릭하면: 변수이름의 약어들을 알려줌

# abline(a=절편값 ,b=기울기값 ,h= ,col= ,lty=선의타입)
abline(1,1, col='red', lty=1) # 절편이 1이고, 기울기가 1인 선그려줌 
#  --> cutoff: 선의 아래쪽에 있는 모형들이 후보가 됨.
# 4개의 최선의 후보모델 -> 이것 중 어느것이 가장 좋을까?(분석가의 몫)

















