# 응용: One-way ANCOVA
# 요인 1개, 공변량 1개
# * 공변량: 함께 변하는 정도

# 사용할 데이터 셋: litter{multcomp}
library(multcomp)

# 분산분석에서, 교란요인(잡음변수)은 공변량(covariate)인데,
# 공변량에서, 공분산을 계산하도록 되어있다.
# --> 교란요인 변수의 유형은, 양적변수이다.
# dose(factor), gesttime(covariate), weight(종속변수)
head(litter) # 임신한 쥐가, 약물 종류별 약물 복용방법에 따른, 새끼 쥐의 출산당시 체중
#   dose weight gesttime number
# 1    0  28.05     22.5     15
# 2    0  33.33     22.5     14
# 3    0  36.37     22.0     14
# 4    0  35.52     22.0     13
# 5    0  36.77     21.5     15
# 6    0  29.60     23.0      5
# dose: 약물복용방법, weight: 새끼쥐의 출산당시 체중
# gestime: 약물투여 시간 --> 공변량(공분산을 계산할 수 있는 수치형변수)
#  --> dose와 gestime이 weight을 결정

data("litter", package = "multcomp")
attach(litter)

library(prettyR)
freq(dose)
# Frequencies for dose 
#         0    5   50  500   NA -> 약물의 양
#        20   19   18   17    0
# %      27 25.7 24.3   23    0 
# %!NA   27 25.7 24.3   23 
# 균형설계는 아니지만, 분석결과에 큰 영향 미치지 않음


# 표본의 그룹별 기초통계량
aggregate(weight, by=list(dose), mean)
#   Group.1        x
# 1       0 32.30850
# 2       5 29.30842
# 3      50 29.86611
# 4     500 29.64647
# 표본의 통계와 모집단이 같을지 분산분석해야 함

fit.aov3 <- aov(formula = weight ~ gesttime + dose, data=litter)
# 공변량인 gesttime을 ~ 바로 뒤에 적음
# gesttime은 양적변수! dose는 질적변수!
fit.aov3
# Call:
#   aov(formula = weight ~ gesttime + dose, data = litter)
# 
# Terms:
#                  gesttime      dose Residuals
# Sum of Squares   134.3039  137.1229 1151.2718
# Deg. of Freedom         1         3        69
# 
# Residual standard error: 4.08474
# Estimated effects may be unbalanced

names(fit.aov3)
# [1] "coefficients"  "residuals"(잔차) "effects"       "rank"          "fitted.values"
# [6] "assign"        "qr"            "df.residual"   "contrasts"     "xlevels"      
# [11] "call"          "terms"         "model" 


# anova(fit.aov3)
summary(fit.aov3)
#             Df Sum Sq Mean Sq F value  Pr(>F)   
# gesttime     1  134.3  134.30   8.049 0.00597 **
# dose         3  137.1   45.71   2.739 0.04988 * 
# Residuals   69 1151.3   16.69                   
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# dose가 만들어낸 집단에 관해 대립가설 채택!
#   -> 여러 집단 간 평균에 차이가 있다.
# 공변량도 해당 집단 간 차이를 만드는데에 유의한 효과를 내고 있다.

# => Type1에 따른 [formula=weight ~ gesttime + dose]해석
# gesttime의 효과가 그대로 반영되고, factor dose의 영향을 평가 시, 
# gesttime이 일정하다나느 통제 하에 dose가 영향을 미친다

# 공변량(교란요인)이 추가되어 있을 때에는,
# 소위 "수정된 집단평균(공변량을 제외한 순수한)"을 구해야 함(*주의*)
# 교란효과를 제외하고, 순수하게 dose가 미친 영향만을 보려면,
library(effects)

# effect{effects} 함수를 통해 순수한 집단평균을 구함
# 즉, 공변량의 효고를 제거한 순수한 집단의 평균
effect("dose", fit.aov3)  # dose의 효과만을 측정하여 집단별 평균값을 구하자

#   dose effect
# dose
#        0        5       50      500 
# 32.35367 28.87672 30.56614 29.33460 
# 수정된 표본통계량을 확인 시, 0을 제외하고 평균이 거의 비슷하다고 판단할 수 있음.
# anova결과 차이가 있다고 판단한 부분은 0일 가능성이 큼.


