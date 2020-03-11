# 상관분석 
# correaltion analysis
# 상관분석 들어가기 전에는 산점도를 그려 
# 두 변수 간 선형적 관계가 있는지 확인한다!!

# sa / test.csv 
test <- read.csv(file.choose())

dim(test) # 12 3


# 가정) 두 변수가 정규성을 따라야 함. --> 따르지 않으면 비모수
# 소표본이므로, CLT를 가정할 수 없으므로 정규성 검정해야 함.
library(ggpubr)
ggqqplot(test$age)
shapiro.test(test$age)
# W = 0.97941, p-value = 0.9812 --> 귀무가설채택: 정규성을 따름
ggqqplot(test$score)
shapiro.test(test$score)
# W = 0.92926, p-value = 0.3723 --> 귀무가설채택: 정규성을 따름

# 두 변수(# age, score: 간격변수(연속형)) 간 상관분석 수행
with(test, {
  cor.test(age, score, method = "pearson", use="pairwise.complete.obs") # {stats}
})


# Pearson's product-moment correlation
# 
# data:  age and score
# t = -2.5072, df = 10, p-value = 0.03106  --> t분포 사용
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.88103872 -0.07361463
# sample estimates:
#        cor  --> 표본상관계수 값 
# -0.6212691  --> 뚜렷한 부상관

# t분포는 정규분포와 비슷하되, 정점이 정규분포보다 위 혹은 아래로 내려갈 수 있는데
# 이를 조절하는 것이, df(자유도)이다! t분포의 자유도는 표본크기-1이다.
# 귀무가설 기각 --> 상관관계 있다 / 상관계수 0이 아니다 / 통계적으로 유의미한 관계이다


# 상관행렬 만들기
cor(test, method="pearson", use="pairwise.complete.obs")  # {stats}
# --> gender는 범주형변수이므로, 수치형변수가 아니므로 불가능
# --> gender 제외하고 하자
with(test, test[-"gender"]) # gender는 factor라 이러한 연산에서 자꾸 걸림
cor(test[c(1,3)]) # 단점: 검정통계량 pvalue안보여주므로, 상관계수의 유의성 알 수 없음
#             age      score  --> 두 변수의 상관계수 보여줌
# age    1.0000000 -0.6212691
# score -0.6212691  1.0000000

require(ggplot2)
data(mpg)

# 정규성 검정
library(ggpubr)
ggqqplot(mpg$cty) # 계단처럼 나옴
shapiro.test(mpg$cty)
# 
# Shapiro-Wilk normality test
# 
# data:  mpg$cty
# W = 0.95679, p-value = 0.000001744 --> 대립가설 --> 정규성X

ggqqplot(mpg$hwy) # 계단처럼 나옴
shapiro.test(mpg$hwy)
# 
# Shapiro-Wilk normality test
# 
# data:  mpg$hwy
# W = 0.95885, p-value = 0.000002999 --> 대립가설 --> 정규성X


# 정규성을 따르지 않으므로, 비모수검정 사용하거나, 정규성갖도록 정규화함
# --> 비모수 검정 사용 --> 사용XXXX
cor(mpg[c("cty", "hwy")], method="spearman")
#           cty       hwy
# cty 1.0000000 0.9542104
# hwy 0.9542104 1.0000000

# --> 대표본이므로, 정규성 검정 시, 정규성을 다르지 않아도
# 정규성을 갖는다는 가정하에 (중심극한의 정리) 모수적 검정인 피어슨 계수를 사용!!

# 상관분석
with(mpg, {
  cor.test(mpg$cty, mpg$hwy, method="pearson")
})
# 
# Pearson's product-moment correlation
# 
# data:  mpg$cty and mpg$hwy
# t = 49.585, df = 232, p-value < 0.00000000000000022
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.9433129 0.9657663
# sample estimates:
#       cor 
# 0.9559159

cor(mpg[c("cty", "hwy")], method="pearson") 
#           cty       hwy
# cty 1.0000000 0.9559159  --> 대칭 관계로 같은 값을 보여줌.
# hwy 0.9559159 1.0000000


# (+ Rmd/5.-Correlation-Analyses.rmd
## Correlogram으로 시각화  : corrplot {corrplot} 
# --> 검정통계량과 pvalue는 안나옴 / 유의여부 알 수 없음
library(corrplot)
library(RColorBrewer)

