# interactive graph
install.packages("plotly", dependencies = T)
# # 설치안되면
# library(devtools)
# devtools::install_github("ropensci/plotly")

library(plotly)

library(ggplot2)
p <- ggplot(data=mpg, 
            aes(x=displ, 
                y=hwy,
                col=drv))  # 색을 칠해주는 변수가 범주형이면, legend 범례 생성됨
p  # 축과 데이터 설정

p <- p + geom_point()

# plotly로 인터랙티브 그래프를 만들자
ggplotly(p) # 마우스에 반응

# 인터랙티브 막대그래프
?diamonds # {ggplot2} 다이아몬드에 대한 정보를 담고 있음.
# 구조보기
str(diamonds) # tibble타입으로 3개의 타입을 동시에 가짐.
# cut color clarity(투명도) 변수는, Ord.factor : 순서가 있는 범주이다.
 # 범주의 개수를 5 levels와 같이 level로 나타냄
 # 기호와 같이 순서를 나타냄

p <- ggplot(data=diamonds,
            aes(x=cut, fill=clarity)) +  # 범주형변수로 막대를 채움
  geom_bar()#position = "dodge")  # dodge 안하면, 한 막대에 여러 색을 다  clarity를 전부 보여줌 -> "stacked area"
# dodge 설정 시, 이 clarity를 나눠서 보여줌. 즉, stacked를 풀어줌.

p


# time-series graph + interactive 
# package : dygraphs : 역동적인 그래프를 만들어줌
library(dygraphs)
# dependencies 가진 패키지는 zoo와 xts 임.
# 이 둘은, 시계열 데이터 분석 시 사용하는 패키지임.
economics <- ggplot2::economics
?economics # 시간의 흐름에 따라 미국의 경제 변화를 담은 데이터셋
str(economics)
View(economics) # pce는 뭘까? 개인소비지출액
# 날짜 정보를 갖는 변수를
# zoo나 xts 둘 중 하나의 타입으로 변경해야 함.
# xts::xts() : 시계열 데이터로 변경하는 함수
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date) # date로 정렬하여, 시계열 데이터로 변경함.
class(eco)  # xts나 zoo 타입으로 나와야 함,
str(eco)
head(eco) # zoo타입의 데이터는, 행이름이 날짜정보를 갖는 데이터임. 
# 실제 데이터는 옆에 [,1] 아래의 데이터임

# * Y's R>head(eco)
#            [,1]
# 1967-07-01 2944  : 행이름: 1967-07-01 / 실데이터: 2944
# 1967-08-01 2945
# 1967-09-01 2958
# 1967-10-01 3143
# 1967-11-01 3066


# 시계열 데이터를 생성
dygraph(eco) # 마우스 호버링 지정 알려줌

# 해당 범위만 보기
dygraph(eco) %>%  dyRangeSelector()  # 범위를 지정가능.
# 아래 쪽에 축을 설정할 수 있는 바가 출력됨.
# 아래쪽에 생긴 그래프는, 위쪽의 그래프를 완만하게 평탄화시킨 것.
# 특정그래프를 상세하게 들여다보기 좋음

# 시계열 그래프 안에,
# 다른 시간 정보를 갖는 다른 변수도 시계열 데이터로 만든 다음 함께 보여줌

# 저축률
eco_a <- xts(economics$psavert, order.by=economics$date)
# 실업자 수
eco_b <- xts(economics$unemploy/1000, order.by=economics$date) # 왜 1000으로 나누냐?
#단위가 다르니까 맞춰주는 것
head(eco_b) 
#            [,1]
# 1967-07-01 2.944
# 1967-08-01 2.945
# 1967-09-01 2.958
# 1967-10-01 3.143
# 1967-11-01 3.066
# 1967-12-01 3.018

# 합치기
eco2 <- cbind(eco_a, eco_b) # 데이터 결합
?bind_cols
head(eco2)
# * Y's R>head(eco2)
#            eco_a eco_b
# 1967-07-01  12.6 2.944  : 행이름이, 날짜, 변수명이 eco_a, eco_b가 됨.
# 1967-08-01  12.6 2.945
# 1967-09-01  11.9 2.958
# 1967-10-01  12.9 3.143
# 1967-11-01  12.8 3.066
# 1967-12-01  11.8 3.018

rownames(eco2)  # NULL
colnames(eco2) <- c("psavert", "unemploy") # 변수명 바꾸기
head(eco2)
# * Y's R>head(eco2)
#            psavert unemploy
# 1967-07-01    12.6    2.944
# 1967-08-01    12.6    2.945
# 1967-09-01    11.9    2.958
# 1967-10-01    12.9    3.143
# 1967-11-01    12.8    3.066
# 1967-12-01    11.8    3.018

# 그래프 만들기
dygraph(eco2) %>% dyRangeSelector()



