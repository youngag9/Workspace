# 통계분석
# 기술통계분석에서, 집단 간 차이가 있는 것으로 나타났더라도
# 이는 우연에 의한 차이일 수 있음
# --> 데이터를 이용해 신뢰할 수 있는 결론을 내리려면, 
# 유의확률을 계산하는 통계적 가설검정절자를 거쳐야 한다

# 가설검정은, 두 집단 간 발생한 차이가, "우연히 발생했는지" or "통계적으로 의미있는지"를 검정하는 것
# 가설검정의 목적은 대립가설이지만, 방법은 귀무가설임.
# 통계적 가설검정 : 유의확률을 이용해 가설을 검정하는방법
# **유의: '통계적으로 의미가 있다'는 뜻. 

# * 가설검정에 필요한 통계량의 종류
# 1) 기각값: 귀무가설을 기각시킬 기준값
# 2) 검정통계량: 기각값과 비교하여, 귀무가설을 기각 또는 채택가능하도록 하는 통계량.
  # 검정통계량이 기각값보다 크면, 귀무가설을 기각시킨다.
  # if 검정통계량 > 기각값, then 귀무가설 기각 -> 대립가설 채택
  # 확률변수 X로부터 구한 통계량.
  # 만약, 확률변수 X가 정규분포를 따르고, 모집단도 정규분포를 따른다면,
  # μ를 중심으로 모집단이 종모양을 따름. α는 귀무가설이 맞는데 기각할 확률이므로,
  # X가 정규분포를 따르면, 유의확률은 오른쪽 끝부분에 위치하면 5%임. 이때의 X값이 기각값.
  # 분포에서 기각값의 오른쪽이 기각역이므로, 검정통계량이 기각값보다 크다면, 기각역에 속하므로 귀무가설을 기각한다.
# *기각값을 결정하려면, 반드시 유의수준이 있어야 함.
# 유의수준값이 정해지면, 만약 0.05라면, 확률변수 X의 분포에서, 5%에 해당하는 면적이 되는 X값을 찾으면.
# 해당 값이 기각값이 된다.
# 보통, 기각값을 찾기 위해 확률별로 기각값을찾아낸 "분포표"를 제공한다.
# 해당 값이, 정규분포를 따른다면 "정규분포표", 카이제곱분포를 따른다면, "카이제곱분포표" ,..
# 분포표가 있고 & 유의수준이 결정된다면, --> 기각값을 알 수 있다. 
# --> 채택역/기각역이 나온다
# --> 이제 검정통계량을 구하면 귀무가설 채택/기각 여부를 알게 된다.

# 3) 유의수준(통계기호로는, α/ =허용한계오차) : 제 1종 오류 / 귀무가설을 채택/기각시킬지 기준이 되는 확률 
  # α = 0.05 / 0.03 / 0.01 / 0.001 (이것은 확률임)
  # 실험의 유의수준을 0.05로 지정: 동일한 실험을 100번 반복했을 때, 제 1종오류(H0이 맞는데 기각하는 오류)를 일으킬 확률이 100번 중 5번이다!
  # 연구자가 임의대로 정하되, 인문학에서는 0.05 , 생물학에서는 0.001까지로 관례화되어 있다.
  # 유의수준이 001정도로 낮추면, "고도로 유의하다"라고 한다.
  # cf. 제 2종 오류는, 새로운 실험의 결과이므로 알 수 없음. 이것을 알기 위해서니까!
# * 유의수준(=허용한계오차)을 정하면, 이 확률에 맞는 값으로 기각값을 자동으로 정한다.
#     유의수준 확률에 맞는 기각값을 찾아내는 것은, 확률변수 X의 확률분포로부터 얻어냄.
#     X의 정규분포의 5%로에 해당하는 값을 뽑아냄.

# 4) 유의확률(통계기호로는, p-value) : 실제로는 집단 간 차이가 없는데,
  # 우연하게 차이가 발생할 확률. 
  # 차이가 인정이 안된다면, 귀무가설이 맞으므로 채택
  # 유의확률이 매우 작게 나왔다면, 그 차이가 우연이 아니라는 얘기 --> 대립가설 채택. --> 통계학적 차이 인정
# 집단 간 차이가 발생했을 때, 이 차이가 우연하게 발생했을 확률
# 우연히 발생할 확률이 작을수록, 진짜 차이가 있다는 것!
# 필연이 커진다는 것.
# 유의확률이 크게 나타난다면, 집단 간 차이가 통계적으로 유의하지 않다고 해석
# "유의확률이 높게" 나온다면, ""유의하지 않다""는 것!!

