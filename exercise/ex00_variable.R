# ex00_variable.R


# cat('\f')
rm(list=ls()) # 모든변수 삭제

# 변수 선언
a <- 1 # 정수형 변수
class(a)  # 변수의 타입
mode(a)   # 변수의 요소의 타입 
str(a)  # df.info와 같음  num 1
dim(a)  # 차원 보여줌
summary(a)  # 요약통계량 df.describe()와 같음

library(ggplot2)
class(mpg)
mode(mpg)
str(mpg)
dim(mpg)
summary(mpg)

b <- 1.5 # 실수형 변수
c <- 2
c1 <- '문자열' # 문자열 변수
c2 <- "Hello"
class(c2)  # character
mode(c2)  # character
dim(c2)
str(c2)  #  chr "Hello"
summary(c2)

bool1 <- TRUE # logical 타입 변수
class(bool1)  # "logical"
mode(bool1)  # "logical"
dim(bool1)  # NULL
str(bool1) #  logi TRUE
summary(bool1)

bool2 <- FALSE
bool3 <- T
bool4 <- F

T <- FALSE
F <- TRUE

cat('hello')


# -------------------
# 연산
a + b
a + b +c
4 / b
5 * b

rm(list = ls()) # 메모리 영역의 변수 삭제
cat('\f') # 콘솔창 지우기

a <- 1
b <- 3
c <- .5
d <- 's1'
e <- TRUE

result <- NA

(result = 1 + 1)
(result = 1 - 1)
(result = 2 * 2)

(result = 2 / 2)
(result = 2 / 0) # [1]Inf : not ERROR

(result = 3 ^ 3) # 제곱
(result = 3 ** 3) # 제곱

# R의 나머지
# (result = 3 % 3) # X: ERROR. 문법상 오류
(result = 3 %% 3) # OK



# --------------------------------
# The identifier's rule
# alphabet, number, -, _
# 변수명
(var1 <- 10)  # OK
class(var1)
mode(var1)
str(var1)
dim(var1)
summary(var1)

# 1var <- 20  # ERROR : 숫자로 시작하는 변수X
(var_name <- 30) # OK
class(var_name)
mode(var_name)
dim(var_name)
str(var_name)
summary(var_name)

# var-name2 <- 40  # ERROR '-' 사용불가
# _var2 <- 'str'  # ERROR '_' 시작으로는 사용불가
# -var3 <- .4  # ERROR '-' 사용불가

# case-sensitive
(var2 <- 10)
(Var2 <- 10)
(var2 == Var2)

# NLS support
(한글 <- 30)
class(한글)
mode(한글)
str(한글)
dim(한글)
summary(한글)

# ---------------------------

# VECTOR
# c() : combine function
(vec1 <- c(1, 2, 5, 7, 8))
class(vec1) # numeric
mode(vec1) # numeric
str(vec1) #  num [1:5]
dim(vec1)
summary(vec1)

(vec2 <- c(1:5))
class(vec2)  # integer
mode(vec2) # numeric
str(vec2) #  int [1:5]


(vec2 <- 1:10)
(vec3 <- seq(1,5)) # 순차번호 생성함수
(vec5 <- seq(1, 10, by=2))

(vec6 <- c(1, 's2'))  # OK (Not Error) -> Promotion
class(vec6)  # character
mode(vec6)  # character
str(vec6)  #  chr [1:2]
dim(vec6)
summary(vec6)


(vec4 <- c(1, .5, 's1'))
class(vec4)  # character
mode(vec4)  # character
str(vec4)  # chr [1:3] "1" "0.5" "s1"
dim(vec4)
summary(vec4)

(vec7 <- 1:10)
class(vec7)  # integer
mode(vec7)   # numeric
str(vec7)  # int [1:10] 

(vec8 <- c(1:10))

# vec9 <- 'a':'z'  # XXX

(seq(1,10))
(seq(1,10,2))
(seq.int(1, 100))
(seq.int(1, 100, 2))

seq_len(10)
seq_along(1:20)

(vec10 <- seq(1,10))
class(vec10)  # integer
mode(vec10)  # numeric
str(vec10)  # int [1:10]
dim(vec10)
summary(vec10)

(vec11 <- c(1:10, c(11:15)))
class(vec11)  # integer
mode(vec11)  # numeric
str(vec11)  # int [1:15]
dim(vec11)
summary(vec11)


(vec13 <- c(1,2,3, c(4,5,6), 7:10))
class(vec13)  # numeric
mode(vec13)  # numeric
str(vec13)  # num [1:10
dim(vec13)  # NULL
summary(vec13)


(vec14 <- c(1,2,3, 4:6, seq(7, 10, 1)))
class(vec14)  # numeric
mode(vec14)  # numeric
str(vec14)  # num [1:10]
dim(vec14)
summary(vec14)

# -----------------------------
# 벡터연산
# 연속형 변수로 연산하기
(vec1 + 2)
(vec1 + vec2)


rm(list = ls())
cat('\f')


(vec <- c(1:100))
class(vec)
mode(vec)
str(vec)
dim(vec)
summary(vec)



# 1st. Vector operator Scalar
vec + 1
vec - 1
vec * 2
vec / 2

vec / 0     # result is Infinite. (Inf)

vec ^ 2
vec ** 2


# 2nd. Vector operator Vector
(vec1 <- c(1:100))
(vec2 <- c(1:100))

vec1 + vec2
vec1 - vec2
vec1 * vec2
vec1 / vec2
vec1 ^ vec2
vec1 ** vec2


# 3rd. Vector operator Vector but vec1, vec2 size is different.
(vec3 <- c(1:10))
(vec4 <- c(1:5))

vec3 + vec4
vec3 - vec4
vec3 * vec4
vec3 / vec4
vec3 ^ vec4
vec3 ** vec4



#----------------------------------------
# 문자 변수
(str1 <- 'a')
(str2 <- 'text')
(str3 <- "Hello World!")
(str4 <- c("a", "b", "c"))
(str5 <- c("Hello", 'world', "is", "good!"))
# (str1 + 2)  # X: ERROR




# 1st. character type scalar variable
( str1 <- 'a' )
( str2 <- "b" )
( str3 <- "Hello World" )
( str4 <- 'Hello World' )


# 2nd. vector consisted of some strings
( vec1 <- c('a', 'b', 'c') )
( vec2 <- c("d", "e", "f") )


# 3rd. vector operation with character variable
# ( str1 + 1 )     # XXX
# ( str1 - 1 )     # XXX
# ( str1 * 1 )     # XXX
# ( str1 / 1 )     # XXX
# ( str1 ^ 2 )     # XXX
# ( str1 ** 2 )    # XXX

