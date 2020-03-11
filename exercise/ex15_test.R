# 검정

install.packages("UsingR", dependencies=T)
library(UsingR)

?cfb  # 개인의 수입 관련 데이터셋
head(cfb)
str(cfb)
# 변수 income이 정규성을 따르는지 검정 "정규성검정"

# * 검정기법을 쓸 때, 가설의 내용을 알고 사용해야 한다.

# 연속형 변수의 정규성 검정기법
# --> Shapiro Wilk Normality Test
# H0: 모집단은 정규분포를 따른다
# H1: 모집단은 정규분포를 따르지 않는다.

# --> shapiro.wilk()

?shapiro.test() # {stats}

shapiro.test(cfb$INCOME)
# 	Shapiro-Wilk normality test
# 
# data:  cfb$INCOME
# W = 0.36883, p-value < 2.2e-16
# --------------
# W분포를 따름, W검정통계량 : 0.36883
# p-value < 0.05 --> 귀무가설 기각! 대립가설 채택!
# 우연히, 대립가설대로 발생할 확률이 무지 작음.
# 우연이 작으니까 --> 필연 --> 대립이 맞음! --> 귀무가설기각
# --> income은 정규성 갖지 않는다.

# 확률분포 그리기
hist(cfb$INCOME, breaks = 200, freq = F)  # 확률을 보여주고 있음.

density(cfb$INCOME)# income에 각각 확률을 구해주는 함수
# Call:
#   density.default(x = cfb$INCOME)
# 
# Data: cfb$INCOME (1000 obs.);	Bandwidth 'bw' = 8324
# 
# x                 y            
# Min.   : -24972   Min.   :0.000e+00  
# 1st Qu.: 372980   1st Qu.:0.000e+00  
# Median : 770933   Median :2.361e-09  
# Mean   : 770933   Mean   :6.273e-07  
# 3rd Qu.:1168886   3rd Qu.:6.919e-08  
# Max.   :1566838   Max.   :1.418e-05  --> density는 요약통계량구해줌

lines(density(cfb$INCOME), col='red', lw=2)  # 오른쪽 꼬리분포
# --> not 정규분포
# 시각화한 것이, 검정결과와 일치함
# 다른 시각화기법으로, 
# Q-Q plot : To visualize normality of a single variable
?qqnorm # {stats}
?qqline # {stats}

qqnorm(cfb$INCOME) 
# y측에 sample quantiles : 4분위수로 샘플링해서 찍음
# x축 : "이론 상 정규성을 가진다면"
qqline(cfb$INCOME)
# qqnorm에 이상적인 정규선을 그려줌
# --> 이 선을 그대로 따라가는 점이라면, 이상적인 정규성을 가진다고 할 수 있다.
# 정규성을 따르지 않는다는. 대립가설이 맞다.



# --> 연속형변수가 정규성을 따르도록, 정규성변환 방법 중 대표적인 것이, 
# (1) 로그변환 --> log()
# (2) 제곱근변환 --> sqrt()
# (3) 1/x 변환
# (4) ln 변환
# (5) x^3 변환
# (6) x^2 변환

# (1) 로그변환
# 수학적으로는, 로그로 변환할 대상이, 0이 있으면 안 됨.
# 0이 있는지 간단히 확인 : summary
summary(cfb$INCOME)  # Min값에 0이 보임
# --> 0이 있으니까 로그변환 시, 1씩 키워줌. 
# --> 미미한 변화이기 때문에, 로그 변환에 큰 영향 주지 않는다.
cfb <- transform(cfb, INCOME_log = log(INCOME+1))
# {base} : 변수 변환
# income에 로그를 씌운 파생변수가 생성된다.
View(cfb$INCOME_log)


# 파생변수가 정규성 따르는지 정규성 검정 재수행
shapiro.test(cfb$INCOME_log)

# Shapiro-Wilk normality test
# 
# data:  cfb$INCOME_log
# W = 0.82171, p-value < 2.2e-16

# 확률분포 그리기
hist(cfb$INCOME_log, breaks = 200, freq = F)
lines(density(cfb$INCOME_log), col='red', lw=2)
# 정규성을 따르지 않음

# (2) sqrt
cfb <- transform(cfb, INCOME_sqrt = sqrt(INCOME))
shapiro.test(cfb$INCOME_sqrt)