# 기술통계량 (~별 ~)가 고급분석의 시작이므로, 이를 구해봐야 함.
# 기술통계량으로, 집단의 현황을 봄.
# 분산분석: 두 집단의
# 세집단의 평균의 차이를 통해 분산분석을 통해 구하는데 한계가 있음.
# 몇번째 그룹에서 차이가나는지는 분산분석이 알려주지 않으므로
# "평균의 다중비교" 어떤 평균이 어떤 또 다른 평균과 실제 차이가 나는지 알 수 있음

# -----------------------------------
# t검정 : 두 집단의 평균이 통계적으로 유의한지
# 두 모집단에서, 각각 표본을 뽑아냄. : 모집단이 다른 데이터: "독립적인 데이터(independent data)"
# 두 표본집단에서 평균이 차이가 난다
# --> t검정을 해보자 (from t분포)
# 왜 정규분포를 안쓰고, 평균의 차이를 검정 시, t분포를 쓸까?
# t분포는 어떻게 생겼는가?
# t분포는 정규분포의 일부지만, 모집단의 모분산을 알면 정규분포(Z분포/ 정규분포 이용한 검정:Z-검정)
# t분포는 모분산을 모르고, 소표본(표본의 크기가 30개 미만일 때)일 때 사용한다.
# 왜 t 확률분포가 필요할까?
# 유의수준이 t분포를 따름. 유의수준의 분포를 알아야 기각값을 알고 가설 채택/기각을 알 수 있음.

library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)

library(dplyr)
mpg_diff <- mpg %>%   # 차이 비교하기 위해 두 변수를 뽑아냄
  filter(class %in% c("compact", "suv")) %>% 
  select(class, cty)

head(mpg_diff)

table(mpg_diff$class)  # 빈도수를 뽑아냄
# 
# compact     suv 
# 47      62 

# 시각화
boxplot(mpg_diff$cty, col='yellow') # cty {graphics} --> 차종별 박스플롯 비교가 아님
# --> class로 구분지어서 나와야 함. / 1. 박스에 색상입히기
# boxplot 사용법익히기
boxplot(mpg$cty, mpg$hwy, col='lightgray') # 그룹을 만든게 아니라
# 1이 도시연비, 2가 고속도로 연비
boxplot(data = mpg_diff, cty~class, col='lightgray') # cty~class가 formula임.
#  ** formula **
#   범주형변수와 연속형변수를 함께 쓰는 식.
#   [ 연속형변수 ~ 범주형변수 ] 와 같은 형식으로 쓴다.
#   오른쪽의 범주형변수대로 그룹이 만들어지고, 연속형변수는 그루핑된다.

#  시각화의 결과, 차이가 극명하게 나므로, 
#   --> 사실, 가설검정이 필요하지 않다.
#     + 중앙값과 평균은 사실 비슷한 곳에 위치하나

# 기술통계량 구하기
# 두 집단의, 평균 연비를 구해보자
class_cty <- mpg_diff %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty))
View(class_cty)

# t-test
t.test(data=mpg_diff, cty~class, var.equal=T)  # {stats}
# t.test의 결과, 검정통게량인 t값과 유의수준?도 출력
# var은 분산인데, 두 변수의 분산이 같으면(등분산이면) var.equal=T로 준다
# 등분산인지 어떻게 아나?
#   도시연비에 영향을 주는 다른 변수가 없고, class에 따른 연비라는 식을 따르므로
#   등분산이라고 생각할 수 있으므로, var.equal에 T값을 준다.
# data : 검정할 데이터, formula: 범주형 변수에 따른 그룹을 만드는 식


