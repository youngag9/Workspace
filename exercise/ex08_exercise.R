# (4) 데이터 탐색(6가지 함수 이용...)
# (5) 로딩시킨, 원천데이터는 복사본을 만들고,
# 원천데이터는 백업시킴(파일로..예: .rda 파일)
# (6) 본격적인 데이터 먼징(전처리, Munging)
# 가. 변수의 이름 쉽게 이해하도록 변경
# 나. 꼭 필요한 경우, 여러 파생변수를 생성
# 다. 데이터셋에서, 조건에 맞는 부분집합만 추출
# (필터링 - filter{dplyr})
# 라. 데이터셋에서, 원하는 변수만 추출
# (셀렉션 연산 - select{dplyr} )
# 마. 관계대수 연산의 조합으로, 자르고, 붙이고...
# 바. 정렬, top-N 연산
# (7) 데이터 정제(=클렌징)
# 가. 결측치 확인 및 부작용 확인
# 나. 결측치 대체(Imputation)
# 1) 결측치 제외 by filter{dplyr} ---> 추천못함!
#   2) 결측치 삭제 by na.omit{stats} --> 추천못함!
#   3) 대표값 또는 보간법, 통계분석예측값 등으로
# 대체
# 다. 이상값(= 이상치, 특이값, 극단치, 극단값)에 대한
# 정제
# (8) 정제된 데이터셋(Tidy Data)을 기반으로, 각 종 기술
# 통계량 산출

# 1. 데이터분석 준비 - 패키지 준비

# foreign: spss 등 파일다루는, S언어를 기반으로 하는 패키지
install.packages("foreign", dependencies = T)
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

# 데이터 불러오기
?read.spss # {foreign}
# 1-1. to.data.frame 안쓰면? list
temp <- read.spss(file="Data/Koweps_hpc10_2015_beta1.sav")
class(temp)  # list
str(temp) 

# List of 957 -> 변수가 957개
# $ h10_id          : num [1:16664] 1 2 3 4 4 6 6 6 6 6 ...
# --> 관측치가 16664개!!
# $ h10_ind         : num [1:16664] 1 1 1 1 1 1 1 1 1 1 ...

# 1-1-1. dataframe으로 바꾸기
raw_welfare <- as.data.frame(temp) # list->data : list에는 key:value쌍이므로! key는 변수가, value는 데이터프레임의 값이 된다.
class(raw_welfare)  # data.frame
rm(temp) # list객체 삭제


