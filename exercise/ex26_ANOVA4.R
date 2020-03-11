# 이원요인분산분석(Two-way Factoria ANOVA)
# factorial: 완전교차(*)
# 이원: 요인이 2개


# 비타민투여방식에 따른 기니피그의 치아 성장
# dose: 집단 간 요인
# supp: 집단 간/내 요인 - 어떻게 투여할지 설계자 결정에 따라
#       비타민C를 오렌지주스(OJ)로 주는지 혹은 
#       다른 걸(VC)로 주느냐

head(ToothGrowth)
#     len(치아길이) supp(투여방식) dose(투여량)
# 1   4.2           VC              0.5
# 2  11.5           VC              0.5
# 3   7.3           VC              0.5

#---------------------------------
# 집단별, 평균구하기(평균치아길이)
attach(ToothGrowth)
aggregate(len, by=list(supp, dose), mean)
# 투여방법에 따라 그룹을 나눈 후, 투여량에 따라 
# 소그룹으로 나눔
#   Group.1 Group.2     x
# 1      OJ     0.5 13.23
# 2      VC     0.5  7.98
# 3      OJ     1.0 22.70
# 4      VC     1.0 16.77
# 5      OJ     2.0 26.06
# 6      VC     2.0 26.14
# --> 공급방법에 따라 그룹 나눈 후, 투여량에 따라 그룹나뉨
# 각 6개 그룹의 표본의 차어길이 평균이 위와 같음

# 균형설계되어 있는가
library(prettyR)
freq(supp)
# Frequencies for supp 
#        OJ   VC   NA
#        30   30    0
# %      50   50    0 
# %!NA   50   50 
freq(dose)
# Frequencies for dose 
#       0.5    1    2   NA
#        20   20   20    0
# %    33.3 33.3 33.3    0 
# %!NA 33.3 33.3 33.3 


# 두 기준으로 빈도 확인하려면
# "교차분할표" 만듦
table(supp, dose) # 앞이 행변수, 뒤가 열변수
#     dose
# supp 0.5  1  2
# OJ    10 10 10
# VC    10 10 10 --> 균형설계

library(prettyR)
xtab(formula = ~ supp + dose, data = ToothGrowth)  
# Crosstabulation of supp by dose 
#         dose
# supp   	 0.5      1        2       
# OJ        10      10      10      30
#         33.33   33.33   33.33       -
#           50      50      50      50
# 
# VC        10      10      10      30
#        33.33   33.33   33.33       -
#          50      50      50      50
# 
#           20      20      20      60
#       33.33   33.33   33.33  100.00
xtabs(formula = ~ supp + dose, data = ToothGrowth) # like table() func
#     dose
# supp 0.5  1  2
# OJ    10 10 10
# VC    10 10 10

str(ToothGrowth)
ToothGrowth$dose <- as.factor(dose)
str(ToothGrowth)

# ANOVA 수행
fit.aov4 <- aov(formula= len ~ supp * dose)
# 위와 동일
fit.aov4 <- aov(formula= len ~ supp + dose + supp:dose)
fit.aov4
# Call:
#   aov(formula = len ~ supp * dose)
# 
# Terms:
#                      supp      dose supp:dose Residuals
# Sum of Squares   205.3500 2224.3043   88.9201  933.6349
# Deg. of Freedom         1         1         1        56
# 
# Residual standard error: 4.083142
# Estimated effects may be unbalanced


anova(fit.aov4)
# Analysis of Variance Table
# 
# Response: len
#           Df  Sum Sq Mean Sq  F value                Pr(>F)    
# supp       1  205.35  205.35  12.3170             0.0008936 ***
# dose       1 2224.30 2224.30 133.4151 < 0.00000000000000022 ***
# supp:dose  1   88.92   88.92   5.3335             0.0246314 *  
# Residuals 56  933.63   16.67                                   
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 상호작용도 0.05의 유의수준에서 유의함.
#  집단 간 차이가 존재한다. 