# cf) 컴퓨터에서 색상을 표시하는 방법 중 한가지
#       (빛의 3원색 : RGB) --> 16진수 2자리로 0~255의 숫자를 표현
#       # RRGGBB    --> #<RED><GREEN><BLUE>
#       # RRGGBBAA  --> #<RED><GREEN><BLUE><ALPHA>
?brewer.pal
brewer.pal(n=8, name="RdYlBu") # 지정한 색의 값 갖는 벡터 생성
# "#D73027" "#F46D43" "#FDAE61" "#FEE090" "#E0F3F8" "#ABD9E9" "#74ADD1" "#4575B4"

M <- cor(mtcars)  # 상관행렬도를 변수에 담음
corrplot(M, type="upper", order = "hclust", col=brewer.pal(n=8, name="RdYlBu"))
# type: 대각선 위에만 보여줌
# order : hcluse군집화 시킴: 같은 색상끼리 모아서 보여줌 

corrplot(M, type="lower", order="hclust", col=brewer.pal(n=8, name="RdYlBu"))


# Rmd/5-1.-Correlation-Analyses.html
install.packages("xtable", dependencies = T)
library(xtable)
# ggpubr : ggplot2패키지를 조금 더 쉽게 사용할 수 있도록 만든 패키지
library(ggpubr)

# 모수는 Pearson의 r을 줄 때
# 비모수의 Kendall은 tau를, Spearman은 rho를 줌
#   - 비모수는 rank(순위)기반의 상관계수를 나타냄!! "순위상관계수"

# 이 중 가장 많이 사용되는 것은, Pearson의 모수적 기법
# 상관분석에서의 df = n-2

library(dplyr)
library(knitr)

my_data <- mtcars
?kable # {knitr}
kable(sample_n(tbl = my_data, size=10, replace=FALSE), caption="A Test Data Set")

library(ggpubr)
# 상관분석 들어가기 전에는 산점도를 그려 
# 두 변수 간 선형적 관계가 있는지 확인한다!!
ggscatter(my_data,
          x = "mpg",
          y = "wt",
          add = "reg.line", # "회귀분석"의 결과인 <회귀선> 그림
          conf.int = TRUE, # 신뢰구간 표시
          cor.coef = TRUE, # 상관계수 표시 (R=-0.87, p = 1.3e-10)
          cor.method = "pearson",
          xlab = "Miles/(US) gallon",
          ylab = "Weight(1000 lbs)")
# --> 부상관이며, 거의 45도를 이루므로 뚜렷한 부상관.

# 원래 통계학에서의 산점도는,
# 두 변수 간 점이 찍히고, 
# 두 변수 간 상관분석 결과인 pvalue를 보여주고,
# r(상관계수)를 보여주고,
#   cf. 결정계수(r/R의 제곱)는, 분석의 신뢰도를 보여줌  ""검정력""
# 회귀분석의 결과인 회귀선(직선 or 곡선)을 보여줌.
#   회귀선은, 흩어져있는 점의 분산을 가장 잘 보여줌
#   점이 없어도, 회귀선을 보면 관계를 확인가능하다. 

# pvalue -> 대립가설 -> 관계가 있다 


# 상관분석의 결과를 신뢰하려면,
# 정해져있는 가정을 충족시키는지 여부를 먼저 테스트 해야함
# 1) 공분산이 선형적이냐? Yes : 산점도로 보니 가정만족
# 2) 산점도에서 회귀선이 곡선을 가지면 --> 비선형적 관계! / 선형적 관계 가짐
# 3) 두 변수가 정규성을 가지냐? --> 검정해야 함. --> 아래 검정해보니 정규성 따름
#     shapiro와 Q-Q plot
shapiro.test(my_data$mpg)
# 
# Shapiro-Wilk normality test
# 
# data:  my_data$mpg
# W = 0.94756, p-value = 0.1229 --> 귀무가설 채택 : 정규성가짐 (통계적으로 유의미하지X)
library(ggpubr)
ggqqplot(my_data$mpg) 
# 이상치outlier가 있지만 대부분 신뢰구간 안에 들어감.
# 신뢰구간에 걸쳤다면, 신뢰구간 안에 들어간다고 판단함.


