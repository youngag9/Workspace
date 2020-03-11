# ex01_func.R

# 함수
(x <- c(1, 2, 3))
(mean(x))
(max(x))
(min(x))

(mean)
# function (x, ...) 
# UseMethod("mean")
# <bytecode: 0x562140e6bab0>
# <environment: namespace:base>

# 문자를 다루는 함수
# To use string functions

rm(list = ls())
cat('\f')


( vec <- c('s1', 's2', 's3') )


# paste() function
( string1 <- paste(vec) )  # "s1" "s2" "s3" : 결합X 그냥 vector
( string2 <- paste(vec, collapse = ',') )  # "s1,s2,s3"
( string3 <- paste(vec, collapse = '') ) # "s1s2s3"
( string4 <- paste(vec, collapse = ' ') )
( string5 <- paste(vec, collapse = '-') )

(paste(str5, collapse=","))
(paste(str5, collapse=" "))

# 함수의 결과물로 새 변수 만들기
(x_mean <- mean(x))
(str5_paste <- paste(str5, collapse = " "))


# How to use sample{base} function
# Usage: sample(length(x), size, replace, prob)

rm(list = ls())
cat('\f')


# (1) How to show help page of the function
?sample
help(sample)


# (2) sampling random number in some ways
sample(1:5)
sample(c(1,2,3,4,5,6), size = 6)
sample(c(1:100), size = 45)
sample(c(1:45), size = 5, replace = FALSE)  # Duplicates allowed(복원추출)
sample(1:45, size = 5, replace = TRUE) # Duplicates NOT allowed (비복원추출)

# (3) 지정 자릿수를 가지는 정수를 (비)복원 무작위 추출
sample.int(1e10, size = 12, replace = T)
sample.int(1e5, 12)
sample.int(1e2, 12)
sample.int(100, 12)


# (4) 지정한 확률을 기반으로 무작위 정수 추출
sample(
  c(1:10),
  5,
  replace = FALSE,
  prob = c(.1, .05, .7, .11, .23, .67, .88, .11, .008, .010)
)


# 패키지 관리
# 1. install package
# install.packages('ggplot2', dependencies = TRUE, type='source')
# 2. load package
# library(ggplot2)
# 2-2. unload package
# detach("package:ggplot2", unload = TRUE)

# 1st. To install new pacakge.
# install.packages('ggplot2')
# install.packages('ggplot2', dependencies = TRUE)
# install.packages('ggplot2', dependencies = T, type = 'source')

# install.packages(c('ggplot2', 'ggplot2movies'))


# 2nd. Update packages
# update.packages()
# update.packages('nlme')
# update.packages(c('devtools', 'DT'))
# update.packages(c('devtools', 'DT'), type = 'source')


# 3rd. Remove specified packages
# remove.packages('ggplot2')
# remove.packages(c('ggplot2', 'ggplot2movies'))


# 4th. Loading a package
# library(ggplot2)

# library(c(ggplot2, ggplot2movies))    # XXX: 'package' must be of length 1


# 5th. Unloading a package.
# detach('package:ggplot2')
# detach('package:ggplot2', unload = T)

# 번외) 함수의 도움말
help(qplot)
??qplot
?qplot


# 함수 사용하기
(x <- c("a", "a", "b", "c")) # x는 질적, 분류변수
library(ggplot2)
# 3. 패키지 메소드 이용
qplot(x) # barplot : 범주형변수
qplot(c("a", "a", "b", "c"))


# 다섯 명의 학생이 시험을 봤습니다. 학생 다섯 명의 시험 점수를 담고 있는 변수를 만들어 출력해 보세요. 각 학생의 시험 점수는 다음과 같습니다.
(test <- c(80, 60, 70, 50, 90))
(mean_test <- mean(test))


# tb_mpg <- ggplot2::mpg
(tb_mpg <- mpg)

