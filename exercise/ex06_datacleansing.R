# data cleansing - mv
rm(list = ls())

# 결측치: NA
(df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5,4,3,4,NA)))
View(df)

is.na(df)  # true가 NA
class(is.na(df))  # matrix
# sex score
# [1,] FALSE FALSE
# [2,] FALSE FALSE
# [3,]  TRUE FALSE
# [4,] FALSE FALSE
# [5,] FALSE  TRUE


# 빈도표를 만들어보면, NA금방찾을 수 있지 않을까?
table(is.na(df))   # df의 값의 범주별로 개수를 셈. table은 변수에 대한 정보가 없음
# FALSE  TRUE 
# 8     2

table(df)  # 변수에 신경쓰며, 각 변수의 범주별로 개수 세 줌.
# 이ㅓㄳ을 "교차표"라고 함.
class(table(df))  # table


# 변수별로 결측치 확인
table(is.na(df$sex))

# 결측치의 연산 --> 결측치
mean(df$score) # NA

# 결측치 대체
# 1. 결측치 행 제외
library(dplyr)

# score에 결측치가 있는 행들 출력(빈도수는 X)
df %>% filter(is.na(score))  

# score에 결측치가 없는 행들 출력
(df_nomiss_score <- df %>% filter(!is.na(score))) # sex에 NA있는 것은 출력됨.

# df에 결측치가 없는 행만 담은, df 생성. 
(df_nomiss <- df %>% filter(!is.na(score) & !is.na(sex)))
mean(df_notna$score)
sum(df_notna$score)


# 2. 결측치 행 삭제
(df_nomiss2 <- na.omit(df))
class(df_nomiss2) # data.frame


# 3. 집계구할 때, 결측치 제외인자 이용
mean(df$score, na.rm=T)
sum(df$score, na.rm=T)
min(df$score, na.rm=T)
max(df$score, na.rm=T)
median(df$score, na.rm=T)
# quantile(df$score, na.rm=T) # na.rm없음

library(dplyr)
# df_exam %>% summarise(na.rm) # na.rm없음

# cf) dataframe 접근
# cf-1. indexing
# , 가 없으면 변수 지정하는 것!
df_exam[1]  # 특정 변수 지정: R에서는, 인덱스가 1부터 시작
df_exam[1,]  # 첫번째 행
df_exam[, 1]
df_exam['class']
df_exam[c('id', 'class')]
df_exam[c(1,2)]

df_exam <- read.csv("Data/csv_exam.csv")
df_exam[c(3,8,15), "math"] <- NA


# cf-2. slicing?? no. 벡터생성!
df_exam[1:3]  # 1~3변수 출력. 끝번호도 출력
# df_exam[1:10:2]  # Alert. by지정X slicing이 아니기 때문!


# cf-3. 행선택
# in pandas: df_exam.loc[] / df_exam.iloc[] --> df의 속성
# in R     : df_exam[행, 변수] --> 둘 중 하나 비우면 all행 or all변수

df_exam[1,] # 첫번째 행과 모든 변수
df_exam[1:3, ] # 1~3행과 모든 변수
df_exam[1, 1]  # 첫번째 행의 첫 변수 값. --> 하나의 셀만 선택한 것.
df_exam[1:3, 1:3]
df_exam[c(1,2,3), c(1,2,3)]

df_exam[]  # 모든행과 열


#-- df
# 4. 결측치 df에 접근하여

(df_exam[c(3,8,15), "math"] <- NA) # 결측치 생성.
(df_exam %>% summarise(mean_math = mean(math)))
(df_exam %>% summarise(mean_math = mean(math, na.rm=T)))
(df_nomiss3 <- df_exam %>% summarise(mean_math = mean(math, na.rm = T),      # 평균 산출
                   sum_math = sum(math, na.rm = T),        # 합계 산출
                   median_math = median(math, na.rm = T))  # 중앙값 산출
)

# 5. impultation?
# 5-1. 대표값으로 대체

# 5-1-1. 산술평균으로 대체
df_exam$math <- ifelse(is.na(df_exam$math), 55, df_exam$math)  # math변수 값이 결측치면 평균인 55로, 아니면 그대로 둠
table(is.na(df_exam$math))

# 6. outlier
(outlier <- data.frame(sex = c(1,2,1,3,2,1,2),
                      score = c(5,4,3,4,2,6,0)))

table(outlier$sex)  # 범주형 변수에서, 범주로서 나올 수 없는 값이 있는지 확인!!! sex:3(outlier)
table(outlier$score)


# 이상치 대체 [존재할 수 없는 값]-1. 이상치 → 결측치
(outlier$sex <- ifelse(outlier$sex==3, NA, outlier$sex))

(outlier$score <- ifelse(outlier$score >5 | outlier$score < 1, NA, outlier$score))


# 이상치 대체 -2. 변경한 결측치 제외
(outlier %>% 
    filter(!is.na(sex) & !is.na(score)) %>% 
    group_by(sex) %>% 
    summarise(mean_score = mean(score),
              max_score = max(score),

# 이상치 대체 [극단치]-1. 이상치 → 결측치
# boxplot 이용하여, 극단치 기준 정해서, 결측처리

df_mpg <- as.data.frame(ggplot2::mpg)
str(df_mpg)

# IQR 위아래를 벗어나면 → 이상치!
#   → 극단치인지는 아직 판단할 수 없음!
boxplot(df_mpg$hwy)
boxplot(df_mpg$hwy)$stats
?boxplot
( result <- boxplot(df_mpg$hwy))
class(result)  # list
result$stats
# [,1]
# [1,]   12 → minimum
# [2,]   18 → 1분위수
# [3,]   24 → 2분위수(median)
# [4,]   27 → 3분위수
# [5,]   37 → maximum
# attr(,"class") → 
# 1  → 
# "integer" → 

# 이상치 대체 [극단치]-1. 이상치 → 결측치
df_mpg$hwy <- ifelse(df_mpg$hwy < 12 | df_mpg$hwy>37, NA, df_mpg$hwy)
table(is.na(df_mpg$hwy))  # 3개의 값을 결측치로 변경함.

boxplot(df_mpg$hwy) # 이상치가 제거됨

# 이상치 대체 -2. 변경한 결측치 제외
(df_mpg %>% 
    group_by(drv) %>% 
    summarise(mean_hwy = mean(hwy, na.rm=T))
)