# 1-2. to.data.frame 옵션으로 바로 dataframe
raw_welfare <- read.spss(file="Data/Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T) # 데이터파일로 백업


# 2. 백업
# 복사본 Rdata파일로
df_welfare <- raw_welfare
# raw는 rda파일로 저장
?save  # base::save()
save(raw_welfare, file = "Data/raw_welfare.rda")
rm(raw_welfare)

# rad를 load로 불러오려면!
load("Data/raw_welfare.rda")
df_welfare <- raw_welfare
rm(raw_welfare)


# 3. 데이터 검토하기
head(df_welfare)
tail(df_welfare)
View(df_welfare)
dim(df_welfare) # 16664 957
str(df_welfare)
summary(df_welfare)


# 4. 전처리
# 4-1. 변수명을 쉬운 단어로 변경:
# str로 확인한 데이터프레임의 변수명이 의미를 알아볼 수 없음.


# rename이나 dplyr::mutate() 사용


# 4-1-1. rename()
df_welfare <- rename(df_welfare,
                  sex = h10_g3,            # 성별
                  birth = h10_g4,          # 태어난 연도
                  marriage = h10_g10,      # 혼인 상태
                  religion = h10_g11,      # 종교
                  income = p1002_8aq1,     # 월급
                  code_job = h10_eco9,     # 직종 코드
                  code_region = h10_reg7)  # 지역 코드

# 4-1-2. mutate() : 파생변수생성 --> 쓰지마 파생변수니까
# df_welfare <- df_welfare %>% 
#   mutate(sex = h10_g3,            # 성별
#          birth = h10_g4,          # 태어난 연도
#          marriage = h10_g10,      # 혼인 상태
#          religion = h10_g11,      # 종교
#          income = p1002_8aq1,     # 월급
#          code_job = h10_eco9,     # 직종 코드
#          code_region = h10_reg7)  # 지역 코드

# 변수이름 변경됐는지 확인
head(df_welfare)
str(df_welfare[c("sex", "birth", "marriage", "religion", "income", "code_job", "code_region")])
# df_welfare$b   # 이런식으로 이름의 변수 있는지 확인
df_welfare %>% 
  select(sex, birth, marriage, religion, income, code_job, code_region)


# 4-2-3. 파생변수 --> 생성 X

# Q1. 성별에 따른 월급이 다를까?
# 1) 시계열 데이터? XXX "Snapshot Data"
# cf) 시계열 / 비율 --> (대표값)기하평균
# 보통, 두 집단의 값을 비교할 때는 우선, 산술평균을 사용한다.
# 산술평균은 특이값의 영향받지만 그래도 신뢰할만한 대표값은 산술평균!
# + 검정 시에도, 산술평균사용

# Q1-5. 변수검토 및 전처리
# 필요한 변수: sex, income 
# Q1-5-1. 변수 검토

class(df_welfare$sex) # 왜 타입을 파악할까?
# --> 우선, 실데이터의 타입을 파악하기 위함이고
# 그리고, 우리가 아는 성별인 'F'로 했는지 0/1로 했는지를 파악할 수 있다.
# 성별은, 범주형변수이다. 그 중 순서비교가 의미없으므로, "분류(명목)변수"이다.
# --> 분류변수니까 빈도표 구하기 더 좋다.
# --> table

table(df_welfare$sex)
#   1    2 
# 7578 9086   --> 1이 남자야 여자야?
# --> 코드북 필요! 코드북에서 2가 여자.

# Q1-5-2. 이상치 확인
table(df_welfare$sex) # 이상치 있는지 학인

# 결측치도 보여주는 함수: summary
summary(df_welfare$sex)  # --> 연속형 변수일 때 사용.
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   1.000   2.000   1.545   2.000   2.000 


# 결측치 확인
table(is.na(df_welfare$sex))
# FALSE 
# 16664 

# 이상치 있으면 결측처리
df_welfare$sex <- ifelse(df_welfare$sex == 9, # 코드북에 지정
                         NA,
                         df_welfare$sex)
table(df_welfare$sex)

# 1이면 male로, 2면 female로 변경
df_welfare$sex <- ifelse(df_welfare$sex == 1,
                         'male',
                         'female')
# 빈도표 생성 --> 원래, 범주형변수는 "도수분포표" 만들어서 확인
table(df_welfare$sex) 

# Q1-5-2. 중간과정 빈도 시각화
qplot(df_welfare$sex)  # barplot 범주형 변수의 빈도 보여줌
# 본격적인 시각화는, ggplot사용.
# qplot은 간단한 시각화에 이용.


# 연속형변수
# 변수타입검토
class(df_welfare$income)

# 연속형변수는 summary로 대략적인 분포확인
summary(df_welfare$income)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#     0.0   122.0   192.5   241.6   316.6  2400.0   12030 
# --> NA 12030 개

# 중간과정 분포(산포도) 확인
qplot(df_welfare$income) #histogram 연속형 변수의 분포 보여줌
# 그림확인하니까, 오른쪽 꼬리분포
# insight) income의 대부분이 0~500에 분포. 
# 왼쪽에 몰려있으니까, 범위를 한정해서, 해당 범위 확대해서 보자
qplot(df_welfare$income) + # ggplot2 패키지는 +로 어서 사용.
  xlim(0, 1000) 


# Q1-5-2. 전처리
# 이상치확인
summary(df_welfare$income) # 결측치외에는, 이상치 확인이 어려움
# 코드표를 확인하면, 임금이 0일 수없다고 하며,
# 월급을 밝히지 않은 사람들은 9999를 줌 → 이상치

# 이상치 결측처리
df_welfare$income <- ifelse(df_welfare$income %in% c(0,9999),
                             NA,
                             df_welfare$income)
 
# 결측치 확인 
# method1
table(is.na(df_welfare$income))  # TRUE 12044
# method2 - for 연속형변수
summary(df_welfare$income) # NA's 12044
# 중위수가 193만원. 



# 그렇다면 결측치 처리는?
# 지금은 배제
# 성별에 따라서 --> group_by()
# 배제 후, 그룹으로 묶음
# 1st. method filter 
sex_income <- df_welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income))
sex_income

# 2nd. na.rm
sex_income <- df_welfare %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income, na.rm=T))
# female 163
# male 312
# --> 차이가 너무 많이 난다