shapiro.test(my_data$wt)
# Shapiro-Wilk normality test
# 
# data:  my_data$wt
# W = 0.94326, p-value = 0.09265 --> 귀무가설 채택 : 정규성 가짐 (통계적으로 유의미하지X)
ggqqplot(my_data$wt)
# 이상치outlier가 있지만 대부분 신뢰구간 안에 들어감.

# 정규성을 따르지 않으면
# 비모수적 -> Kendall rank-based correlation test
# 정규성 따르므로 -> Pearson
(res <- cor.test(my_data$wt, my_data$mpg, method="pearson")) # 검정의 결과인 list를 res변수에 담음
# Pearson's product-moment correlation
# 
# data:  my_data$wt and my_data$mpg
# t = -9.559, df = 30, p-value = 0.0000000001294
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.9338264 -0.7440872
# sample estimates:
#        cor 
# -0.8676594  -> 뚜렷한 부상관 관계
# 귀무가설 기각 -> 통계적으로 유의 : 두 변수 간 관계가 있다
res$p.value # list변수의 값 참조

# ***상관분석의 함정 조심!****


# 비모수 : bivariate이변량 normal정규 distribution분포를 따르지 않을 때 사용.
# Kendall rank-based correlation test
# 상관계수 : tau  (cf. Spearman -> rho)
(res2 <- cor.test(my_data$wt, my_data$mpg, method="kendall"))
# 
# Kendall's rank correlation tau
# 
# data:  my_data$wt and my_data$mpg
# z = -5.7981, p-value = 0.000000006706
# alternative hypothesis: true tau is not equal to 0
# sample estimates:
#        tau  --> 비모수 상관계수의 강도(모수상관관계 r과 해석 동일)
# -0.7278321    : 뚜렷한 부상관 관계
# 
# 경고메시지(들): 
# In cor.test.default(my_data$wt, my_data$mpg, method = "kendall") :
#   tie때문에 정확한 p값을 계산할 수 없습니다

# 통계적으로 유의한 결과 나옴: 대립가설채택


# Spearman rank-based correlation test
(res2 <- cor.test(my_data$wt, my_data$mpg, method="spearman"))
# 
# Spearman's rank correlation rho
# 
# data:  my_data$wt and my_data$mpg
# S = 10292, p-value = 0.00000000001488
# alternative hypothesis: true rho is not equal to 0
# sample estimates:
#       rho  --> 스피어만의 상관계수
# -0.886422  --> 뚜렷한 부상관 관계
# 
# 경고메시지(들): 
# 1: In cor.test.default(my_data$wt, my_data$mpg, method = "kendall") :
#   Cannot compute exact p-value with ties
# 2: In cor.test.default(my_data$wt, my_data$mpg, method = "spearman") :
#   tie때문에 정확한 p값을 계산할 수 없습니다

# 통계적으로 유의: 대립가설 채택 -> 상관관계 있음

# 상관계수가 -1일 때
# 확률변수 X가 증가할 때마다, Y의 값이 매번 감소한다.



# ------- 상관행렬Correlation Matrix--------
# Rmd/5-2.-Correlation-Matrix.html

# 결측치 부분 연습
cor(x, method= "pearson", use="complete.obs") # use옵션: 완전히 제거하라는 뜻
# 가장 많이 쓰는 use 옵션은, "pairwise.complete.obs"이다.

data("mtcars")
#  숫자형변수  mpg, disp, hp, drat, wt, qsec 만 가져와서 my_data에 담음
my_data <- mtcars[, c(1,3,4,5,6,7)]

library(dplyr, quietly = TRUE)
# 완전확률화에 기반한 비복원추출로 10개로 구성된 데이터 뽑음
rsd <- sample_n(tbl=my_data, size=10, replace=FALSE) # {dplyr} 

# 예쁘게 보여주기
library(knitr)
kable(x = rsd, caption = 'A random sampling data of a my_data')


# 데이터가 결측치(NA)를 포함한다면, 
# R에서는, case(=관측치)-wise deletion을 수행할 수 있다!
# -> 이를 cor,test/cor의 use 옵션에 지정해준다

