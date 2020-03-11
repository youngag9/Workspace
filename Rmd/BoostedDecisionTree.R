#-------------------------------------------------------------
# Boosted Decision Tree pipelines
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
  'duration',
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

# 신용을 좋고 나쁨으로 표시
credit$credit <- ifelse(credit$credit == 1, 'Good', 'Bad')

# 신용도 좋음을 베이스 레벨로 설정
credit$credit <- factor(credit$credit, levels = c('Good','Bad'))

# After data munging
head(credit[ , keep.cols])

#-------------------------------------------------------------
# step5. 분석용 데이터 탐색 ( 변수들 간의 관계 확인)
#        변수들 간에 뚜렷한 선형관계가 없음을 보여
#-------------------------------------------------------------
# install.packages('useful', dependencies = T)
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
# step6. 예측 매트릭스와 반응 벡터의 생성
#-------------------------------------------------------------
library(useful)

# 모형을 기술하는 포뮬러
# 의사결정나무이기 때문에 절편이 필요없음
credit.formula <- 
  credit ~ credithistory + purpose + employment + duration + age + creditamount - 1

credit.formula
class(credit.formula)

# 의사결정나무이기 때문에 카테고리형(범주형) 변수에 대해서, 모든 레벨을 사용
credit.x <- build.x(credit.formula, data = credit, contrasts = F)
head(credit.x)

credit.y <- build.y(credit.formula, data = credit)
credit.y

# 논리형 벡터를 [0, 1]로 변환
as.integer(relevel(credit.y, ref = 'Bad'))
credit.y <- as.integer(relevel(credit.y, ref = 'Bad')) - 1
credit.y

#-------------------------------------------------------------
# step7. 부스팅 의사결정나무 계산
#        xgboost{xgboost} 함수 사용
#-------------------------------------------------------------
# install.packages('xgboost', dependencies = T)
library(xgboost)

credit.boost <- xgboost(
  data = credit.x,
  label = credit.y,
  max.depth = 3,
  eta = 0.3,
  nthread = 4,
  nrounds = 3,
  objective = 'binary:logistic'
)
credit.boost

credit.boost20 <- xgboost(
  data = credit.x,
  label = credit.y,
  max.depth = 3,
  eta = 0.3,
  nthread = 4,
  nrounds = 20,
  objective = 'binary:logistic'
)

#-------------------------------------------------------------
# step8. 부스팅 의사결정나무 시각화  
#        xgb.plot.multi.trees{xgboost} 함수 사용
#        - {htmlwidgets} 에 기초 둔, {DiagrammeR} 패키지 사용
#        - 수많은 의사결정나무를 하나로 합쳐 시각화 수행
#        의사결정나무가 적합된 방법에 따라, 하나 이상의 질문이 각 노드마다 존재
#-------------------------------------------------------------
# install.packages('xgboost', dependencies = T)
library(xgboost)

xgb.plot.multi.trees(credit.boost, feature_names = colnames(credit.x))

#-------------------------------------------------------------
# step9. 부스팅 의사결정나무 시각화2 - 변수중요도그림(variable importance plot)
#        기존 부스팅 의사결정나무 시각화는 이해하기 어려움
#        좀 더 나은 방법
#        각각의 변수가 모형에 얼마나 이바지 하는지 보여줌
#        가장 중요한 변수를 확인 할 수 있음
#        xgb.plot.importance{xgboost} 함수 사용
#-------------------------------------------------------------
library(xgboost)

xgb.plot.importance(
  xgb.importance(credit.boost, feature_names = colnames(credit.x))
)

par(mfrow=c(1,1))
