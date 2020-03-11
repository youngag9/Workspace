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

install.packages("memoise", dependencies = T)
install.packages("KoNLP", dependencies = T) # natural language Processing 자연어
install.packages("devtools", dependencies = T)
library(devtools)
devtools::install_github("haven-jeon/koKLP")

install.packages("/KoNLP_0.80.2.tar.gz")

?left_join
