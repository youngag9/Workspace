#----------------------------------------
# 두 시계열 간의 교차상관(cross-correlation) plot
#----------------------------------------
library(forecast)

# ccf()
# cross correlation/corvariance between order_cnt - sess_tm
ccf(x = df_ts.v1[,1], 
    y = df_ts.v1[,2], 
    type = 'correlation', 
    plot = TRUE, 
    main = 'order_cnt - sess_tm')

ccf(df_ts.v1[,1], 
    df_ts.v1[,2], 
    type = 'corvariance', 
    plot = TRUE, 
    main = 'order_cnt - sess_tm')

ccf(df_ts.v1[,1], 
    df_ts.v1[,2], 
    type = 'partial', 
    plot = TRUE, 
    main = 'order_cnt - sess_tm')

# cross correlation/corvariance between order_cnt - act_hitseq
ccf(df_ts.v1[,1], 
    df_ts.v1[,3], 
    type = 'correlation', 
    plot = TRUE, 
    main = 'order_cnt - act_hitseq')

# cross correlation/corvariance between order_cnt - act_search
ccf(df_ts.v1[,1], 
    df_ts.v1[,4], 
    type = 'correlation', 
    plot = TRUE, 
    main = 'order_cnt - act_search')

# cross correlation/corvariance between order_cnt - act_pv
ccf(df_ts.v1[,1], 
    df_ts.v1[,5], 
    type = 'correlation', 
    plot = TRUE, 
    main = 'order_cnt - act_pv')

# cross correlation/corvariance between order_cnt - act_order
ccf(df_ts.v1[,1], 
    df_ts.v1[,6], 
    type = 'correlation', 
    plot = TRUE, 
    main = 'order_cnt - act_order')

# cross correlation/corvariance between order_cnt - buy_price
ccf(df_ts.v1[,1], 
    df_ts.v1[,7], 
    type = 'correlation', 
    plot = TRUE, 
    main = 'order_cnt - buy_price')

#----------------------------------------
# 다변량 시계열의 상관행렬도 plot
#----------------------------------------
cor(df_ts.v1)

graphics.off()

library(corrplot)
corrplot(corr = cor(df_ts.v1), 
         type = 'lower', 
         add = TRUE, 
         method = 'color', 
         is.corr = TRUE, 
         diag = TRUE, 
         hclust.method = 'average')