# 사후분석: 평균의 다중비교 (분석가가 원하는대로 평균의 다중비교)
# 공변량을 제외한 순수한 집단평균을 확인 시,
# 약물을 투여하지 않은 집단만이 차이가 있었으므로 이를 확인하고자 함.
library(multcomp)

# rbind로 matrix(행렬) 생성
contrasts <- rbind("비투약그룹 대 투약그룹" = c(3, -1, -1, -1)) 
# 0(비투약)이 차이가 났음 -> 0에만 다른 값을 줌.
contrasts
#                         [,1] [,2] [,3] [,4]
# 비투약그룹 대 투약그룹    3   -1   -1   -1

class(contrasts)
df_contrasts <- as.data.frame(contrasts)
df_contrasts
#                         V1 V2 V3 V4
# 비투약그룹 대 투약그룹  3 -1 -1 -1

?glht # {multcomp}
# 분석가가 원하는 가설대로(즉, 현재같은 경우에는,
# 비약물투여집단과 약물투여 집단 간의 평균의 차이를 검정)
# 평균의 다중비교를 수행할 수 있음.
# 이때, 조건은, 분석가가 검정하고자하는 대조군을 벡터로 만들어서 지정
# 즉, constrasts = c(3, -1, -1, -1)
fit.glht3 <- glht(fit.aov3, linfct= mcp(dose = contrasts)) # 비투약그룹만 다른 값을 줌.
fit.glht3
# 
#       General Linear Hypotheses
# 
# Multiple Comparisons of Means: User-defined Contrasts
# 
# 
# Linear Hypotheses:
#                               Estimate
# 비투약그룹 대 투약그룹 == 0    8.284

summary(fit.glht3)
# 
# Simultaneous Tests for General Linear Hypotheses
# 
# Multiple Comparisons of Means: User-defined Contrasts
# 
# 
# Fit: aov(formula = weight ~ gesttime + dose, data = litter)
# 
# Linear Hypotheses:
#                               Estimate Std. Error t value Pr(>|t|)  
# 비투약그룹 대 투약그룹 == 0    8.284      3.209   2.581    0.012 *
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# (Adjusted p values reported -- single-step method)
# 대립가설 -> 통계적으로 유의한 차이가 있다고 볼 수 있지만, 
#         사람의 목숨과 관련된 것이므로, 0.001 등 더 높은 유의수준이 필요
#       -> 0.05에서 유의하지만, 그보다 작은 것에서는 유의하지 않음
# 약물투여 쥐는 0.05에서 효과가 있음


# 위의 분석결과를 과연 신뢰할 수 있는가?
# 담보물: 분산분석의 가정(Assumptions) 충족여부
# (1) 정규성, (2) 등분산성을 충족해야 함.
#
# 문제는, 공변량이 포함된 ANCOVA의 경우에는, 가정이 하나 더 추가됨
# 즉, (3) 회귀방정식의 기울기(slope)가 각 집단별로 동일해야 함.

library(multcomp)

# 공변량이 효과를 미침을 위해서 확인했으므로, formula를 수정해야 함.

# 회귀방정식의 기울기의 동등성 검정하기 위해서는,
# 요인이 만들어내는 각 집단에 대해, 상호작용효과(gesttime : dose)를
# ANCOVA 모델에 추가해야 함!!(-> gesttime * dose) (*주의*)

# 이것이 의미하는 바는 결국, 상호작용이 통계적으로 유의미하다면,
# 투여시간(gesttime)과 출산시체중(weight)과의 관계가, 
# 약물투여량(dose)에 따라, 다르게 나타남을 의미함!!(*주의*)

#완전교차 -> formula = weight ~ gesttime + dose + gesttime:dose
fit2.aov3 <- aov(formula = weight ~ gesttime * dose, data=litter) 

summary(fit2.aov3)
#               Df Sum Sq Mean Sq F value  Pr(>F)   
# gesttime       1  134.3  134.30   8.289 0.00537 **
# dose           3  137.1   45.71   2.821 0.04556 * 
# gesttime:dose  3   81.9   27.29   1.684 0.17889    
# Residuals     66 1069.4   16.20                   
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#   - 상호작용은 유의X(회귀선 기울기가 같음)


# sudo apt-get install libmpfr-dev 후
# install.packages("HH")
library(HH)
ancova(weight ~ gesttime + dose, data = litter)
# 회귀선을 만들 때의 회귀방정식.
# gesstime이 dose에 영향을 준다는 뜻은 아님




detach(litter)


