df_exam <- read.csv("Data/csv_exam.csv")

head(df_exam) 
# class는 범주, 나머지들은 점수지만
# 취할 수 있는 값은 한정되어 있음
# 점수가 정수형만 나올 수 있다면 이산형이 맞지만,
# 실수형도 나올 수 있다면, 무수히 많은 실수가 나올 수 있으므로
# 연속형 변수가 되고,
# 연속형 변수 안에는, 간격/비율 변수가 있는데,
# 0점이라고 사라지지 않으므로, 간격변수이다.
tail(df_exam, n=10)
View(df_exam)
dim(df_exam)
str(df_exam)
summary(df_exam)

# 1. 데이터 파악
#---범주형변수의 summary정보로 파악
# library(ggplot2)
df_mpg <- ggplot2::mpg  # 패키지 로딩하지 않고도,
# 해당 데이터셋만 직접끌어올림.
class(df_mpg) #tbl_df, tbl, data.frame
str(df_mpg)
summary(df_mpg)
df_mpg <- as.data.frame(ggplot2::mpg)
class(df_mpg)  # data.frame
str(df_mpg)

head(df_mpg)
tail(df_mpg, n=10)
dim(df_mpg)
summary(df_mpg)
?ggplot2::mpg


# 2. 데이터 백업 후, 데이터 변수명 수정
# -- 데이터 변수명 수정
(df_raw <- data.frame(var1= c(1,2,3),
                      var2= c(2,3,2)))
(df_new <- df_raw)

dim(df_raw) # 3 2

save(df_raw, file="Data/df_raw.original.rda")
rm(df_raw)
load(file="Data/df_raw.original.rda")



install.packages("dplyr", dependencies = TRUE)
?dplyr
library(dplyr)

# dplyr::rename()
(df_new <- rename(df_new, v2 = var2))
head(df_new)
(df_new <- rename(df_new, v1 = var1))

# mpg로 변수명 다루기
df_mpg <- ggplot2::mpg
(df_mpg <- rename(df_mpg, city = cty))
(df_mpg <- rename(df_mpg, highway = hwy))


# rename 한번 호출로 동시에 변수명 여러개 바꾸기
(df_mpg <- rename(df_mpg, fuel = fl, cylinder=cyl))


# 3. 파생변수 생성
(df_new$mean <- (df_new$v1 + df_new$v2)/2)
 # 잘못들어간 열 삭제 (df_new <- df_new[-c(3)])
(df_new$sum <- (df_new$v1 + df_new$v2))


df_mpg$total <- (df_mpg$city + df_mpg$highway) / 2
head(df_mpg)  
summary(df_mpg$total)
hist(df_mpg$total)

# 파생변수로, 합격판정변수 만들기

# vector 연산 test
df_mpg$test <- c(1,2,3) # 배수관계에 있을 때, 벡터연산은 오른쪽을 재사용한다.

# ifelse 연습
df_mpg$test <- ifelse(T, "pass", "fail")
# ifelse는 값을 몇개 산출해낼까? 234개. 즉, 벡터연산임.
ifelse(df_mpg$total >= 20, "pass", "fail")
df_mpg$test <- ifelse(df_mpg$total >= 20, "pass", "fail")


# 빈도표 만들기 -> 질적변수에 대해서!!
table(df_mpg$test)  # 각 표본의 개체수를 구하는 것과 같다.

# table함수는 NA도 하나의 값으로 분류한다.
df_mpg$test <- ifelse(df_mpg$total >= 20, "pass", NA)
table(df_mpg$test)


# 4. 막대 그래프로 빈도표현
library(ggplot2)
qplot(df_mpg$test)


# 5. 중첩 ifelse 활용하여, 구간 갖는 파생변수 생성
df_mpg$grade <- ifelse(df_mpg$total >= 30, "A",
                       ifelse(df_mpg$total >= 20, "B", "C"))

summary(df_mpg$grade)
table(df_mpg$grade)
qplot(df_mpg$grade)


# -- 혼자해보기
library(ggplot2)
library(dplyr)
raw_midwest <- ggplot2::midwest
class(raw_midwest)
df_midwest <- as.data.frame(raw_midwest)
class(df_midwest)
rm(raw_midwest)

mode(df_midwest)
dim(df_midwest)
str(df_midwest)
summary(df_midwest)

df_midwest <- rename(df_midwest, total=poptotal, asian=popasian)
str(df_midwest)

df_midwest$per <- (df_midwest$asian / df_midwest$total)
head(df_midwest)

hist(df_midwest$per)
mean(df_midwest$per)

df_midwest$meantest <- ifelse( df_midwest$per > mean(df_midwest$per), "large", "small")
head(df_midwest)

table(df_midwest$meantest)
qplot(df_midwest$meantest)