#* Y's R>t.test(data=mpg_diff, cty~class, var.equal=T)  # {stats}
# 
# Two Sample t-test  --> t-test는 두 모집단에서 뽑아내는데
#                     현재 식에서 모집단은, mpg_diff하나인 것 같음.
#                     하나의 데이터프레임에 들어있어 하나의 집단처럼 보이지만
#                     클래스가 다르므로, 두개의 모집단이라고 할 수 있음
# 
# data:  cty by class
#  ------ 이 아래가 검정통계량 -------------
# t = 11.917, df = 107, p-value < 2.2e-16
#  : t값과, df(자유도)=n-1 (t-test에서!!), p-value: 유의확률(유의수준을 0.05로 했을 때 검정통계량의 확률/ 우연히 발생할 확률)
#    R에서는 유의확률이 너무 작으면, 2.2e-16으로 나옴.
#    검정통계량에 대한 t-분포에 대한 확률
#    유의수준은 연구자가 정함. 만약, 유의수준이 0.05라면 이때 귀무가설기각! 대립가설채택!
#    차이가 있다!! --> 앞에서 박스플롯에서 확인한 결과와 같다.
# --> "유의수준 0.05" 혹은 "5% 유의수준하에서", 
# "두 집단의 평균의 차이가 인정된다"
# 혹은 "두 집단의 평균의 차이가 유의하다"고 표현함.
# ----------------------------------------
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   5.525180 7.730139       --> 모수의 범위. 즉, 여기서는 모평균의 범위
#                             모수는 상수이므로, 고정된 값이니까
#                             모수가 이 구간 안에 있다!!라고 표현한다.
# ---------------------------------------
# sample estimates:
#   mean in group compact     mean in group suv   --> 그룹별, 기술통계량을 내줌
# 20.12766              13.50000                      6.62가 모수의 구간안, (5.525180 7.730139)범위 안에 있음.
#----------------------------------------
# 대부분의 검정이,
# 검정통계량인 t값과, 자유도, p-value(유의확률),
# 모수의 범위 (95% 신뢰수준하의 신뢰구간) --> 표본평균으로부터 모수의 범위를 추정한 것!!
# 기술통계량을 알려줌


# 각 검정은, 가정이 있으므로, 
# 검정에 전제되어 있는 가정을 만족하고 있는지 확인해야 함.


# 일반 휘발유와 고급휘발유의 도시연비 t검정

# 1. 검증하고자 하는 변수의 확률분포곡선을 그리자.
# 무슨 확률분포를 따르는지 알고 있어야 함.
# t-test는 연속변수이고, t분포를 따라야 함, 모수를 모르고, 소집단일 때!
# 도시연비가 정규분포를 따르는지/ t분포를 다르는지.. 알아야 함!
# 종모양을 만들지 못하면(정규분포를 따르지 못하면) --> 정규성을 갖도록 정규화해야 함.
df_mpg <- ggplot2::mpg
cty <- df_mpg$cty
hist(cty, freq=F, breaks=100)
lines(density(cty), col='red', lwd=2)  # 그리니까, 오른쪽 꼬리분포.
# 왜도(=비대칭도)가 양수니까, 오른쪽 꼬리분포 --> 실제 왜도가 무슨값 갖는지 구하자
??skew
# e1071::skewness()
library(e1071)
skewness(cty) # 0.7863773 --> 양수이니까 오른쪽 꼬리분포 / 0이었으면 정규분포
# 왜도가 5.0이상이면, 많이 치우친 것(왜도가 5이상인 많이 치우친 분포를, "카이제곱분포"라고 한다.). 지금은 약간 치우친 것!
# 약간 치우쳤으니가 t-test가능!

# 왜도의 통계기호는 Sk(k는 아래첨자)
# Sk = 0: 정규분포 / Sk > 0 : 오른쪽꼬리분포 / Sk < 0: 왼쪽꼬리분포

# 2. 데이터준비
mpg_diff2 <- mpg %>% 
  filter(fl %in% c("r", "p")) %>%  # regular, premium
  select(fl,cty)  # fl : 범주형변수

table(mpg_diff2$fl)

# t-test
# formula를 매개변수로 가짐. 
# R의 함수에는, y(연속)~x(범주) : 범주별 연속형 변수의 값.
# 두 집단의 표본이 등분산을 갖고 있는지 체크하는데.
# 등분산 검정은 bar.test() 이지만, 주어진 변수의 값으로 등분산여부를 판단할 수 있다
# 한 변수로, 분류를 쪼개기 때문에, 등분산이라고 생각할 수 있으므로,
# var.equal=T로 둘 수 있다.

t.test(data=mpg_diff2, cty~fl, var.equal = T)

# t-test는, 독립테스트, twosample, paired 의 세가지가 있음
# t-test()가 내부에서 범주별로 평균을 구해줌. 
# 원래는, 기초통계량 확인하고 차이가 있는것 같으면 검정하는 것이 맞음.