# 시각화 --> 기술통계량의 끝은 시각화!!!
library(ggplot2)
ggplot(data=sex_income, aes(x=sex, y=mean_income)) +
  geom_col()  # 그룹 간 차이.

# 이후, 남녀 임금의 차이가 유의미한 차이인지 "검정"한다.

# Q2. 몇살 때 월급을 가장 많이 받을까?
# * 나이와 월급의 관계
# 분석 목적에 필요한 변수 (변수선정) - 변수별 클렌징 - 기술통계량 구하기 - 시각화


# Q2-1. 필요한 변수는?
# 나이(전처리 필요), income(Q1에서 전처리 끝)
# rename한 것 중에 나이변수는없음
# 생년 정보가 있으니까 나이 변수를 만들자 "파생변수"
class(df_welfare$birth) # numeric 
# 무슨 변수일까? 
# 수치로 표현할 수 있으니, 양적변수
# 무수히 많은 실수값 취할 수 없으니, 연속형X  이산형O
# 이산형 변수 중 크기를 비교할 수 있으니 순서형변수

summary(df_welfare$birth) # 어떤 변수 종류인지 모름.
# birth는 양적변수
# 하지만, 결측치가 있는지 확인가능!
# 여기는 결측치가 없음
# + 여기서는, 몇년생부터 몇년생까지 조사됐는지 알 수 있음
# 1907~2014년  --> 범위통계량임 "range" : 통계기호는 "R"

head(df_welfare$birth)

# 중간시각화
qplot(df_welfare$birth) 
# 생년은 연속형변수가 아님.
# R은 그걸모르고, 숫자형이니까 histogram으로 보여줌
# 빈도를 보여줌
# 데이터의 분포모양 파악.
# 넓게 퍼져있음 not 꼬리형.
# x축은 생년, y축은 빈도. 가장 빈도가 높은 생년구간이 1920-1950
# 빈도의 차이가 있지만, 전반적으로 골고루 조사가 됨.
# 1980년대 태어난 사람들은 조사가 부족해보인다.

# birth 가공
# 나이를 만들기전에
# 이상치확인
summary(df_welfare$birth) # 이상한 숫자 안보임

#결측치확인
# summary로 확인했음
# 다르게 확인하려면 table(is.na(df_welfare$birth))

# 응답이 안되거나, 없던 자료는 (from 코드북) 9999로 처리되어 있음
# 이러한 이상치는 결측치로 처리한다
df_welfare$birth <- ifelse(df_welfare$birth == 9999, NA, df_welfare$birth) # summary에서 없었으니까 하나마나
table(is.na(df_welfare$birth)) # 이상치없엇음

# 나이라는 파생변수 만들어야 함.
df_welfare$age <- 2015 - df_welfare$birth + 1
summary(df_welfare$age)  # 2~109살까지 조사대상에 포함됨.
# 결측치 없음
# 이상치 있는지 확인

qplot(df_welfare$age)
# 원래 확률분포(pandas의 distplot)를 그려줘서 확인해야 함
# 분산이랑, 표준편차를 구해서 확인해봐야 함

# 필요한 변수 정리했으니
# 기술통계량을 구함

# 나이에 따른 월급평균표 만들기
# 1st. method
age_income <- df_welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))
 # 여기아래에 %>% head(5) 하면 안됨!!!!!!
# 변수에 담기니까! 5개 관측치만 변수에 담김.

# 2nd. method
age_income <- df_welfare %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income, na.rm=T))

head(age_income)


# 기술통계량 나왔으니까 시각화 by ggplot
ggplot(data=age_income, aes(x=age, y=mean_income)) +
  geom_line()
# 왜 line을 그릴까?
# 나이는, 일종의 시계열의 의미를 가지므로!!
# x축이 나이, y축 나이별 평균임금
# 가장 높은 급여를 받기 시작하는 나이는 40~55살 정도까지
# 그 후 정년을 맞이하면 급격하게 낮아짐.
# 첫 급여의 평균은 100만원 약간 넘는 금액

# 처음 분석목표: 몇살때 월급을 가장 많이 받을까
# 가장 많이 받는 부분은 대략 53세정도


# Q3. 어떤 연령대의 월급이 가장 많을까?
# 필요파생변수 : 연령대 ifelse로 중첩
# 필요변수: 월급
# 연령대 만들기 위한 age 전처리 끝났음

