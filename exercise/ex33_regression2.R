# 다중선형회귀 : 독립변수는 여러개이지만, 관계는 선형적.
#
# (1) 독립(예측/설명)변수가 2개 이상일 때
# (2) 독립변수와 종속변수 간의 관계가 선형적일 때
#

# 분석데이터셋 state.x77{datasets}  
#   : 미국 50개 주의 강력범죄(살인율)과 관련된 여러 변수를 갖는 데이터셋
#   인구수, 문맹율, 평균소득, 추운날씨를 보인 날수 등을 변수로 가짐.
# -> 주마다 범죄율이 다른 이유를 분석해볼 수 있다.

?state.x77
str(state.x77)
class(state.x77) # "matrix"

# 필요한 변수만 추출하여, 데이터프레임으로 만들자
df_states <- 
  as.data.frame(
    state.x77[, c('Murder', 'Population', 'Illiteracy', 'Income', 'Frost')]
  )

View(df_states) 
# Murder: 살인율 / Income: 평균소득 / Illiteracy: 문맹율 / Frost: 추운날씨 수

#         Murder Population Illiteracy Income Frost
# Alaska   11.3        365        1.5   6315   152
# -> Murder외의 다른 변수들이, 실제로 살인율에 영향을 미치고 있을까?

# 1) 변수선정(독립, 종속)
#   종속변수: Murder
#   원인(독립/설명/예측)변수: Population, Illiteracy, Income, Frost


# 독립변수가 여러개이므로, 산점도로 독립-종속변수 관계 파악할 수 없음
# 여러 변수 간 관계는 -> 상관행렬 or 공분산행렬 구함.
# 2) 종속변수와 선정된 독립변수 간의 관계를 확인

# 상관행렬 구함
cor(df_states)
#                Murder Population Illiteracy     Income      Frost
# Murder      1.0000000  0.3436428  0.7029752 -0.2300776 -0.5388834
# Population  0.3436428  1.0000000  0.1076224  0.2082276 -0.3321525
# Illiteracy  0.7029752  0.1076224  1.0000000 -0.4370752 -0.6719470
# Income     -0.2300776  0.2082276 -0.4370752  1.0000000  0.2262822
# Frost      -0.5388834 -0.3321525 -0.6719470  0.2262822  1.0000000
# -> 문맹율과 살인율이 상관정도 가장 크며, "뚜렷한 정상관".
# -> 수입과, 추운날씨 수와 살인율은 부상관. : 수입이 적을수록, 추운날씨가 적을수록 살인율이 증가

# 상관계수 검정
#~~~~~~
?cor.test
cor.test(df_states$Illiteracy, df_states$Murder, method = 'spearman')
# 
# 
# Spearman's rank correlation rho
# 
# data:  df_states$Illiteracy and df_states$Murder
# S = 6823.1, p-value = 0.00000008932
# alternative hypothesis: true rho is not equal to 0
# sample estimates:
#       rho 
# 0.6723592 

dev.off()
# 산점도 행렬
scatterplotMatrix(df_states, smooth=T)
# 신뢰구간과, smoothing line(평활적합선) 그려줌(점선이 평활적합선)
# 어떤 식으로 (단순/ 다중 / 다항..) fitting 시킬지 결정함.

# 각 변수별은, rug plot(데이터 밀집도)도 보여줌
# Murder: 쌍봉분포 / Population: F나 포아송분포와 비슷
# Murder-Population: 기울기 완만하지만, 선형적관계. 평활적합선.
# ...



# 공분산행렬
cov(df_states)
#                 Murder   Population   Illiteracy      Income      Frost
# Murder       13.627465     5663.524    1.5817755   -521.8943   -103.406
# Population 5663.523714 19931683.759  292.8679592 571229.7796 -77081.973
# Illiteracy    1.581776      292.868    0.3715306   -163.7020    -21.290
# Income     -521.894286   571229.780 -163.7020408 377573.3061   7227.604
# Frost      -103.406000   -77081.973  -21.2900000   7227.6041   2702.009

# cov2cor {stats} : 공분산을, 상관계수로 변환
cov2cor(cov(df_states))
#                Murder Population Illiteracy     Income      Frost
# Murder      1.0000000  0.3436428  0.7029752 -0.2300776 -0.5388834
# Population  0.3436428  1.0000000  0.1076224  0.2082276 -0.3321525
# Illiteracy  0.7029752  0.1076224  1.0000000 -0.4370752 -0.6719470
# Income     -0.2300776  0.2082276 -0.4370752  1.0000000  0.2262822
# Frost      -0.5388834 -0.3321525 -0.6719470  0.2262822  1.0000000

# -> Murder와 Illiteracy는 연관이 있다고 할 수 있지만, 인과관계에 대해서는 말할 수 없음


# ******************************************
# 다중선형회귀분석수행
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data = df_states)
fit <- lm(Murder ~ ., data = df_states)  # . : Murder제외한 변수
# 명시적으로 적는 것이 좋음. 튜닝작업하기 더 좋으니까

fit  # 회귀계수 나옴(만약, 회귀계수가 0이라면 결과에 출력X)
# Call:
#   lm(formula = Murder ~ Population + Illiteracy + Income + Frost, 
#      data = df_states)
# 
# Coefficients:
# (Intercept)   Population   Illiteracy       Income        Frost  
# 1.23456341   0.00022368   4.14283659   0.00006442   0.00058131  
# -> plot에서 부상관을 그렸는데, 회귀계수는 양의 값을 가짐.
# => 상관계수

summary(fit)
# Call:
#   lm(formula = Murder ~ Population + Illiteracy + Income + Frost, 
#      data = df_states)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -4.7960 -1.6495 -0.0811  1.4815  7.6210 
# 
# Coefficients:
#               Estimate Std. Error t value  Pr(>|t|)    
# (Intercept) 1.23456341 3.86611474   0.319    0.7510    
# Population  0.00022368 0.00009052   2.471    0.0173 *  
# Illiteracy  4.14283659 0.87435319   4.738 0.0000219 ***
# Income      0.00006442 0.00068370   0.094    0.9253    
# Frost       0.00058131 0.01005366   0.058    0.9541    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.535 on 45 degrees of freedom
# Multiple R-squared:  0.567,	Adjusted R-squared:  0.5285 
# F-statistic: 14.73 on 4 and 45 DF,  p-value: 0.00000009133

# 회귀모형 유의함. (H0: β=0)
# 문맹률과 인구수의 회귀계수가 유의성이 인정됨. (H0: b1 = b2 = .. = 0)
#   - 오차항과, Income, Frost의 회귀계수는 0이다. 
#       - 이들이, Murder와 관계가 없다고 할 수 없다.
#       - 이들은, 직선(선형)적 관계가 없다! (O) / 곡선(비선형)적 관계가 있을 수 있음.
#   - 독립변수가 2개이상일 때나오는 회귀계수는,
#       현재 회귀계수외의 다른 변수는 일정하다는 가정으로 측정.
#   - 인구수가 일정할 때, 문맹률이 한 단위 증가 시 4.14283659만큼 살인율이 증가한다.
#   - 문맹률가 일정할 때, 인구수가 한 단위 증가 시 0.00022368만큼 살인율이 증가한다.
# 설명력은 56.7%