# 	Shapiro-Wilk normality test
# 
# data:  cfb$INCOME_log
# W = 0.77551, p-value < 2.2e-16 --> 대립채택

# 확률분포 그리기
hist(cfb$INCOME_sqrt, breaks = 200, freq = F)
lines(density(cfb$INCOME_sqrt), col='red', lw=2)
# 정점을 중심으로 어느정도 좌우대칭은 됐지만,
# 여전히 꼬리분포를 따름.

# 이 외에도, 다양한 변환방법이 있음.


# (3) 1/x 변환 
cfb <- transform(cfb, INCOME_x = 1/(INCOME+1))
shapiro.test(cfb$INCOME_x)

# 	Shapiro-Wilk normality test
# 
# data:  cfb$INCOME_log
# W = 0.036002, p-value < 2.2e-16 --> 대립채택

# 확률분포 그리기
hist(cfb$INCOME_x, breaks = 200, freq = F)  
# 두 개의 정점: 베르누이 시행에 의한 이항분포
lines(density(cfb$INCOME_x), col='red', lw=2)


# (4) ln 변환 --> ln함수 아니야..
??ln
cfb <- transform(cfb, INCOME_ln = ln(INCOME+1))
shapiro.test(cfb$INCOME_ln)
# 확률분포 그리기
hist(cfb$INCOME_ln, breaks = 200, freq = F)  
lines(density(cfb$INCOME_ln), col='red', lw=2)


cfb <- transform(cfb, INCOME_3x = INCOME^3)
shapiro.test(cfb$INCOME_3x)  # 정규성 따르지 않음
hist(cfb$INCOME_3x, breaks = 200, freq = F)  
lines(density(cfb$INCOME_3x), col='red', lw=2)

cfb <- transform(cfb, INCOME_2x = INCOME^2)
shapiro.test(cfb$INCOME_2x)  # 정규성 따르지 않음
hist(cfb$INCOME_2x, breaks = 200, freq = F)  
lines(density(cfb$INCOME_2x), col='red', lw=2)



# 정규성 검정
test <- read.csv(file.choose())  # 파일 선택창 띄우는 함수
# test.csv 파일 가져옴

str(test)
# age, score : 소수점을 취하지 않는 정수
# gender : 범주형


# shapiro-wilk검정 
# 유의수준 0.05
# 귀무가설은, 정규분포를 따른다.
shapiro.test(test$score)  
# Shapiro-Wilk normality test
# 
# data:  test$score
# W = 0.92926, p-value = 0.3723 
# p-value는 유의수준보다 크다면, 우연히 가설대로 발생확률이 크다는 뜻이므로
# 우연히 발생할 확률이 크므로, 귀무가설 채택임.
# 

# 가설검정만의 결과를 믿지 말고
dim(test)  # 12개 --> 소표본
# 표본의 크기가 너무 작으니까 --> 이 때는, 비모수검정방법도 써봐야 한다
hist(test$score, freq = F, breaks=5)
lines(density(test$score), col='red', lw=2)
# 시각적으로보면, 정규분포는 아님. 양쪽이 잘렸으니까
# --> 양쪽 잘린 분포도 나중에 배울 거에요


# 범주형 변수에 대한 통계분석
#   1.  빈도분석
# > install.packages(‘Hmisc’)
# > install.packages(‘prettyR’)
# > library(Hmisc)
# > library(prettyR)
test <- read.csv(file.choose(), fileEncoding = 'UTF-8') # ch2_discrete.csv
# 유효하지 않은 다국어 문자가 나왔다는 오류가 뜬다면,
#  help page열어서, fileEncoding 매개변수 사용
str(test)
# gender, product, area모두 질적/범주형 변수

# 1. 빈도분석
freq(test) # {prettyR}  / df
# 
# Frequencies for gender 
#       남자 여자   NA
#        15   10    0
# %      60   40    0 
# %!NA   60   40 
# 
# 
# Frequencies for product 
#       과자   사탕 초코바     NA
#         9    9    7    0
# %      36   36   28    0 
# %!NA   36   36   28 
# 
# 
# Frequencies for area 
#       일본   미국   중국   한국 필리핀     NA
#         6    5    5    5    4    0
# %      24   20   20   20   16    0 
# %!NA   24   20   20   20   16 

