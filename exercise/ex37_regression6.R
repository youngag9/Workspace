# 회귀모형에서 이상치(Outlier)의 확인
# (참고) https://m.blog.naver.com/PostView.nhn?blogId=ilustion&logNo=220285462430&proxyReferer=https%3A%2F%2Fwww.google.com%2F
# 대부분의 관측치와 비교 시, 정상적인 표본이라고 볼 수 없는 값을 이상치라 한다.
# 회귀모델이 이상하게 만드는 관측치
# 회귀모형의 회귀계수 결정에 큰 영향을 주는 관측치

# 이상치의 종류 (바라보는 관점에 따라 이름을 다르게 붙인 것)
# (1) 이상치(Outlier)
# (2) 큰-지렛대 점(High-leverage Point) (힘이 센 데이터)
#     : 특정 관측치인데, 회귀모형을 통해 나오는 추정값(예측값)에
#       지대한 영향을 끼치는 관측치 / 수식 상으로 분리됨.
#     - 주로, 독립변수와 관련된 것임.
#     - 수식: 어떤 데이터포인트(관측치)가 예측치를 끌어당기는 정도
# (3) 영향치(Influencers)     (힘이 센 지렛대가 이상치면, 영향치..?)
#     : 종속변수의 값 중에 영향력 있는 데이터포인트.


# 힘이 센 High-leverage Point찾고, outlierTest에서 이상치로 나온 것이
# High-leverage Point와 같으면 -> High-leverage Point는 이상치가 되므로
# 영향치라 할 수 있음?

#---------
# (1) 이상치의 판단
#     : 회귀모델로 잘 예측할  수 없는 관측치
#     - 이상치로 인해 대체로, 큰 양수나 음수의 잔차를 가지게 됨.
#
#   잔차(오차) = 종속변수의 관측치 - 종속변수의 추정치(예측값)
#      ε = y - y^ 
#     - 잔차가 커진다는 의미는, y^(예측치)가 커지거나 작아진다는 의미.
#   가. 과대추정: 잔차ε가 -방향으로 클수록, y^가 관측치보다 더 크게 추정.
#   나. 과소추정: 잔차ε가 +방향으로 클수록, y^가 관측치보다 더 작게 추정.


df_states <- 
  as.data.frame(
    state.x77[, c('Murder', 'Population', 'Illiteracy', 'Income', 'Frost')]
  )

fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data = df_states)

# --------------------------
# (1) 이상치 검정
# --------------------------
# 방법-1: Q-Q Plot

# qqPlot{car}
qqPlot(fit)

# 방법-2: outlierTest{car} - 이상치 검정
# 통계적 가설:
#   H0: No outlier
#   H1: Not H0

library(car)
# 잔차 중 가장 큰 잔차를 갖는 데이터포인트 하나만 이상치 검정하기 때문에,
# 반복적으로 수행해야 한다.
# 만약, 출력값이 이상치라면, 이것을 제거 후 다시 outlierTest()를 진행해야 함.
outlierTest(fit) 
#         rstudent   unadjusted p-value  Bonferroni p
# Nevada 3.542929         0.00095088     0.047544
# -> 두가지 종류의 p-value가 나옴
# Bonferroni pvalue로 가설검정
#   -> 유의수준 0.05일 때, 대립가설 채택
#   -> Nevada는 이상치
# rstudent는 잔차값.


# --------------------------
# (2) 큰 지렛대 포인트(High-leverage point)판단
# --------------------------
# 정의: 다른 예측변수(독립)의 값들에 비해서, 이상치인 값.
#       독립변수들에 의해 종속변수가 영향을 받는 관측치가 이거다..?
# 판단배경이론: 
#    Hat values(모수추정치)와 평균모수치를 비교하여,
#    Hat values(모수추정치)가 평균모수치의 2~3배  큰 관측치를 
#    큰 지렛대 포인트로 판단
#   - Hat values: 모집단과 관련된 추정치. 값 구하는 함수 있음.
# 확인된 큰 지렛대 포인트는, 이상치여부에 따라
# (1) 영향치가 될 수도 있고
# (2) 영향치가 안될 수도 있음.


