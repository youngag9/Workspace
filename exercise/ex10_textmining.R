# 10. textmining

install.packages("rJava", dependencies = T) # ubuntu에 자바 설치 후
# sudo apt install -y openjdk-8-jdk openjdk-8-jre : 윈도우와 동일
# 자바설치 확인
# java -version
# R에 Java 파일이 있을 거라고 생각되는 위치에 업데이트 한다.
# 
# 
# sudo R CMD javareconf
# sudo sync 후 sudo reboot
# sudo -i R
# install.packages(“rJava”)
library(rJava)
# sudo apt-get install libxtst6?
install.packages("memoise", dependencies = T)
install.packages("KoNLP", dependencies = T) # natural language Processing 자연어
install.packages("devtools", dependencies = T)
library(devtools)
devtools::install_github("haven-jeon/KoNLP")

library(KoNLP)

library(dplyr)

# 설치 위치 바궜으면,  setenv 실행
# $ which java
Sys.setenv(JAVA_HOME="/usr/bin/java")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64")
Sys.getenv("JAVA_HOME")

# 사전설정 : github에서 받아줌 --> Yes입력력
useNIADic()
statDic() # 단어로 나옴

# 데이터  준비
txt <- readLines("Data/hiphop.txt", encoding = "UTF-8")
txt
# 워닝뜸
# 끝이 
# txt <- readLines(encoding = "UTF-8")
install.packages("stringr")
library(stringr)
txt <- str_replace_all(txt, '\\W', " ")
head(txt)

# koNLP중 extraNoun() : 명사만 추출
nouns <-extractNoun(txt) # list r객체로 나옴

# unlist : 리스트를 풀어서 벡터로 담아줌
wordcount <-table(unlist(nouns)) # 정확도 높이는 작업중임

View(table(wordcount))

# 테이블을 df로 만들 때
df_word <-as.data.frame(wordcount, stringsAsFactors = F)
# dpltr은 df에 특화되므로 변경함
df_word <-rename(df_word,
                 word = Var1,
                 freq = Freq)

# 두 글자 이상 단어 추출 / nchar: 문자 수를 세줌
?nchar
nchar("A B")
nchar("ABCD")
df_word <- filter(df_word, nchar(word) >= 2)# 두 문자만 남겨놓음
df_word <- df_word %>% 
  filter(nchar(word) >= 2)

top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

View(top20)

install.packages("RColorBrewer", dependencies = T)
install.packages("wordcloud")
library(wordcloud) 
# library(RColorBrewer) # wordcloud로딩 시, 쟈동으로 library 해줌

?brewer.pal
pal <- brewer.pal(8, "Dark2") # 첫번째인자는 팔레트에 들어갈 색상 수
# 두번재인자는, 팔레트의 이름
pal # 8개의 색상 값이 나옴. RGB값의 색상값을 담고 있음
class(pal)
# wordcloud는 내부적으로 난수를 사용
# 동일한 값 사용하려면 seed함수 사용
set.seed(1234)  # {base} 난수고정
wordcloud(words=df_word$word,  # 단어
          freq = df_word$freq, #빈도
          min.freq = 2, # 최소단어빈도
          max.words = 200, # 표현단어수
          random.order=F, # 임의의 배치 막아서,고빈도단어 중앙 배치
          rot.per = .1, # 회전단어 비율(rotation percent) : 단어를 표시할 때 약간 회전시켜 출력
          scale=c(4, 0.3), # 단어크기 범위
          colors = pal) # 색깔목록

#-----------------------
library(KoNLP)
library(dplyr)

# 사전설정 : github에서 받아줌 --> Yes입력력
useNIADic()  # konlp의 NIA 사전. 사전 가져옴
statDic() # 단어로 나옴

# 데이터  준비
kakao <- readLines("Data/20200218_talk.txt", encoding = "UTF-8")
kakao

library(stringr)
kakao <- str_replace_all(kakao, '\\W', " ")
head(kakao)

# koNLP중 extraNoun() : 명사만 추출
kn <-extractNoun(kakao) # list r객체로 나옴

# unlist : 리스트를 풀어서 벡터로 담아줌
kwordcount <-table(unlist(kn)) # 정확도 높이는 작업중임

View(table(kwordcount))

# 테이블을 df로 만들 때
df_word2 <-as.data.frame(kwordcount, stringsAsFactors = F)
# dpltr은 df에 특화되므로 변경함
df_word2 <-rename(df_word2,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출 / nchar: 문자 수를 세줌
df_word2 <- filter(df_word2, (nchar(word) >= 2) & word != c('2020', '오후', '안영', '김수빈', '유찬희', '아름', "오전") )# 두 문자만 남겨놓음
# 어떻게?

top20 <- df_word2 %>% 
  arrange(desc(freq)) %>% 
  head(20)

View(top20)

library(wordcloud) 

pal <- brewer.pal(8, "Dark2") # 첫번째인자는 팔레트에 들어갈 색상 수

set.seed(14)  # {base} 난수고정
wordcloud(words=df_word2$word,  # 단어
          freq = df_word2$freq, #빈도
          min.freq = 2, # 최소단어빈도
          max.words = 200, # 표현단어수
          random.order=F, # 임의의 배치 막아서,고빈도단어 중앙 배치
          rot.per = .1, # 회전단어 비율(rotation percent) : 단어를 표시할 때 약간 회전시켜 출력
          scale=c(4, 0.3), # 단어크기 범위
          colors = pal) # 색깔목록