# -->  빈도와, 백분율(상대도수), NA가 아닌 백분율

# pandas의 describe 함수와 비슷
Hmisc::describe(test)  # {Hmisc} / 최빈값없음

# test 
# 
# 3  Variables      25  Observations
# -------------------------------------------------------------------------------
#   gender 
# n  missing distinct 
# 25        0        2 
# 
# Value       남자  여자
# Frequency   15    10  
# Proportion 0.6   0.4  
# -------------------------------------------------------------------------------
#   product 
# n  missing distinct 
# 25        0        3 
# 
# Value        과자   사탕 초코바
# Frequency     9      9      7  
# Proportion 0.36   0.36   0.28  
# -------------------------------------------------------------------------------
#   area 
# n  missing distinct 
# 25        0        5 
# 
# lowest : 미국   일본   중국   필리핀 한국  , highest: 미국   일본   중국   필리핀 한국  
# 
# Value        미국   일본   중국 필리핀   한국
# Frequency     5      6      5      4      5  
# Proportion 0.20   0.24   0.20   0.16   0.20  
# -------------------------------------------------------------------------

prettyR::describe(test)  # 최빈값 함께 출력
# Description of test 
# 
# Factor 
# 
# gender    남자 여자
# Count     15   10
# Percent   60   40
# Mode 남자         --> 최빈값
# 
# product   과자 사탕 초코바
# Count      9    9      7
# Percent   36   36     28
# Mode >1 mode      --> 최빈값이 두개 이상 나올 때 출력
# 
# area      일본 미국 중국 한국 필리핀
# Count      6    5    5    5      4
# Percent   24   20   20   20     16
# Mode 일본 



# 원하는 컬럼만 출력
mpg
mpg[1,2]  # X: schalar값 : 1행2열값
mpg[c(1,2)]  # O: 1,2번째 변수(컬럼)
mpg[, c(1,2)] # O: 1,2번째 변수(컬럼)
# dplyr::select()도 사용가능

# manu model year에 대해 빈도분석해보기
freq(mpg[, c(1,2,4)])
prettyR::describe(mpg[, c(1,2,4)])
# 범주가 많아(factor level이 커서) 보기에 복잡함.
freq(mpg[, c('drv', 'fl')])
# 
# Frequencies for drv 
#         f    4    r   NA  : facotrlevel 4 / 총관측치 수: 106+103+25
#       106  103   25    0
# %    45.3   44 10.7    0 
# %!NA 45.3   44 10.7 
# 
# 
# Frequencies for fl 
#         r    p    e    d    c   NA
#       168   52    8    5    1    0
# %    71.8 22.2  3.4  2.1  0.4    0  : 일반 휘발유가 많음
# %!NA 71.8 22.2  3.4  2.1  0.4 
# --> 균형있게 자료수집됐는지 확인 가능

prettyR::describe(mpg[c(7,10)]) # 최빈값도 함께 보여줌
# Description of mpg[c(7, 10)] 
# 
# Factor 
# 
# drv           f      4     r
# Count   106.0 103.00 25.00
# Percent  45.3  44.02 10.68
# Mode f   :  전륜구동
# 
# fl             r     p    e    d    c
# Count   168.00 52.00 8.00 5.00 1.00
# Percent  71.79 22.22 3.42 2.14 0.43
# Mode r  :   일반휘발유


# 범주형변수 분석
#   2. 교차분석 : 내부적으로 카이제곱검정을 함 : 두 범주변수의 빈도정보로
#                 “두 변수가 독립적인지/관계가 있는지” 검정함.

# ch2_discrete 성별 품목 교차분석
xtab(~product+gender, data=test) # {prettyR} : +앞변수: 영향받는변수 / +뒤변수: 영향주는변수
# --> 성별 품목의 빈도(--> 교차표)가 나옴.