# (2-1) 모수추정치(Hat values) 구하기
# hatvalues{stats}
hatvalues(fit)  # 추정치와 관측치 간의 비율
# Alabama         Alaska        Arizona       Arkansas     California 
# 0.09819211     0.43247319     0.12264914     0.08722029     0.34087628 
# Colorado    Connecticut       Delaware        Florida        Georgia 
# 0.05469964     0.09474658     0.05859637     0.12940379     0.05803142 
# Hawaii          Idaho       Illinois        Indiana           Iowa 
# 0.22443594     0.06905425     0.09683616     0.03871740     0.04627447 
# Kansas       Kentucky      Louisiana          Maine       Maryland 
# 0.05245106     0.05131253     0.17022388     0.09966458     0.06942663 
# Massachusetts       Michigan      Minnesota    Mississippi       Missouri 
# 0.02687166     0.05740920     0.04638897     0.14748152     0.04199088 
# Montana       Nebraska         Nevada  New Hampshire     New Jersey 
# 0.05253317     0.04421328     0.09508977     0.06387335     0.06616617 
# New Mexico       New York North Carolina   North Dakota           Ohio 
# 0.15998871     0.23298637     0.05218913     0.10529028     0.08652446 
# Oklahoma         Oregon   Pennsylvania   Rhode Island South Carolina 
# 0.05117056     0.19057634     0.11185698     0.04562377     0.10445404 
# South Dakota      Tennessee          Texas           Utah        Vermont 
# 0.07553161     0.04580225     0.13392638     0.06970746     0.08788063 
# Virginia     Washington  West Virginia      Wisconsin        Wyoming 
# 0.03230467     0.21662901     0.05839687     0.04173326     0.06012359 
# -> 각 관측치마다 모수추정치. -> 추정치랑 비슷한 값이 나옴??

# (2-2) 평균모수치 = p / n
#           (n:표본크기, p:회귀모형이 찾아낸 회귀계수의 개수)
coef(fit)
# (Intercept)   Population   Illiteracy       Income        Frost 
# 1.2345634112 0.0002236754 4.1428365903 0.0000644247 0.0005813055
p <- length(coef(fit))  # 5 벡터니까 length로 셈
n <- length(fitted(fit)) # 50

(x <- p/n) # 0.1


# High-leverage point 판단함수 만들기
hat.plot <- function(fit) {
  p <- length(coef(fit))
  n <- length(fitted(fit))
  
  hv <- hatvalues(fit)
  plot(hv, main='-Index plot of hat values-')
  abline(h=c(2,3) * p/n, col='red', lw=2)
  # 2~3배만큼 큰 값 / 벡터의 각 원소에 그리므로 두 개생김
  identify(1:n, hv, names(hv))  # names(hv): 각 주의 이름
  # 찍은 포인트의 주의 이름보여줌
}
# 지렛대 기준 선 그린 후, 포인트 찍으면 이상치의 주 이름을 알 수 있음.

dev.off()
hat.plot(fit)
# 진짜 이상치처럼 과소/과대추정을 일으킬지 알아보려면, outlierTest를 해야 함.
# 유력한 후보일 뿐! 아직 추정 일으키는지 알 수 없음.


# --------------------------
# (3) 영향치 판단
# --------------------------
# 회귀모형의 회귀계수 결정에 큰 영향을 주는 관측치
# 이론: Cook's distance (거리척도)를 이용해서, 찾아냄.
#       이상치라면, 거리가 멀리 떨어져 있음.
#       이상치가 있다면, 회귀계수에 큰 영향을 주므로 없애자.
# 작용: 회귀모델이 하나의 관측치(영향치)에 의해서, 극적으로 회귀계수가 변하게 됨.
# 판단공식:
#     if  Cook's distance > [ 4 / (n - k -1) ], ==> 영향치
#       (n: 표본의 크기, k: 예측(독립)개수)
#     4 / (n - k -1)를 cutoff라 보자
# 
# 영향관측치는 모형의 인수들에 불균형한 영향을 미치는 관측치이다. 
# 하나의 관측치를 제거함으로써 모형이 극적으로 달라지게 되는 경우가 있는데 
# 이러한 관측치가 영향관측치이다.
(n <- length(fitted(fit)))
(n <- nrow(df_states))
(k <- length(coef(fit)) - 1 ) # 절편은 예측변수 아니니까 빼줌

