# The identifier's rule
# alphabet, number, -, _

rm(list = ls())
cat('\f')


var1 <- 10  # OK
var1
class(var1)
mode(var1)
str(var1)
dim(var1)
summary(var1)


# 1var <- 20        # XXX : cannot start with numbers


var_name <- 30      # OK
class(var_name)
mode(var_name)
str(var_name)
dim(var_name)
summary(var_name)


# var-name2 <- 40   # XXX : cannot use hyphen(-)


# _var2 <- 'str'    # XXX : cannot start with underscore(_)


# -var3 <- .4       # XXX : cannot start with hyphen(-)


# default, case-sensitive, var2 != Var2
var2 <- 10
Var2 <- 20

var2 == Var2


# NLS support
한글변수 <- 30
class(한글변수)
mode(한글변수)
str(한글변수)
dim(한글변수)
summary(한글변수)


