# Unpaired Two-samples = independent


# 모수적---------------------------------------------
# Unpaired t-test

# 두 개의 독립적인 그룹의 평균을 비교
# 100명을 남50 여50의 평균을 구함.

# 주의사항) 두 개의 그룹이 관련성이 없어야 한다!! 독립적이어야 한다!!

# 가정) 두 그룹이 정규분포를 따를 때 (shapiro-wilk 검정함)
# 가정) 등분산을 따라야 함 (F검정 사용하는 var.test()사용)

# 가설) H0: 두 그룹의 평균이 같다
# 귀무가설_
#   H0 : mA = mB
#   H0 : mA ≤ mB
#   H0 : mA ≥ mB
# 대립가설
#   H1 : mA ≠ mB (different)
#   H1 : mA > mB (greater)
#   H1 : mA < mB (less)


#### Welch t-statistic :
# 두 그룹의 분산이 다르다면!!(등분산이 아니라면, var.equal=F)
# Welch의 t-test를 사용한다.
# t-분포 따르는 검정을, t-test라 하는데, 
# t분포를 발견한 사람의 이름따서 ['Student'] t-test라 한다.


# 검정통계량의 해석) 유의수준은 0.05로 정해져 있음
t.test(x, y, alternative = "two.sided", var.equal = FALSE)
# 두 그룹/벡터 or Formula 지정
# alternative는 양측검정이 기본!
# var.equal(등분산여부) = T면, 그냥 t-test
#                         F(default)면 Welch T-test

women_weight <- c(38.9, 61.2, 73.3, 21.8, 63.4, 64.6, 48.4, 48.8, 48.5)
men_weight <- c(67.8, 60, 63.4, 76, 89.4, 73.3, 67.3, 61.3, 62.4)

(my_data <- data.frame(
              group = rep(c("Woman", "Man"), each = 9),
                # rep의 each에 따라 개별값 정해진 횟수 반복
                # woman먼저 9번/ 그다음 man 9번
              weight = c(women_weight, men_weight) 
                # 벡터 안에 벡터가 들어가므로, 다 풀어헤침
))



# 질문: 여자 몸무게 평균과, 남자 몸무게 평균이 다른가? -> 양측검정
# Unpaired Two sample T-test

# 검정 들어가기 전, 기술통계량 구하기!
library(dplyr, quietly = TRUE)

group_by(my_data, group) %>% 
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm= TRUE)
  )
# group count  mean    sd
# <fct> <int> <dbl> <dbl>
# 1 Man     9  69.0  9.38
# 2 Woman   9  52.1 15.6  --> 17kg차이

# 시각화
library(ggpubr)

# boxplot만 보더라도, 검증이 필요한지를 확인할 수 있다
# 중위선의 차이가 크면, 두 집단의 평균이 확연히 차이나므로 사실 상 검정하지 않아도 됨.
ggboxplot(my_data, x="group", y="weight", #x에 범주형, y에 연속형 -> 범주별로 박스플롯 그려짐
          color = "group", palette = c("#00AFBB", "#E7B800"),  # color로 지정한 것 범례나옴
          ylab = 'Weight', xlab = 'Groups')
# 여성은 중위수가 1분위수에 붙었음.
# 중위수만 비교해봐도, 차이가 크므로 사실 검정할 필요없음.
# 여성의 몸무게는 아래쪽에 이상치가 하나있음.


# 가정 충족 확인
# 1. 두 집단이 독립적인가? -> 카이제곱검정(범주형) / 공분산(연속형)
# 남녀로 나뉘었기 때문에, 독립적이라고 할 수 있음.

# 2. 두 집단이 정규검정을 따르는가? -> shapiro.wilk검정
with(my_data, shapiro.test(weight[group == 'Man'])) # 벡터연산 수행
# Man 그룹의 weight 정규성 검정
# 
# Shapiro-Wilk normality test
# 
# data:  weight[group == "Man"]
# W = 0.86425, p-value = 0.1066
# pvalue > 0.05 -> 귀무가설 채택. -> 정규성을 따른다

with(my_data, shapiro.test(weight[group == 'Woman']))
# 
# Shapiro-Wilk normality test
# 
# data:  weight[group == "Woman"]
# W = 0.94266, p-value = 0.6101 
# pvalue > 0.05 -> 귀무가설채택 -> 정규성 갖는다.


# 3. 모집단이 등분산을 따르는지? (남녀 그룹의 분산이 같은지)
(res.ftest <- var.test(weight ~ group, data = my_data))
# 
# F test to compare two variances
# 
# data:  weight by group
# F = 0.36134, num df = 8, denom df = 8, p-value = 0.1714
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#   0.08150656 1.60191315
# sample estimates:
#   ratio of variances 
# 0.3613398 
# pvalue > 0.05 -> 귀무가설 채택 : 등분산을 따른다. 분산이 같다!!


(res <- t.test(women_weight, men_weight, var.equal = TRUE)) # welch가 아님
(res <- t.test(weight~group, data=my_data, var.equal = TRUE)) # 결과 같음
# Two Sample t-test
# 
# data:  women_weight and men_weight
# t = -2.7842, df = 16, p-value = 0.01327
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -29.748019  -4.029759
# sample estimates:
#   mean of x mean of y 
# 52.10000  68.98889 
# pvalue < 0.05이므로 대립가설채택 -> 두 그룹의 평균은 같지 않다.



# 비모수적---------------------------------------------
# 정규분포를 따르지 않거나,
# Two sample T-test의 세 가정을 따르지 않으면
#   --> Wilcox Two-sample Test
#    = Mann-Whitney test

# 두 그룹의 **중위수**비교 (중위수는 이상치의 영향을 덜 받음)
library(dplyr)

group_by(my_data, group) %>%
  summarise(
    count = n(),
    median = median(weight, na.rm = TRUE),
    IQR = IQR(weight, na.rm = TRUE)
  )
# group count median   IQR
# <fct> <int>  <dbl> <dbl>
# 1 Man   9   67.3  10.9
# 2 Woman 9   48.8  15  

(res <- wilcox.test(women_weight, men_weight))
# 
# Wilcoxon rank sum test with continuity correction
# 
# data:  women_weight and men_weight
# W = 15, p-value = 0.02712
# alternative hypothesis: true location shift is not equal to 0
# 
# 경고메시지(들): 
#   In wilcox.test.default(women_weight, men_weight) :
#   tie가 있어 정확한 p값을 계산할 수 없습니다

# 대립가설 채택 : 두 그룹 평균 몸무게 다르다
# -> 경고메시지 없애려면, exact=FALSE로 줌
(res <- wilcox.test(weight~group, data=my_data, exact=FALSE))
# --> 경고메시지 출력되지 않음.
# 
# Wilcoxon rank sum test with continuity correction
# 
# data:  weight by group
# W = 66, p-value = 0.02712 
# alternative hypothesis: true location shift is not equal to 0
(res <- wilcox.test(weight~group, data=my_data, exact=TRUE))
# exact?? 검정통계량으로부터 나오는 pvalue 정확하게 출력시켜줌.
# # W = 66, p-value = 0.02712 

# 단측검정 수행시
# alternative = "less" or "greater"

