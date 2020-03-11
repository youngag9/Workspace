# 1. mpg{ggplot2} 데이터셋을 변수 df_mpg 로 로딩하시고,
# 2. 이 df_mpg 데이터프레임의 구조를 파악하신후,
# 3. 아래 조건으로, 파생변수를 생성하세요..
# 가. 파생변수 이름: total_avg (통합연비)
# 나. 파생변수 생성규칙: df_mpg$파생변수 <- 값
# 다. 통합연비(total_avg)의 대표값으로, 
# (1) 산술평균
# (2) 중위수
# 를 구했을 때에,
# 라. 통합연비(total_avg) 기준으로, 연비합격판정을
# 내린다면, 가장 적절한 통합연비의 기준값은
# 어느값으로 하는게 좋은지 결정하세요.

library(ggplot2)
df_mpg <- mpg

class(df_mpg)  # tbl_df
mode(df_mpg)  # list
str(df_mpg)
dim(df_mpg)
summary(df_mpg)

(mean <- mean(df_mpg$cty + df_mpg$hwy) / 2)  # 20.14957
(med <- median(df_mpg$cty + df_mpg$hwy) / 2)  # 20.5
# cty: Median :17.00   hwy: Median :24.00  
# cty: Mean   :16.86   hwy: Mean   :23.44

# (df_mpg$total_avg <- )

# 조건만족하는 행 뽑아내기
(drv4 <- df_mpg[df_mpg$drv == '4',])
(drvf <- df_mpg[df_mpg$drv == 'f',])
(drvr <- df_mpg[df_mpg$drv == 'r',])
(drv4 <- subset(df_mpg, drv=='4'))

(mean4 <- mean(drv4$cty + drv4$hwy) / 2) # 16.75243
(meanf <- mean(drvf$cty + drvf$hwy) / 2) # 24.06604
(meanr <- mean(drvr$cty + drvr$hwy) / 2) # 17.54

(median4 <- median(drv4$cty + drv4$hwy) / 2) # 16
(medianf <- median(drvf$cty + drvf$hwy) / 2) # 23.5
(medianr <- median(drvr$cty + drvr$hwy) / 2) # 18

qplot(data=df_mpg, x=drv, y=cty, geom='boxplot')
qplot(data=df_mpg, x=drv, y=hwy, geom='boxplot')
qplot(data=df_mpg, x=drv, y=(cty+hwy)/2, geom='boxplot')
