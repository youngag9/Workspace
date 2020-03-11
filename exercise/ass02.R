# 1. mpg{ggplot2} 데이터셋을 loading 하여, df_mpg 
# 데이터프레임 변수를 만들고...
# 2. df_mpg 데이터프레임이 가지고 잇는 변수들(전에 배우셧던
#                              str(df_mpg) 함수이용) 중에, 연속형 변수에 대해서,
# 3. 도수분포표를 만들어 내시오 (R을 이용하여...)
# 단, 계급(값)은 만들지 않고, 각 데이터에 대하여,
# (1) 도수(빈도(수))
# (2) 누적도수
# (3) 상대도수
# 를 구하시오... 
# (sample18.R 파일참고할 것!!!)
# 4. 위 과제를 다하신분은, 여러분에게 배포된 책(부교재말고..) p.320 분할표를 연습하시기 바랍니다.!!!


library(ggplot2)
df_mpg <- mpg

class(df_mpg)
mode(df_mpg)
str(df_mpg)
dim(df_mpg)
summary(df_mpg)
?mpg
head(df_mpg$displ)
# displ / year / cyl / cty / hwy 

table(df_mpg$displ)               # 도수
cumsum(table(df_mpg$displ))      # 누적도수
prop.table(table(df_mpg$displ))  # 상대도수

# cbind{base} -> return list
displ_freq_list <- cbind(
  Freq = table(df_mpg$displ),
  Cumul = cumsum(table(df_mpg$displ)), 
  Relative = prop.table(table(df_mpg$displ)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$displ)))
)

( df_displ_freq <- as.data.frame(displ_freq_list) )
str(df_displ_freq)


# cbind{base} -> return list
cty_freq_list <- cbind(
  Freq = table(df_mpg$cty),
  Cumul = cumsum(table(df_mpg$cty)), 
  Relative = prop.table(table(df_mpg$cty)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$cty)))
)

( df_cty_freq <- as.data.frame(cty_freq_list) )
str(df_cty_freq)

# cbind{base} -> return list
hwy_freq_list <- cbind(
  Freq = table(df_mpg$hwy),
  Cumul = cumsum(table(df_mpg$hwy)), 
  Relative = prop.table(table(df_mpg$hwy)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$hwy)))
)

( df_hwy_freq <- as.data.frame(hwy_freq_list) )
str(df_hwy_freq)


#---------범주형변수: 도수분포표
# cbind{base} -> return list
manu_freq_list <- cbind(
  Freq = table(df_mpg$manufacturer),
  Cumul = cumsum(table(df_mpg$manufacturer)), 
  Relative = prop.table(table(df_mpg$manufacturer)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$manufacturer)))
)

( df_manu_freq <- as.data.frame(manu_freq_list) )
str(df_manu_freq)


# cbind{base} -> return list
year_freq_list <- cbind(
  Freq = table(df_mpg$year),
  Cumul = cumsum(table(df_mpg$year)), 
  Relative = prop.table(table(df_mpg$year)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$year)))
)

( df_year_freq <- as.data.frame(year_freq_list) )
str(df_year_freq)

# cbind{base} -> return list
model_freq_list <- cbind(
  Freq = table(df_mpg$model),
  Cumul = cumsum(table(df_mpg$model)), 
  Relative = prop.table(table(df_mpg$model)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$model)))
)

( df_model_freq <- as.data.frame(model_freq_list) )


# cbind{base} -> return list
cyl_freq_list <- cbind(
  Freq = table(df_mpg$cyl),
  Cumul = cumsum(table(df_mpg$cyl)), 
  Relative = prop.table(table(df_mpg$cyl)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$cyl)))
)

( df_cyl_freq <- as.data.frame(cyl_freq_list) )
str(df_cyl_freq)

# cbind{base} -> return list
drv_freq_list <- cbind(
  Freq = table(df_mpg$drv),
  Cumul = cumsum(table(df_mpg$drv)), 
  Relative = prop.table(table(df_mpg$drv)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$drv)))
)

( df_drv_freq <- as.data.frame(drv_freq_list) )
str(df_drv_freq)

# cbind{base} -> return list
fl_freq_list <- cbind(
  Freq = table(df_mpg$fl),
  Cumul = cumsum(table(df_mpg$fl)), 
  Relative = prop.table(table(df_mpg$fl)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$fl)))
)

( df_fl_freq <- as.data.frame(fl_freq_list) )
str(df_fl_freq)


# cbind{base} -> return list
class_freq_list <- cbind(
  Freq = table(df_mpg$class),
  Cumul = cumsum(table(df_mpg$class)), 
  Relative = prop.table(table(df_mpg$class)),
  Relative_Cumul = cumsum(prop.table(table(df_mpg$class)))
)

( df_class_freq <- as.data.frame(class_freq_list) )
str(df_class_freq)

#----범주형변수: 분할표 / 도수분포표----------
str(df_mpg)

(xtabs(~ df_mpg$manufacturer, df_mpg))
(xtabs(~ df_mpg$manufacturer + df_mpg$year, data=df_mpg))

d <- data.frame(
  x=c('1', '2', '2', '1'),
  y=c('A', 'B', 'A', 'B'),
  num = c(3, 5, 8 ,7)  # num: 빈도수를 갖는 변수
)

(xtabs(num ~ x + y, data= d))


d2 <- data.frame(x=c('a', 'a', 'a', 'b', 'b'))
(xtabs( ~ x, d2))
