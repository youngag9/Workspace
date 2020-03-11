# ex07_visualization.R

library(ggplot2)

# 1. 레이아웃 생성
ggplot(data=mpg, aes(x=displ, y=hwy))
?aes

# 2. 그래프 그리기 * 산점도
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()


# 3. 데코레이션
# 3-1. 범위 설정
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + xlim(3,6)

ggplot(data=mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  xlim(3,6) + 
  ylim(10,30)


?options
options(scipen =99)

# mpg / mmidwest의 scatterplot
ggplot(data=mpg, aes(x=cty, y=hwy)) +
  geom_point()   # 상관관계
ggplot(data=midwest, aes(x=poptotal, y=popasian)) +
  geom_point() +
  xlim(0, 5e+05) +
  ylim(0,10000)



# 2. 그래프그리기 *bar plot
# 그룹 간 차이 표현
library(dplyr)

# 구동축별 평균연비 나옴
(df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy)))

# barplot 그리기
ggplot(data=df_mpg, aes(x=drv, y=mean_hwy)) +
  geom_col()

# x축 순서변경 : mean_hwy기준으로 내림
ggplot(data=df_mpg, aes(x=reorder(drv, -mean_hwy), y=mean_hwy)) +
  geom_col()

ggplot(data=df_mpg, aes(x=reorder(drv, mean_hwy), y=mean_hwy)) +
  geom_col()

# barplot - 빈도보여주기
# for 범주형변수
ggplot(data = mpg, aes(x=drv)) + geom_bar()
# 연속형변수를 지정한다면,
# 이는 히스토그램이다.
ggplot(data = mpg, aes(x=hwy)) + geom_bar()
# 원칙은 geom_hist()
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

#
ggplot(data = mpg, aes(x=class)) +
  geom_bar()

# 2. *시계열 데이터
?economics
ggplot(data = economics, aes(x=date, y=unemploy)) +
  geom_line()

#
ggplot(data=economics, aes(x=date, y=psavert)) +
  geom_line()


# 2. 데이터의 분포 *boxplot
ggplot(data=mpg, aes(x=drv, y=hwy)) + 
  geom_boxplot()

#
(df_mpg3 <- mpg %>% 
    filter(class %in% c("compact", "subcompact", "suv")))
ggplot(data = df_mpg3, aes(x=class, y=cty)) +
  geom_boxplot()