# Crosstabulation of product by gender 
#             gender
# product	    남자     여자    
# 과자           5       4       9  : 빈도수 / 총
#           55.56   44.44       -   : 과자 안에서 각 남녀의 상대도수 
#           33.33   40.00   36.00   : 세로로 봄
# : 남자 안에서 남자의과자 비율 / 여자 중 여자의과자 비율/ 전체 관측 치 중 과자의 비율
# 
# 사탕           5       4       9
#           55.56   44.44       -
#           33.33   40.00   36.00
# 
# 초코바         5       2       7
#           71.43   28.57       -
#           33.33   20.00   28.00
# 
#              15      10      25 : 전체 관측치 중 남녀 빈도
#              60      40     100 : 전체 관측치 중 남녀 상대도수
# 남자에서, 최빈값 품목은 없음
# X2[2]=0.529, p=0.7675511  : 카이제곱 통게량과, p-value -> 귀무가설 채택
# 경고메시지(들): 
#   In chisq.test(x$counts, ...) : Chi-squared approximation may be incorrect
# --> 카이제곱 추정이 정확하지 않을 수 있다는 경고메시지 출력.
# Fisher의 정확한 검정을 한 번 더 거쳐야 독립적인지 관계가 있는지 알 수 있음

# 두 변수 간, 독립성이 있는가? 서로 영향을 주는가?
# 카이제곱 검정의 가설
# H(0) :  두 범주형 변수 간 관계가 없다. (독립)
# H(1) :  두 범주형 변수 간 관계가 있다. 
# --> gender와 product는 관계가 없고, 독립적이다.

??chisq.test  # 카이제곱 검정 함수 따로 있음

# area별 gender의 관계가 잇는가?
xtab(~gender+area, data=test) #  --> 두 변수가 관계가 없다
# 교차분석의 핵심은, 빈도 /비율 정보를 보는 것.
xtab(gender~area, data=test) # 이것이 정석!!

# Crosstabulation of gender by area 
#           area
# gender 	 미국     일본     중국     필리핀   한국    
# 남자       2       3       4       1       5      15
#           13.33      20   26.67    6.67   33.33   -
#           40      50      80      25     100      60
# 
# 여자      3       3       1       3       0      10
#           30      30      10      30       0       -
#           60      50      20      75       0      40
# 
#           5       6       5       4       5      25
#           20      24      20      16      20     100
# X2[4]=7.292, p=0.1212546


# range 구하기
range(mpg$cty) # 9 35   {base}
range(mpg$hwy) # 12 44
# 사분위 IQR 구하기
IQR(mpg$cty)  # 5 {stats}
IQR(mpg$hwy)  # 9



# 분포도
# -비대칭도 
# Sk = 0 : 정규분포
# Sk < 0 : 오른쪽꼬리분포, 왼쪽으로 치우침
# Sk > 0 : 왼쪽꼬리분포, 오른쪽으로 치우침
# > install.packages(‘moments’)
# > library(moments)
skewness(mpg$cty)  # {moments} / prettyR::skew()도 사용가능
# 0.791445 : 
skewness(mpg$hwy) # 0.366865

hist(mpg$cty, freq=F, breaks=30)
lines(density(mpg$cty), col='red', lwd=2)


hist(mpg$hwy, freq=F, breaks=30)
lines(density(mpg$hwy), col='red', lwd=2)

par(mfrow=c(1,2))
hist(mpg$cty, freq=F, breaks=30)
lines(density(mpg$cty), col='red', lwd=2)
?par


# 분포도
# - 첨도
# > 3 : 정규분포보다 위로 약간 올라감
# < 3 : 정규분포보다 아래로 약간 내려감
# = 3 : 정규분포와 비슷
kurtosis(mpg$cty) # {moments}
# 4.468651 --> 뾰족
kurtosis(mpg$hwy) # 3.163929 --> 뾰족 
# 그래프로 확인 시, 정점이 2개 있음.


# ch3_continuous.csv
test2 <- read.csv(file.choose())
# income에 대해 왜도와 첨도 구하여, 분포의 모양과 맞는지 확인
skewness(test2$incom)  # 1.34467  --> 오른쪽 꼬리분포  / 비대칭도는 작음
skew(test2$incom) # {prettyR} : 모집단의 비대칭도도 추정하여 출력
# $sample
# [1] 1.34467
# 
# $population
# [1] 1.456247
kurtosis(test2$incom)  # 4.857484 --> 3보다 2정도 크니까 정규분포보다 약간 올라감.


par(mfrow=c(1,1))
hist(test2$incom, freq = F, breaks=50)
lines(density(test2$incom), col='red', lwd=2)


