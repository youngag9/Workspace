# ex07_visualization.R

library(ggplot2)

# 1. 레이아웃 생성
ggplot(data=mpg, aes(x=displ, y=hwy))
?aes # x, y축 값과, fill로 범주/범례 추가

# 2. 그래프 그리기 * 산점도
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()


# 3. 데코레이션
# 3-1. 범위 설정
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(3,6)

ggplot(data=mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  xlim(3,6) + 
  ylim(10,30)

# 지수-0나열 숫자표현으로 변경
?options
options(scipen =99) # 0이 나열된 정수로 숫자표현(not 지수표현)

# mpg / mmidwest의 scatterplot -> 연속형변수 간 관계파악
ggplot(data=mpg, aes(x=cty, y=hwy)) +
  geom_point()   # 상관관계 : 부상관을 그리는 관계. 배기량이 늘어날 수록 연비감소
ggplot(data=midwest, aes(x=poptotal, y=popasian)) +
  geom_point() +
  xlim(0, 5e+05) +
  ylim(0,10000)


# ****
# geom_col() VS geom_bar()
# •평균 막대 그래프 : 
#     데이터를 요약한 평균표를 먼저 만든 후 평균표를 이용해 그래프 생성
#     - geom_col() →  기술통계량 → 기술통계량을 시각화한다.
# •빈도 막대 그래프 : 
#     별도로 표를 만들지 않고 원자료를 이용해 바로 그래프 생성
#     - geom_bar()

# 2. 그래프그리기 *bar plot
# 그룹 간 차이 표현
library(dplyr)

# 구동축별 평균연비 나옴
(df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy)))

# barplot 그리기
# geom_col() :x축이 범주면, y축에 집계값을 보여주면서, 집단 간 차이 시각화
ggplot(data=df_mpg, aes(x=drv, y=mean_hwy)) +
  geom_col()

# x축 순서변경 : mean_hwy기준으로 내림차순으로 x축인 drv순서를 바꿈.
ggplot(data=df_mpg, aes(x=reorder(drv, -mean_hwy), y=mean_hwy)) +
  geom_col()
# mean_hwy 기준으로 오름차순으로 x축인 drv 순서 변경.
ggplot(data=df_mpg, aes(x=reorder(drv, mean_hwy), y=mean_hwy)) +
  geom_col()

# barplot - 빈도보여주기
# for 범주형변수
# geom_bar()
ggplot(data = mpg, aes(x=drv)) + geom_bar()

ggplot(data = mpg, aes(x=class)) +
  geom_bar()

# 연속형변수를 지정한다면,
# barplot이 아니라 히스토그램으로 해야함.
ggplot(data = mpg, aes(x=hwy)) + geom_bar() # 출력은 해주지만, 데이터사이 간격있음
# 원칙은 geom_histogram()
ggplot(data=mpg, aes(x=hwy)) + geom_histogram()

#
(df_mpg2 <- mpg %>% 
    filter(class=="suv") %>% 
    group_by(manufacturer) %>% 
    summarise(mean_cty = mean(cty)) %>% 
    arrange(desc(mean_cty)) %>% 
    head(5))

ggplot(data = df_mpg2, aes(x= reorder(manufacturer, -mean_cty),
                           y = mean_cty)) +
  geom_col()



# 2. *시계열 데이터
?economics
# 날짜별 실업률
ggplot(data = economics, aes(x=date, y=unemploy)) +
  geom_line()
# 시계열 데이터에서 가장 중요한 것은 “패턴” / “추세”이다.
# 2010년에 실업률이 치솟음
# 시계열데이터는 “요소분해” 들어가서, 이러한 때에 이런 데이터가 어떻게 나오게 됐는지 추론을 하고 예측도 가능하다.
# 추세를 그릴 때는, 각 그래프의 하단부 이어주고, 상단부 이어줌.
# 이 때, 상단부와 하단부가 모이는 부분이 가장 중요하다.
# 각각의 원인이 뭘지 예측하는 것이 시계열 분석.

#
ggplot(data=economics, aes(x=date, y=psavert)) +
  geom_line()


# 2. 데이터의 분포 *boxplot - 범주별 연속형변수 비교에 많이 쓰임.
ggplot(data=mpg, aes(x=drv, y=hwy)) + 
  geom_boxplot()

#
(df_mpg3 <- mpg %>% 
    filter(class %in% c("compact", "subcompact", "suv")))
ggplot(data = df_mpg3, aes(x=class, y=cty)) +
  geom_boxplot()