# 파생변수생성
df_welfare <- df_welfare %>% 
  mutate(ageg = ifelse(age<30, "young",
                       ifelse(age<=59, "middle", "old")))
# 빈도 확인
# 연령대는 범주형 변수이므로, 각 빈도를 확인해야 함.
table(df_welfare$ageg)
# middle    old  young 
# 6049   6281   4334

qplot(df_welfare$ageg)
# 청소년이 가장 적은 비율


# 기술통계량 만듦
ageg_income <- df_welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))

ageg_income
# 1 middle        282.
# 2 old           125.
# 3 young         164.


# 시각화
# 그룹 별 평균의 차이 -> 막대그래프 col
ggplot(data=ageg_income, aes(x=ageg, y=mean_income)) +
  geom_col()

# 정렬
ggplot(data=ageg_income, aes(x=reorder(ageg, mean_income), y=mean_income)) +
  geom_col()

# 임의의 순서대로 정렬
?scale_x_discrete # ggplot2

ggplot(data=ageg_income, aes(x=ageg, y=mean_income)) +
  geom_col() +
  scale_x_discrete(limits= c("young", "middle", "old"))
  # x축이 이산형 변수라면, c함수로 순서를 지정해준다
  
# Q4. 성별 월급 차이는 연령대별로 다를까?
# 필요변수: 연령대, 성별, 월급
# 변수탐색
class(df_welfare$ageg)
table(df_welfare$ageg) # 결측치 이상치 없음

class(df_welfare$sex)
table(df_welfare$sex) # 결측치 이상치 없음

class(df_welfare$income)
summary(df_welfare$income)  # 결측치 있음 이상치 없는듯

qplot(df_welfare$ageg)
qplot(df_welfare$sex)
qplot(df_welfare$income)


# 기초 통계량 구하기
sexageg_income <- df_welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex, ageg) %>% 
  summarise(mean_income = mean(income))
?group_by


# 시각화
# aes의 fill 인자로, 색을 넣어서 3변수간 관계를 확이나능?/
ggplot(data = sexageg_income, aes(x=ageg, y=mean_income, fill=sex)) + 
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))

# 보기 불편하니까 옆으로 늘어놓자
ggplot(data = sexageg_income, aes(x=ageg, y=mean_income, fill=sex)) + 
  geom_col(position="dodge") +
  scale_x_discrete(limits = c("young", "middle", "old"))


# 이걸로 뭘 얻을 수 있을까?
# 중노년 여성의 임금은 남성의 절반이됨.


# 나이 및 성별 월급차이분석

# 성별 연령별 월급 평균표 만들기
sex_age <- df_welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income = mean(income))

head(sex_age)  

# 숫자로 파악하기 힘드니까 시각화!
# 기술통계량을 내고 하는, 시각화는 ggplot 사용
ggplot(data = sex_age, aes(x=age, y=mean_income, col=sex)) +
  geom_line()
# 색을 범주형변수인 성별로 했기 때문에, 두개의 그래프가 생김.

#  insight) 20대에는 거의 비슷히자만, 
# 30대가 되며 격차가 벌어짐. 가장 큰 격차벌어지는 것이 55살쯤
# 점점 격차 좁혀지다가 75살에 같게 수렴됨.
# 약 15년간 임금격차가 생김.


# Q6. 어떤 직업이 월급을 가장 많이 받을까?
# 직업코드 이용.
# 어떤 직업이 월급을 가장 많이 받을까?

# class로 먼저 타입을 봄
class(df_welfare$code_job)  # 범주형 변수는 이걸로 몇개의 범주가 존재하는지 알아보자

table(df_welfare$code_job)  # 각 코드의 빈도를 볼 수 있다.
# 직업코드가 많아서, 빈도 보기가 어려움--> 별로 의미가 없음. 직업명을 몰라서!

# 직업분류코드 목록을 불러옴
# 실제 직업정보 갖는 데이터프레임을 가져와 join시켜 직업코드의 이름 만들자
library(readxl)
list_job <- read_excel("Data/Koweps_Codebook.xlsx",
                       col_names = T,  # 워크시트에 변수명 포함된 경우 T로 지정
                       sheet = 2)  # 로딩시킬 워크시트의 번호/이름 지정

head(list_job)
View(list_job) # 직업코드별, 실제직종명
dim(list_job) # 149 2
str(list_job) # tibble type 
# dataframe만으로 할 거면
list_job <- as.data.frame(list_job)
class(list_job)

