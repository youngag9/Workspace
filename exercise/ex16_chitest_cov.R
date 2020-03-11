library(ggplot2)

data(mpg)  # type: promise
mpg <- as.data.frame(mpg) # tibble -> dataframe
str(mpg)

library(MASS)
data(survey) # 조사자료 dataset
str(survey)
# 성별 컬럼 type: Factor --> R에서는, 범주형변수를 factor타입으로.
# factor level은, 2라고 나옴.


library(prettyR)
xtab(formula=~fl+drv, data=mpg) # 범주와 비율정보 함께 제공
# 이미 카이제곱 검정을 수행해서, pvalue값이 나오긴 함.
## Crosstabulation of fl by drv  : fl이 행변수, drv가 열변수
# 구동방식별, 연료.
## X2[8]=6.562, p=0.584558

(crosstab <- xtabs(formula= ~fl+drv, data=mpg)) # 빈도만 보여줌

(crosstab2 <- table(survey$W.Hnd)) # 일원분할표

# 카이제곱 검정하기
# 아래 특정한 경우에만, 피셔의 정확한 검정을 수행한다.
#   - 표본수가 작거나
#   - 표본의 교차표의 셀에 빈도가 한쪽에 치우치게 분포된 경우

chisq.test(crosstab, correct = TRUE)  # 독립성 검정
# 
# Pearson's Chi-squared test
# 
# data:  crosstab
# X-squared = 6.5618, df = 8, p-value = 0.5846
# 
# 경고메시지(들): 
# In chisq.test(crosstab, correct = TRUE) :
#   카이제곱 approximation은 정확하지 않을수도 있습니다

# 귀무가설 채택 -> 관계가 없다
# 경고메시지 출력 --> 피셔의 정확한 검정 필요 
# 여기서는 너무 크게 나와서, 사실 하나마나임.

# 피셔의 정확한 검정을 할 때
# alternative 인자로, 양측/단측 검정을 지정할 수 있다.
# 양측: 차이가 있다/없다
fisher.test(crosstab)
# 
# Fisher's Exact Test for Count Data
# 
# data:  crosstab
# p-value = 0.5121
# alternative hypothesis: two.sided
# 피셔의 정확한 검정에도, 귀무가설채택 (관계가 없다)

# alternative : 'greater', 'less', 'two-sided'(default)
fisher.test(crosstab, alternative = 'two.sided') 

# 우측 단측검정
fisher.test(crosstab, alternative= 'greater')
# 
# Fisher's Exact Test for Count Data
# 
# data:  crosstab
# p-value = 0.5121
# alternative hypothesis: greater
# 귀무가설 채택. 

# 좌측 단측검정
fisher.test(crosstab, alternative = 'less')
# p-value = 0.5121

chisq.test(crosstab2, p=c(.3, .7))  # 일원분할표의 비율"적합도"검정
# p 인자에 이미 정해진 비율인, 분리비율을 지정해준다.
# 정해진 도수대로, 관찰도수 비율이 나왔는지 검정
# 
# Chi-squared test for given probabilities
# 
# data:  crosstab2
# X-squared = 56.252, df = 1, p-value = 0.00000000000006376

# crosstab2
##  Left Right 
##    18   218 --> 3:7에 일치하지 않음

# pvalue가 작게 나왔으니까, 귀무가설 기각
# 대립가설: 관찰도수 비율이 기대 분리비에 적합하지 않다.



# **독립성 검정**
# 범주형 변수의 경우, 교차분석(카이제곱)이용하지만
# 연속형 변수의 경우, "공분산" 검정을 수행한다

# 공분산 검정 for 연속형변수
# 한 변수가 한 단위 커질 때마다, 다른 변수가 함께 커지거나 감소
# 크기 변화의 방향이 같다면, 공분산은 양의 값을 가짐. : "정상관"
# 크기 변화의 방향이 반대라면, 공분산은 음의 값을 가짐. : "부상관"
# 두 변수 간 관계가 없다면, 공분산의 값은 0이다. : 같이 움직이지 않음. 독립.
# 공분산 절대값이 커지면, 함께 변하는 정도가 커진다는 의미!
# 두 확률 변수의 개수가 다를 때에는, 공분산 계산 시 오류가 남

# --> pvalue가 나오는 것이 아닌, 수치값이 나옴

library(ggplot2)
data(mpg)

# with: 데이터프레임 변수 접근 시 $ 붙이지 않고 사용가능.
with(data= mpg, expr={  # expr: 실행할 여러 문장을 넣어줌.
  cov(x= cty, y=hwy)  # cov: 공분산 함수 안에, 두 연속형 변수 넣음
})
# [1] 24.22543  --> 공분산의 값이 양의 값을 가지므로, 두 변수가 독립이 아님
# 같은 방향으로, 함께 변함 : """정상관"""


# 임의의 확률변수 벡터x,y의 공분산 구하기
cov(x= 1:5, y=5:1) 
## [1] -2.5 --> 부상관 : 서로 반대방향

cov(x=1:5, y=10:1) 
## Error in cov(x = 1:5, y = 10:1) : 호환되지 않는 차원들입니다

cov(x=1:5, y=c(1,2,3,4,5))
## [1] 2.5

cov(x = 1:5, y = c(1, 3, 1, 2 ,0))
## [1] -0.75 --> 수치값이 0에 가까우므로, 함께 움직인다고 말할 수 있는 정도는 아님
# 이렇게 수치가 0에 가까우면, 독립적이라고 말한다.(???)
# --> 산점도를 그려서 눈으로 확인한다
plot(x=1:5, y=c(1,3,1,2,0))

cov(x = 1:5, y = c(4, 4, 4, 4 ,4))
## [1] 0 --> 완전히 두 연속형 변수는 독립적이다