# 아래는 연속형변수 사용하므로, histogram
qplot(data=tb_mpg, x=hwy) # 연속형변수 hwy
qplot(data=tb_mpg, x=cty) # 연속형변수 cty
qplot(data=tb_mpg, x=drv, y=hwy) #drv: 범주형변수, y: 연속형변수
qplot(data = tb_mpg, x = drv, y = hwy, geom = "line")
qplot(data = tb_mpg, x = drv, y = hwy, geom = "boxplot")
qplot(data = tb_mpg, x = drv, y = hwy, geom = "boxplot", colour = drv) 
qplot(data = tb_mpg, x = drv, y = hwy, geom = "boxplot", colour = fl) 

# 연속형 변수의 평균구하기
# (mean(mpg$hwy)
((sum(mpg$hwy) + sum(mpg$cty)) / 234)
(var(mpg$hwy))  # 분산
(sd(mpg$hwy))   # 표준편차
?sd

# How to use a function in the specified package

rm(list = ls())
cat('\f')


library(ggplot2)

?qplot


( vec <- c(1,1,1,2,3,3,4,4,4,4,7,8,9,0,0) )
table(vec)     # table{base} - Tp produce cross table(교차표)
qplot(vec, bins = 8)     # qplot{ggplot2} / 오른쪽 꼬리분포

# use table
table(mpg$cty)  # 연속형 변수지만, 데이터셋이 적지 않아 적은 것으로 교차표출력가능.
# 값이 많은, 연속형 변수도 교차표를 생성할 수 있지만 의미가 없다.

( vec <- c('a','a','b','c','c','c'))
table(vec)    # table{base}
qplot(vec)    # qplot{ggplot2}


( mtcars <- datasets::mtcars )  # datasets package의 dataframe
View(datasets::mtcars) # table형태로 보기


qplot(data = mtcars, x = mpg, y = wt)  # default, scatterplot

qplot(data = mtcars, x = mpg, y = wt, color = cyl)
qplot(data = mtcars, x = mpg, y = wt, color = I('red'))
class(I('red'))  # "AsIs"


qplot(data = mtcars, x = mpg, y = wt, size = wt)
qplot(data = mtcars, x = mpg, y = wt, color = cyl, size = wt)
qplot(data = mtcars, x = mpg, y = wt, color = I('red'), size = wt)
qplot(data = mtcars, x = mpg, y = wt, color = cyl, size = wt, xlab = 'mpg', ylab = 'weight' )
?qplot
# just x supplied = histogram
qplot(data = mtcars, x = mpg)
qplot(data = mtcars, x = cyl)

# just y supplied = scatterplot, with x = seq_along(y)
qplot(data = mtcars, y = mpg)
?seq_along

# 정규분포
vec <- rnorm(n=10000, mean=0, sd=1)
density(vec)
plot(density(vec))
?rbinom

# Use different geoms
qplot(data = mtcars, x = mpg, y = wt)
qplot(data = mtcars, x = mpg, y = wt, geom = 'path')
qplot(data = mtcars, x = cyl, y = wt, geom = c('boxplot', 'jitter'))
qplot(data = mtcars, x = cyl, y = wt, geom = c('boxplot', 'jitter'), color = cyl)
qplot(data = mtcars, x = cyl, y = wt, geom = c('boxplot', 'jitter'), color = cyl, size = wt)
qplot(data = mtcars, x = mpg, geom = 'dotplot')




detach('package:ggplot2', unload = TRUE)


# ---------------------------
# 샘플링
# How to use sample{base} function
# Usage: sample(length(x), size, replace, prob)

rm(list = ls())
cat('\f')


# (1) How to show help page of the function
?sample
help(sample)


# (2) sampling random number in some ways
sample(1:5)
sample(c(1,2,3,4,5,6), size = 6)
sample(c(1:100), size = 45)
sample(c(1:45), size = 5, replace = FALSE)  # Duplicates allowed(복원추출)
sample(1:45, size = 5, replace = TRUE) # Duplicates NOT allowed (비복원추출)

# (3) 지정 자릿수를 가지는 정수를 (비)복원 무작위 추출
sample.int(1e10, size = 12, replace = T)
sample.int(1e5, 12)
sample.int(1e2, 12)
sample.int(100, 12)


# (4) 지정한 확률을 기반으로 무작위 정수 추출
sample(
  c(1:10),
  6,
  replace = FALSE,
  prob = c(.1, .05, .7, .11, .23, .67, .88, .11, .008, .010)
)