# cor()는 상관계수만을 반환(not 검정통계량, pvalue)함.
# --> 뒤에 Hmisc의 함수로 한꺼번에 볼 수 있는 방법 사용하자
(res <- cor(my_data))  # 상관행렬 (not 상관행렬도: 그림)
# 이것 보고 insight 도출하세요

round(res, 2) # R에서 기본 소수자리 표시 수는 7자리수라 줄여서 보여줌


# pvalue와 correlation matrix 함께 보여주기!!
# --> Hmisc::rcorr() : 검정 결과까지 함께 보여줌
library(Hmisc)
(res2 <- rcorr(as.matrix(my_data), type="pearson"))
# 데이터를 행렬로 변환 후 인자로 줌! --> rcorr이 행렬을 요구하므로


#        mpg  disp    hp  drat    wt  qsec
# mpg   1.00 -0.85 -0.78  0.68 -0.87  0.42
# disp -0.85  1.00  0.79 -0.71  0.89 -0.43
# hp   -0.78  0.79  1.00 -0.45  0.66 -0.71
# drat  0.68 -0.71 -0.45  1.00 -0.71  0.09
# wt   -0.87  0.89  0.66 -0.71  1.00 -0.17
# qsec  0.42 -0.43 -0.71  0.09 -0.17  1.00
# 
# n= 32 
# 
# 
# P
#      mpg    disp   hp     drat   wt     qsec  
# mpg         0.0000 0.0000 0.0000 0.0000 0.0171
# disp 0.0000        0.0000 0.0000 0.0000 0.0131
# hp   0.0000 0.0000        0.0100 0.0000 0.0000
# drat 0.0000 0.0000 0.0100        0.0000 0.6196
# wt   0.0000 0.0000 0.0000 0.0000        0.3389
# qsec 0.0171 0.0131 0.0000 0.6196 0.3389  

# drat-qsec / wt-qsec의 상관계수는 유의하지 않으므로 믿으면 안 됨.
# corr()은 조합가능한 상관계수의 값을 보여주지만
# Hmisc::rcorr()은 검정통계량까지 함께 보여줌.


# 사용자 정의함수를 사용하면, rcorr() 출력 결과를 보기 좋게 설정가능.
flattenCorrMatrix <- function(cormat, pmat) {
  # upper.tri{base} : Lower and Upper Triangular Part of a Matrix
  #   - return class : matrix
  #   - including logical values in all each cell of the returned matrix
  ( ut <- upper.tri(cormat) )
  
  # create a data frame
  #   - row{base} : Row Indexes
  #   - col{base} : Column Indexes
  #   - rownames{base} : Row Names
  #   - colnames{base} : Column Names
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
} # flattenCorrMatrix
  
library(Hmisc, quietly = TRUE)

res2 <- rcorr( as.matrix( mtcars[ ,1:7] ) )
flattenCorrMatrix(res2$r, res2$P)  # -> long 타입으로 rcorr() 결과 보여줌
# res2$r : 상관계수 / res2$P : pvalue

# 상관행렬 시각화
# 1) symnum{stats}
# 2) corrplot{corrplot}
# 3) ggscatterplt?
# 4) Hitmap


# 1) symnum{stats}
# 상관을, symbol로 대체(text기반) -> 보기 힘듦.
symnum(
  x,  # 상관행렬
  cutpoints = c(.3, .6, .8, .9, .95),  # 상관계수의 자르는 지점
  symbols = c(" ", ".", ",", "+", "*", "B"), # 상관계수의 정도에 따라 보여줄 "기호"를 정함
  abbr.colnames = TRUE
)
# cutpoints 0~0.3:    " "
# cutpoints 0.3~0.6:  "."
# cutpoints 0.6~0.8:  ","
# cutpoints 0.8~0.9:  "+"
# cutpoints 0.9~0.95: "*"
# cutpoints 0.95~1:   "B"

symnum(res, abbr.colnames = FALSE)
#     mpg disp hp drat wt qsec
# mpg  1                       
# disp +   1                   
# hp   ,   ,    1              
# drat ,   ,    .  1           
# wt   +   +    ,  ,    1      
# qsec .   .    ,          1   
# attr(,"legend")
# [1] 0 ‘ ’ 0.3 ‘.’ 0.6 ‘,’ 0.8 ‘+’ 0.9 ‘*’ 0.95 ‘B’ 1


