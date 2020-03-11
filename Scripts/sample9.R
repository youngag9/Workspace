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