# 
length(test2)  # {base} 5 
length(test2$incom) # {base} 20
mean(test2$incom) # 368.55
var(test2$incom) # 44392.05
sd(test2$incom) # 210.6942
max(test2$incom) # 987
min(test2$incom) # 111
median(test2$incom) # 328
quantile(test2$incom)
#     0%    25%    50%    75%   100% 
# 111.00 209.00 328.00 457.25 987.00 
quantile(mpg$cty)
quantile(mpg$cty, probs = c(.1, .3, .5, .8, 1))  # 10 30 50 80 100%값 보여줌
seq(0,1, .1)  # 0~1 사이의 값을 0.1단위로 구해라
quantile(mpg$cty, probs = seq(0,1, .1))
# 0%  10%  20%  30%  40%  50%  60%  70%  80%  90% 100% 
# 9   11   13   14   15   17   18   19   20   21   35

# 상관분석 상관계수 : 두 변수 간 관계
cor(mpg$hwy, mpg$cty)  # 0.9559159 : 45도에 가까운 정상관의 관계
# 상관계수 값을 출력해주지만, 
# p-value는 뽑아내서 검정하지 못함.

# 공분산 : 단위가 없음
# 공분산은, 두 연속형 변수의 분산이 어떻게 함께 변하는지(변동이 비슷하게 나오는지) 보여줌
# 공분산으로부터, 상관계수가 나옴.
cov(mpg$hwy, mpg$cty) # 24.22543

summary(mpg)

# 줄기-잎 그림(stem-leaf)
stem(mpg$cty)

# 연속형 변수의 빈도보여주므로 텍스트 방식의 히스토그램과 같음
# | 왼쪽에는 특정값 오른쪽은 그 횟수.
# The decimal point is at the |
# 
#   8 | 00000
#  10 | 00000000000000000000
#  12 | 00000000000000000000000000000
#  14 | 0000000000000000000000000000000000000000000
#  16 | 00000000000000000000000000000000000
#  18 | 0000000000000000000000000000000000000000000000
#  20 | 0000000000000000000000000000000000
#  22 | 0000000
#  24 | 0000000
#  26 | 000
#  28 | 000
#  30 | 
#  32 | 0
#  34 | 0


#  연속형 변수의 표준화!!
# --> 자료형이 matrix 타입이 되고,
# --> 평균이 0, 분산이 1 (--> 편차도 1)의 값으로 바꿔줌 : 단위가 떼어짐.
# --> "단위가 다른" 두 연속형 변수의 값을 비교하고자 할 때, 표준화 시킨 값으로 비교한다.
# 표준화 후, 값은 표준편차 1사이에 거의 집중된다.

# cf. 지수(ex. 행복지수)로 변환하고자 할 때에는, 삼각함수를 사용한다

x <- scale(mpg$cty) # 표준화시킨 x
class(x) # "matrix"
x <- as.data.frame(x)
str(x) 
x <- x$V1  
class(x) # numeric인 vector
# 표준화 0,1로 제대로 되는지
mean(x) # 2.980539e-16 --> 0에 가까운 실수로 해줌. 
var(x) # 1

skewness(x)  # 0.7914453 -->  비대칭도는 정규분포에 가까운, 좌우대칭에 가까움
kurtosis(x)  # 4.468651  --> 첨도는 3보다 약간 크니까 약간 올라감
# --> 확률분포의 모양이 정규분포와 비슷할까?
# 그려보자
hist(x, freq = F, breaks=30)  # 막대사이에 빈곳없도록 breaks조절
lines(density(x), col='red', lwd=2)

shapiro.test(mpg$cty)
# 
# Shapiro-Wilk normality test
# 
# data:  mpg$cty
# W = 0.95679, p-value = 1.744e-06 --> 귀무가설기각: 정규성 X
shapiro.test(x)
# 
# Shapiro-Wilk normality test
# 
# data:  x
# W = 0.95679, p-value = 1.744e-06 --> 귀무가설기각: 정규성 X
# --> 꼬리분포니까!!
boxplot(mpg$cty)  # 극단치 있음
# 극단치 제거 시, 꼬리쪽 값이 사라지므로 정규분포를 따를 것이다.


