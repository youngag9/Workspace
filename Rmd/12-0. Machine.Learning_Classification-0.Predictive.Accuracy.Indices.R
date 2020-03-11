#----------------------------------------------------------
# Predictive Accuracy Indices for binominal classification
#----------------------------------------------------------
# using performance cross-tabulation (2X2)
# by 5-accuracy indices :
#
#     1. Sensitivity (민감성) - 참된 긍정률 ('재현'이라고도 함)
#        실제 산출값이 정적(positive)일 때, 정적 분류를 얻을 확률
#     2. Specificity (특이성) - 참된 부정률
#        실제 산출값이 부적(negative)일 때, 부적 분류를 얻을 확률
#     3. Positive predictive rate - 정적 예측률 ('정교성'이라고도 함)
#        정적(positive)으로 분류된 관측치가, 
#        정확하게 정적으로 식별된 비율
#     4. Negative predictive rate - 부적 예측률
#        부적(negative)으로 분류된 관측치가,
#        정확하게 부적으로 식별된 비율
#     5. Accuracy (정확성) - 'ACC' 라고도 함
#        정확하게 식별된 관측치의 비율
#
#----------------------------------------------------------
# Predictive accuracy equations for binomical classification
#----------------------------------------------------------
# When,
#                         Actual  Predicted  Cell
#                         ------- --------- ------
#     tn = table[1,1]   -> True   Negative  value
#     fp = table[1,2]   -> False  Positive  value
#     fn = table[2,1]   -> False  Negative  value
#     tp = table[2,2]   -> True   Positive  value
#
#     1. Sensitivity :  
#         * ssp = tp / (tp+fn) = [2,2] / ([2,2] + [2,1])
#     2. Specificity :  
#         * scp = tn / (tn+fp) = [1,1] / ([1,1] + [1,2])
#     3. Positive predictive ratio : 
#         * ppp = tp / (tp+fp) = [2,2] / ([2,2] + [1,2])
#     4. Negative predictive ratio : 
#         * npp = tn / (tn+fn) = [1,1] / ([1,1] + [2,1])
#     5. Accuracy :     
#         * acc = (tn+tp) / (tp+tn+fp+fn)
#               = ([1,1] + [2,2]) / ([2,2] + [1,1] + [1,2] + [2,1]) 
#----------------------------------------------------------
classifier.perf <- function(table, n = 2) {
  if(class(table)!= 'table')
    stop("must be 'table' class.", call. = TRUE)
  
  tbl.name = deparse(substitute(table))
  
  if(all(dim(table)!=c(2,2)))
    stop(
      paste0("\n\t'", 
             tbl.name,
             "' dimension should be (2x2)."), 
      call. = TRUE
    )
  
  
  tn = table[1,1]
  fp = table[1,2]
  fn = table[2,1]
  tp = table[2,2]
  
  ssp = tp / (tp+fn)
  scp = tn / (tn+fp)
  ppp = tp / (tp+fp)
  npp = tn / (tn+fn)
  acc = (tn+tp) / (tp+tn+fp+fn)
  
  cat('\n')
  cat('---------------------------------------------------\n')
  cat('* Model Perf. Indices : [', tbl.name, ']\n')
  cat('---------------------------------------------------\n')
  cat('1. Sensitivity\t:', ssp, '\n')
  cat('2. Specificity\t:', scp, '\n')
  cat('3. Positive Predictive Ratio\t:', ppp, '\n')
  cat('4. Negative Predictive Ratio\t:', npp, '\n')
  cat('5. Accuracy\t:', acc, '\n')
  cat('---------------------------------------------------')
}

#----------------------
# Clear a console
#----------------------
cat("\014")