# Two Sample t-test
# 
# data:  cty by fl
# t = 1.0662, df = 218, p-value = 0.2875
#    : t통계량값 1.062 / 자유도 218 / 통계량의 유의확률 0.2875
#     유의확률 : 우연히 발생할 확률이 28프로이므로, 귀무가설 채택
#     일반휘발유에 대한, 도시연비는 차이가 없다. 유의미하지 않다
# 
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:  # 95%의 유의수준하에
#   -0.5322946  1.7868733
# sample estimates:
#   mean in group p mean in group r 
# 17.36538        16.73810 


# 정말 분포가 차이가 별로없는지 박스플롯 그려보자
mpg <- ggplot2::mpg
boxplot(cty~fl, data=mpg, col='green')
# 프리미엄 휘발유 차이 있어보였는데, t-test하니까 큰 차이가 없다

boxplot(cty~fl, data=mpg_diff2, col='green')$stats
#     [,1] [,2]
# [1,] 11.0   11
# [2,] 15.5   14
# [3,] 18.0   16
# [4,] 19.5   19
# [5,] 23.0   26
# attr(,"class")
# p 
# "integer" 

# boxplot 연습
#---------------------------------
boxplot( mpg$cty, col='lightgray' )
boxplot( mpg$cty, mpg$hwy, col='lightgray' ) 
boxplot( count ~ spray, data=InsectSprays, col = 'lightgray')
boxplot( cty ~ fl, data=mpg, col='lightgray' )
boxplot( cty ~ class, data=mpg, col='lightgray' )
boxplot( cty ~ cyl, data=mpg, col='lightgray' )
boxplot( cty ~ year, data=mpg, col='lightgray' )
boxplot( cty ~ displ, data=mpg, col='lightgray' )
boxplot( cty ~ drv, data=mpg, col='lightgray')
boxplot( cty ~ trans, data=mpg, col='lightgray')

qplot( hwy, data=mpg )
qplot( hwy, data=mpg, binwidth=2 )
qplot( hwy, data=mpg, binwidth=2, fill=drv )
qplot( hwy, data=mpg, binwidth=2, fill=drv, facets=.~drv ) # .은 전부를 의미
qplot( hwy, data=mpg, binwidth=2, fill=drv, facets=drv~. )
qplot( hwy, data=mpg, fill=drv, facets=.~drv, geom='bar' )

qplot( displ, hwy, data=mpg )
qplot( displ, hwy, data=mpg, color=drv )
qplot( displ, hwy, data=mpg, color=drv, facets=.~drv )
qplot( displ, hwy, data=mpg, color=drv, facets=drv~.)
qplot( displ, hwy, data=mpg, color=factor(drv) )
qplot( displ, hwy, data=mpg, color=factor(fl) )
qplot( displ, hwy, data=mpg, color=factor(class) )

qplot( displ, hwy, data=mpg, color=factor(fl), size=cyl )
qplot( displ, hwy, data=mpg, geom=c('point', 'smooth' ) )
#---------------------------------

# 두 변수 간 관계 분석: 회귀(R=r의제곱: 결정계수) 상관(r: 상관계수) 교차 분석 등등

# 두 변수 간 관계이므로, 산점도를 먼저 그린 후.
# 상관분석을 함.
# 상관분석 : 두 연속형 변수의 관계성을 븐석
# 상관의 정도를 수치화해서 보여주는 것이 "상관계수(r)"
# 
# 상관계수는 -1~1 사이의 값을 갖고, 
# 절대값이 1에 가까울수록 상관성 크다(상관의 정도가 높다)
# 0에 가까울수록 무상관.
# 0보다 크면서, 1에 가까우면, 정상관
# 0보다 작으면서, -1에 가까우면, 부상관
#  


# 실업자수와 개인소비지출의 상관관계
# economics: 미국의 경제상황 dataset
economics <- as.data.frame(ggplot2::economics) # tibble이므로 df로
str(economics)
# 'data.frame':	574 obs. of  6 variables:
#   $ date    : Date, format: "1967-07-01" "1967-08-01" ...
# $ pce     : num  507 510 516 512 517 ... : 개인소비경향
# $ pop     : num  198712 198911 199113 199311 199498 ...
# $ psavert : num  12.6 12.6 11.9 12.9 12.8 11.8 11.7 12.3 11.7 12.3 ...
# $ uempmed : num  4.5 4.7 4.6 4.9 4.7 4.8 5.1 4.5 4.1 4.6 ...
# $ unemploy: num  2944 2945 2958 3143 3066 ...
# 보고자하는 변수의 타입과 연속형변수임을 확인할 수 있음


