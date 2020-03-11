# To create a vector.

rm(list = ls())
cat('\f')


# 1st. method - combine function: c()
vec1 <- c(1,2,3,4,5,6,7,8,9,0)
vec1
class(vec1)
mode(vec1)
str(vec1)
dim(vec1)
summary(vec1)


vec2 <- c('s1', 's2', 's3')
vec2
class(vec2)
mode(vec2)
str(vec2)
dim(vec2)
summary(vec2)


vec3 <- c(1, 's2')
vec3
class(vec3)
mode(vec3)
str(vec3)
dim(vec3)
summary(vec3)


vec4 <- c(1, .5, 's1')
vec4
class(vec4)
mode(vec4)
str(vec4)
dim(vec4)
summary(vec4)



# 2nd. method - : operator 
vec5 <- 1:10
vec5
class(vec5)
mode(vec5)
str(vec5)
dim(vec5)
summary(vec5)


vec6 <- c(1:10)
vec6
class(vec6)
mode(vec6)
str(vec6)
dim(vec6)
summary(vec6)


# vec7 <- 'a':'z'   # XXX : cannot use string as a value
# vec7



# 3rd. method - Sequence Generator function: seq(start, end, by)
seq(1, 10)
seq(1, 10, 2)
seq(0, 10, 2)

seq.int(1, 100)
seq.int(1, 100, 2)

seq_len(10)
seq_along(1:20)


vec8 <- seq(1,10)
vec8
class(vec8)
mode(vec8)
str(vec8)
dim(vec8)
summary(vec8)


vec9 <- seq(1,10,1)
vec9
class(vec9)
mode(vec9)
str(vec9)
dim(vec9)
summary(vec9)


vec10 <- seq(1,10,2) # by = 2
vec10
class(vec10)
mode(vec10)
str(vec10)
dim(vec10)
summary(vec10)


vec11 <- seq(0,10,2) # by = 2
vec11
class(vec11)
mode(vec11)
str(vec11)
dim(vec11)
summary(vec11)



# 4st. method - nested vectors merged into a vector
vec12 <- c(1:10, c(11:15))
vec12
class(vec12)
mode(vec12)
str(vec12)
dim(vec12)
summary(vec12)


vec13 <- c(1,2,3, c(4,5,6), 7:10)
vec13
class(vec13)
mode(vec13)
str(vec13)
dim(vec13)
summary(vec13)


vec14 <- c(1,2,3, 4:6, seq(7, 10, 1))
vec14
class(vec14)
mode(vec14)
str(vec14)
dim(vec14)
summary(vec14)