# 연속형변수의 이상치 확인
#  - boxplot
?boxplot # {graphics}
boxplot(mpg$cty)
boxplot(mpg$cty ~ mpg$fl) # 연속~범주 : 범주별로 나타나는 분포 비교
boxplot(cty~fl, data=mpg)  # 보기 더 수월
boxplot(cty~drv, data=mpg, col='lightgray')  # 구동방식에 따라 범주 나뉨
# 각 범주별 분포의 특징 비교할 수 있다.
# 4와 f는 통계적의로 유의미한지 검정하지 않아도 차이가 확연하다
# r을 볼 때, IQR의 범위는 중앙선이 딱 붙을 수 있음
# r과 4를 비교해본다 --> 유의미한 차이인지.
# cty만 박스플롯을 보면, 이상치가 4개
# cty~drv로 보면, 이상치가 더 많음.
# 범주에 따라, 혼자 봤을 때에는, 정상적인 값도 이상치로 나타날 수 있음.
# 범주별, 이상치가 다름.
# 이상치제거 시, --> 범주별로 봐야할까? NO. / 변수 하나만 보면 된다.


result <- boxplot(mpg$cty)
class(result) # "list"
result
# $stats  --> list의 key를 참조할 수 있음
# [,1]
# [1,]    9 : min값
# [2,]   14 : 1분위수
# [3,]   17 : 중위수
# [4,]   19 : 3분위수
# [5,]   26 : max값  --> 이상치 제거 시, 경계값이 됨.
# attr(,"class")
# 1 
# ....
# $out              --> 이상치 값들을 보여줌
# [1] 28 28 33 35 29


# 이상치의 정확한 값을 알아보려면,
# 시각화하지 않고, 통계량만 보여줌
boxplot.stats(mpg$cty) # {grDevices}
# $stats  --> 분위별 값
# [1]  9 14 17 19 26
# 
# $n    --> 표본의 크기
# [1] 234
# 
# $conf --> 신뢰구간
# [1] 16.48356 17.51644
# 
# $out   --> 이상치
# [1] 28 28 33 35 29


# 범주형변수간의 연관성분석
#  -1. 카이제곱검정
# > install.packages(‘prettyR’)
# > library(prettyR)

# 교차표 만들기
# ch6_chisq.csv
test3 <- read.csv(file.choose(), fileEncoding = 'cp949')
crosstbl <- xtab(snack~gender, data=test3) #  카이제곱검정에서 오류
crosstbl <- xtabs(snack~gender, data=test3) #  카이제곱검정에서 오류
crosstbl <- xtabs(~snack + gender, data=test3)
#           gender
# snack     남 여
# candy     19 17
# chocolate 25  2  --> 카이제곱에서는 빈도만 있어야 함. 비율있으면 x
crosstbl

chisq.test(crosstbl) # 'list' object cannot be coerced to type 'double'
# 
# Pearson's Chi-squared test with Yates' continuity correction
# 
# data:  crosstbl
# X-squared = 9.7982, df = 1, p-value = 0.001747
# p-value < 0.05--> 대립가설채택(차이가 있다, 관계가 있다)
# snack이 성별에 영향을 준다

#  -2. 피셔의 정확한 검정
chitest <- ch2_discrete

# 교차분할표 생성
# 범주형 변수 2개 필요
crosstbl <- table(chitest$product, chitest$gender) 
crosstbl # 행

crosstbl <- xtabs(~product+ gender, data=chitest)
crosstbl # ~뒤의 첫번째가 행변수, 뒤에 나오는게 열변수


chisq.test(crosstbl)  # {stats}
# 
#   Pearson's Chi-squared test
# 
# data:  crosstbl
# X-squared = 0.5291, df = 2, p-value = 0.7676
# 경고메시지(들): 
#   In chisq.test(crosstbl) :
#   카이제곱 approximation은 정확하지 않을수도 있습니다

# pvaule가 높은 값이 나왔으므로, 귀무가설 채택
# 카이제곱 검정의 귀무가설은, 서로 관계가 없다!
# --> 카이제곱 검정 결과가 정확하지 않을 수 있다는 메시지 나오므로,
# 피셔의 정확한 검정 수행
fisher.test(crosstbl)  # {stats}
# 
# Fisher's Exact Test for Count Data
# 
# data:  crosstbl
# p-value = 0.7733
# alternative hypothesis: two.sided
# pvalue값을 보면, 귀무가설 채택

