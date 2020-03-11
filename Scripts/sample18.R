# 도수분포표 (Frequency Table)

rm(list = ls())
cat('\f')


( x <- sample(10:20, 44, T) )

table(x)              # 도수
cumsum(table(x))      # 누적도수
prop.table(table(x))  # 상대도수


# cbind{base} -> return list
freq_list <- cbind(
        Freq = table(x),
        Cumul = cumsum(table(x)), 
        Relative = prop.table(table(x))
    )

( df_freq <- as.data.frame(freq_list) )
str(df_freq)

