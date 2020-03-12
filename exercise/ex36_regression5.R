# 다중공선성(Multi-colinearity)

# 주의: 다중공선성은, 이전의 회귀모델의 가정판단과는 다른 문제.
# 대상: 다중선형회귀
# 정의: formula에 나열한, 독립변수들 사이에, 강한 상관관계가 존재하여,
#       회귀모형을 적합시킬 때, 아래와 같은 두가지의 문제를 발생시킨다.
#       (1) 과소추정:  
#       (2) 과대추정: 
#     - 원래, 종속변수에 영향을 미칠 때, 한 독립변수가 영향미칠 때 
#         다른 독립변수들은 통제되어 있어야 함.
#     - 모형이 적합하지만, 회귀계수가 통계적으로 유의하지 않을 때!! 다중공선성을 의심하라.
#     - 회귀가정을 다 통과했어도, 다중공선성의 문제가 생길 수 있다.
# 부작용: 모델을 적합시킬 때,
#         회귀모델의 회귀계수의 신뢰구간이 넓어지고,(믿지못한 회귀계수가 됨)
#         개별회귀계수의 해석이 어려워짐.

# 다중공선성의 유무 판정:
# 소위, 분산팽창지수(VIF, Variance Inflation Factor)값으로 판단
#   원래의 값에 비교해 분산이 커졌는지를 비교하여 다중공선성을 판정
# 일단, VIF값이 구해지면, 아래와 같은 기준으로 판정한다.
# 
# 판정기준: sqrt(VIF) > 2인 경우  -->   다중공선성이 있다고 판정
#

# VIF값 구하기
library(car)
df_states <- 
  as.data.frame(
    state.x77[, c('Murder', 'Population', 'Illiteracy', 'Income', 'Frost')]
  )

fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data = df_states)
vif(fit)
# Population Illiteracy     Income      Frost 
# 1.245282   2.165848       1.345822   2.082547 
#
sqrt(vif(fit))> 2
# Population Illiteracy     Income      Frost 
# FALSE      FALSE          FALSE      FALSE 
# -> 공선성 문제가 없음 / 문제가 있다면, 모델에서 빼야 함.


# 시계열분석에서는, 자기상관성(ACF) / 부분자기상관성(PACF)로 판단






