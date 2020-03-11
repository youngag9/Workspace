# Vector Operation

rm(list = ls())
cat('\f')


vec <- c(1:100)
vec
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
vec1 <- c(1:100)
vec2 <- c(1:100)

vec1 + vec2
vec1 - vec2
vec1 * vec2
vec1 / vec2
vec1 ^ vec2
vec1 ** vec2


# 3rd. Vector operator Vector but vec1, vec2 size is different.
vec3 <- c(1:10)
vec4 <- c(1:5)

vec3
vec4

vec3 + vec4
vec3 - vec4
vec3 * vec4
vec3 / vec4
vec3 ^ vec4
vec3 ** vec4