# 두 변수가 연속형변수인지 확인
# 변수 간 관계확인 위해, 산점도 그림
plot(economics$unemploy, economics$pce) # 뱀모양그림
# --> 상관분석의 "눈속임효과" : 양끝의 점만 연결하면 정상관이라고 생각할 수 있음


# 분석기법의 가정마다, 귀무/대립가설이 정해져 있다.

# 상관분석 / 검정
# cor.test # {stats}
cor.test(economics$unemploy, economics$pce)
#  -- 피어슨의 상관계수
#  -- 상관분석은 피어슨, 스피어만, ..
# 	Pearson's product-moment correlation
# 
# data:  economics$unemploy and economics$pce
# t = 18.63, df = 572, p-value < 2.2e-16
# t분포를 기반으로 검정통계량 내는 구나 : 실데이터는 대부분 정규분포와 유사한 t분포 기반으로 함
# 0.05보다 작다 : 우연히 발생한 것이 아니다 -> 귀무가설 기각
# t-test를 95% 유의수준하에서, 유의하다. (대립가설 채택: 우연이 아니다)
# 즉, 두 연속형 변수 간 상관성이 있다.
# 
# --- 대립가설의 내용을 보여줌
# alternative hypothesis: true correlation is not equal to 0
#     : 참인 상관성이 0이 아니다. (상관성이 있다)
# --> H0: 두 연속형 변수 간에 관계가 없다. (보통 부정적인 내용이 귀무가설)
# 95 percent confidence interval:
#   0.5608868 0.6630124
# sample estimates:
#   cor 
# 0.6145176    # 상관계수값. r = 0.6145176 
# 계수는 '표준화'한 값이기 때문에, 퍼센트가 아님! 
# 0.5이상이므로, 두 변수 간 뚜렷한 상관성이 있다(0.3~0.7)고 할 수 있음.
# 양수이므로, 정상관임

# scatter plot에서는, 눈속임효과 발생하므로,
# 상관분석은 반드시 시각화를 해봐야 한다.


# 상관행렬 Correlation Matrix
#   다변량데이터가 갖는, 여러 변수 간 상관분석을 동시에 수행 시,
#   상관행렬도를 그림.
# 어떤 변수끼리 관련이 크고 작은지 파악할 수 있음

# 데이터셋 준비
head(mtcars) # datasets::mtcars
str(mtcars)
?mtcars

# 상관행렬도 만들기
car_cor <- cor(mtcars)  # cor(다변량데이터갖는 df)
View(car_cor)  # 위아래 동일한 변수들이 있고,
# 이 안의 값들이 상관계수(r)임. 
# 대각선은 동일 변수이므로, 완전 상관일 떄의 상관계수인 1을 가짐.
# 대각선을 대칭으로, upper와 lower가 같은 상관계수 값을 가짐.

str(car_cor)
#  num [1:11, 1:11] 1 -0.852 -0.848 -0.776 0.681 ...
#  - attr(*, "dimnames")=List of 2
#   ..$ : chr [1:11] "mpg" "cyl" "disp" "hp" ...
#   ..$ : chr [1:11] "mpg" "cyl" "disp" "hp" ...


# 상관행렬의 히트맵 만들기
# 히트맵: 값의 크기를 색으로 표현한 그래프

# install.packages("corrplot", dependencies=T)
library(corrplot)

corrplot(car_cor)  # 시각화한 결과
# 색이 진할 수록, 파란색이면 정상관의 정도가 커지고
# 색이 진할 수록, 빨간색이면 부상관의 정도가 커진다.
# 시각화결과로 insight 도출
# mpg와의 상관성변수: cyl은 부상관이므로, 실린더가 커지면 mpg(연비)작아짐
# 지금은, p-value가 안나옴

# --> 히트맵에 상관계수 표시
corrplot(car_cor, method="number") # 원대신 상관계수 보여줌

# --> 히트맵의 색 지정
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(car_cor,
         method = "color",
         col = col(200),  # 지정한 색 사이사이에서, 색상 200개 지정
         # type = "lower", # 아럐만 보여줌
         type = "upper",
         order = "hclus", # 비슷한 것끼리 군집화 --> 같은 색끼리는 모임
         addCoef.col = "black",  # 상관계수 색
         tl.col = "black", #변수명 색
         tl.srt = 45, # 변수명 45도 기울임
         # diag = F ) # 대각행렬 제외 / 같은 변수끼리 연결된 것 없앰
         diag = T )  # T/F의 변수의 위치가 변경됨

# corrplot은, p-value는 보여지지 않아, 검정까지는 한 번에 못함




