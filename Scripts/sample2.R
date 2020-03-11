# Basic Operators

rm(list = ls())
cat('\f')


a <- 1
b <- 3
c <- .5
d <- 's1'
e <- TRUE

result <- NA


( result = 1 + 1 )
( result = 1 - 1 )
( result = 2 * 2 )

( result = 2 / 2 )
( result = 2 / 0 )

( result = 3 ^ 3 )
( result = 3 ** 3 )

class(result)
mode(result)
str(result)
dim(result)
summary(result)


result = a + b + c
result
class(result)
mode(result)
str(result)
dim(result)
summary(result)


# result = numeric + character
# result = a + d        # Error in a + d : non-numeric argument to binary operator
# result


# result = numeric + logical (TRUE/T: 1, FALSE:/F: 0)
result = a + e
result
class(result)
mode(result)
str(result)
dim(result)
summary(result)


# result = character + logical
# result = d + e         # Error in d + e : non-numeric argument to binary operator
# result








