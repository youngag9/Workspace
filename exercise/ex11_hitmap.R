# install.packages("ggiraphExtra", dependencies = T)
# devtools::install_github("davidgohel/ggiraph")
# library(ggiraph)
library(ggiraphExtra)

?USArrests  # {datasets} : R구동시 기본로딩되는 패키지
str(USArrests) # 주별정보가 무슨 변수에 있을까?
head(USArrests) # 데이터탐색
# --> rownames /
# 의미있는 이름을 지어주지 않으면, 변수명에 출력되지 않음
# --> "주"는 이름을 지어주지 않아 변수명이 없음
colnames(USArrests) # 데이터 프레임의 변수의 목록을 벡터로 돌려줌
rownames(USArrests) # 데이터프레임의 행의 이름 벡터로 돌려줌

# 50개 주에 대한, 강력범죄 정보를 담고 있음

library(tibble)
crime <- rownames_to_column(USArrests, var="state") # 행의 이름을 데이터로 갖는 하나의 컬럼을 생성 --> melt와 같음

# 주의 위치 정보가 없음
crime$state <-tolower(crime$state) # 소문자로 바꿔줌

str(crime) # 행의 이름 변경 및 소문자로 변경확인함.

# 지도 데이터 준비 
library(ggplot2)
states_map <-map_data("state") # map_data로 지도데이터 준비
# 미국의 각 주에 대한 지도데이터를 갖는 데이터프레임을 가져와서 담음
str(states_map)

# ggChoropleth가 되지 않는다면 아래 패키지 설치
# install.packages('maps',type='binary')  # type이 linux에서는 source / windows에서는 binary
# install.packages('mapproj',type='binary')
?ggChoropleth  # {ggiraphExra}
ggChoropleth(data = crime,         # 지도에표현할데이터
             aes(fill = Murder,    # 색깔로표현할변수
                 map_id = state),  # 지역기준변수 : 연결고리를 지역기준변수로 설정
             map = states_map)

# R에서는 , 마우스의 조작에 반응하는
# '인더랙티브 그래프'를 만들어줌.
ggChoropleth(data = crime,         # 지도에표현할데이터
             aes(fill = Murder,    # 색깔로표현할변수
                 map_id = state),  # 지역기준변수 : 연결고리를 지역기준변수로 설정
             map = states_map,
             interactive = T)  # interactive에 T를 주니, 마우스호버링에 따라 위치정보가 나타남/


# 한국지도 패키지 설치
library(stringi)
library(devtools)
# devtools::install_github('cardiomoon/kormaps2014')
library(kormaps2014)

# 한국인구 데이터 준비
# korpop1: {kormpas2014}
# changeCode() : {kormpas2014}
class(korpop1) # data.frame
# R의 promise 타입: 해당 타입으로 갖고 있다가 함수 적용하면, 
# 원래 타입이 나타남
# ?changeCode # 주어진 데이터프레임의 컬럼이름과 코드값을 한글로 변경해줌.
# temp <- changeCode(korpop1) # 한글로 바꿔줌 code는 문자집합을 의미.
# class(temp)
colnames(korpop1) 
# colnames(temp) # 
# str(temp)
# str(changeCode(korpop1))

korpopt <- kormaps2014::korpop1
kormapt <- kormaps2014::kormap1

class(korpop1)
library(dplyr)
korpopt <- korpopt %>% 
  rename(
          pop = 총인구_명,
          name= 행정구역별_읍면동)
  
head(korpopt)

# korpop1 <- changeCode(korpop1, from='cp949', to='utf-8')
# kormap1 <- changeCode(kormap1, from='cp949', to='utf-8')
View(korpop1)
View(kormap1)

# 우리나라의 지도정보 담고 있음
str(changeCode(kormap1)) # 한글이 깨지지 않도록 해줌
library(ggplot2)
korpop1 <- korpop1
kormap1 <- kormap1
?ggChoropleth
ggChoropleth(data = korpopt,       # 지도에표현할데이터
             aes(fill = pop,       # 색깔로표현할변수
                 map_id = code,    # 지역기준변수
                 tooltip = name),  # 지도위에표시할지역명
             map =kormap1,        # 지도데이터
             interactive = T)        




