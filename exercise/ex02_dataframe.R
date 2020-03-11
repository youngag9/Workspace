# ex02_dataframe.R

# How to create a data frame or tibble(simple data frame) object

rm(list = ls())
cat('\f')



( eng <- c(90, 80, 60, 70) )
( math <- c(50, 60, 100, 20) )
( class <- c(1, 1, 2, 2))
( df_midterm <- data.frame(eng, math, class))

# To create a data frame
# ( df_midterm <- data.frame(eng, math) )
# ( df_midterm <- data.frame(eng, math, class) )


rm(list = c('eng', 'math', 'class'))

( df_midterm <- data.frame(
  eng = c(90, 80, 60, 70),
  math = c(50, 60, 100, 20),
  class = c(1, 1, 2, 2)
) )


class(df_midterm) # "data.frame"
mode(df_midterm) # list
str(df_midterm)
head(df_midterm)
?head
head(df_midterm, 10)
tail(df_midterm)
tail(df_midterm, 10)
dim(df_midterm)
summary(df_midterm)

View(df_midterm)


(mean(df_midterm$math))
(mean(df_midterm$eng))


( pro <- data.frame(
  제품 = c('사과', '딸기', '수박'),
  가격 = c(1800, 1500, 3000),
  판매량 = c(24, 38, 13)
))

( mean(pro$가격)) # 2100
( mean(pro$판매량)) # 25

# To create a tibble
library(tibble)
# ( tb_midterm <- tibble(eng, math) ) 


rm(list = c('eng', 'math', 'class'))

( tb_midterm <- tibble(
  eng = c(90, 80, 60, 70),
  math = c(50, 60, 100, 20),
  class = c(1, 1, 2, 2)
) )


class(tb_midterm)
mode(tb_midterm)
str(tb_midterm)
head(tb_midterm)
head(tb_midterm, 10)
tail(tb_midterm)
tail(tb_midterm, 10)
dim(df_midterm)
summary(df_midterm)

View(tb_midterm)
VieW(head(tb_midterm, 100))



# dataframe 접근 
# 1. indexing
# , 가 없으면 변수 지정하는 것!
df_exam[1]  # 특정 변수 지정: R에서는, 인덱스가 1부터 시작
df_exam[1,]  # 첫번째 행
df_exam[, 1]
df_exam['class']
df_exam[c('id', 'class')]
df_exam[c(1,2)]

df_exam <- read.csv("Data/csv_exam.csv")
df_exam[c(3,8,15), "math"] <- NA


# 2. slicing?? no. 벡터생성!
df_exam[1:3]  # 1~3변수 출력. 끝번호도 출력
# df_exam[1:10:2]  # Alert. by지정X slicing이 아니기 때문!


# 3. 행선택
# in pandas: df_exam.loc[] / df_exam.iloc[] --> df의 속성
# in R     : df_exam[행, 변수] --> 둘 중 하나 비우면 all행 or all변수

df_exam[1,] # 첫번째 행과 모든 변수
df_exam[1:3, ] # 1~3행과 모든 변수
df_exam[1, 1]  # 첫번째 행의 첫 변수 값. --> 하나의 셀만 선택한 것.
df_exam[1:3, 1:3]
df_exam[c(1,2,3), c(1,2,3)]

df_exam[]  # 모든행과 열

