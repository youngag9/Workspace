# Data Munging

df_exam <- read.csv("Data/csv_exam.csv")

class(df_exam)
mode(df_exam)
dim(df_exam)
str(df_exam)
summary(df_exam)


library(dplyr)


# 1. Projection!! ""dplyr::filter()""
# coding rule : not error 
# 1st <-- use this!!
(df_temp <- df_exam %>% 
          filter(class==1))  # Projection
# 2nd <-- not error but don't use
(df_temp <- df_exam 
            %>% filter(class==1))  # Projection
# 3rd <-- use this.
(df_temp <- 
    df_exam %>% 
    filter(class==1))

class(df_temp)
rm(df_temp)

(df_exam %>% filter(class==2))
(df_exam %>% filter(class != 1))
(df_exam %>% filter(class != 3))
(df_exam %>% filter(math > 50))
(df_exam %>% filter(math <= 50))
(df_exam %>% filter(english >= 80))
(df_exam %>% filter(english <= 80))
(df_exam %>% filter(class == 1 & math >= 50))
(df_exam %>% filter(class == 2 & english >= 80))
(df_exam %>% filter(math >= 90 | english >= 90))
(df_exam %>% filter(english < 90 | science < 50))
(df_exam %>% filter(class == 1 | class == 3 | class == 5))
(df_exam %>% filter(class %in% c(1,3,5)))


class1 <- df_exam %>% filter(class == 1)
class2 <- df_exam %>% filter(class == 2)

mean(class1$math)
mean(class2$math)

df_mpg <- ggplot2::mpg
df_mpg_dislow <- df_mpg %>% filter(df_mpg$displ <= 4)
df_mpg_dishigh <- df_mpg %>% filter(df_mpg$displ >= 5)
mean(df_mpg_dislow$hwy)  #25.96319
mean(df_mpg_dishigh$hwy)  # 18.07895

df_mpg_audi <- df_mpg %>% filter(df_mpg$manufacturer == "audi")
df_mpg_toyo <- df_mpg %>% filter(df_mpg$manufacturer == "toyota")
mean(df_mpg_audi$cty) # 17.61111
mean(df_mpg_toyo$cty) # 18.52941

df_mpg_etc <- df_mpg %>% filter(df_mpg$manufacturer %in% c("chevrolet", "ford", "honda"))
mean(df_mpg_etc$hwy)  # 22.50943


# 2. Selection : dplyr::select()
df_exam %>% select(math)
df_exam %>% select(english)
df_exam %>% select(class, math, english)
df_exam %>% select(-math)  # math제외한 컬럼 모두 추출
df_exam %>% select(-math, -english)


# 3. Projection + selection
df_exam %>% 
  filter(class==1) %>% 
  select(english)
# df_exam %>% select(english) %>% filter(class==1) # Error
df_exam %>% select(class, english) %>% filter(class==1)

df_exam %>% 
  select(id, math) %>% 
  head(10)

(df_mpg_sel <- df_mpg %>% select(class, cty))
# 연비(1갤런 당 표본을 구성하는 자동차개체의 값이 다름) 
# 비교하는데, 대표값으로 산술평균 사용하는 게 맞나?
mean((df_mpg_sel %>% filter(class == "suv"))$cty) # 13.5
mean((df_mpg_sel %>% filter(class == "compact"))$cty) # 20.12766

# --> 동일한 조사대상에 대해 서로다른 개체값을 보이는 것에는
#     조화평균을 사용하는 것이 좋다.
1/mean(1/(df_mpg_sel %>% filter(class == "suv"))$cty) # 13.10513
1/mean(1/(df_mpg_sel %>% filter(class == "compact"))$cty) # 19.64686


# 4. 정렬
df_exam %>% arrange(math)
df_exam %>% arrange(desc(math)) # 내림차순
df_exam %>% arrange(class, math) # 앞에나온 컬럼 먼저 정렬 후, 그 부분 행 데이터 내에서 두번째 변수 기준으로 정렬된다.
# 반 별로 정렬 후 수학적으로 내림차순 정렬
df_exam %>% arrange(class, desc(math))


str(df_mpg_audi)

df_mpg %>%  filter(manufacturer =="audi") %>% 
  arrange(desc(hwy)) %>% 
  head(3)

# 5. 파생변수
df_exam %>% 
  mutate(total = math + english + science) %>% 
  head

df_exam %>% 
  mutate(total = math + english + science,
         mean = (math + english + science)/3) %>% 
  head

df_exam_tmp <- df_exam %>% 
         mutate(total = math + english + science,
                mean = total/3) %>% 
        head

max(df_exam_tmp$mean) # 79
min(df_exam_tmp$mean) # 59.66667
