#-------------------------------------------------------------
# Decision Tree pipelines
#-------------------------------------------------------------

#-------------------------------------------------------------
# step1. 원격 데이터셋의 URL을 저장한 문자열 변수 정의
#-------------------------------------------------------------
credit.url <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data'
credit.url

#-------------------------------------------------------------
# step2. 원격 데이터셋에는 컬럼명(변수명)이 없음
# 이에 각 컬럼(변수)명을 저장한 문자열 벡터 생성 (21개 컬럼명으로 구성)
#-------------------------------------------------------------
colnames <- c(
  'checking',
  'duration',
  'credithistory',
  'purpose',
  'creditamount',
  'savings',
  'employment',
  'installmentrate',
  'gendermarital',
  'otherdebtors',
  'yearsatresidence',
  'realestate',
  'age',
  'otherinstallment',
  'housing',
  'existingcredits',
  'job',
  'numliable',
  'phone',
  'foreign',
  'credit'
)
colnames
length(colnames)

#-------------------------------------------------------------
# step3. 원격 URL로부터 데이터 셋을 읽어들임
#-------------------------------------------------------------
credit <- read.table( credit.url, header = F, sep = ' ', stringsAsFactors = F, col.names = colnames )
credit

str(credit)
summary(credit)
names(credit)
colnames(credit)
head(credit)

#-------------------------------------------------------------
# step4. 분석용 데이터 정제 수행
#-------------------------------------------------------------
keep.cols <- c(
  'credithistory',
  'purpose',
  'employment',
  'credit'
)
keep.cols

credit.history <- c(
  A30='All Paid',
  A31='All Paid This Bank',
  A32='Up To Date',
  A33='Late Payment',
  A34='Critical Account'
)
credit.history
# credit.history['A30']

purpose <- c(
  A40='car (new)',
  A41='car (used)',
  A42='furniture/equipment',
  A43='radio/television',
  A44='domestic appliances',
  A45='repairs',
  A46='education',
  A47='(vacation - does not exist ?)',
  A48='retraining',
  A49='business',
  A410='others'
)
purpose
# purpose['A49']

employment <- c(
  A71='unemployed',
  A72='< 1 year',
  A73='1 - 4 years',
  A74='4 - 7 years',
  A75='>=7 years'
)
employment
# employment['A75']

# Before data munging
head(credit[ , keep.cols])

# Data Munging
credit$credithistory <- credit.history[credit$credithistory]
credit$purpose <- purpose[credit$purpose]
credit$employment <- employment[credit$employment]

head(credit)

# 신용을 좋고 나쁨으로 표시
credit$credit <- ifelse(credit$credit == 1, 'Good', 'Bad')

# 신용도 좋음을 베이스 레벨로 설정
credit$credit <- factor(credit$credit, levels = c('Good','Bad'))

head(credit$credit)

# After data munging
head(credit[ , keep.cols])

#-------------------------------------------------------------
# step5. 분석용 데이터 탐색 ( 변수들 간의 관계 확인)
#        변수들 간에 뚜렷한 선형관계가 없음을 보여
#-------------------------------------------------------------
library(useful)

# 신용상태, 부채, 과거력, 고용상태들의 관계를 보여주는 그래프
ggplot(credit, aes(x=creditamount, y=credit)) +
  geom_jitter(position = position_jitter(height = .2)) +
  facet_grid(credithistory ~ employment) +
  xlab('Credit Amount') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5)) +
  scale_x_continuous(labels = multiple)

# 나이와 부채의 관계를, 과거력과 고용상태로 패싯팅했고, 신용을 색으로 구분
ggplot(credit, aes(x=creditamount, y=age)) +
  geom_point(aes(color = credit)) +
  facet_grid(credithistory ~ employment) +
  xlab('Credit Amount') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5)) +
  scale_x_continuous(labels = multiple)

#-------------------------------------------------------------
# step6. 의사결정나무 계산
#        반환된 텍스트 형태의 의사결정나무 출력
#        rpart{rpart} 함수 사용
#        다른 모형 함수들과 같이, 포뮬러(formula) 사용
#        상호작용은 허용 안됨
#        함수 수행결과로, 텍스트 형식의 의사결정나무 반환
#        - 노드 하나 당  하나의 행으로 출력
#        - 첫번째 노드 : 모든 데이터의 루트(뿌리)
#          1000개 관측치 존재, 이 가운데 300개를 ‘Bad’로 처리
#        - 다음 단계의 들여쓰기 : 첫번째 분리(split), credithistory 사용
#          가. credithistory가 ‘Critical Account’ | ‘Late Payment’ | ‘Up to Date’ 값을
#              가질 때 -->  911개 관측치 존재, 247개 ‘Bad’로 처리 
#              ( 신용도가 좋을 확률은 73% )
#          나. credithistory가 ‘All Paid’ | ‘All Paid This Bank’ 값을 가질 때
#              ( 불량 신용도 확률은 60% )
#        - 다음 단계의 들여쓰기  다음 단계의 분리(spilit) 의미
#-------------------------------------------------------------
# install.packages('rpart', dependencies = T)
library(rpart)

credit.tree <- rpart(credit ~ creditamount+age+credithistory+employment, data = credit)
credit.tree

#-------------------------------------------------------------
# step7. 의사결정나무 시각화
#        rpart.plot{rpart.plot} 함수 사용
#        왼쪽으로 분지되는 노드들 : 조건에 부합하는 경우들 의미
#        오른쪽으로 분지되는 노느들 : 조건에 부합하지 않는 경우들 의미
#        각 터미널 노드들을 예측된 클래스로 표시(예: ‘Good’, ‘Bad’)
#        터미널 노드 : 예측되는 클래스(‘Good’, ’Bad’)를 보여줌
#        확률 : 왼쪽에서 오른쪽으로 읽음(이때 ‘Good’이 왼쪽)
#-------------------------------------------------------------
# install.packages('rpart.plot', dependencies = T)
library(rpart.plot)

rpart.plot(credit.tree, extra = 4)