(cutoff <- 4 / (n - k - 1))  # 0.08888889
# par(mfrow = c(2,2))
# plot(fit)  # 4번째는, Residual vs Leverage 였음
plot(fit, which = 4)  # which: 몇번째 플롯 그릴지 지정 -> 쿡의 거리로 보여줌
# 라벨명 그려진 것이, 영향치로 결정가능한 관측치.

# cutoff line 추가
abline(
  # a = # 회귀식의 절편 intercept
  # b = # 회귀계수 β
  h = cutoff, # y축의 값 --> 수평선
  col = 'red'
)


# 위의 outlierTest에서는 Nevada가 잔차가 가장 크다는 결과가 나왔음.
# Nevada 추정값이 작다는 의미(과소추정).

# high-leverage point 수행 시, 
# Nevada는 보이지 않음.
# Alaska, California 
# -> 영향관측치일수도 있고, 아닐수도 있는데 이상치가 아니냐에 따라 달라짐

# 영향치 : Alaska, Hawaii, Nevada

# --> 검정방법? 판정기준에 따라 이상치가 다르게 나옴
# --> 힘이 센 High-leverage Point찾고, outlierTest에서 이상치로 나온 것이
# High-leverage Point와 같으면 -> High-leverage Point는 이상치가 되므로
# 영향치라 할 수 있음???
# -> 정상치라도 힘이 세면 제거해보는 것도 좋음
# -> 이상치 제거 기준은 명확하게 없음

# -------------------------------
# Added-variable Plot
# -------------------------------
# avPlots{car}함수를 이용한 영향치 판단
# Cook의 거리에 기반한 영향치 판단 기법은, 제약이 있다.
# 제약: 영향치를 찾는데에는 도움을 주지만, 
# 찾아낸 영향치가 실제 모델 적합화에서 어떻게 영향을 끼치는지는 말해주지 않는다.

library(car)
avPlots(fit, id.method='identify', ask=F)
# x축에 지정한 예측변수가 하나씩 나옴. / y축은 종속변수
# -> 각 예측변수가 종속변수ㅜ에 영향을 미치는 정도를 보여줌.
# -> 각 그래프의 직선은. 각 예측변수-종속변수의
#     "회귀직선"(다른 예측변수 통제한 상태에서의 회귀계수가 기울기)임.

# Population은 Murder를 높이므로 영향을 미친다.
# Illiteracy는 Murder를 높이므로 영향을 미친다. 
#   기울기(θ)로 보아, 문맹률이 인구수보다 더 살인율에 영향을 미침을 알 수 있음
# Income, Frost는 현재 모델에서 영향을 미치지 않는다.

# Plot의 라벨이 붙어있는 것들이 ""영향치""이다. 
# 각 라벨링된 점들이, 회귀계수(기울기)를 자신 점의 위치로 끌어당기고 있음.
# 네 플롯 모두, Nevada가 나오며, outlierTest로 이상치로 검정됨.
# Nevada가 만약, outlierTest에서 이상치로 판정이 나지 않아도,
#   힘이 세니까 조심스럽게 제거해보는 것이 좋음.


# 이상치 + 큰지렛대 + 영향치 한번에 판정
library(car)
influencePlot(
  model = fit,
  id.method = 'identify',
  main = 'Influence Plot',
  sub = 'Circle size is proportional to Cook\'s distance')
# 수평선으로 그어진 점선과 수직으로 그어진 점선으로 판정
# y축을 기준으로 하면 벗어나면 큰 지렛대 / 영향력이 크면 원의 크기가 크다
# 원의 크기가 크고 이상치로 판정될 수 있음.
# 캘리포니아는 큰 지렛대지만 영향치는 아니다.

