library(ROracle)

oraDrv = dbDriver('Oracle')

oraDrv


oraConn <- dbConnect(oraDrv, dbname='db202001311541_high', username='LOTTE', password='Oracle1234567')
oraConn



dbDisconnect(oraConn)

# library(ROracle)
# 
# -----------------
#   
# oraDrv <- dbDriver('Oracle')
# oraDrv
# 
# oraDrv <- dbDriver('Oracle', unicode_as_utf8 = TRUE, ora.attributes = TRUE)
# oraDrv
# 
# -----------------
#   
# oraConn <- dbConnect(oraDrv, dbname='atp20191201_high', username='SCOTT', password='Oracle1234567')
# oraConn <- dbConnect(oraDrv, dbname='atp20191201_high', username='SCOTT', password='Oracle1234567', encoding='UTF-8')
# oraConn <- dbConnect(oraDrv, dbname='atp20191201_high', username='SCOTT', password='Oracle1234567', encoding='KSC5601')
# oraConn
# 
# -----------------
#   
# dbGetInfo(oraConn)
# dbListTables(oraConn)
# dbListFields(oraConn, 'EMP', schema = 'SCOTT')
# dbExistsTable(oraConn, 'EMP', schema = 'SCOTT')
# dbRemoveTable(oraConn, 'MYNAME', schema = 'SCOTT', purge = T)
# 
# -----------------
#   
# df_emp = dbReadTable(oraConn, 'EMP')
# View(df_emp)
# 
# -----------------
#   
# df_mpg <- ggplot2::mpg
# 
# dbWriteTable(oraConn, 'MPG', df_mpg)
# 
# -----------------
#   
# query = "SELECT * FROM emp"
# 
# df_emp <- dbGetQuery(oraConn, query)
# View(df_emp)
# 
# -----------------
#   
# resultset <- dbSendQuery(oraConn, query)
# resultset
# 
# # n: maximum number of records to retrieve per fetch.
# # Use ‘n = -1’ to retrieve all pending records.
# data <- fetch(resultset)
# # data <- fetch(resultset, n=-1)
# # data <- fetch(resultset, n=1)
# # data <- fetch(resultset, n=2)
# 
# data
# 
# dbClearResult(resultset)
# resultset
# 
# -----------------
#   
# # query WHERE 절에 한글사용하기
# library(stringr)
# 
# query = "SELECT * FROM emp WHERE ename LIKE :1"
# 
# df_rs <- dbGetQuery(oraConn, query, '%김동희%')
# df_rs <- dbGetQuery(oraConn, query, str_conv('%김동희%', 'KSC5601'))
# 
# df_rs
# 
# -----------------
#   
#   dbDisconnect(oraConn)