# 같은 직업코드로, 직업명 알아보기 위해 join해보자
# df_welfare에 직업명 결합 : left outer join
df_welfare <- left_join(df_welfare, list_job, id="code_job") # 공통변수:code_job

head(df_welfare)
str(df_welfare)

df_welfare %>% 
  filter(!is.na(code_job)) %>%  # 결측치가 있는 행 제외
  select(code_job, job) %>%  # 뽑을 변수 선택
  head(10) # 10개만 보여줌

# 직업별 월급 평균구해서 그룹 간 비교해보자
job_income <- df_welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income=mean(income))  # groupby code_job한 후 조인할 수도 있음


head(job_income)

# 상위 10개 추출
# job_income에 대해 정렬 후 head(10)해야 함
top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)

top10
# 
# job                                  mean_income
# <chr>                                      <dbl>
#   1 금속 재료 공학 기술자 및 시험원             845.
# 2 의료진료 전문가                             844.
# 3 의회의원 고위공무원 및 공공단체임원         750 
# 4 보험 및 금융 관리자                         726.
# 5 제관원 및 판금원                            572.
# 6 행정 및 경영지원 관리자                     564.
# 7 문화 예술 디자인 및 영상 관련 관리자        557.
# 8 연구 교육 및 법률 관련 관리자               550.
# 9 건설 전기 및 생산 관련 관리자               536.
# 10 석유 및 화학물 가공장치 조작원              532.

# 가장 많이 받는직업은 소재개발하는 직업/ 의사 / 국회의원 공기업/...

# 그래프 만들기
ggplot(data=top10, aes(x=reorder(job, mean_income), y=mean_income)) +
  geom_col() +
  coord_flip() # 축을 뒤집는 함수, x축에 직업명 넣으면 길이가 길어서 겹치게 됨.
# x축 평균입금, y축이 직업명


# 하위10위 추출
bottom10 <- job_income %>% 
  arrange(mean_income) %>%  # arrange는 기본이 내림차순 / 아니면, 오름차순 정렬 후, tail함수 사용해도 됨.
  head(10)

bottom10

# 하위 10위 그래프로
ggplot(data=bottom10, aes(x=reorder(job, -mean_income),
                          y=mean_income)) +
  geom_col() + 
  coord_flip() +
  ylim(0, 850) # y축은 직업명이라고 생각할 수 있으나,
# coord flip 적용되도,xy축 값은 aes에서 지정한 값을 따름

# ?? coord_flip 사용해야 하나?
ggplot(data=bottom10, aes(y=reorder(job, -mean_income),
                          x=mean_income)) +
  geom_col() + 
  xlim(0, 850) 


# Q7. 성별로 어떤 직업이 많을까?
# 성별직업빈도 
# 범주형변수는 원래 도수분포표 만드는데, 이 예제는 빈도표만 만듦

# 빈도표 만들기
# 남성 상위 빈도 직업 10개 추출
job_male <- df_welfare %>% 
  filter(!is.na(job) & sex=='male') %>% 
  group_by(job) %>%  # 직업코드를 쓸 수 있지만. 우리가 조인해서 직업명을 구해놨으니까 이거쓰자?
  summarise(n=n()) %>%  # 남성의 수를 구하게 됨
  arrange(desc(n)) %>% 
  head(10)

job_male
# 농업 / 운송업 / 회사원 / 영업 / 매장판매 / 제조생산업,, (2015)


# 여성직업빈도 상위 10개 추출
job_female <- df_welfare %>% 
  filter(!is.na(job) & sex=='female') %>% 
  group_by(job) %>%  # 직업코드를 쓸 수 있지만. 우리가 조인해서 직업명을 구해놨으니까 이거쓰자?
  summarise(n=n()) %>%  # 여성의 수를 구하게 됨
  arrange(desc(n)) %>% 
  head(10)

job_female
# 농업 / 미화원 / 매장판매 / 회계경리 / 음식서비스 / 가사도우미 / 의료복지 / 음식


# 2. 그래프만들기

# 남성 직업빈도 상위 10개 직업
ggplot(data=job_male, aes(x=reorder(job, n), y=n)) +
  geom_col() +
  coord_flip()

# 여성 직업빈도 상위 10개 직업
ggplot(data=job_female, aes(x=reorder(job, n), y=n)) +
  geom_col() +
  coord_flip()
