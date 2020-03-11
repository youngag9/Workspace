# 반복측정 ANOVA (Repeated Measure ANOVA)
#   -> 집단 "내" 요인
#     - 집단 내 요인으로 formula 구성 시, 개별 객체를 고유하게 식별할 수 있는 변수 필수!
# 실험설계 조건: 
# (1) 1개의 집단 간 요인 (Between-groups factor)
# (2) 1개의 집단 내 요인 (Within-groups factor)
#
# 분석할 데이터셋: CO2{dataset}(이산화탄소가 식물에 영향을 주는지 데이터)
#   (1) Plant : 서열변수 / 범주형  (개별 Plant의 고유식별자)
#           - 집단 내 요인으로 formula 구성 시, 개별 객체를 고유하게 식별할 수 있는 변수 필수!
#   (2) Type : 범주형 (Plant의 서식지 - 퀘벡/미시시피)
#   (3) Treatment : 범주형 (냉해/비냉해 처리)
#   (4) conc : CO2 농도
#   (5) uptake : CO2 섭취량

data("CO2", package = "datasets")
head(CO2)
View(CO2)
str(CO2)
# 5 variables:
#   $ Plant    : Ord.factor w/ 12 levels "Qn1"<"Qn2"<"Qn3"<..: 1 1 1 1 1 1 1 2 2 2 ...
# $ Type     : Factor w/ 2 levels "Quebec","Mississippi": 1 1 1 1 1 1 1 1 1 1 ...
# $ Treatment: Factor w/ 2 levels "nonchilled","chilled": 1 1 1 1 1 1 1 1 1 1 ...
# $ conc     : num  95 175 250 350 500 675 1000 95 175 250 ...
# $ uptake   : num  16 30.4 34.8 37.2 35.3 39.2 39.7 13.6 27.3 37.1 ...

# Treatment 빈도확인
table(CO2$Treatment)
# nonchilled    chilled 
#         42         42 

# conc 확인
table(CO2$conc)
# 95  175  250  350  500  675 1000 
# 12   12   12   12   12   12   12  -> 요인화시켜야 함

# 요인역할을 할 변수는, factor타입으로 변환! (분산분석 시)
CO2$conc <- factor(CO2$conc)

# ANOVA 대상 요인선정
#  (1) conc  (2) Type
# 분석변수(종속)변수는, uptake (CO2 섭취량)

# 냉해처리된 식물만 분석대상으로 뽑자
wlbl <- subset(CO2, Treatment=='chilled') # {base}
View(wlbl)

# 1개의 집단 내 요인을 공식으로 지정하는 방식

fit.aov5 <- aov(formula = uptake ~ conc * Type + Error(Plant/(conc)))

# 집단 간 요인의 개체수가 일정(Balanced Design)
fit.aov5 <- aov(formula = uptake ~ Type * conc + Error(Plant/conc),
                data = wlbl)
# 집단 내 요인: W, 집단 간 요인 : A, 식별자 : Subject(각 관측치를 유일하게 구분해주는 것)
# formula = y ~ A * W + Error(Subject/W)

# 집단 내 요인으로 적합된 모델 출력 시, "Stratum(층)"이 나타난다!
fit.aov5
# Call:
#   aov(formula = uptake ~ Type * conc + Error(Plant/conc), data = wlbl)
# 
# Grand Mean: 23.78333
# 
# Stratum 1: Plant
# 
# Terms:
#                      Type Residuals
# Sum of Squares  2667.2402  176.5981
# Deg. of Freedom         1         4
# 
# Residual standard error: 6.644511
# 6 out of 7 effects not estimable
# Estimated effects are balanced
# 
# Stratum 2: Plant:conc
# 
# Terms:
#                      conc Type:conc Residuals
# Sum of Squares  1472.3900  428.8281  112.1419
# Deg. of Freedom         6         6        24
# 
# Residual standard error: 2.161615
# Estimated effects may be unbalanced

anova(fit.aov5)
summary(fit.aov5)
# 층(Stratum)의 개수대로 2개가 나옴.

# Error: Plant
#           Df Sum Sq Mean Sq F value  Pr(>F)   
# Type       1 2667.2  2667.2   60.41 0.00148 **
# Residuals  4  176.6    44.1                   
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# -> 평균의 차이가 있다
# 
# Error: Plant:conc
#           Df Sum Sq Mean Sq F value           Pr(>F)    
# conc       6 1472.4  245.40   52.52 0.00000000000126 ***
# Type:conc  6  428.8   71.47   15.30 0.00000037483686 ***
# Residuals 24  112.1    4.67                             
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#   ->  평균의 차이가 있고, 상호작용효과에서도 평균의 차이가 있다.


# 어디서 평균의 차이가 발생하는지 aov는 알려주지 않음

# 분산분석 결과 시각화 -1
# 사후분석으로, 평균의 다중비교법을 하지 않더라도, 
# 아래의 시각화 결과로, 어느 집단 간 종속변수의 평균의 차이가 얼마나 나는지 직관적으로 알 수 있다.

attach(wlbl)

# stats::interaction.plot
interaction.plot(
  conc, Type, uptake, type='b',
  col = c('red', 'blue'), 
  pch = c(1,5)  # 점의 모양을 바꿈.
) 


# 분산분석 결과 시각화 -2
# 사후분석으로, 평균의 다중비교법을 하지 않더라도, 
# 아래의 시각화 결과로, 어느 집단 간 종속변수의 평균의 차이가 얼마나 나는지 직관적으로 알 수 있다.
# 이원분산분석이니까 상호작용되는 것이 많으니까 이를 모두 보여주자 
#   x축이 Quebec.95와 같이 되어 있어 상호작용결과임을 알 수 있다.
boxplot(uptake ~ Type * conc, data=wlbl, # 누가 집단 내 요인인지 알려주지 않음
        col = c('red', 'green'),
        main = '- Main -'
)  # y축 평균이 아님. 
# CO2 섭취량 퀘벡이 높음, 대기 중 이산화탄소 농도가 높을 때 CO2 섭취량 높음



detach(wlbl)




