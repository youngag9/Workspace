# 1. Comparing one-sample mean to a standard known mean:
#   (1) One-Sample T-test (parametric)
#   (2) One-Sample Wilcoxon Test (non-parametric)
# 
# 2. Comparing the means of two independent groups:
#   (1) Unpaired Two Samples T-test (parametric)
#   (2) Unpaired Two-Samples Wilcoxon Test (non-parametric)
# 
# 3. Comparing the means of paired samples:
#   (1) Paired Samples T-test (parametric)
#   (2) Paired Samples Wilcoxon Test (non-parametric)
# 
# 4. Comparing the means of more than two groups
#   (1) Analysis of variance (ANOVA, parametric):
#     - One-Way ANOVA Test in R
#     - Two-Way ANOVA Test in R
#     - MANOVA Test in R: Multivariate Analysis of Variance
#   (2) Kruskal-Wallis Test in R (non-parametric alternative to one-way ANOVA)


#************************************
# One-Sample T-test(모수) : 두 집단의 평균비교
# one-sample t-test is used to compare the mean of one sample 
# to a known standard (or theoretical/hypothetical) mean (μ).
# -> 이미 알려져있는 평균과 표본의 평균 비교

# 통계적 가설
# 1. H0 : m = μ (양측검정)
# 2. H0 : m ≤ μ (단측검정)
# 3. H0 : m ≥ μ (단측검정)

# t.test(x, mu = 0, alternative = "two.sided")  : mu에 알려져있는 평균

set.seed(1234)
library(ggpubr)