# 2) corrplot()
library(corrplot)
corrplot(res, type="upper", order="hclust", tl.col = "black", tl.srt = 45)
# tl.col : 변수명 색
# tl.srt : 변수명 기울기(겹침방지)

corrplot(res2$r, type="upper", order="hclust", p.mat=res2$P, sig.level = 0.01, insig="blank")
# p.mat: Pvalue 행렬지정
# sig.level: 유의수준(α) (0.01로 지정 시 99%)
# insig: 유의수준 달하지 않는 것 어떻게 처리하는지 지정
#       (blank : 통계적으로 유의하지 않은 부분 보여주지 않음)

corrplot(res2$r, type="lower", order="hclust", p.mat=res2$P, sig.level = 0.05, insig="blank")


# 3) scatter plot
install.packages("PerformanceAnalytics", dependencies = T)
library(PerformanceAnalytics)

my_data <- mtcars[, c(1,3,4,5,6,7)]
# 상관계수와, 통계적으로 유의한 정도(pvalue에 첨자로 붙는 */**/***)를 함께 보여줌
# 대각선에는, 특정 변수의 확률밀도 + 히스토그램을 함께 보여줌 : "확률분포표"
#     --> 해당 변수의 정규성 여부, 왜도, 첨도 등 볼 수 있음.
# scatter plot은 적합선!(회귀분석으로 나온 회귀선)
chart.Correlation(my_data, histogram = TRUE, pch=19) 
# histogram: false면 bar plot 그림 보여주지x


# 4) Heatmap - 많은 색상이 필요
col <- colorRampPalette(c("blue", "white", "red"))(20) # {grDevices}
# 지정한 세개의 색상 사이에서 20개의 색상을 만듦.
col # 함수를 받음
heatmap(x = res, col = col, symm=TRUE) # {stats}
# symm: 대칭인지 여부


# correlogram으로 시각화 ---------
library(dplyr, quietly = TRUE)
(rs <- sample_n(tbl=mtcars, size=10, replace=FALSE)) # {dplyr} / 비복원추출

# 예쁘게 보여주기
library(knitr, quietly = TRUE)
kable(x=rs, caption="The random sampling of mtcars data set")

# 상관행렬 만들기
(M <- cor(mtcars))
# 색 생성
col<- colorRampPalette(c("red", "white", "blue"))(20)
library(RColorBrewer)
?brewer.pal # 팔레트에 따른 색상 수 지정되어 있음.
brewer.pal(n=8, name="RdBu")

library(corrplot, quietly = TRUE)
# 시각적으로, 상관관계의 강도를 보여줌
corrplot(M, p.mat = res2$P, sig.level = 0.01,
         type = "full", order="hclust", method="circle",
         col=col, bg="lightblue", 
         tl.col = "blue", tl.srt = 45)
corrplot(M, method="square")
corrplot(M, method="ellipse")
corrplot(M, method="shade") # 빗금친 사각형 -1에 가까우면 빗금!
corrplot(M, method="color")
corrplot(M, method="pie") # 칠해진 pie면적이 상관계수의 정도
corrplot(M, method="number")
# 첫 인자에는, 상관행렬
# type : 그래프의 어디를 그려주는지/ "full" "upper" "lower"
# p.mat : pvalue 값 넣어줌
# sig.level : 유의수준 적어줌
# method : 그려지는 도형  “circle”, “square”, “ellipse”, “number”, “shade”, “color”, “pie”
# order : "hclust" : 같은 계열을 모아주는 군집화 (정상관끼리 / 부상관끼리 모음)
# color : 칠해지는 색 지정 / c("black", "white")와 같이도 지정가능 / brewer.pal(n=8, name="RdBu")와 같이 지정 가능
# bg : 배경색 지정
# tl.col : 변수명 색상 지정
# tl.srt : 변수명 적는 각도 지정 (45도면 변수명 길어도 겹치지 않음)


# 사용자 함수로 출력가능
# 아래함수는, 교차분할표안에 pvalue를 표시하도록 함.
cor.mtest <- function(mat, ...) {  # ... : 가변인자 의미
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}

# matrix of the p-value of the correlation
p.mat <- cor.mtest(mtcars)