# 가정검정 : 정규성 , 등분산성


#---------------------------------------------------
# 분석결과 시각화-1 (supp와 dose 두 factor의 상호작용효과만)
#---------------------------------------------------
# 두 요인 간 상호작용 유의함.
?interaction.plot  # {stats} 두 요인 간 상호작용 효과 시각화
interaction.plot(dose, supp, len, type='b',  # 요인나열하고, 종속변수적음.
                                            # 뒤의 요인이 범례만듦
                 col=c('red', 'blue'), pch = c(16,18)) # pch: 점의 크기
# -> 각 그룹의 평균이 점으로 표시됨. 
# insight) 
#     VC 투여량을 증가할 때, 선형적으로 치아길이가 증가
#     OJ를 투여시, VC 투여보다 치아길이 증가효과가 높음.
#     OJ의 투여량을 지속적으로 증가해도 효과는 줄어들 수 있음.

#---------------------------------------------------
# 분석결과 시각화-2 (supp와 dose 두 factor의 상호작용효과만)
#---------------------------------------------------
library(gplots)

# interaction {base}
class(interaction(supp, dose, sep='-'))  # factor
# [1] VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-0.5 VC-1   VC-1  
# [13] VC-1   VC-1   VC-1   VC-1   VC-1   VC-1   VC-1   VC-1   VC-2   VC-2   VC-2   VC-2  
# [25] VC-2   VC-2   VC-2   VC-2   VC-2   VC-2   OJ-0.5 OJ-0.5 OJ-0.5 OJ-0.5 OJ-0.5 OJ-0.5
# [37] OJ-0.5 OJ-0.5 OJ-0.5 OJ-0.5 OJ-1   OJ-1   OJ-1   OJ-1   OJ-1   OJ-1   OJ-1   OJ-1  
# [49] OJ-1   OJ-1   OJ-2   OJ-2   OJ-2   OJ-2   OJ-2   OJ-2   OJ-2   OJ-2   OJ-2   OJ-2  
# Levels: OJ-0.5 VC-0.5 OJ-1 VC-1 OJ-2 VC-2  <== interaction의 결과도 하나의 팩터임.
# -> 두 팩터의 상호작용효과 보여줌 -> 두 팩터의 집합을 보여줌.

dev.off()
plotmeans(
  formula= len ~ interaction(supp, dose, sep='-'), 
    # interaction함수가 독립변수의 역할을 함. 6개의 레벨을 갖는 하나의 팩터를 생성하므로.
    # 반복적인 집단은 없음
  connect = list(c(1,3,5), c(2,4,6)),  # 어떤 점을 이어주는지 지정하는 매개변수
  col = c('red', 'blue'),
  main = '- Main Title -',
  xlab = 'Supp & Dose Combination'
)
# y축은 평균치아길이
# 신뢰구간을 표시해줌

#---------------------------------------------------
# 분석결과 시각화-3 (주효과 + 상호작용효과 모두 시각화)
#---------------------------------------------------
# interaction2wt {HH} 함수이용
library(HH)

interaction2wt(len ~ supp * dose)  # interaction2wt(len ~ supp + dose + supp:dose)
# 같은 요인끼리 상호작용하는 경우도 고려한 것.
# main effects: (dose | dose) , (supp | supp)
#         - 각각 dose의 개수와, supp의 개수 만큼의 boxplot 나옴.
#         - boxplot은 중위수를 보여줌
# interaction effects: (supp | dose), (dose | supp)

# supp|supp: x축이 OJ, VC : supp의 방식에 상관없이 (OJ, VC) 모두 복용량이 증가할수록, 치아의 길이가 증가함
# dose|dose: x축이 dose : 복용량이 증가했을 때 치아길이가 증가한다
# dose|supp: x축이 dose :  선형적 관계
# supp|dose: x축이 OJ, VC : OJ보다 VC투여 시 치아길이가 작다. 선형적관계는 아닌듯


detach(ToothGrowth)

