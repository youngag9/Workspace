# To use string functions

rm(list = ls())
cat('\f')


( vec <- c('s1', 's2', 's3') )


# paste() function
( string1 <- paste(vec) )
( string2 <- paste(vec, collapse = ',') )
( string3 <- paste(vec, collapse = '') )
( string4 <- paste(vec, collapse = ' ') )
( string5 <- paste(vec, collapse = '-') )