# Specialized the insignificant value according to the significant level
corrplot(M, type="upper", order="hclust", p.mat = p.mat, sig.level = 0.01)
head(p.mat[, 1:5])



# correlogram 커스터마이징
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))


corrplot(
  M,
  method="color",
  col=col(200),
  type="upper",
  order="hclust", 
  # Add coefficient of correlation
  addCoef.col = "black",  # 유의수준 값
  #Text label color and rotation
  tl.col="red",           # 변수명 색
  tl.srt=45,
  # Combine with significance
  p.mat = p.mat,
  sig.level = 0.01,
  insig = "blank",
  # hide correlation coefficient on the principal diagonal
  diag=FALSE            # 대각선 보여주지 않음
)


# 텍스트 기반의 상관행렬도
# xtable 이용하여, 상관관계 표시
# Rmd/5-4.-Elegant-correlation-table.html

# 상관행렬
(mcor <- round(cor(mtcars), 2))

# triangle part : 대각선 위나 아래의 삼각형 의미
# --> 윗부분만 그릴지 아래부분을 그릴지를 logical값으로 리턴함.
# --> boolean 추출에 사용됨
# diag인자로, 대각선 표시할지말지 지정
upper.tri(mcor, diag = FALSE)  # {base} / 위쪽 삼각형만 TRUE / 대각선과 아래는 FALSE 
upper.tri(mcor, diag = TRUE)   # 
lower.tri(mcor, diag = FALSE)  # {base} / 아래쪽 삼각형만 TRUE / 대각선과 위는 FALSE


upper <- mcor
upper[ upper.tri(mcor) ] <- ""  # 위쪽인 TRUE에 빈 문자열 줌.
( upper <- as.data.frame(upper) )

lower <- mcor
lower[ lower.tri(mcor, diag=TRUE) ] <- ""
( lower <- as.data.frame(lower) )

# xtable 패키지 이용
library(xtable)
print(xtable(upper), type="html")  #해당 표를 html문법으로 표현 시를 보여줌 

# 사용자 정의함수
corstars <-function(
  x,
  method=c("pearson", "spearman"),
  removeTriangle=c("upper", "lower"),
  result=c("none", "html", "latex")) {
  
  #Compute correlation matrix
  require(Hmisc)
  
  x <- as.matrix(x)
  
  correlation_matrix <- rcorr(x, type=method[1])
  
  R <- correlation_matrix$r # Matrix of correlation coeficients
  p <- correlation_matrix$P # Matrix of p-value 
  
  ## Define notions for significance levels; spacing is important.
  mystars <- ifelse(p < .0001, "****", ifelse(p < .001, "*** ", ifelse(p < .01, "**  ", ifelse(p < .05, "*   ", "    "))))
  
  ## trunctuate the correlation matrix to two decimal
  R <- format( round( cbind( rep(-1.11, ncol(x) ), R ), 2 ) )[,-1]
  
  ## build a new matrix that includes the correlations with their apropriate stars
  Rnew <- matrix( paste( R, mystars, sep="" ), ncol=ncol(x) )
  diag(Rnew) <- paste( diag(R), " ", sep="" )
  rownames(Rnew) <- colnames(x)
  colnames(Rnew) <- paste(colnames(x), "", sep="")
  
  ## remove upper triangle of correlation matrix
  if(removeTriangle[1]=="upper") {
    Rnew <- as.matrix(Rnew)
    Rnew[upper.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove lower triangle of correlation matrix
  else if(removeTriangle[1]=="lower") {
    Rnew <- as.matrix(Rnew)
    Rnew[lower.tri(Rnew, diag = TRUE)] <- ""
    Rnew <- as.data.frame(Rnew)
  }
  
  ## remove last column and return the correlation matrix
  Rnew <- cbind(Rnew[1:length(Rnew)-1])
  if (result[1]=="none") return(Rnew)
  else {
    if(result[1]=="html") print(xtable(Rnew), type="html")
    else print(xtable(Rnew), type="latex") 
  }
}

corstars(mtcars[,1:7], result="html")



# 5-5.-Correlation-matrix-All_R_functions.html는 스스로 해보기

# 적용)
# 10a당 질소사용량에 따른 벼수량 (14장. 상관분석_v0.1_20180812.ppt page28, 30)
# 