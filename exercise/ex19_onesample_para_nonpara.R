# One sample : 하나의 샘플의 평균과, 이미 잘 알려진 평균과 비교할 때
#    이미 알려진 평균과 같은지 / 작은지 / 큰지 비교할 때
#    H0: 이미 알려진 평균과 같다. m = μ
#  standard (or theoretical/hypothetical) mean (μ).
# theoretical: 이전의 실험을 통해 나온 평균이거나, 연구실같은 통제환경하에 실험하에 얻어낸 통계

# One Sample T-test
# 전제) 데이터가 정규분포를 따를 때
# -> shapiro-wilks와 시각화로 정규성 점검 (하나의 변수검정 / cf. 다변량의 경우, 말라하비라스 검정 사용)

# pvalue가 < 0.05면, 대립가설 채택
# (기존의 평균과 다르므로) 표본의 평균이 유의미하다

install.packages("qqpubr", quiet = TRUE) # 조용하게 패키지를 설치한다
require(ggpubr)

t.test(x, mu=0, alternative = "two.sided") # default / "greater" / "less"
# mu : 비교할 평균값 --> default: 0

set.seed(134)
# 이미 알려진 평균인 25g과 표본의 평균이 다른가?
(my_data <- data.frame(name=paste0(rep("M_", 10), 1:10), weight = round(rnorm(10, 20, 2), 1)))
# rep : 지정 문자열을 횟수만큼 반복
# paste/paste0 : 문자열 붙여줌
# rnorm : 정규성을 따르는 정규분포에서 무작위로 지정한 개수만큼의 숫자 생성
#   rnorm(개수, 평균, 표준편차)  : X~N(20, 4) 분포에서 10개 추출
# my_data: name, 정규성값 갖는weight 변수를 갖는 데이터프레임

library(dplyr, quietly = TRUE)
sample_n(tbl=my_data, size=10, replace=FALSE) 
# 10개인 데이터에서 10개의 데이터 표본추출하므로
# 이 함수는 순서랜덤으로 바꾸는 것과 같음

summary(my_data$weight) # 무작위로 생성한 무게의 요약통계량

# boxplot으로 분포 확인
library(ggpubr, quietly = TRUE)

ggboxplot(
  my_data$weight,
  ylab = "Weight (g)",
  xlab = FALSE,
  ggtheme = theme_classic()
)


# One Sample T-test
# 가정) 대표본인가? -> No. 소표본임
#     -> 대표본이 아니기 때문에, 정규성를 따르는지 체크해야 함.

# 정규성 검정
shapiro.test(my_data$weight)
# Shapiro-Wilk normality test
# 
# data:  my_data$weight
# W = 0.98412, p-value = 0.9834  -> 귀무가설: 정규성따름
ggqqplot(my_data$weight, ylab="Men's weight", ggtheme = theme_bw())
# 시각화로 확인해도, 정규성 따름
# 신뢰구간까지 확인할 수 있어 유용하다.

# 정규성 따르므로, T-test가능!!
# 만약, 정규성을 따르지 않는다면, one-sample Wilcoxon rank test를 한다.

# One sample t-test
(res <- t.test(my_data$weight, mu=25))
# 
# One Sample t-test
# 
# data:  my_data$weight
# t = -6.8118, df = 9, p-value = 0.00007801
# alternative hypothesis: true mean is not equal to 25
# 95 percent confidence interval:
#   19.17875 22.08125
# sample estimates:
#   mean of x 
#     20.63 
# pvale < 0.05 -> 대립가설! 
# - t                 : the t-test statistic value (t = -6.8118),
# - df                : the degrees of freedom (df= 9),
# - p-value           : the significance level of the t-test (p-value = 0.00007801).
# - conf.int          : the confidence interval of the mean at 95% (conf.int = [19.17875, 22.08125]);
# - sample estimates  : he mean value of the sample (mean = 20.63).

# 미리 주어진 값 25와 표본의 평균20.63은 통계적으로 같지 않다.
# 표본의 크기가 작고 4-5차이는 큰 차이이므로, 같지 않다.


# 질문이, 표본의 평균이 25g보다 작냐이냐면 -> 단측 좌측검정 수행
t.test(my_data$weight, mu=25, alternative = "less")
# 이 때, 대립가설: 표본의 평균이 25보다 작다
# 
# One Sample t-test
# 
# data:  my_data$weight
# t = -6.8118, df = 9, p-value = 0.00003901
# alternative hypothesis: true mean is less than 25
# 95 percent confidence interval:
#   -Inf 21.80601
# sample estimates:
#   mean of x 
# 20.63 
# 대립가설채택

# 질문이, 표본의 평균이 25g보다 크냐이면 -> 단측 우측검정 수행
t.test(my_data$weight, mu=25, alternative = "greater")
# 
# One Sample t-test
# 
# data:  my_data$weight
# t = -6.8118, df = 9, p-value = 1
# alternative hypothesis: true mean is greater than 25
# 95 percent confidence interval:
#   19.45399      Inf
# sample estimates:
#   mean of x 
# 20.63 


# t.test 객체도 반환값이 존재하는데, 이를 변수에 담으면
# list 타입임 : 결과의 특정항목 참조 시, 변수로 담아 접근한다.

# - statistic : the value of the t test statistics : t통계량
# - parameter : the degrees of freedom for the t test statistics : 자유도
# - p.value   : the p-value for the test
# - conf.int  : a confidence interval for the mean appropriate to the specified alternative hypothesis.
# - estimate  : the means of the two groups being compared (in the case of independent t test)  : 표본의 평균
# or difference in means (in the case of paired t test).


os_ttest <- t.test(my_data$weight, mu=25, alternative = "less")
os_ttest$statistic  # t통계량
os_ttest$estimate
os_ttest$conf.int # 신뢰구간[CI(confidence interval)]



# -------------------------------------------------------------#
# One Sample의 비모수 검정
#   : Wilcoxon Signed Rank Test by wilcox.text()

# 주어진 정규분포를 따르지 않을 때! (+소표본일 때)

# 비모수의 대표값은, ""중위수(median)""를 사용한다

# 
# 가정) 데이터가 중위수에 대칭적으로 분포되어 있어야 함. 중위수보다 작거나 큰 값으로 존재
# 가설) H0: 미리구한 중위수 = 표본의 중위수


library(ggpubr)
# 사용법
wilcox.test(x, mu=0, alternative = "two.sided") # {stats}
# 비모수방법은 이상치와 정규분포, 표본의 크기를 가정하지 않음.
# mu: 비교할 기준값
# alternative : two.sided(default), greater, less

(my_data <- data.frame(name=paste0(rep("M_", 10), 1:10), weight = round(rnorm(10, 20, 2), 1)))
library(dplyr)
sample_n(tbl=my_data, size=10, replace=FALSE) 

(res <- wilcox.test(my_data$weight, mu=25))
# 
# Wilcoxon signed rank test
# 
# data:  my_data$weight
# V = 0, p-value = 0.001953
# alternative hypothesis: true location is not equal to 25
# 대립가설 채택! -> 중위수는 같지 않다. (모수적검정과 동일하게 귀무가설 기각)

